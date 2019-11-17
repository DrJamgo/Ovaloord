require 'game/unit'

local units = {
  Human = {
    Peasant = {}
  },
  
  Undead = {
    Canibal = {}
  }
}

for fraction,unitlist in pairs(units) do
  for name,spec in pairs(unitlist) do
    _G[name] = class(name, Unit)
    if not spec.spritepath then
      _G[name].spritepath = 'res/sprites/'..fraction..'/'..name..'.png'
    end
    for k,v in pairs(spec) do
      _G[name][k] = v 
    end
  end
end