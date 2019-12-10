require('middleclass')
Widget = class('Widget')
Widget.content = vec2(320,240)

function Widget:initialize(x, y, w, h, scale)
  self.rect = {x, y, w, h}
  self.scale = scale or math.floor(math.min(h / self.content.y, w / self.content.x))
  
  self.canvas = love.graphics.newCanvas(w / self.scale, h / self.scale)
  self.canvas:setFilter('nearest', 'nearest')
  self.cursor = Cursor(self)
  
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

function Widget:update(dt)
end

function Widget:draw()
  love.graphics.push()
  local x,y,w,h = unpack(self.rect)
  love.graphics.replaceTransform(self.transform)
  love.graphics.draw(self.canvas)
  love.graphics.pop()
  --love.graphics.rectangle("line",x,y,w,h)
end

TiledWidget = class('TiledWidget', Widget)

function TiledWidget:initialize(map, ...)  
  Widget.initialize(self, ...)
  self.map = map
  self.camera = Camera(self.canvas)
end

function TiledWidget:update(dt)
  self.camera:update(dt)
  self.cursor:update(dt)
end

function TiledWidget:getMapFromScreen(screenx, screeny)
  -- transform from screen to canvas pixels
  local canvasx, canvasy = self.transform:inverseTransformPoint(screenx, screeny)
  -- transform from canvas to map pixels
  return self.camera.transform:inverseTransformPoint(canvasx, canvasy)
end

function TiledWidget:convertMapToScreen(mx, my)
  local canvasx, canvasy = self.camera.transform:transformPoint(mx, my)
  return self.transform:transformPoint(canvasx, canvasy)
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
    for _,object in pairs(layer.objects or {}) do
      local x,y = object.x, object.y
      local w,h = object.width, object.height
      if object.sprite then
        x,y = object.sprite.x, object.sprite.y
        w,h = object.sprite.width, object.sprite.height
      end
      if x and mapx >= x and mapx <= x + w and mapy >= y and mapy <= y + h then
        return object, layer
      end
    end
  end
  return nil
end

function TiledWidget:getObjectDecription(object)
  if object.brief then
    return object.brief, object.long
  elseif object.name then
    return T.get(object.name)
  elseif object.type and object.type ~= '' then
    if _G[object.type] and _G[object.type].brief then
      return _G[object.type].brief, _G[object.type].long
    end
    return T.get(object.type)
  end
end

function TiledWidget:draw()
  Widget.draw(self)
  self.cursor:draw()
end