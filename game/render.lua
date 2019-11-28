require('graphics/guiwidget')
require('graphics/mainviewwidget')
require('graphics/widget')

require('game/combat/unitslayer')
require('game/combat/gridlayer')

local Render = {}

function Render:load()
  assert(self.map)
  local pixelperTile = 4
  local w,h = self.map.width * pixelperTile, self.map.height * pixelperTile
  
  self.widgets = {}
  self.main = MainViewWidget(self.map, 0, 0, love.graphics:getWidth(), love.graphics:getHeight(), self.scale)
  
  self.widgets[#self.widgets+1] = self.main

  local numButtons = 8
  local w,h = self.guimap.tilewidth * self.guimap.width * self.scale, self.guimap.tileheight * self.guimap.height * self.scale, self.scale
  local y = love.graphics:getHeight() - h
  self.widgets[#self.widgets+1] = GuiWidget(self.fractions['Undead'], self.guimap, 0, y, w, h, self.scale)
  
end

return Render