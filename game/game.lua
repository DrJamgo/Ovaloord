local STI = require "sti/sti"
require 'utils/camera'

Game = {}
Game.__index = Game

setmetatable(Game, {
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end
})

function Game:_init()
  self.minimap_canvas = love.graphics.newCanvas(160, 120)
  self.maincamera = Camera()
  self.minimapcamera = Camera()
  self.zoom = 2
  return self
end

function Game:load(mapPath)
  self.map = STI(mapPath)
  
  -- save original visibility state in properties
  for i,layer in ipairs(self.map.layers) do
    layer.properties.visible = layer.visible or false
  end
  
  for i,layer in ipairs(self.map.layers) do
    layer.visible = layer.properties.minimap or false
  end
  
  -- draw minimap once
  love.graphics.setCanvas(self.minimap_canvas)
  love.graphics.clear(0,0,0,0)
  self.minimapcamera:fit(self.map, self.minimap_canvas)
  self.map:draw(self.minimapcamera:getMapArgs())
  love.graphics.setCanvas()
  
  -- restore original state
  for i,layer in ipairs(self.map.layers) do
    layer.visible = layer.properties.visible
  end
end

function Game:update(dt)
  self.map:update(dt)
end

function Game:draw()
  local map = self.map
  local minimap_canvas = self.minimap_canvas
  
  -- draw map
  self.maincamera:setFromTile(map,9,11,self.zoom)
  self.map:draw(self.maincamera:getMapArgs())
  -- redraw units layer (transparent)
  love.graphics.replaceTransform(self.maincamera:getTransform())
  map.layers.Units.properties.opacity = map.layers.Units.opacity
  map.layers.Units.opacity = 0.3
  map:drawLayer(map.layers.Units)
  map.layers.Units.opacity = map.layers.Units.properties.opacity
  
  love.graphics.replaceTransform(love.math.newTransform())
  love.graphics.draw(minimap_canvas, 0, 0)
  love.graphics.rectangle("line",0,0,minimap_canvas:getWidth(), minimap_canvas:getHeight())
end