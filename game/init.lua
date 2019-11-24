local STI = require "sti/sti"
require 'utils/camera'
require 'utils/map'
require 'game/grid'
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

function Game:load(mapPath)
  self.guimap = STI('res/maps/gui_units.lua')
  
  local map = STI(mapPath)
  self.mappath = mapPath
  self.map = map
  self.grid = Grid(map)

  self.units = {}
  self.objects = {}
  self.fractions = {}
  self.renderer.load(self)
  
  for l,layer in ipairs(map.layers) do
    local fraction = layer.properties.fraction
    if fraction then
      self.fractions[#self.fractions] = _G[fraction](self, layer)
    end
  end
  
  require('utils/microscope')('Game.dot', self, 2, 'nometatables')
end

function Game:update(dt)
  dt = math.min(dt, 0.25)
  if love.keyboard.isDown('y') then dt = dt * 0.1 end
  if options['p'] then dt = 0 end
  local leading_undead = nil
  for _=1,(love.keyboard.isDown('x') and 10) or 1 do
    self.map:update(dt)
    self.grid:update(dt, self.units)
    for _,unit in pairs(self.units) do
      unit:update(dt*1.25)
    end
    for _,object in pairs(self.objects) do
      object:update(dt)
    end
  end
end

function Game:draw()
  self.renderer.draw(self)
end

function Game:addUnit(unit)
  self.units[#self.units+1] = unit
  unit.id = #self.units
end
local id = 1
function Game:addObject(object)
  self.objects[id] = object
  object.id = id
  id = id + 1
end

function Game:removeObject(object)
  self.objects[object.id] = nil
end
