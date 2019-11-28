require 'middleclass'
StationaryEffect = class('StationaryEffect')
StationaryEffect.color = {1,1,1,1}

function StationaryEffect:initialize(map, pos, color)
  assert(self.spriteimage, "spriteimage not set")
  self.color = color or self.color
  self.map = map
  self.pos = vec2(pos.x, pos.y)
  self.time = 0
end

function StationaryEffect:getProgress()
  return self.time / self.duration
end

function StationaryEffect:update(dt)
  self.time = math.min(1, self.time + dt)
  if self.time >= self.duration then
    self.map:removeObject(self)
  end
end

function StationaryEffect:draw()
  local pos = vec2(gamemap.getPixelFromTile(self.map, {x=self.pos.x, y=self.pos.y}))
  local frame = math.floor(self:getProgress() * self.frames)
  local quad = love.graphics.newQuad(frame * self.quadsize.x, 0, self.quadsize.x, self.quadsize.y, self.spriteimage:getDimensions())
  love.graphics.setColor(unpack(self.color))
  love.graphics.draw(self.spriteimage, quad,
    pos.x,
    pos.y,
    0, self.scale, self.scale, self.offset.x, self.offset.y)
end

SpiritEffect = class('SpiritEffect', StationaryEffect)
SpiritEffect.spriteimage = love.graphics.newImage('res/sprites/effects/undead-spirit-recruit-anim-explode.png')
--SpiritEffect.spriteimage:setFilter('nearest','nearest')
SpiritEffect.scale = 1
SpiritEffect.offset = vec2(32, 128)
SpiritEffect.quadsize = vec2(64,128)
SpiritEffect.frames = 12
SpiritEffect.duration = 1