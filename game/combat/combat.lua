require 'middleclass'
require 'game/widget'
require 'game/combat/unitslayer'
require 'game/combat/gridlayer'
Combat = class('Combat', TiledWidget)

local STI = require "sti/sti"

function Combat:initialize(map)
  TiledWidget.initialize(self, map, 0, 0, love.graphics:getWidth(), love.graphics:getHeight(), 2)
  map.addObject = addObject
  map.removeObject = removeObject
  
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
end

function Combat:_setFocus(focus)
  self.focus = focus
end

function Combat:update(dt)
  local undead = self.fractions['Undead']
  local leader = self.fractions['Undead']:getLeadingUnit()
  if leader then
    self:_setFocus(leader.pos)
  else
    self:_setFocus(undead.spawn)
  end
  self.gridlayer.cursor = self.cursorl
  self.map:update(dt)
end

function Combat:draw()
  self.gridlayer.visible = options['g']
  
  -- save current canvas
  local targetCanvas = love.graphics.getCanvas()
  
  love.graphics.setCanvas(self.canvas)
  love.graphics.clear(0,0,0,0)
  if self.focus then
    self.camera:setFromTile(self.map, self.focus.x, self.focus.y, 1)
  else
    self.camera:setFromTile(self.map, 1, 1, 1)
  end
  self.map:draw(self.camera:getMapArgs())
  
  -- restore target canvas and draw to it
  love.graphics.setCanvas(targetCanvas)
  Widget.draw(self)
end