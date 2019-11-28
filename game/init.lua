local STI = require "sti/sti"
require 'utils/camera'
require 'utils/map'
require 'game/unit/fraction'

Game = 
{
  renderer = require 'game/render'
}
Game.__index = Game

setmetatable(Game, {
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end
})

function Game:_init()
  self.scale = 2
  return self
end

local id = 1
function addObject(map, object)
  local objects = map.layers.Units.objects
  objects[id] = object
  object.id = id
  id = id + 1
end

function removeObject(map, object)
  local objects = map.layers.Units.objects
  objects[object.id] = nil
end

function Game:load(mapPath)
  self.guimap = STI('res/maps/gui_units.lua')
  
  local map = STI(mapPath)
  map.addObject = addObject
  map.removeObject = removeObject
  self.map = map
  
  self.objects = {}
  self.fractions = {}
  
  self.unitslayer = UnitsLayer(self.map)
  self.gridlayer = GridLayer(self.map, self.unitslayer.objects)

  for l,layer in ipairs(map.layers) do
    local fraction = layer.properties.fraction
    if fraction then
      self.fractions[fraction] = _G[fraction](self, layer)
    end
  end
  
  self.renderer.load(self)
  
  require('utils/microscope')('Game.dot', self, 2, 'nometatables')
end

function Game:update(dt)
  local undead = self.fractions['Undead']
  local leader = self.fractions['Undead']:getLeadingUnit()
  if leader then
    self.main:setFocus(leader.pos)
  else
    self.main:setFocus(undead.spawn)
  end
  
  for _,widget in ipairs(self.widgets) do
    widget:update(dt)
  end
end

function Game:draw()
  love.graphics.setColor(1,1,1,1)
  love.graphics.setCanvas()
  love.graphics.replaceTransform(love.math.newTransform())
  
  for _,widget in ipairs(self.widgets) do
    widget:draw()
  end
end

function Game:forwardMouseEvent(f, x, y, ...)
  if self.widgets then
    for i=1,#self.widgets do
      -- iterate in reverse order to process last dawn widgets first
      local widget = self.widgets[#self.widgets + 1 - i]
      if widget:test(x,y) and widget[f] then
        if widget[f](widget, x,y,...) then
          return
        end
      end
    end
  end
end
