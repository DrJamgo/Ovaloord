--
-- Copyright DrJamgo@hotmail.com 2019
--

if arg[#arg] == "-debug" then require("mobdebug").start() end

love.window.setMode(1000, 640, flags)

require 'game'

local game = Game()
options = {}

function love.keypressed( key, scancode, isrepeat )
  options[key] = ((options[key] == nil) and true) or nil
end

function love.wheelmoved(x, y)
  game.zoom = math.max(1, math.min(4,game.zoom + y))
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

