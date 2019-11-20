require 'game/unit'



local units = {
  Human = {
    Peasant = {
      melee = {0.5, 'slash', 1, 0.6, 0.5},
      hp = 10
      }
  },
  
  Undead = {
    Canibal = {
      melee = {2.0, 'slash', 1, 0.6, 0.5, 2.0},
      hp = 10
      }
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