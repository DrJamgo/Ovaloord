--
-- Copyright DrJamgo@hotmail.com 2019
--
love.filesystem.setRequirePath("?.lua;?/init.lua;lua/?.lua;lua/?/init.lua")
APPLICATIONNAME = 'Ovaloord'

if arg[#arg] == "-debug" then require("mobdebug").start() end

require 'text'
require 'game'
require 'intro'
require 'utils/table'


local intro = Intro()
local game = Game()
local main = intro
options = {}
-- copy args to options table
for _,a in ipairs(arg) do
  options[a] = true
end

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

end

local erroroccured = false
function errorHandler( err )
  print( "ERROR:", err )
  if false == erroroccured then
    local dump = {}
    dump.err = err
    dump.game = game
    dump.stack = debug.traceback()
    print(dump.stack)
    table.save(dump, 'errordump')
    erroroccured = true
    --love.system.openURL("mailto:drjamgo@hotmail.com?subject="..APPLICATIONNAME.." crashed.&body=Hello,%0A%0AMy '"..APPLICATIONNAME.."' game has crashed, please see my dump-file attached.. [please attach errordump file before sending!]%0A%0AThanks!")
    love.event.quit()
  end
end

function love.update(dt)
  if main == intro and not intro:isActive() then
    game:enterWorldMap()
    main = game
  end
  xpcall(main.update, errorHandler, main, dt)
end

function love.draw()
  xpcall(main.draw, errorHandler, main)
end

