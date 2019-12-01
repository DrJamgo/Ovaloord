require 'game/unit'

--
-- Cheet sheets
--
-- melee/range (dmg, range, anim, cooldown, duration, trigger)
--
local unitcatalogue = {
  Human = {
    { -- T1
      Peasant  ={hp= 5, melee={0.5,1.1,'slash',0.5,0.4,0.2}, }
    },
    { -- T2
      Militia  ={hp= 7, melee={1.0,1.1,'slash',0.6,0.4,0.2}, }
    }
  },
  Undead = {
    { -- T1
    },
    { -- T2
      Canibal  ={hp=10, melee={5.0,1.1,'slash',2.0,0.8,0.5}, speed=1.5}
    },
    { -- T3
      Revenant ={hp= 5, melee={2.0, 1.1,'thrust',1,0.8,0.6}, },
      Hitter   ={hp= 5, range={4.0, 5.1,'shoot',2.0,0.8,0.5}, },
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