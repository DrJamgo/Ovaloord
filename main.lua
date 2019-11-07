
local sti = require "src/sti/sti"
local map = sti("res/maps/untitled.lua")

function love.load(arg)
  if arg[#arg] == "-debug" then require("mobdebug").start() end
end

function love.update(dt)
  map:update(dt)
end

function love.draw()
  map:draw(-200,-200,2,2)
end

