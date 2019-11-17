--
-- Defines behaviour of that fraction
--
require 'middleclass'
require 'game/unit/unitspec'

Fraction = class('Fraction')
function Fraction:initialize(game, layer)
  self.game = game
  for y,col in ipairs(layer.data) do
    for x,tile in pairs(col) do
      assert(_G[tile.type], "Unit type '"..(tile.type or "nil").."' not found! "..game.mappath.." -> "..layer.name.." -> ".. x-1 ..","..y-1)
      self:addUnit(tile.type, x, y)
    end
  end
end
function Fraction:addUnit(typename, x, y)
  local class = assert(_G[typename], "Unit type '"..(typename or "nil").."' not found! ")
  self.game.units[#self.game.units+1] = class(self.game, self, x, y)
end
function Fraction:getUnitTarget(unit)
  -- do nothing
end

Undead = class('Undead', Fraction)
function Undead:getUnitTarget(unit)
  -- default behaviour: move to game.goal..
  return {'move', self.game.goal}
end

Human = class('Human', Fraction)
