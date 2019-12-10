--symbolic values
S = {
  tier={'\1','\2','\3','\4'},
  combat='\5',
  move='\6',
  locked='\7',
  unlock='\8',
  info='\9',
  goal='\11',
  skull='\12',
}

local font = love.graphics.newImageFont("assets/love2d_font.png",
    " abcdefghijklmnopqrstuvwxyz" ..
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ0" ..
    "123456789.,!?-+/():;%&`'*#=[]\""..
    S.combat..S.move..S.locked..S.unlock..S.info..
    S.tier[1]..S.tier[2]..S.tier[3]..S.tier[4]..
    S.goal..S.skull)

font:setFilter( 'nearest', 'nearest', 0 )
love.graphics.setFont(font)

T = require 'text_en'
T.defaultscale = (love.graphics.getWidth() > 1000 and 2.0 or 1.5)

function T.get(name)
  if T[name] then
    return T[name][1],T[name][2]
  end
  return '%'..tostring(name)..'%',nil
end