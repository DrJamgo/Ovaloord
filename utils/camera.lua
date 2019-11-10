Camera = {}
Camera.__index = Camera

setmetatable(Camera, {
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end
})

function Camera:_init()
  self.offsetx = 0
  self.offsety = 0
  self.scale = 1
  self:updateTransform()
  return self
end

function Camera:setFromTile(map,tx,ty,zoom,isCorner)
  local wx,wy = map:convertTileToPixel(
    tx + (isCorner and 0 or 0.5),
    ty + (isCorner and 0 or 0.5))
  return self:setFromWorld(map, wx, wy, zoom)
end

function Camera:setFromWorld(map,wx,wy,zoom)
  local canvas = love.graphics.getCanvas() or love.graphics
  self.offsetx = -wx + canvas:getWidth() / 2 / zoom
  self.offsety = -wy + canvas:getHeight() / 2 / zoom
  self.scale   = zoom
  self:updateTransform()
end

function Camera:updateTransform()
  self.transform = love.math.newTransform(
    0, 0, 0, self.scale, self.scale, 
    -self.offsetx, -self.offsety)
end

function Camera:fit(map, canvas)
  local width  = map.width * map.tilewidth
  local height = map.height * map.tileheight
  local invscale = 
    math.max(width / canvas:getWidth(), height / canvas:getHeight())
  self.scale = 1 / math.floor(invscale)
  self.offsetx = -(width - canvas:getWidth() / self.scale) / 2
  self.offsety = -(height - canvas:getHeight() / self.scale) / 2
end

function Camera:getMapArgs()
  return self.offsetx, self.offsety, self.scale, self.scale
end

function Camera:getTransform()
  return self.transform
end

return setmetatable({}, Camera)