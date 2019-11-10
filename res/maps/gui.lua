return {
  version = "1.2",
  luaversion = "5.1",
  tiledversion = "1.2.4",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 18,
  height = 12,
  tilewidth = 32,
  tileheight = 32,
  nextlayerid = 5,
  nextobjectid = 4,
  properties = {},
  tilesets = {
    {
      name = "terrain_atlas",
      firstgid = 1,
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
        }
      }
    }
  },
  layers = {
    {
      type = "tilelayer",
      id = 3,
      name = "Background",
      x = 0,
      y = 0,
      width = 18,
      height = 12,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "tilelayer",
      id = 2,
      name = "Tile Layer 1",
      x = 0,
      y = 0,
      width = 18,
      height = 12,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        753, 754, 754, 754, 754, 754, 754, 754, 754, 754, 754, 754, 754, 754, 754, 754, 754, 755,
        785, 787, 0, 0, 0, 0, 0, 0, 0, 0, 0, 785, 818, 818, 818, 818, 818, 787,
        785, 787, 0, 0, 0, 0, 0, 0, 0, 0, 0, 785, 787, 0, 0, 0, 785, 787,
        785, 787, 0, 0, 0, 0, 0, 0, 0, 0, 0, 785, 787, 0, 0, 0, 785, 787,
        785, 787, 0, 0, 0, 0, 0, 0, 0, 0, 0, 785, 787, 0, 0, 0, 785, 787,
        785, 787, 0, 0, 0, 0, 0, 0, 0, 0, 0, 785, 787, 0, 0, 0, 785, 787,
        785, 787, 0, 0, 0, 0, 0, 0, 0, 0, 0, 785, 786, 786, 786, 786, 786, 787,
        785, 787, 0, 0, 0, 0, 0, 0, 0, 0, 0, 785, 786, 786, 786, 786, 786, 787,
        785, 787, 0, 0, 0, 0, 0, 0, 0, 0, 0, 785, 786, 786, 786, 786, 786, 787,
        785, 787, 0, 0, 0, 0, 0, 0, 0, 0, 0, 785, 786, 786, 786, 786, 786, 787,
        785, 819, 0, 0, 0, 0, 0, 0, 0, 0, 0, 817, 786, 786, 786, 786, 786, 787,
        817, 818, 818, 818, 818, 818, 818, 818, 818, 818, 818, 818, 818, 818, 818, 818, 818, 819
      }
    },
    {
      type = "objectgroup",
      id = 4,
      name = "Objects",
      visible = false,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      draworder = "topdown",
      properties = {},
      objects = {
        {
          id = 1,
          name = "",
          type = "main_window",
          shape = "rectangle",
          x = 64,
          y = 32,
          width = 288,
          height = 320,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 3,
          name = "",
          type = "minimap_window",
          shape = "rectangle",
          x = 416,
          y = 64,
          width = 96,
          height = 128,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    }
  }
}
