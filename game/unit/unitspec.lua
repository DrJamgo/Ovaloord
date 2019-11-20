require 'game/unit'

--
-- CHeet sheets
--
-- melee(dmg, anim, cooldown, duration, trigger)
--


local units = {
  Human = {
    Peasant = {
      melee = {0.5, 'slash', 0.5, 0.4, 0.2},
      hp = 5
    }
  },
  
  Undead = {
    Shooter = {
      range = {2.0, 'shoot', 1, 0.8, 0.5},
      hp = 10
    },
    Revenant = {
      melee = {2.0, 'thrust', 1, 0.8, 0.6},
      hp = 5
    },
    Canibal = {
      melee = {2.0, 'slash', 1, 0.8, 0.5},
      hp = 10
    },

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