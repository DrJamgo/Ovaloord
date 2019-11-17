require 'middleclass'
require 'utils/map'

LPCSpriteLibrary = class('LPCSSpriteLibrary')

local library
function LPCSpriteLibrary.getSprite(filepath)

  return library[filepath]
end

LPCSprite = class('LPCSprite')
function LPCSprite:initialize(filepath)
  library = library or {}
  if not library[filepath] then
    library[filepath] = love.graphics.newImage(filepath)
    library[filepath]:setFilter('nearest','nearest')
  end
  self.spriteimage = library[filepath]
end

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

function LPCSprite:drawAnimation(wx, wy, animation, direction, time)
  local anim_offset = self.anim[animation]
  self.animtime = (self.animtime or 0) + time
  if anim_offset then
    local drawframe = (math.floor(self.animtime / anim_offset.frametime) % anim_offset.framecnt)
    local anim_time_offset = (self.drawframe or 0) * 64
    local quad = love.graphics.newQuad(anim_offset.x + anim_time_offset, anim_offset.y + dir_offset[direction], self.size[1], self.size[2], self.spriteimage:getDimensions())
    
    if not self.drawpos or self.drawframe ~= drawframe then
      self.drawpos = vec2(wx, wy)
    end
    love.graphics.draw(self.spriteimage, quad, self.drawpos.x, self.drawpos.y, 0, self.scale, self.scale, unpack(self.offset))
    
    self.drawframe = drawframe
  end
end