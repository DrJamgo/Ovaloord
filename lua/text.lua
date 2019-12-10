--symbolic values
S = {
  tier={'\1','\2','\3','\4'},
  attack='\5',
  move='\6',
  locked='\7',
  info='\8',
}

local font = love.graphics.newImageFont("assets/love2d_font.png",
    " abcdefghijklmnopqrstuvwxyz" ..
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ0" ..
    "123456789.,!?-+/():;%&`'*#=[]\""..
    S.attack..S.move..S.locked..S.info..
    S.tier[1]..S.tier[2]..S.tier[3]..S.tier[4])

font:setFilter( 'nearest', 'nearest', 0 )
love.graphics.setFont(font)

T = require 'text_en'

function T.get(name)
  if T[name] then
    return T[name][1],T[name][2]
  end
  return '%'..tostring(name)..'%',nil
end