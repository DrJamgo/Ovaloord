require 'middleclass'
require 'game/widget'
require 'page'

FadeScreen = class('FadeScreen')
function FadeScreen:initialize(path, fadein, time, fadeout, skip)
  self.path = path
  self.fadein = fadein
  self.duration = time
  self.fadeout = fadeout
  self.skip = skip
  
  self.time = 0
  self.alpha = 0
  
  self.image = love.graphics.newImage(self.path)
  self.image:setFilter('nearest','nearest')
  local scale = math.max(love.graphics.getWidth() / self.image:getWidth(), love.graphics.getHeight() / self.image:getHeight())
  local origin = {x=self.image:getWidth()/2, y=self.image:getHeight()/2}
  local center = {x=love.graphics.getWidth()/2, y=love.graphics.getHeight()/2}
  self.transform = love.math.newTransform(center.x,center.y,0,scale,scale,origin.x,origin.y)
end

function FadeScreen:update(dt)
  if love.mouse.isDown(1) and self.skip then
    self.time = math.max(self.time, self.fadein + self.duration)
  end
  self.alpha = math.min(1, self.time / self.fadein)
  self.alpha = math.min(self.alpha, self.alpha - math.max(-1, (self.time - self.fadein - self.duration)) / self.fadeout)
  
  self.time = self.time + dt
  if self.time > (self.fadein + self.duration + self.fadeout) then
    return true
  end
end

function FadeScreen:draw()
  love.graphics.replaceTransform(self.transform)
  love.graphics.clear(0,0,0,0)
  love.graphics.setColor(1,1,1,self.alpha)
  love.graphics.draw(self.image)
end

OvaLoordScreen = class('OvaLoordScreen', FadeScreen)
OvaLoordScreen.numframes = 5
OvaLoordScreen.size = vec2(128,72)
function OvaLoordScreen:initialize(...)
  FadeScreen.initialize(self, ...)
  local scale = math.max(love.graphics.getWidth() / self.image:getWidth() / self.numframes, love.graphics.getHeight() / self.image:getHeight())
  local origin = {x=self.image:getWidth()/2/self.numframes, y=self.image:getHeight()/2}
  local center = {x=love.graphics.getWidth()/2, y=love.graphics.getHeight()/2}
  self.transform = love.math.newTransform(center.x,center.y,0,scale,scale,origin.x,origin.y)
  self:update(0.1)
end

function OvaLoordScreen:update(dt)
  local finished = FadeScreen.update(self, dt)
  local inframe = self.time - self.fadein
  local animduration = 1.0
  local frame = math.max(0,math.min(math.floor(inframe / animduration * self.numframes),self.numframes-1))
  self.quad = love.graphics.newQuad(frame*self.size.x,0,self.size.x,self.size.y,self.size.x*self.numframes,self.size.y)
  
  if not self.sound and frame >= 3 then
    self.sound = love.audio.newSource("assets/sound/ghostbreath.wav", 'stream')
    self.sound:setVolume(0.5) -- 90% of ordinary volume
    self.sound:play()
  end  

  return finished
end

function OvaLoordScreen:draw()
  if self.quad then
    love.graphics.setColor(1,1,1,self.alpha)
    love.graphics.draw(self.image, self.quad, self.transform)
  end
end

Intro = class('Intro', Page)

Intro.screens = {
  FadeScreen('assets/splash/powered_by_love.png', 1.0, 3.0, 0.0, true),
  OvaLoordScreen('assets/splash/Ovaloord.png', 0.0, 2.0, 1.0, true),
}

function Intro:initialize()
  self.index = 1
end

function Intro:update(dt)
  local screen = self.screens[self.index]
  if screen then
    local finished = screen:update(dt)
    if finished then
      self.index = self.index + 1
      if self.index > #self.screens then
        PageManager.switch('worldpage')
      end
    end
  end
end

function Intro:draw()
  local screen = self.screens[self.index]
  if screen then
    screen:draw()
  end
end