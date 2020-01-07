require 'middleclass'
Research = class('Research')

Research.units = {
  {'Rosen', 'Warden', 'Revenant'},
  {'Pirate', 'Raider', 'Marauder'},
}

function Research:initialize(game)
  self.state = game.state
end

function Research:unlockUnit(name)
  if not table.searchByValue(self.state.research, name) then
    table.insert(self.state.research, name)
    return true
  end
  return false
end

function Research:unlockRandomUnit()
  local lockedCount = 0
  local lockedUnits = {}
  for col, units in ipairs(self.units) do
    for row,unit in ipairs(units) do
      if self:isKnown(unit) and self:isUnlocked(unit) == false then
        lockedUnits[#lockedUnits+1] = unit
      end
    end
  end
  if #lockedUnits > 0 then
    local index = math.random(1, #lockedUnits)
    self:unlockUnit(lockedUnits[index])
  end
end

function Research:isPoolFull()
  return #self.state.active >= self.state.selectioncap
end

function Research:isUnlocked(name)
  return table.searchByValue(self.state.research, name) ~= nil
end

function Research:isKnown(name)
  for col, units in ipairs(self.units) do
    local known = false
    if self:isUnlocked(units[1]) then
      known = true
    end
    for row,unit in ipairs(units) do
      if known and (unit == name) then return true end
      if not self:isUnlocked(unit) then
        break
      end
    end
  end
  
  return false
end

function Research:removeUnitFromPool(name)
  for i,selected in ipairs(self.state.active) do
    if selected == name then
      table.remove(self.state.active, i)
      break
    end
  end
end

function Research:addUnitToPool(name)
  if not self:isPoolFull() then
    table.insert(self.state.active, name)
  end
end
