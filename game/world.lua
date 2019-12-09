require 'middleclass'
local STI = require "sti/sti"
require 'game/cursor'

World = class('World', TiledWidget)
World.scale = 2
World.player = vec2(0,0)
World.player.name = 'player'
World.player.width = 24
World.player.height = 40
World.player.image = love.graphics.newImage('assets/sprites/playertoken.png')
World.player.image:setFilter('nearest','nearest')
World.player.offset = vec2(12, 32)
World.content = vec2(256,192)

function World:initialize(game)
  self.game = game
  self.map = STI('maps/worldmap.lua')
  TiledWidget.initialize(self, self.map, 0,0,love.graphics.getWidth(), love.graphics.getHeight())
  
  self.map.layers.UI.visible = false
  table.insert(self.map.layers.UI.objects, self.player)
  self.cursortext = ''
  
  self:_updatePlayerPos()
end

function World:_getObjectFromLevel(levelname)
  for _,o in ipairs(self.map.layers.UI.objects) do
    if o.name == levelname then
      return o
    end
  end
end


-- can return
--  move
--  attack
--  locked
--  nil
function World:getActionFromObject(object)
  local level = object and object.name and object.type == 'level'
  if level then
    local unlocked = self.game.state.levels[object.name]
    if unlocked then
      if object.name == self.game.state.currentlevel then
        return 'attack'
      else
        return 'move'
      end
    else
      return 'locked'
    end
  end
  return 'info'
end

function World:_updatePlayerPos(smooth)
  local level = self:_getObjectFromLevel(self.game.state.currentlevel)
  local centerx, centery = level.x+level.width/2, level.y+level.height/2
  self.player.x = centerx - self.player.offset.x
  self.player.y = centery - self.player.offset.y
  self.camera:setFromWorld(self.map, centerx, centery, 1, smooth)
end

function World:update(dt)
  TiledWidget.update(self, dt)
  self:_updatePlayerPos(true)
  if self.cursortile and self.cursortile.name then
    local _,text = self:_getAction(self.cursortile.name)
    self.cursortext = text
  else
    self.cursortext = ''
  end
end

function World:mousepressed(gx,gy,button,isTouch)
  local tileOrObject, layer, x, y = self:getTileAtPosition(gx, gy)
  if tileOrObject and tileOrObject.shape and tileOrObject.name then
    local action = self:getActionFromObject(tileOrObject)
    if action == 'attack' then
      self.game:enterCombat()
    end
    if action == 'move' then
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
  love.graphics.draw(self.player.image, self.player.x, self.player.y)
  love.graphics.pop()
  
  -- restore target canvas and draw to it
  love.graphics.setCanvas(targetCanvas)
  TiledWidget.draw(self)
end