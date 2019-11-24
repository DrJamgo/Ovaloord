require('graphics/guiwidget')
require('graphics/mainviewwidget')
require('graphics/widget')

local Render = {}

function drawUnitsLayer(layer)
  Render:pushColor()
  for y=1,layer.map.height do
    for _,unit in ipairs(layer.units) do
      local offset = (unit.hp > 0 and 0) or 2
      if unit.pos.y >= y + offset and unit.pos.y < y+1+offset then
        Render:popColor()
        unit:draw()
      end
    end
    for _,object in pairs(layer.objects) do
      if object.pos.y >= y and object.pos.y < y+1 then
        object:draw()
      end
    end
  end
end

function Render:pushColor()
  self.color = {love.graphics.getColor( )}
end

function Render:popColor()
  love.graphics.setColor(unpack(self.color))
end

function Render:load()
  assert(self.map)
  local pixelperTile = 4
  local w,h = self.map.width * pixelperTile, self.map.height * pixelperTile
  
  self.main = MainViewWidget(self.map, 0, 0, love.graphics:getWidth(), love.graphics:getHeight(), self.scale)

  local numButtons = 8
  local w,h = self.guimap.tilewidth * self.guimap.width * self.scale, self.guimap.tileheight * self.guimap.height * self.scale, self.scale
  local y = love.graphics:getHeight() - h
  self.gui_units = GuiWidget(self.guimap, 0, y, w, h, self.scale)
  
  self.unitslayer = self.map:convertToCustomLayer('Units')
  self.unitslayer.draw = drawUnitsLayer
  self.unitslayer.map = self.map
  self.unitslayer.units = self.units
  self.unitslayer.objects = self.objects
end

function Render:draw()
  love.graphics.setColor(1,1,1,1)
  love.graphics.setCanvas()
  love.graphics.replaceTransform(love.math.newTransform())
  
  self.main:setFocus(self.units[1].pos)
  self.main:draw()
  self.gui_units:draw()
end

return Render