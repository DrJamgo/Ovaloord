require 'middleclass'

---------- Ability ----------

local lookup = {}
lookup.cooldown = {veryslow=1.5, slow=1.25, normal=1.0, fast=0.75, veryfast=0.5}
lookup.duration = lookup.cooldown

Ability = class('Ability')
function Ability:initialize(unit, cooldown, duration, trigger)
  
  if type(duration) == 'string' then
    assert(lookup.duration[duration], "value for duration="..duration.." not defined")
    duration = lookup.duration[duration]
    trigger = duration * 0.75
  end
  
  if type(cooldown) == 'string' then
    assert(lookup.cooldown[cooldown], "value for cooldown="..cooldown.." not defined")
    cooldown = duration + lookup.cooldown[cooldown]
  end

  self.cooldown = cooldown
  self.duration = duration or 0
  self.trigger = trigger or 0
  
  self.unit = unit
  self.time = 0
  self.active = false
  
  return self
end

function Ability:getValue()
  return 1
end

function Ability:update(dt)
  local trigger = self.time > self.trigger
  
  if self.active then
    self.time = self.time + dt
  end
  
  trigger = (trigger == false) and (self.time > self.trigger)
  
  if self.cooldown and self.time > self.cooldown then
    self.active = false
    self.time = self.time - self.cooldown
  end
  
  return trigger
end

function Ability:isActive()
  return self.active
end

function Ability:isReady()
  return self.active == false
end

--
-- Activates ability (starts cooldown)
-- @return true if ability was ready and is now acive, false otherwise
--
function Ability:activate()
  if self:isReady() then
    self.active = true
  end
  return isReady
end

function Ability:getProgress()
  if self.active == false or self.time > self.duration then
    return 0
  end
  return self.time / math.max(self.duration, 0.0001)
end

local adjecentOffsets = {
  vec2( 1, 0),
  vec2( 0, 1),
  vec2(-1, 0),
  vec2( 0,-1)
}

function Ability:_calculateCost(node, dest)
  -- TODO: better cost function!
  node.score = node.mCost + 1
end

function Ability:getNodes(grid, fromnode, dest)
  local result = {}
  if not fromnode.action or fromnode.action == 'move' then
    for _,delta in ipairs(adjecentOffsets) do
      local n = self:getNode(grid, fromnode, vec2_add(fromnode.location, delta), dest)
      if n then
        self:_calculateCost(n, dest)
        table.insert(result, n)
      end
    end
  end
  return result
end

---------- Move ----------
Move = class('Move', Ability)
function Move:activate(target)
  if self:isReady() then
    self.from = self.unit.pos
    self.target = target
    local dist = vec2_dist(self.from, self.target)
    self.duration = dist / self.unit.speed
    self.cooldown = self.duration
    self.trigger = self.duration
    Ability.activate(self)
    return true
  end
  return false
end

function Move:update(dt)
  local trigger = Ability.update(self, dt)
  if trigger then
    self.unit.pos = vec2(self.target.x, self.target.y)
  else
    local progress = self:getProgress()
    self.unit.pos = vec2_add(vec2_mul(self.from, 1 - progress),  vec2_mul(self.target,progress))
  end
  return trigger
end

function Move:getNode(grid, fromnode, location, dest)
  local node = grid:getNode(location, nil, fromnode)
  if node and node.walk then
    local dx = math.max(location.x, dest.x) - math.min(location.x, dest.x)
    local dy = math.max(location.y, dest.y) - math.min(location.y, dest.y)
    local emCost = dx + dy
    node.score = node.mCost + emCost
    node.action = 'move'
    return node
  end
  return nil
end

lookup.triggerfactor = {slash=4/6, thrust=6/8, shoot=9/12}

---------- Melee ----------
Melee = class('Melee', Ability)
Melee.rangetolerance = 0.1
Melee.minrange = 0.5
function Melee:initialize(unit, dmg, range, anim, ...)
  Ability.initialize(self, unit, ...)
  self.trigger = self.duration * (lookup.triggerfactor[anim] or 1)
  self.maxrange = range + self.rangetolerance
  self.dmg = dmg
  self.anim = anim
end

function Melee:activate(target)
  self.target = target
  return Ability.activate(self)
end

function Melee:update(dt)
  local trigger = Ability.update(self, dt) and self:validateTarget(self.unit.node, self.target)
  if trigger then
    -- todo: DMG calculation
    self.target:hit(self.dmg, self.unit)
  end
  return trigger 
end

function Melee:validateTarget(fromnode, target)
  if target and self.unit.fraction:isEnemy(target) and target.hp and target.hp > 0 then
    local diff = vec2_sub(target.pos, fromnode.location)
    local dist = vec2_dist(target.pos, fromnode.location)
    return dist <= self.maxrange and dist >= self.minrange
  end
  return false
end

function Melee:getNode(grid, fromnode, location, dest)
  -- Here you make sure the requested node is valid (i.e. on the map, not blocked)
  local x,y = location.x,location.y
  if y >= 1 and y <= #grid.static then
      local target = grid.dynamic[y][x]
      if self:validateTarget(fromnode, target) then
        local node = Node(location, self.cooldown, grid.numtiles + target.id, fromnode)
        node.unit = target
        node.action = 'attack'
        node.ability = self
        self:_calculateCost(node, dest)
        return node
      end
      return nil
  end
  return nil
end

---------- Range ----------
require 'game/unit/projectile'

Range = class('Range', Melee)
Range.minrange = 1.1
function Range:initialize(unit, projectile, ...)
  Melee.initialize(self, unit, ...)
  self.projectile = projectile
end

function Range:getNodes(grid, fromnode, target)
  local result = {}
  if not fromnode.action or fromnode.action == 'move' then
    for _,delta in ipairs(adjecentOffsets) do
      local loc = fromnode.location
      for i=1,math.floor(self.maxrange) do
        if loc then
          loc = vec2_add(loc, delta)
          local node, continue = self:getNode(grid, fromnode, loc)
          table.insert(result, node)
          if continue == false then
            loc = nil
          end
        end
      end
    end
  end
  return result
end

function Range:getNode(grid, fromnode, location)
  local node = grid:getNode(location)
  if node and node.shoot then
    if node.unit and self:validateTarget(fromnode, node.unit) then
      return Melee.getNode(self, grid, fromnode, location), false
    end
    return nil, true
  end
  return nil, false
end

function Range:update(dt)
  local valid = self:validateTarget(self.unit.node, self.target)
  local trigger = Ability.update(self, dt) and valid
  if not valid then
    self.time = self.cooldown
  end
  if trigger then
    self.unit.map:addObject(self.projectile(self, self.unit, self.target))
  end
  return trigger
end