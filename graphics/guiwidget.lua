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
  local tile = self:getTileAtPosition(gx, gy)
  if tile and tile.type then
    self.fraction:addUnit(tile.type, self.fraction.spawn)
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
  if self.cursortile then
    love.graphics.print(self.cursortile.type, self.cursor[1], self.cursor[2], 0, 2)
  end
end