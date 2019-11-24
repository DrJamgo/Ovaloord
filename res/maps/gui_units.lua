return {
  version = "1.2",
  luaversion = "5.1",
  tiledversion = "1.2.4",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 17,
  height = 3,
  tilewidth = 24,
  tileheight = 32,
  nextlayerid = 9,
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
          id = 719,
          type = "spawn"
        },
        {
          id = 720,
          type = "goal"
        }
      }
    }
  },
  layers = {
    {
      type = "tilelayer",
      id = 6,
      name = "Tile Layer 2",
      x = 0,
      y = 0,
      width = 17,
      height = 3,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 16,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 551, 0, 551, 0, 551, 0, 551, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 583, 0, 583, 0, 583, 0, 583, 0, 0, 0, 0, 0, 0, 0, 550, 0
      }
    },
    {
      type = "tilelayer",
      id = 7,
      name = "Tile Layer 1",
      x = 0,
      y = 0,
      width = 17,
      height = 3,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 8,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 9, 0, 4, 0, 0, 0, 549, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 550, 0, 0, 0, 550, 0, 0, 0
      }
    },
    {
      type = "tilelayer",
      id = 8,
      name = "Tile Layer 3",
      x = 0,
      y = 0,
      width = 17,
      height = 3,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 18, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 550, 0, 0, 0, 0, 0
      }
    }
  }
}
