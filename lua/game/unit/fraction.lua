--
-- Defines behaviour of that fraction
--
require 'middleclass'
require 'game/unit/unitspec'

---------- Fraction ----------

Fraction = class('Fraction')
function Fraction:initialize(game, layer)
  self.game = game
  self.name = self.class.name
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
  return unit and unit.fraction ~= self
end

function Fraction:findClosestEnemy(unit)
  local enemy = nil
  local enemydist
  for _,object in pairs(self.game.unitslayer.objects) do
    if object.fraction and object.fraction ~= self then
      local dist = vec2_dist(unit.pos, object.pos)
      if dist < (enemydist or unit.sight) then
        enemy = object
        enemydist = dist
      end
    end
  end
  return enemy
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

function Undead:getLeadingUnit()
  local leader = nil
  for _,unit in pairs(self.game.map.layers.Units.objects) do
    if unit.hp and unit.hp > 0 and unit.fraction == self and ((leader == nil) or leader.pos.x < unit.pos.x) then
      leader = unit
    end
  end
  return leader
end

---------- Human ----------

Human = class('Human', Fraction)
function Human:getUnitTarget(unit)
  local enemy = self:findClosestEnemy(unit)
  if enemy then
    local pos = (enemy.node and enemy.node.location)
    if pos then return {'move', pos} end
  end
  return {'move', unit.spawn}
end
