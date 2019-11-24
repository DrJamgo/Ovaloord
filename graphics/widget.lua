require('middleclass')
Widget = class('Widget')

function Widget:initialize(rect)
  self.rect = rect
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

function Widget:draw(canvas)
  love.graphics.push()
  local x,y,w,h = unpack(self.rect)
  local hscale = self:getWidth() / canvas:getWidth()
  local vscale = self:getHeight() / canvas:getHeight()
  local t = love.math.newTransform(x,y,0,hscale,vscale)
  love.graphics.replaceTransform(t)
  love.graphics.draw(canvas)
  
  love.graphics.pop()
  love.graphics.rectangle("line",x,y,w,h)
end