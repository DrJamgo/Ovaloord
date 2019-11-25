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
  
  self.widgets = {}
  self.main = MainViewWidget(self.map, 0, 0, love.graphics:getWidth(), love.graphics:getHeight(), self.scale)
  
  self.widgets[#self.widgets+1] = self.main

  local numButtons = 8
  local w,h = self.guimap.tilewidth * self.guimap.width * self.scale, self.guimap.tileheight * self.guimap.height * self.scale, self.scale
  local y = love.graphics:getHeight() - h
  self.widgets[#self.widgets+1] = GuiWidget(self.fractions['Undead'], self.guimap, 0, y, w, h, self.scale)
  
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
  
  local undead = self.fractions['Undead']
  local leader = self.fractions['Undead']:getLeadingUnit()
  if leader then
    self.main:setFocus(leader.pos)
  else
    self.main:setFocus(undead.spawn)
  end
  
  for _,widget in ipairs(self.widgets) do
    widget:draw()
  end
end

function Render:forwardMouseEvent(f, x, y, ...)
  if self.widgets then
    for i=1,#self.widgets do
      -- iterate in reverse order to process last dawn widgets first
      local widget = self.widgets[#self.widgets + 1 - i]
      if widget:test(x,y) and widget[f] then
        if widget[f](widget, x,y,...) then
          return
        end
      end
    end
  end
end

return Render