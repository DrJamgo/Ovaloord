require 'utils/camera'
require 'utils/map'
require 'utils/table'
require 'game/unit/fraction'
require 'game/combat/combat'
require 'game/combat/controlwidget'
require 'game/world'
require 'middleclass'

local STI = require "sti/sti"
Game = class('Game')

function newGameState()
  local state = {}
  state.levels = {desertvillage=0}
  state.currentlevel = 'yourpyramid'
  state.souls = {3}
  return state
end

function Game:loadGame()
  local filepath = 'save.lua'
  if love.filesystem.getInfo(filepath) then
    self.state = table.load(filepath)
  else
    self.state = newGameState()
    --table.save(self.state, filepath)
  end
end

function Game:initialize()
  self:loadGame()
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

function Game:enterWorldMap()
  self.world = World(self)
  self.widgets = {}
  self:addWidget(self.world)
end

function Game:enterCombat()
  local levelname = self.state.currentlevel
  local objectives = levels.getObjectives(levelname)
  local objective = objectives[self.state.levels[levelname]+1] or Objective()
  
  self.combat = Combat(self, objective)
  self.control = ControlWidget(self.combat.fractions['Undead'], self.scale)
  self.combat.unitslayer.controlwidget = self.control
  
  self.widgets = {}
  self:addWidget(self.combat)
  self:addWidget(self.control)
  --require('utils/microscope')('Game.dot', self, 2, 'nometatables')
end

function Game:reward(unlocks, souls)
  for _,levelname in ipairs(unlocks) do
    self.state.levels[levelname]=0
  end
  for tier,amount in pairs(souls) do
    self.state.souls[tier]=(self.state.souls[tier] or 0) + amount
  end
  self.state.levels[self.state.currentlevel] = self.state.levels[self.state.currentlevel] + 1
  self.animation = 0
end

function Game:exitCombat()
  -- TODO: do something on combat exit
  self:enterWorldMap()
end

function Game:addWidget(widget)
  self.widgets[#self.widgets+1] = widget
end

function Game:update(dt)
  self.animation = (self.animation or 0) + dt
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
  local textscale = T.defaultscale * 1.5 * (1 + 0.3 * math.sin(math.min(math.pi, self.animation * 10)))
  local text = ''
  for tier,souls in ipairs(self.state.souls) do
    text = text..S.tier[tier]..tostring(souls)
  end
  love.graphics.printf(text, 0, 0, (love.graphics.getWidth()-40)/textscale, 'right', 0, textscale)
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
