--
-- Copyright DrJamgo@hotmail.com 2019
--
APPLICATIONNAME = 'YesMaster'

if arg[#arg] == "-debug" then require("mobdebug").start() end

require 'game'
require 'intro'

local intro = Intro()
local game = Game()
local main = intro
options = {}

--symbolic values
S = {
  attack='\001',
  move='\002',
  locked='\003',
  }

local font = love.graphics.newImageFont("res/love2d_font.png",
    " abcdefghijklmnopqrstuvwxyz" ..
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ0" ..
    "123456789.,!?-+/():;%&`'*#=[]\""..S.attack..S.move..S.locked)
  
love.graphics.setFont(font)

function love.keypressed( key, scancode, isrepeat )
  options[key] = ((options[key] == nil) and true) or nil
  if key == "escape" then
    love.event.quit()
  end
end

function love.mousepressed(...)
  if main.forwardMouseEvent then main:forwardMouseEvent('mousepressed', ...) end
end

function love.mousemoved(...)
  if main.forwardMouseEvent then main:forwardMouseEvent('mousemoved', ...) end
end

function love.load(arg)
  --
end

function love.update(dt)
  if main == intro and not intro:isActive() then
    game:enterWorldMap()
    main = game
  end
  main:update(dt)
end

function love.draw()
  main:draw()
end

