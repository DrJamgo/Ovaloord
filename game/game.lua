local STI = require "sti/sti"
require 'utils/camera'
require 'utils/map'
require 'game/grid'
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
end

function Game:update(dt)
  self.map:update(dt)
  local astar = AStar(self.grid)
  self.path = astar:findPath(self.spawn, self.goal)
end

function Game:draw()
  self.renderer.draw(self)
  love.graphics.replaceTransform(self.maincamera:getTransform())
  local nodes = self.path:getNodes()
  for i=1,#nodes-1 do
    local x1, y1 = gamemap.getPixelFromTile(self.map, nodes[i].location)
    local x2, y2 = gamemap.getPixelFromTile(self.map, nodes[i+1].location)
    love.graphics.line(x1, y1, x2, y2)
  end
end

