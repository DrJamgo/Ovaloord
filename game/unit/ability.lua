require 'middleclass'
Ability = class('Ability')

function Ability:initialize(cooldown, duration, trigger)

  self.cooldown = cooldown or 0
  self.duration = duration or 0
  self.trigger = trigger or 0
  
  self.time = 0
  self.active = false
  
  return self
end

function Ability:update(dt)
  local trigger = self.time > self.trigger
  
  if self.active then
    self.time = self.time + dt
  end
  
  trigger = (trigger == false) and (self.time > self.trigger)
  
  if self.time > self.cooldown then
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

function Ability:getNodes(grid, unit, fromnode)
  local result = {}
  for _,delta in ipairs(Grid.adjecentOffsets) do
    local n = self:getNode(grid, unit, fromnode, vec2_add(fromnode.location, delta))
    if n then
      local emCost = 1
      n.mCost = n.mCost + (fromnode.mCost or 0)
      n.score = n.mCost + emCost
      n.parent = fromnode
      table.insert(result, n)
    end
  end
  return result
end

---------- Melee ----------

Melee = class('Melee', Ability)
function Melee:initialize(...)
  Ability.initialize(self, ...)
  self.range = 1.1
end

function Melee:activate(unit, target)
  self.unit = unit
  self.target = target
  return Ability.activate(self)
end

function Melee:update(dt)
  local trigger = Ability.update(self, dt) and self:validateTarget(self.unit, self.unit.node, self.target)
  if trigger then
    -- todo: DMG calculation
    self.target.hp = self.target.hp - 1
  end
  return trigger 
end

function Melee:validateTarget(unit, fromnode, target)
  return target and unit.fraction:isEnemy(target) and vec2_dist(target.pos, fromnode.location) <= self.range and target.hp > 0
end

function Melee:getNode(grid, unit, fromnode, location)
  -- Here you make sure the requested node is valid (i.e. on the map, not blocked)
  local x,y = location.x,location.y
  if y >= 1 and y <= #grid.static then
      local target = grid.dynamic[y][x]
      if self:validateTarget(unit, fromnode, target) then
        local node = Node(location, 1, grid.static[y][x].id + grid.numtiles)
        node.unit = target
        node.cost = 1
        node.action = 'melee'
        return node
      end
  end
  return nil
end