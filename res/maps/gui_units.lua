return {
  version = "1.2",
  luaversion = "5.1",
  tiledversion = "1.2.4",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 17,
  height = 4,
  tilewidth = 36,
  tileheight = 32,
  nextlayerid = 18,
  nextobjectid = 1,
  properties = {},
  tilesets = {
    {
      name = "undead",
      firstgid = 1,
      filename = "../tilesets/undead.tsx",
      tilewidth = 64,
      tileheight = 64,
      spacing = 0,
      margin = 0,
      columns = 5,
      image = "../tilesets/undead.png",
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
      filename = "../tilesets/terrain_atlas.tsx",
      tilewidth = 32,
      tileheight = 32,
      spacing = 0,
      margin = 0,
      columns = 32,
      image = "../sprites/terrain_atlas.png",
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
      filename = "../sprites/effects/undead-spirit-recruit-anim-explode.tsx",
      tilewidth = 64,
      tileheight = 128,
      spacing = 0,
      margin = 0,
      columns = 12,
      image = "../sprites/effects/undead-spirit-recruit-anim-explode.png",
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
    }
  },
  layers = {
    {
      type = "tilelayer",
      id = 15,
      name = "Tile Layer 2",
      x = 0,
      y = 0,
      width = 17,
      height = 4,
      visible = true,
      opacity = 1,
      offsetx = 8,
      offsety = 16,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        551, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        516, 551, 551, 551, 551, 455, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        548, 487, 487, 516, 487, 582, 0, 550, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "tilelayer",
      id = 17,
      name = "Tile Layer 3",
      x = 0,
      y = 0,
      width = 17,
      height = 4,
      visible = true,
      opacity = 1,
      offsetx = 8,
      offsety = 8,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "tilelayer",
      id = 16,
      name = "Tile Layer 1",
      x = 0,
      y = 0,
      width = 17,
      height = 4,
      visible = true,
      opacity = 1,
      offsetx = 8,
      offsety = 8,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 4, 0, 9, 18, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 550, 0, 550, 0, 0, 0, 0, 0, 0, 0, 0
      }
    }
  }
}
