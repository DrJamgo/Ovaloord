require 'middleclass'
local STI = require "sti/sti"

World = class('World', TiledWidget)
World.scale = 2
World.player = {}
World.player.image = love.graphics.newImage('res/sprites/playertoken.png')
World.player.image:setFilter('nearest','nearest')
World.player.offset = vec2(12, 32)

function World:initialize(game)
  self.game = game
  self.map = STI('res/maps/worldmap.lua')
  TiledWidget.initialize(self, self.map, 0,0,love.graphics.getWidth(), love.graphics.getHeight(), self.scale)
  
  self.map.layers.UI.visible = false
end

function World:_getObjectFromLevel(levelname)
  for _,o in ipairs(self.map.layers.UI.objects) do
    if o.name == levelname then
      return o
    end
  end
end

function World:update(dt)
  local level = self:_getObjectFromLevel(self.game.state.currentlevel)
  self.player.pos = vec2( level.x+level.width/2, level.y+level.height/2)
  self.camera:setFromWorld(self.map, self.player.pos.x, self.player.pos.y, self.scale)
end

function World:mousepressed(gx,gy,button,isTouch)
  local tileOrObject, layer, x, y = self:getTileAtPosition(gx, gy)
  if tileOrObject.shape and tileOrObject.name then
    local level = self.game.state.levels[tileOrObject.name]
    if tileOrObject.name == self.game.state.currentlevel then
      self.game:enterCombat()
    else
      self.game.state.currentlevel = tileOrObject.name
    end
  end
end

function World:draw()
  -- save current canvas
  local targetCanvas = love.graphics.getCanvas()
  
  love.graphics.setCanvas(self.canvas)
  love.graphics.clear(0,0,0,0)
  self.map:draw(self.camera:getMapArgs())
  love.graphics.push()
  love.graphics.replaceTransform(self.camera:getTransform())
  love.graphics.draw(self.player.image, self.player.pos.x, self.player.pos.y, nil,nil,nil,self.player.offset.x, self.player.offset.y)
  love.graphics.pop()
  
  -- restore target canvas and draw to it
  love.graphics.setCanvas(targetCanvas)
  Widget.draw(self)
  if self.cursortile and self.cursortile.name then
    love.graphics.setColor(0,0,0,1)
    love.graphics.print(self.cursortile.name, self.cursor[1], self.cursor[2], 0, 2)
  end
end