--
-- Copyright DrJamgo@hotmail.com 2019
--

if arg[#arg] == "-debug" then require("mobdebug").start() end

love.window.setMode(1000, 640, flags)

require 'game/game'

local game = Game()

function love.wheelmoved(x, y)
  game.zoom = math.max(1, math.min(4,game.zoom + y / 2))
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

