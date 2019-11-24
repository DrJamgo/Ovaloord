require('middleclass')
Widget = class('Widget')

function Widget:initialize(x, y, w, h, scale)
  self.rect = {x, y, w, h}
  self.scale = scale
  self.canvas = love.graphics.newCanvas(w / scale, h / scale)
  self.canvas:setFilter('nearest', 'nearest')
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

function Widget:draw()
  love.graphics.push()
  local x,y,w,h = unpack(self.rect)
  local hscale = self:getWidth() / self.canvas:getWidth()
  local vscale = self:getHeight() / self.canvas:getHeight()
  local t = love.math.newTransform(x,y,0,hscale,vscale)
  love.graphics.replaceTransform(t)
  love.graphics.draw(self.canvas)
  
  love.graphics.pop()
  love.graphics.rectangle("line",x,y,w,h)
end