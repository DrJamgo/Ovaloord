require 'game/unit'

--
-- Cheet sheets
--
-- melee/range (dmg, range, anim, cooldown, duration, trigger)
--
unitcatalogue = {
  Human = {
    { -- T1
      Peasant  ={hp= 5, melee={0.5,1.1,'slash','fast','fast'}},
      Militia  ={hp= 7, melee={1.0,1.1,'slash','fast','fast'}},
      Ranger   ={hp= 7, range={4.0,5.1,'shoot','veryslow','fast'}},
    },
    { -- T2
    }
  },
  Undead = {
    { -- T1
      Canibal  ={hp=10, melee={5.0,1.1,'slash','slow','normal'}, speed=1.5},
      Revenant ={hp= 5, melee={2.0,1.1,'thrust','normal','slow'}},
      Hitter   ={hp= 5, range={4.0,5.1,'shoot','veryslow','normal'}},
    },
    { -- T2
    },
    { -- T3
    }
  }
}

for fraction, unitlist in pairs(unitcatalogue) do
  for tier,units in ipairs(unitlist) do
    for name,spec in pairs(units) do
      _G[name] = class(name, Unit)
      _G[name].brief, _G[name].long = T.get(name)
      _G[name].brief = S.tier[tier].._G[name].brief
      if not spec.spritepath then
        _G[name].spritepath = 'assets/sprites/'..fraction..'/'..name..'.png'
      end
      _G[name].tier = tier
      for k,v in pairs(spec) do
        _G[name][k] = v 
      end
    end
  end
end