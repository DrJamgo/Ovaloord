local STI = require "sti/sti"
require 'utils/camera'
require 'utils/map'
require 'game/grid'
require 'game/unit'
require 'astar/astar'
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
  self.grid = Grid(map)
  
  local object = gamemap.getObjectByName(map, "spawn")
  self.spawn = gamemap.getTileFromObject(map, object)
  object = gamemap.getObjectByName(map, "goal")
  self.goal = gamemap.getTileFromObject(map, object)
  
  self.renderer.load(self)
  
  self.units = {}
  for i=1,5 do
    self.units[i] = Unit(self, 1, 4+i)
  end
end

function Game:update(dt)
  dt = math.min(dt, 0.25)
  if love.keyboard.isDown('x') then dt = dt * 10 end
  if love.keyboard.isDown('y') then dt = dt * 0.1 end
  self.map:update(dt)
  self.grid:update(dt, self.units)
  for _,unit in ipairs(self.units) do
    unit:update(dt)
  end
end

function Game:draw()
  self.renderer.draw(self)
  love.graphics.replaceTransform(self.maincamera:getTransform())
  for _,unit in ipairs(self.units) do
    unit:draw()
  end
end

