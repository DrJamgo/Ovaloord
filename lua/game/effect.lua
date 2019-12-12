require 'middleclass'
StationaryEffect = class('StationaryEffect')
StationaryEffect.color = {1,1,1,1}
StationaryEffect.originy = 0

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
  self.time = math.min(self.duration, self.time + dt)
  if self.time >= self.duration then
    self.map:removeObject(self)
  end
end

function StationaryEffect:draw()
  local pos = vec2(gamemap.getPixelFromTile(self.map, {x=self.pos.x, y=self.pos.y}))
  local frame = math.floor(self:getProgress() * self.frames)
  local quad = love.graphics.newQuad(self.offset.x + frame * self.quadsize.x, self.offset.y, self.quadsize.x, self.quadsize.y, self.spriteimage:getDimensions())
  love.graphics.setColor(unpack(self.color))
  love.graphics.draw(self.spriteimage, quad,
    pos.x,
    pos.y,
    0, self.scale, self.scale, self.origin.x, self.origin.y)
end

---------- SpriritEffect -----------

SpiritEffect = class('SpiritEffect', StationaryEffect)
SpiritEffect.spriteimage = love.graphics.newImage('assets/sprites/effects/undead-spirit-recruit-anim-explode.png')
SpiritEffect.spriteimage:setFilter('nearest','nearest')
SpiritEffect.scale = 1
SpiritEffect.origin = vec2(32, 128)
SpiritEffect.offset = vec2(0,0)
SpiritEffect.quadsize = vec2(64,128)
SpiritEffect.frames = 12
SpiritEffect.duration = 1.2
SpiritEffect.colors = {
  {0.2,1,1,1},
  {0.2,1,0.2,1},
  {1,0.4,0.4,1}
}

---------- SpiritOrb -----------

SpiritOrb = class('SpiritOrb', StationaryEffect)
SpiritOrb.spriteimage = love.graphics.newImage('assets/sprites/effects/rotating_orbs.png')
SpiritOrb.spriteimage:setFilter('nearest','nearest')
SpiritOrb.scale = 1
SpiritOrb.origin = vec2(6, 12)
SpiritOrb.offset = vec2(0,24)
SpiritOrb.quadsize = vec2(24,24)
SpiritOrb.frames = 4
SpiritOrb.duration = 0.6
SpiritOrb.colors = {
  {0.2,1,1,1},
  {0.2,1,0.2,1},
  {1,0.4,0.4,1}
}

function SpiritOrb:update(dt)
  self.time = (self.time + dt) % self.duration
end