require 'middleclass'
local STI = require "sti/sti"

World = class('World', TiledWidget)
World.scale = 2
World.player = {}
World.player.image = love.graphics.newImage('res/sprites/playertoken.png')
World.player.image:setFilter('nearest','nearest')
World.player.offset = vec2(12, 32)

World.content = vec2(240,160)

function World:initialize(game)
  self.game = game
  self.map = STI('res/maps/worldmap.lua')
  TiledWidget.initialize(self, self.map, 0,0,love.graphics.getWidth(), love.graphics.getHeight())
  
  self.map.layers.UI.visible = false
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
function World:_getAction(objectname)
  local level = self.game.state.levels[objectname]
  if level then
    if objectname == self.game.state.currentlevel then
      return 'attack', S.attack..objectname
    else
      return 'move', S.move..objectname
    end
  else
    return 'locked', S.locked..objectname
  end
end

function World:_updatePlayerPos(smooth)
  local level = self:_getObjectFromLevel(self.game.state.currentlevel)
  self.player.pos = vec2( level.x+level.width/2, level.y+level.height/2)
  self.camera:setFromWorld(self.map, self.player.pos.x, self.player.pos.y, 1, smooth)
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
    local action = self:_getAction(tileOrObject.name)
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
  love.graphics.draw(self.player.image, self.player.pos.x, self.player.pos.y, nil,nil,nil,self.player.offset.x, self.player.offset.y)
  if self.cursor then
    love.graphics.printf(self.cursortext, self.cursor[1]-200, self.cursor[2], 400, "center",0, 1.0)
  end
  love.graphics.pop()
  
  -- restore target canvas and draw to it
  love.graphics.setCanvas(targetCanvas)
  Widget.draw(self)

end