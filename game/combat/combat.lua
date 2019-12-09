require 'middleclass'
require 'game/widget'
require 'game/combat/unitslayer'
require 'game/combat/gridlayer'
Combat = class('Combat', TiledWidget)
Combat.scale = 2
local STI = require "sti/sti"

function Combat:initialize(map)
  TiledWidget.initialize(self, map, 0, 0, love.graphics:getWidth(), love.graphics:getHeight(), self.scale)
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
  local undead = self.fractions['Undead']
  self.camera:setFromTile(self.map, undead.spawn.x, undead.spawn.y, 1)
end


function Combat:update(dt)
  TiledWidget.update(self, dt)
  local undead = self.fractions['Undead']
  local leader = self.fractions['Undead']:getLeadingUnit()
  if leader then
    self.camera:setFromTile(self.map, leader.pos.x, leader.pos.y, 1, true)
  else
    local x,y = unpack(undead.spawn)
    self.camera:setFromTile(self.map, undead.spawn.x, undead.spawn.y, 1, true)
  end
  self.gridlayer.visible = options['g']

  self.gridlayer.cursor = self.cursorl
  self.map:update((options['p'] and 0) or dt)
end

function Combat:draw()

  -- save current canvas
  local targetCanvas = love.graphics.getCanvas()
  
  love.graphics.setCanvas(self.canvas)
  love.graphics.clear(0,0,0,0)

  self.map:draw(self.camera:getMapArgs())
  
  -- restore target canvas and draw to it
  love.graphics.setCanvas(targetCanvas)
  Widget.draw(self)
end