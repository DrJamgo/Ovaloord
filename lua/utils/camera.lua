Camera = {}
Camera.__index = Camera
Camera.speed = 3

setmetatable(Camera, {
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end
})

function Camera:_init(canvas)
  self.canvas = canvas or love.window
  self.offsetx = 0
  self.offsety = 0
  self.scale = 1
  self:_updateTransform()
  return self
end

function Camera:update(dt)
  if self.target then
    local diffx, diffy = self.target.x - self.offsetx, self.target.y - self.offsety
    if diffx ~= 0 or diffy ~= 0 then
      local step = math.ceil(self.speed * dt)
      diffx = math.max(-step, math.min(step, diffx))
      diffy = math.max(-step, math.min(step, diffy))
      self.offsetx = self.offsetx + diffx
      self.offsety = self.offsety + diffy
      self:_updateTransform()
    else
      self.target = nil
    end
  end
end

function Camera:setFromTile(map,tx,ty,zoom,smooth)
  local wx,wy = gamemap.getPixelFromTile(map, {x=tx, y=ty})
  return self:setFromWorld(map, wx, wy, zoom or self.scale, smooth)
end

function Camera:setFromWorld(map,wx,wy,zoom,smooth)
  local canvas = self.canvas
  self.target = {}
  self.scale   = zoom or self.scale
  self.target = vec2(math.floor(-wx + canvas:getWidth() / 2 / self.scale),
    math.floor(-wy + canvas:getHeight() / 2 / self.scale))
  if not smooth then
    self.offsetx = self.target.x
    self.offsety = self.target.y
    self.target = nil
  end
  self:_limitToMap(map)
  self:_updateTransform()
end

function Camera:_limitToMap(map)
  local max_x = map.width * map.tilewidth - self.canvas:getWidth() / self.scale
  local max_y = map.height * map.tileheight - self.canvas:getHeight() / self.scale
  self.offsetx = math.max(math.min(self.offsetx, 0), -max_x)
  self.offsety = math.max(math.min(self.offsety, 0), -max_y)
end

function Camera:_updateTransform()
  self.transform = love.math.newTransform(
    0, 0, 0, self.scale, self.scale, 
    -self.offsetx, -self.offsety)
end

function Camera:fit(map)
  local map_w, map_h  = map.width * map.tilewidth, map.height * map.tileheight
  local canv_w, canv_h = self.canvas:getDimensions()
  local invscale = 
    math.max(map_w / self.canvas:getWidth(), map_h / self.canvas:getHeight())
  local scale = 1 / invscale
  self.scale = scale
  self.offsetx = -(map_w - self.canvas:getWidth() / self.scale) / 2
  self.offsety = -(map_h - self.canvas:getHeight() / self.scale) / 2
end

function Camera:getMapArgs()
  return self.offsetx, self.offsety, self.scale, self.scale
end

function Camera:getTransform()
  return self.transform
end

return setmetatable({}, Camera)