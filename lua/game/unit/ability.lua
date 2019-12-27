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

function Ability:_calculateCost(grid, node)
  local emCost = 1
  node.mCost = node.mCost + (node.parent.mCost or 0)
  node.score = node.mCost + emCost
end

function Ability:getNodes(grid, fromnode)
  local result = {}
  for _,delta in ipairs(grid.adjecentOffsets) do
    local n = self:getNode(grid, fromnode, vec2_add(fromnode.location, delta))
    if n then
      n.parent = fromnode
      self:_calculateCost(grid, n)
      table.insert(result, n)
    end
  end
  return result
end

---------- Move ----------
Move = class('Move', Ability)
function Move:getNode(grid, fromnode, location)
  local node = grid:getNode(location)
  return node
end

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

---------- Melee ----------
Melee = class('Melee', Ability)
Melee.rangetolerance = 0.1
Melee.minrange = 0.5
function Melee:initialize(unit, dmg, range, anim, ...)
  Ability.initialize(self, unit, ...)
  self.maxrange = range + self.rangetolerance
  self.dmg = dmg
  self.anim = anim
end

function Melee:getValue()
  -- value is DPS with range bonus
  return (self.dmg / self.cooldown) * math.max(1,math.ceil(self.maxrange / 2))
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
    local dist = vec2_dist(target.pos, fromnode.location)
    return dist <= self.maxrange and dist >= self.minrange
  end
  return false
end

function Melee:getNode(grid, fromnode, location)
  -- Here you make sure the requested node is valid (i.e. on the map, not blocked)
  local x,y = location.x,location.y
  if y >= 1 and y <= #grid.static then
      local target = grid.dynamic[y][x]
      if self:validateTarget(fromnode, target) then
        local node = Node(location, 1, grid.numtiles + target.id)
        node.unit = target
        node.cost = 1
        node.action = 'attack'
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
function Range:getNodes(grid, fromnode)
  local result = {}
  for _,delta in ipairs(grid.adjecentOffsets) do
    local loc = fromnode.location
    for i=1,math.floor(self.maxrange) do
      if loc then
        loc = vec2_add(loc, delta)
        local node, continue = self:getNode(grid, fromnode, loc)
        if node then
            node.parent = fromnode
            node.action = 'attack'
            self:_calculateCost(grid, node)
            debug[node.mCost] = loc
            table.insert(result, node)
        end
        if continue == false then
          loc = nil
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
      return node, false
    end
    return nil, true
  end
  return nil, false
end

function Range:update(dt)
  local trigger = Ability.update(self, dt) and self:validateTarget(self.unit.node, self.target)
  if trigger then
    self.unit.map:addObject(Arrow(self, self.unit, self.target))
  end
  return trigger
end