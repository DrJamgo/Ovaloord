--
-- Copyright DrJamgo@hotmail.com 2019
--
APPLICATIONNAME = 'YesMaster'

if arg[#arg] == "-debug" then require("mobdebug").start() end

require 'game'
require 'intro'
require 'utils/table'

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

end

local erroroccured = false
function errorHandler( err )
  print( "ERROR:", err )
  if false == erroroccured then
    local dump = {}
    dump.err = err
    dump.game = game
    dump.stack = debug.traceback()
    table.save(dump, 'errordump')
    erroroccured = true
    love.system.openURL("mailto:drjamgo@hotmail.com?subject="..APPLICATIONNAME.." crashed.&body=Hello,%0A%0AMy '"..APPLICATIONNAME.."' game has crashed, please see my dump-file attached.. [please attach errordump file before sending!]%0A%0AThanks!")
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

