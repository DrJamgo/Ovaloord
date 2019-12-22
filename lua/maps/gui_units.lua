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
  nextlayerid = 42,
  nextobjectid = 6,
  properties = {},
  tilesets = {
    {
      name = "terrain_atlas",
      firstgid = 1,
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
      firstgid = 1025,
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
      firstgid = 1037,
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
      firstgid = 1069,
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
        },
        {
          id = 22,
          type = "Quit"
        }
      }
    },
    {
      name = "undead",
      firstgid = 1097,
      filename = "../../res/tilesets/undead.tsx",
      tilewidth = 64,
      tileheight = 64,
      spacing = 0,
      margin = 0,
      columns = 4,
      image = "../../assets/tilesets/undead.png",
      imagewidth = 256,
      imageheight = 576,
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
      tilecount = 36,
      tiles = {
        {
          id = 0,
          type = "Corpse"
        },
        {
          id = 1,
          type = "Zombie"
        },
        {
          id = 2,
          type = "Cadaver"
        },
        {
          id = 3,
          type = "Rotter"
        },
        {
          id = 34,
          type = "Cadaver"
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
        0, 0, 503, 0, 0, 978, 978, 978, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 503, 503, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 959, 959, 959, 959, 959, 959, 0, 0, 0, 0,
        0, 0, 418, 418, 418, 418, 418, 418, 0, 0, 0, 0,
        0, 0, 0, 0, 305, 368, 368, 368, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "tilelayer",
      id = 35,
      name = "Buttons",
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
        1091, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        1084, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        1070, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1077, 1076, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1077, 1076, 1078, 1090, 1090, 1090, 0, 0, 0, 0,
        0, 0, 1077, 1083, 1078, 1090, 1090, 1090, 0, 0, 0, 0,
        0, 0, 0, 0, 1078, 1090, 1090, 1090, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "tilelayer",
      id = 39,
      name = "UnitButtons",
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
        0, 0, 1077, 1076, 1078, 1079, 1080, 1082, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "objectgroup",
      id = 41,
      name = "Research",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      draworder = "topdown",
      properties = {},
      objects = {
        {
          id = 3,
          name = "Rosen",
          type = "",
          shape = "rectangle",
          x = 72,
          y = 220,
          width = 32,
          height = 28,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 4,
          name = "Warden",
          type = "",
          shape = "rectangle",
          x = 72,
          y = 248,
          width = 32,
          height = 28,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 5,
          name = "Revenant",
          type = "",
          shape = "rectangle",
          x = 72,
          y = 276,
          width = 32,
          height = 28,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    },
    {
      type = "objectgroup",
      id = 40,
      name = "Units",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      draworder = "topdown",
      properties = {},
      objects = {}
    }
  }
}
