--
-- Copyright DrJamgo@hotmail.com 2019
--

if arg[#arg] == "-debug" then require("mobdebug").start() end

--love.window.setMode(800, 600, flags)
love.window.setMode(0, 0, flags)

require 'game'

local game = Game()
options = {}

function love.keypressed( key, scancode, isrepeat )
  options[key] = ((options[key] == nil) and true) or nil
  if key == "escape" then
    love.event.quit()
  end
end

function love.mousepressed(...)
  game.renderer.forwardMouseEvent(game, 'mousepressed', ...)
end

function love.mousemoved(...)
  game.renderer.forwardMouseEvent(game, 'mousemoved', ...)
end

function love.wheelmoved(x, y)
  game.zoom = math.max(1, math.min(4,game.zoom + y/2))
end

function love.load(arg)
  game:load("res/maps/untitled.lua")
end

function love.update(dt)
  game:update(dt)
end

function love.draw()
  game:draw()
end

