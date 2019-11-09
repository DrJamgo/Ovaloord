
local sti = require "sti/sti"
local map = sti("res/maps/untitled.lua")

local minimap_canvas = love.graphics.newCanvas(160, 120)

local camera = require 'utils/camera'
local zoom = 2

function love.wheelmoved(x, y)
  zoom = math.max(1, math.min(4,zoom + y / 2))
end

function love.load(arg)
  if arg[#arg] == "-debug" then require("mobdebug").start() end
  
  for i,layer in ipairs(map.layers) do
    layer.properties.visible = layer.visible or false
  end
  
  for i,layer in ipairs(map.layers) do
    layer.visible = layer.properties.minimap or false
  end
  
  love.graphics.setCanvas(minimap_canvas)
  love.graphics.clear(0,0,0,0)
  local camera = require 'utils/camera'
  camera:fit(map, minimap_canvas)
  map:draw(camera:getMapArgs())
  love.graphics.setCanvas()
end

function love.update(dt)
  map:update(dt)
end

function love.draw()
  for i,layer in ipairs(map.layers) do
    layer.visible = layer.properties.visible
  end
  
  camera:setFromTile(map,9,11,zoom)
  map:draw(camera:getMapArgs())
  love.graphics.replaceTransform(love.math.newTransform())
  love.graphics.draw(minimap_canvas, 0, 0)
  love.graphics.rectangle("line",0,0,minimap_canvas:getWidth(), minimap_canvas:getHeight())
end

