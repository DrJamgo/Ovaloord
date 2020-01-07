return {
  version = "1.2",
  luaversion = "5.1",
  tiledversion = "1.2.4",
  orientation = "orthogonal",
  renderorder = "left-down",
  width = 12,
  height = 13,
  tilewidth = 32,
  tileheight = 32,
  nextlayerid = 44,
  nextobjectid = 9,
  properties = {},
  tilesets = {
    {
      name = "research",
      firstgid = 1,
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
      name = "terrain-v7",
      firstgid = 29,
      filename = "../../res/tilesets/terrain-v7.tsx",
      tilewidth = 32,
      tileheight = 32,
      spacing = 0,
      margin = 0,
      columns = 32,
      image = "../../assets/tilesets/lpc-terrains/terrain-v7.png",
      imagewidth = 1024,
      imageheight = 2048,
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
      tilecount = 2048,
      tiles = {}
    },
    {
      name = "terrain_atlas",
      firstgid = 2077,
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
          probability = 0.1
        },
        {
          id = 176,
          probability = 0.5
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
      name = "decorations-medieval",
      firstgid = 3101,
      filename = "../../res/tilesets/decorations-medieval.tsx",
      tilewidth = 32,
      tileheight = 32,
      spacing = 0,
      margin = 0,
      columns = 16,
      image = "../../assets/tilesets/decoration_medieval/decorations-medieval.png",
      imagewidth = 512,
      imageheight = 2144,
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
      tilecount = 1072,
      tiles = {
        {
          id = 13,
          animation = {
            {
              tileid = 13,
              duration = 100
            },
            {
              tileid = 14,
              duration = 100
            },
            {
              tileid = 15,
              duration = 100
            }
          }
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
        100, 101, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 68, 100, 100, 100, 100, 100, 100, 100, 100, 101, 0,
        0, 132, 132, 132, 132, 132, 132, 132, 132, 132, 68, 101,
        132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 36, 165,
        132, 132, 2515, 2515, 132, 132, 132, 132, 132, 132, 68, 101,
        132, 132, 2518, 2518, 2518, 2518, 2518, 132, 132, 132, 132, 133,
        132, 132, 3006, 2494, 2494, 2494, 2494, 2494, 132, 132, 132, 133,
        132, 132, 132, 132, 2381, 2381, 2381, 2381, 132, 36, 164, 165,
        132, 132, 132, 132, 132, 132, 132, 132, 132, 133, 0, 0
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
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        3114, 3151, 0, 0, 0, 0, 0, 3169, 0, 3101, 0, 0,
        0, 3153, 0, 0, 0, 0, 0, 0, 0, 3117, 3133, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3153, 0,
        3114, 3169, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
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
        23, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 9, 8, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 9, 8, 10, 11, 12, 0, 0, 0, 0, 0,
        0, 0, 9, 8, 10, 11, 12, 14, 0, 0, 0, 0,
        0, 0, 0, 0, 10, 11, 12, 14, 0, 0, 0, 0,
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
      objects = {}
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
