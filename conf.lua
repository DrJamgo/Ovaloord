-- from: https://love2d.org/wiki/Config_Files

function love.conf(t)
  t.identity = nil
  t.window.title = "Ovaloord"
  t.window.icon = "res/icon.bmp"
  
  t.window.fullscreen = false
  
  t.window.width = 800                -- The window width (number)
  t.window.height = 600               -- The window height (number)
end