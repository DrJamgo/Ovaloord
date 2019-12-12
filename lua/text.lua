--symbolic values
S = {
  {combat='\5'},
  {move='\6'},
  {locked='\7'},
  {unlock='\8'},
  {info='\9'},
  {tier={'\1','\2','\3','\4'}},
  {goal='\11'},
  {skull='\12'},
  {fist='\14'},
  {dagger='\15'},
  {sword='\16'},
  {spear='\17'},
  {bow='\18'},
  {wand='\19'},
  {hatchet='\20'},
  {axe='\21'},
  {hammer='\22'},
  {holy='\23'},
  {unholy='\24'},
  {halberd='\25'},
}

local glyphlist = " abcdefghijklmnopqrstuvwxyz" ..
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ0" ..
    "123456789.,!?-+/():;%&`'*#=[]\""

for i,s in ipairs(S) do
  for name,v in pairs(s) do
    if type(v) == 'string' then
      glyphlist = glyphlist..v
    else
      for j,g in ipairs(v) do
        glyphlist = glyphlist..g
      end
    end
    S[name] = v
  end
end

local font = love.graphics.newImageFont("assets/love2d_font.png", glyphlist)

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