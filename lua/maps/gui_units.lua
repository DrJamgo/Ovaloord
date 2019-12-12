return {
  version = "1.2",
  luaversion = "5.1",
  tiledversion = "1.2.4",
  orientation = "orthogonal",
  renderorder = "left-down",
  width = 12,
  height = 13,
  tilewidth = 36,
  tileheight = 28,
  nextlayerid = 38,
  nextobjectid = 2,
  properties = {},
  tilesets = {
    {
      name = "undead",
      firstgid = 1,
      filename = "../../res/tilesets/undead.tsx",
      tilewidth = 64,
      tileheight = 64,
      spacing = 0,
      margin = 0,
      columns = 5,
      image = "../../assets/tilesets/undead.png",
      imagewidth = 320,
      imageheight = 640,
      tileoffset = {
        x = -16,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 64,
        height = 64
      },
      properties = {},
      terrains = {},
      tilecount = 50,
      tiles = {
        {
          id = 0,
          type = "Master"
        },
        {
          id = 3,
          type = "Revenant"
        },
        {
          id = 8,
          type = "Hitter"
        },
        {
          id = 17,
          type = "Canibal"
        }
      }
    },
    {
      name = "terrain_atlas",
      firstgid = 51,
      filename = "../../res/tilesets/terrain_atlas.tsx",
      tilewidth = 32,
      tileheight = 32,
      spacing = 0,
      margin = 0,
      columns = 32,
      image = "../../assets/tilesets/terrain_atlas.png",
      imagewidth = 1024,
      imageheight = 1024,
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 32,
        height = 32
      },
      properties = {},
      terrains = {},
      tilecount = 1024,
      tiles = {
        {
          id = 38,
          type = "road"
        },
        {
          id = 112,
          type = "road"
        },
        {
          id = 175,
          type = "road",
          probability = 0.1
        },
        {
          id = 176,
          type = "road",
          probability = 0.5
        },
        {
          id = 177,
          type = "road"
        },
        {
          id = 234,
          type = "stone"
        },
        {
          id = 719,
          type = "spawn"
        },
        {
          id = 720,
          type = "goal"
        }
      }
    },
    {
      name = "undead-spirit-recruit-anim-explode",
      firstgid = 1075,
      filename = "../../res/tilesets/undead-spirit-recruit-anim-explode.tsx",
      tilewidth = 64,
      tileheight = 128,
      spacing = 0,
      margin = 0,
      columns = 12,
      image = "../../assets/sprites/effects/undead-spirit-recruit-anim-explode.png",
      imagewidth = 768,
      imageheight = 128,
      tileoffset = {
        x = -16,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 64,
        height = 128
      },
      properties = {},
      terrains = {},
      tilecount = 12,
      tiles = {
        {
          id = 0,
          animation = {
            {
              tileid = 0,
              duration = 100
            },
            {
              tileid = 1,
              duration = 100
            },
            {
              tileid = 2,
              duration = 100
            },
            {
              tileid = 3,
              duration = 100
            },
            {
              tileid = 4,
              duration = 100
            },
            {
              tileid = 5,
              duration = 100
            },
            {
              tileid = 6,
              duration = 100
            },
            {
              tileid = 7,
              duration = 100
            },
            {
              tileid = 8,
              duration = 100
            },
            {
              tileid = 9,
              duration = 100
            },
            {
              tileid = 10,
              duration = 100
            },
            {
              tileid = 11,
              duration = 100
            }
          }
        },
        {
          id = 10,
          animation = {
            {
              tileid = 10,
              duration = 100
            },
            {
              tileid = 9,
              duration = 100
            },
            {
              tileid = 8,
              duration = 100
            },
            {
              tileid = 7,
              duration = 100
            },
            {
              tileid = 6,
              duration = 1000
            }
          }
        }
      }
    },
    {
      name = "rotating_orbs",
      firstgid = 1087,
      filename = "../../res/tilesets/rotating_orbs.tsx",
      tilewidth = 24,
      tileheight = 24,
      spacing = 0,
      margin = 0,
      columns = 4,
      image = "../../assets/sprites/effects/rotating_orbs.png",
      imagewidth = 96,
      imageheight = 192,
      tileoffset = {
        x = 4,
        y = -4
      },
      grid = {
        orientation = "orthogonal",
        width = 24,
        height = 24
      },
      properties = {},
      terrains = {},
      tilecount = 32,
      tiles = {
        {
          id = 4,
          animation = {
            {
              tileid = 4,
              duration = 100
            },
            {
              tileid = 5,
              duration = 100
            },
            {
              tileid = 6,
              duration = 100
            },
            {
              tileid = 7,
              duration = 100
            }
          }
        }
      }
    },
    {
      name = "research",
      firstgid = 1119,
      filename = "../../res/tilesets/research.tsx",
      tilewidth = 32,
      tileheight = 32,
      spacing = 0,
      margin = 0,
      columns = 7,
      image = "../../assets/tilesets/research.png",
      imagewidth = 224,
      imageheight = 128,
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 32,
        height = 32
      },
      properties = {},
      terrains = {},
      tilecount = 28,
      tiles = {
        {
          id = 1,
          type = "Research"
        },
        {
          id = 3,
          animation = {
            {
              tileid = 3,
              duration = 100
            },
            {
              tileid = 4,
              duration = 100
            },
            {
              tileid = 5,
              duration = 100
            },
            {
              tileid = 6,
              duration = 100
            }
          }
        },
        {
          id = 15,
          type = "Settings"
        }
      }
    }
  },
  layers = {
    {
      type = "tilelayer",
      id = 34,
      name = "Tier",
      x = 0,
      y = 0,
      width = 12,
      height = 13,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 553, 553, 553, 553, 0, 0, 0, 0, 0, 0,
        0, 0, 1009, 1009, 1009, 1009, 1009, 1009, 0, 0, 0, 0,
        0, 0, 468, 468, 468, 468, 468, 468, 468, 468, 0, 0,
        0, 0, 0, 0, 0, 418, 418, 418, 418, 418, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "tilelayer",
      id = 35,
      name = "ResearchTiles",
      x = 0,
      y = 0,
      width = 12,
      height = 13,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        1134, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        1120, 0, 1119, 1126, 1127, 1128, 1129, 1130, 1131, 1132, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1119, 1126, 1127, 1128, 0, 0, 0, 0, 0, 0,
        0, 0, 1119, 1126, 1127, 1128, 1129, 1130, 0, 0, 0, 0,
        0, 0, 1119, 1133, 1127, 1128, 1129, 1130, 1131, 1132, 0, 0,
        0, 0, 0, 0, 0, 1128, 1129, 1137, 1131, 1132, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "tilelayer",
      id = 37,
      name = "Units",
      x = 0,
      y = 0,
      width = 12,
      height = 13,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = -14,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    }
  }
}
