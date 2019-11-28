require 'middleclass'
Projectile = class('Projectile')

Projectile.spriteimage = love.graphics.newImage('res/sprites/arrow.png')
Projectile.speed = 15
Projectile.scale = 1
Projectile.offset = vec2(16, 16)
Projectile.quadsize = vec2(32,32)

function Projectile:initialize(ability, unit, target)
  self.ability = ability
  self.pos = vec2(unit.pos.x, unit.pos.y)
  self.unit = unit
  self.target = target
  
  self.diff = vec2_sub(target.pos, unit.pos)
  
  -- 1=right, 2=down, 3=left, 4=up
  self.dir = (math.floor((math.atan2(self.diff.y, self.diff.x) / math.pi * 2 + 0.5))) % 4 + 1
  self.diff, self.duration = vec2_norm(self.diff)
  self.duration = self.duration / self.speed
  self.time = 0
end

function Projectile:getProgress()
  return self.time / self.duration
end

function Projectile:update(dt)
  self.pos = vec2_add(self.pos, vec2_norm(self.diff, dt * self.speed))
  self.time = math.min(1, self.time + dt)
  if self.time >= self.duration then
    self.target:hit(self.ability.dmg, self.unit)
    self.unit.map:removeObject(self)
  end
end

function Projectile:draw()
  local pos = vec2(gamemap.getPixelFromTile(self.unit.map, {x=self.pos.x, y=self.pos.y}))
  local quad = love.graphics.newQuad(0, (self.dir - 1) * self.quadsize.y, self.quadsize.x, self.quadsize.y, self.spriteimage:getDimensions())
  love.graphics.draw(self.spriteimage, quad,
    pos.x,
    pos.y - math.sin(self:getProgress()*math.pi) * self.curve,
    0, self.scale, self.scale, self.offset.x, self.offset.y)
    
end

Arrow = class('Arrow', Projectile)
Arrow.spriteimage = love.graphics.newImage('res/sprites/arrow.png')
Arrow.speed = 15
Arrow.curve = 8