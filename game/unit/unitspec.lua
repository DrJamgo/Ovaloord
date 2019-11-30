require 'game/unit'

--
-- Cheet sheets
--
-- melee(dmg, range, anim, cooldown, duration, trigger)
--
local unitcatalogue = {
  Human = {
    { -- T1
      Peasant = {
        melee = {0.5, 1.1, 'slash', 0.5, 0.4, 0.2},
        hp = 5,
      }
    },
    { -- T2
      Militia = {
        melee = {1.0, 1.1, 'slash', 0.6, 0.4, 0.2},
        hp = 7
      }
    }
  },
  Undead = {
    { -- T1
    },
    { -- T2
      Canibal = {
        melee = {2.0, 1.1, 'slash',  1, 0.8, 0.5},
        hp = 10,
        speed = Unit.speed * 0.8
      }
    },
    { -- T3
      Revenant = {
        melee = {2.0, 1.1, 'thrust', 1, 0.8, 0.6},
        hp = 5
      },
      Hitter = {
        range = {2.0, 5, 'shoot', 1, 0.8, 0.5},
        hp = 5
      },
    }
  }
}

for fraction, unitlist in pairs(unitcatalogue) do
  for tier,units in ipairs(unitlist) do
    for name,spec in pairs(units) do
      _G[name] = class(name, Unit)
      if not spec.spritepath then
        _G[name].spritepath = 'res/sprites/'..fraction..'/'..name..'.png'
      end
      _G[name].tier = tier
      for k,v in pairs(spec) do
        _G[name][k] = v 
      end
    end
  end
end