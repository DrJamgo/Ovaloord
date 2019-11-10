local STI = require "sti/sti"
require 'utils/camera'
require 'utils/map'

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
  self.minimap_canvas = love.graphics.newCanvas(160, 120)
  self.main_canvas    = love.graphics.newCanvas(800, 640)
  self.maincamera = Camera()
  self.minimapcamera = Camera()
  self.zoom = 2
  return self
end

function Game:load(mapPath)
  local map = STI(mapPath)
  self.map = map
  
  local object = gamemap.getObjectByName(self.map, "spawn")
  self.spawn = {map:convertPixelToTile(object.x, object.y)}
  object = gamemap.getObjectByName(self.map, "goal")
  self.goal = {map:convertPixelToTile(object.x, object.y)}
  
  self.renderer.load(self)
end

function Game:update(dt)
  self.map:update(dt)
end

function Game:draw()
  self.renderer.draw(self)
end

