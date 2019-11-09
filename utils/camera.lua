local camera = {}

function camera:setFromTile(map,tx,ty,zoom,isCorner)
  local wx,wy = map:convertTileToPixel(
    tx + (isCorner and 0 or 0.5),
    ty + (isCorner and 0 or 0.5))
  return self:setFromWorld(map, wx, wy, zoom)
end

function camera:setFromWorld(map,wx,wy,zoom)
  local canvas = love.graphics.getCanvas() or love.graphics
  self.offsetx = -wx + canvas:getWidth() / 2 / zoom
  self.offsety = -wy + canvas:getHeight() / 2 / zoom
  self.scale   = zoom

  self.transform = love.math.newTransform(0, 0, 0, zoom, zoom, 
    -self.offsetx, -self.offsety)
end

function camera:fit(map, canvas)
  local width  = map.width * map.tilewidth
  local height = map.height * map.tileheight
  local invscale = 
    math.max(width / canvas:getWidth(), height / canvas:getHeight())
  self.scale = 1 / math.floor(invscale)
  self.offsetx = -(width - canvas:getWidth() / self.scale) / 2
  self.offsety = -(height - canvas:getHeight() / self.scale) / 2
end

function camera:getMapArgs()
  return self.offsetx, self.offsety, self.scale, self.scale
end

function camera:getTransorm()
  return self.transform
end

return camera