require 'game/unit'

--
-- Cheet sheets
--
-- melee/range (dmg, range, anim, cooldown, duration, trigger)
--
unitcatalogue = {
  Human = {
    { -- T1
      Peasant  ={icon=S.fist,   hp= 5, melee={0.5,1.1,'slash','fast','fast'}},
      Militia  ={icon=S.dagger, hp= 7, melee={1.0,1.1,'slash','fast','fast'}},
      Ranger   ={icon=S.bow,    hp= 7, range={4.0,5.1,'shoot','veryslow','fast'}},
    },
    { -- T2
    }
  },
  Undead = {
    { -- T1
      Rosen    ={icon=S.spear,  hp= 5, melee={3.0,1.1,'thrust','normal','slow'}},
      Zombie   ={icon=S.dagger, hp= 7, melee={2.0,1.1,'slash','normal','fast'}},
    },
    { -- T2
      Warden   ={icon=S.spear,  hp= 7, melee={5.0,1.1,'thrust','normal','slow'}},
      Hitter   ={icon=S.bow,    hp= 5, range={4.0,5.1,'shoot','veryslow','normal'}},
      Canibal  ={icon=S.hatchet, hp=10, melee={5.0,1.1,'slash','slow','normal'}, speed=1.5},
    },
    { -- T3
      Revenant ={icon=S.spear,  hp= 10, melee={7.0,1.1,'thrust','normal','slow'}},
    }
  }
}

for fraction, unitlist in pairs(unitcatalogue) do
  for tier,units in ipairs(unitlist) do
    for name,spec in pairs(units) do
      _G[name] = class(name, Unit)
      _G[name].brief, _G[name].long = T.get(name)
      _G[name].brief = (spec.icon and {SpiritEffect.colors[tier], spec.icon, {1,1,1,1}, _G[name].brief}) or (S.tier[tier].._G[name].brief)
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