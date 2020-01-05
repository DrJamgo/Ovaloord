require 'middleclass'
StationaryVisual = class('StationaryVisual')
StationaryVisual.color = {1,1,1,1}
StationaryVisual.originy = 0
StationaryVisual.soundfile = nil

function StationaryVisual:initialize(map, pos, color)
  assert(self.spriteimage, "spriteimage not set")
  self.color = color or self.color
  self.map = map
  self.pos = vec2(pos.x, pos.y)
  self.time = 0
  if self.soundfile then
    self.sound = love.audio.newSource(self.soundfile, 'stream')
    self.sound:play()
  end
end

function StationaryVisual:getProgress()
  return self.time / self.duration
end

function StationaryVisual:update(dt)
  self.time = math.min(self.duration, self.time + dt)
  if self.time >= self.duration then
    self.map:removeObject(self)
    if self.sound then
      self.sound:release()
    end
  end
end

function StationaryVisual:draw()
  local pos = vec2(gamemap.getPixelFromTile(self.map, {x=self.pos.x, y=self.pos.y}))
  local frame = math.floor(self:getProgress() * self.frames)
  local quad = love.graphics.newQuad(self.offset.x + frame * self.quadsize.x, self.offset.y, self.quadsize.x, self.quadsize.y, self.spriteimage:getDimensions())
  love.graphics.setColor(unpack(self.color))
  love.graphics.draw(self.spriteimage, quad,
    pos.x,
    pos.y,
    0, self.scale, self.scale, self.origin.x, self.origin.y)
end

---------- SpriritVisual -----------

SpiritVisual = class('SpiritVisual', StationaryVisual)
SpiritVisual.spriteimage = love.graphics.newImage('assets/sprites/effects/undead-spirit-recruit-anim-explode.png')
SpiritVisual.spriteimage:setFilter('nearest','nearest')
SpiritVisual.scale = 1
SpiritVisual.origin = vec2(32, 128)
SpiritVisual.offset = vec2(0,0)
SpiritVisual.quadsize = vec2(64,128)
SpiritVisual.frames = 12
SpiritVisual.duration = 1.2
SpiritVisual.soundfile = 'assets/sound/spiriteffect.wav'
SpiritVisual.colors = {
  {0.2,1,1,1},
  {0.2,1,0.2,1},
  {1,0.4,0.4,1}
}

---------- SpiritOrb -----------

SpiritOrb = class('SpiritOrb', StationaryVisual)
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