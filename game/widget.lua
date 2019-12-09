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

function Widget:update(dt)
end

TiledWidget = class('TiledWidget', Widget)

function TiledWidget:initialize(map, ...)  
  Widget.initialize(self, ...)
  self.map = map
  self.camera = Camera(self.canvas)
end

function TiledWidget:getMapFromScreen(screenx, screeny)
  -- transform from screen to canvas pixels
  local canvasx, canvasy = self.transform:inverseTransformPoint(screenx, screeny)
  -- transform from canvas to map pixels
  return self.camera.transform:inverseTransformPoint(canvasx, canvasy)
end

function TiledWidget:getTileAtPosition(...)
  local mapx, mapy = self:getMapFromScreen(...)
  -- transform from map pixels to map tiles
  local tx, ty = self.map:convertPixelToTile(mapx, mapy)
  tx = math.floor(tx + 1)
  ty = math.floor(ty + 1)
  for i=1,#self.map.layers do
    local layer = self.map.layers[#self.map.layers + 1 - i]
    if layer.data and layer.data[ty] then
      local tile = layer.data[ty][tx]
      if tile then return tile, layer, tx, ty end
    end
    for _,object in ipairs(layer.objects or {}) do
      if object.x and mapx >= object.x and mapx <= object.x + object.width and mapy >= object.y and mapy <= object.y + object.height then
        return object, layer
      end
    end
  end
  return nil
end

function TiledWidget:mousemoved(gx,gy)
  local tile, layer, tx, ty = self:getTileAtPosition(gx, gy)
  self.cursortile = tile
  self.cursorl = {tx, ty}
  self.cursor = {gx, gy}
  return self.tile ~= nil
end