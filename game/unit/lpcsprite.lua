require 'middleclass'
require 'utils/map'

LPCSprite = class('LPCSprite')
LPCSprite.sprite = love.graphics.newImage('res/sprites/Canibal.png')
LPCSprite.sprite:setFilter('nearest','nearest')

LPCSprite.size = {64, 64}
LPCSprite.offset = {32, 48}
LPCSprite.scale = 1

LPCSprite.anim = {
  stand = vec2(0,512),
  move  = vec2(64,512)
}
LPCSprite.anim.move.framecnt = 8
LPCSprite.anim.move.frametime = 1/8
LPCSprite.anim.stand.framecnt = 1
LPCSprite.anim.stand.frametime = 1

-- direction: 1=right, 2=down, 3=left, 4=up
local dir_offset = {
  192,
  128,
  64,
  0
}

function LPCSprite:drawAnimation(animation, direction, time)
  local anim_offset = LPCSprite.anim[animation]
  self.animtime = (self.animtime or 0) + time
  if anim_offset then
    local drawframe = (math.floor(self.animtime / anim_offset.frametime) % anim_offset.framecnt)
    local anim_time_offset = (self.drawframe or 0) * 64
    local quad = love.graphics.newQuad(anim_offset.x + anim_time_offset, anim_offset.y + dir_offset[direction], LPCSprite.size[1], LPCSprite.size[2], LPCSprite.sprite:getDimensions())
    local wx, wy = gamemap.getPixelFromTile(self.game.map, {x=self.pos.x, y=self.pos.y})
    love.graphics.setColor(1,1,1,1)
    if not self.drawpos or self.drawframe ~= drawframe then
      self.drawpos = vec2(wx, wy)
    end
    love.graphics.draw(LPCSprite.sprite, quad, self.drawpos.x, self.drawpos.y, 0, LPCSprite.scale, LPCSprite.scale, unpack(LPCSprite.offset))
    
    self.drawframe = drawframe
  end
end