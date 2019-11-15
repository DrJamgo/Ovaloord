require 'middleclass'
require 'utils/map'

LPCSprite = class('LPCSprite')

function LPCSprite:draw()
  local wx, wy = gamemap.getPixelFromTile(self.game.map, {x=self.tx, y=self.ty})
   
  self.rect = {
    wx + self.offset.x, 
    wy + self.offset.y,
    self.size.x,
    self.size.y
  }
  self.circle = {
    wx,
    wy,
    self.size.x / 2
  }
  
  love.graphics.setColor(1,0,0)
  love.graphics.circle("line",unpack(self.circle))
  love.graphics.rectangle("line",unpack(self.rect))
end