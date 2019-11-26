require('graphics/mainviewwidget')
GuiWidget = class('GuiWidget', MainViewWidget)

function GuiWidget:initialize(fraction, map, ...)  
  MainViewWidget.initialize(self, map, ...)
  
  self.camera:fit(map)
  self.fraction = fraction
  self.map = map
  self.tile = nil
end

function GuiWidget:mousepressed(gx,gy,button,isTouch)
  local tile, layer, x, y = self:getTileAtPosition(gx, gy)
  if tile and tile.type and tile.type ~= '' and _G[tile.type] then
    self.fraction:addUnit(tile.type, self.fraction.spawn)
    self.map:setLayerTile(layer.name, x, y, 0)
  end
end

function GuiWidget:mousemoved(gx,gy)
  local tile = self:getTileAtPosition(gx, gy)
  self.cursortile = tile
  self.cursor = {gx, gy}
  return self.tile ~= nil
end

function GuiWidget:draw()
  MainViewWidget.draw(self)
  if self.cursortile and self.cursortile.type then
    love.graphics.print(self.cursortile.type, self.cursor[1], self.cursor[2], 0, 2)
  end
end