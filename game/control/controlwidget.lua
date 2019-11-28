require 'game/widget'
ControlWidget = class('ControlWidget', TiledWidget)

function ControlWidget:initialize(fraction, map, scale)
  local w,h = map.tilewidth * map.width * scale, map.tileheight * map.height * scale
  local y = love.graphics:getHeight() - h
  
  TiledWidget.initialize(self, map, 0, y, w, h, 2)
  
  self.camera:fit(map)
  self.fraction = fraction
  self.map = map
  self.tile = nil
end

function ControlWidget:mousepressed(gx,gy,button,isTouch)
  local tile, layer, x, y = self:getTileAtPosition(gx, gy)
  if tile and tile.type and tile.type ~= '' and _G[tile.type] then
    self.fraction:addUnit(tile.type, self.fraction.spawn)
    self.map:setLayerTile(layer.name, x, y, 0)
  end
end

function ControlWidget:update(dt)
  self.map:update(dt)
end

function ControlWidget:draw()
  -- save current canvas
  local targetCanvas = love.graphics.getCanvas()
  
  love.graphics.setCanvas(self.canvas)
  love.graphics.clear(0,0,0,0)
  self.map:draw(self.camera:getMapArgs())
  
  -- restore target canvas and draw to it
  love.graphics.setCanvas(targetCanvas)
  Widget.draw(self)
  if self.cursortile and self.cursortile.type then
    love.graphics.print(self.cursortile.type, self.cursor[1], self.cursor[2], 0, 2)
  end
end