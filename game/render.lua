require('graphics/guiwidget')
require('graphics/mainviewwidget')
require('graphics/widget')

local Render = {}

function drawUnitsLayer(layer)
  Render:pushColor()
  for y=1,layer.map.height do
    for _,object in pairs(layer.objects) do
      if object.pos.y >= y and object.pos.y < y+1 then
        Render:popColor()
        object:draw()
      end
    end
  end
end

function updateUnitsLayer(layer, dt)
  dt = math.min(dt, 0.25)
  if love.keyboard.isDown('y') then dt = dt * 0.1 end
  if options['p'] then dt = 0 end
  local leading_undead = nil
  for _=1,(love.keyboard.isDown('x') and 10) or 1 do
    for _,object in pairs(layer.objects) do
      object:update(dt)
    end
  end
end

function updateGridLayer(layer, dt)
  layer.grid:update(dt)
end
  
function drawGridLayer(layer, dt)
  layer.grid:draw()
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
  self.unitslayer.update = updateUnitsLayer
  self.unitslayer.map = self.map
  self.unitslayer.objects = self.objects
  
  self.gridlayer = self.map:addCustomLayer('grid')
  self.gridlayer.update = updateGridLayer
  self.gridlayer.draw = drawGridLayer
  self.gridlayer.grid = self.grid
  self.gridlayer.objects = self.unitslayer.objects
end

return Render