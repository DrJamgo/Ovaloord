--
-- Copyright DrJamgo@hotmail.com 2019
--
APPLICATIONNAME = 'YesMaster'

if arg[#arg] == "-debug" then require("mobdebug").start() end

require 'game'

local game = Game()
options = {}

--symbolic values
S = {
  attack='\001',
  move='\002'
  }

local font = love.graphics.newImageFont("res/love2d_font.png",
    " abcdefghijklmnopqrstuvwxyz" ..
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ0" ..
    "123456789.,!?-+/():;%&`'*#=[]\""..S.attack..S.move)
  
love.graphics.setFont(font)

function love.keypressed( key, scancode, isrepeat )
  options[key] = ((options[key] == nil) and true) or nil
  if key == "escape" then
    love.event.quit()
  end
end

function love.mousepressed(...)
  game.forwardMouseEvent(game, 'mousepressed', ...)
end

function love.mousemoved(...)
  game.forwardMouseEvent(game, 'mousemoved', ...)
end

function love.load(arg)
  game:enterWorldMap()
end

function love.update(dt)
  game:update(dt)
end

function love.draw()
  game:draw()
end

