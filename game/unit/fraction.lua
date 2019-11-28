--
-- Defines behaviour of that fraction
--
require 'middleclass'
require 'game/unit/unitspec'

---------- Fraction ----------

Fraction = class('Fraction')
function Fraction:initialize(game, layer)
  self.game = game
  gamemap.getTilesInLayer(layer, 
    function(tile, pos)
      if _G[tile.type] then
        self:addUnit(tile.type, pos)
        self.game.map:setLayerTile(layer.name, pos.x, pos.y, nil)
      end
    end
  )
end
function Fraction:addUnit(typename, spawn)
  local class = assert(_G[typename], "Unit type '"..(typename or "nil").."' not found! ")
  local newUnit = class(self.game.map, self, spawn)
  self.game.map:addObject(newUnit)
end
function Fraction:getUnitTarget(unit)
  return {'move', unit.spawn}
end

function Fraction:isEnemy(unit)
  return unit.fraction ~= self
end

---------- Undead ----------

Undead = class('Undead', Fraction)
function Undead:initialize(game, layer)
  Fraction.initialize(self, game, layer)
  local map = game.map
  
  gamemap.getTilesInLayer(layer,
    function(tile, pos)
      if tile.type == 'spawn' then
        self.spawn = pos
      end
      if tile.type == 'goal' then
        self.goal = pos
      end
    end
  )
end
function Undead:getUnitTarget(unit)
  -- default behaviour: move to goal..
  return {'move', self.goal}
end

function Undead:getLeadingUnit(unit)
  local leader = nil
  for _,unit in pairs(self.game.objects) do
    if unit.hp and unit.hp > 0 and unit.fraction == self and ((leader == nil) or leader.pos.x < unit.pos.x) then
      leader = unit
    end
  end
  return leader
end

---------- Human ----------

Human = class('Human', Fraction)