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
  table.insert(self.state.research, name)
end

function Research:isPoolFull()
  return #self.state.active >= self.state.selectioncap
end

function Research:isUnlocked(name)
  return table.searchByValue(self.state.research, name) ~= nil
end

function Research:isKnown(name)
  return self.state.souls[_G[name].tier] ~= nil
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
