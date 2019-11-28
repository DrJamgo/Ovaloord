require 'utils/camera'
require 'utils/map'
require 'game/unit/fraction'
require 'game/combat/combat'
require 'game/control/controlwidget'

require 'middleclass'

local STI = require "sti/sti"
Game = class('Game')

function Game:initialize()
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
  self.combatmap = STI('res/maps/untitled.lua')
  self.combat = Combat(self.combatmap)
  self.control = ControlWidget(self.combat.fractions['Undead'], self.guimap, self.scale)
  
  self.widgets = {}
  self:addWidget(self.combat)
  self:addWidget(self.control)
  
  require('utils/microscope')('Game.dot', self, 2, 'nometatables')
end

function Game:addWidget(widget)
  self.widgets[#self.widgets+1] = widget
end

function Game:update(dt)
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
