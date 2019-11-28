require('middleclass')
Widget = class('Widget')

function Widget:initialize(x, y, w, h, scale)
  self.rect = {x, y, w, h}
  self.scale = scale
  self.canvas = love.graphics.newCanvas(w / scale, h / scale)
  self.canvas:setFilter('nearest', 'nearest')
  
  local hscale = self:getWidth() / self.canvas:getWidth()
  local vscale = self:getHeight() / self.canvas:getHeight()
  self.transform = love.math.newTransform(x,y,0,hscale,vscale)
end

function Widget:getDimensions()
  return self.rect[3], self.rect[4]
end

function Widget:getWidth()
  return self.rect[3]
end

function Widget:getHeight()
  return self.rect[4]
end

function Widget:test(mx,my)
  local x,y,w,h = unpack(self.rect)
  return mx >= x and mx <= x + w and my >= y and my <= y + h
end

function Widget:draw()
  love.graphics.push()
  local x,y,w,h = unpack(self.rect)
  love.graphics.replaceTransform(self.transform)
  love.graphics.draw(self.canvas)
  love.graphics.pop()
  --love.graphics.rectangle("line",x,y,w,h)
end

STIWidget = class('STIWidget', Widget)
function STIWidget:initialize(stimap)

end