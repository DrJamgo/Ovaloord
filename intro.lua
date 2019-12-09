require 'middleclass'
require 'game/widget'
Intro = class('Intro')

Intro.screens = {
  {path='res/splash/powered_by_love.png', fadein=1.0, time=3.0, fadeout=1.0, skip=true}
}

function Intro:initialize()
  self.index = 1
  self.time = 0
  self.alpha = 0
end

function Intro:isActive()
  return self.index <= #self.screens
end

function Intro:update(dt)
  local screen = self.screens[self.index]
  
  if screen then
    if not screen.image then
      screen.image = love.graphics.newImage(screen.path)
      screen.image:setFilter('nearest','nearest')
      local scale = math.max(love.graphics.getWidth() / screen.image:getWidth(), love.graphics.getHeight() / screen.image:getHeight())
      local origin = {x=screen.image:getWidth()/2, y=screen.image:getHeight()/2}
      local center = {x=love.graphics.getWidth()/2, y=love.graphics.getHeight()/2}
      self.transform = love.math.newTransform(center.x,center.y,0,scale,scale,origin.x,origin.y)
    end
    if love.mouse.isDown(1) and screen.skip then
      self.time = math.max(self.time, screen.fadein + screen.time)
    end
    self.alpha = math.min(1, self.time / screen.fadein)
    self.alpha = math.min(self.alpha, self.alpha - math.max(-1, (self.time - screen.fadein - screen.time)) / screen.fadeout)
    
    self.time = self.time + dt
    if self.time > (screen.fadein + screen.time + screen.fadeout) then
      self.time = 0
      self.index = self.index + 1
    end
  end
end

function Intro:draw()
  local screen = self.screens[self.index]
  if screen then
    love.graphics.replaceTransform(self.transform)
    love.graphics.clear(0,0,0,0)
    love.graphics.setColor(1,1,1,self.alpha)
    love.graphics.draw(screen.image)
  end
end