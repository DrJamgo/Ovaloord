require('graphics/widget')
MainViewWidget = class('MainViewWidget', Widget)

function MainViewWidget:initialize(map, ...)  
  Widget.initialize(self, ...)
  self.map = map
  self.camera = Camera(self.canvas)
end

function MainViewWidget:draw()
  -- save current canvas
  local targetCanvas = love.graphics.getCanvas()
  
  love.graphics.setCanvas(self.canvas)
  love.graphics.clear(0,0,0,0)
  if self.focus then
    self.camera:setFromTile(self.map, self.focus.x, self.focus.y, 1)
  else
    self.camera:setFromTile(self.map, 1, 1, 1)
  end
  self.map:draw(self.camera:getMapArgs())
  
  -- restore target canvas and draw to it
  love.graphics.setCanvas(targetCanvas)
  Widget.draw(self)
end

function MainViewWidget:setFocus(focus)
  self.focus = focus
end