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

function Render:init()

end

function Render:load()
  assert(self.map)

  local pixelperTile = 4
  local w,h = self.map.width * pixelperTile, self.map.height * pixelperTile
  
  self.main = Widget(0, 0, love.graphics:getWidth(), love.graphics:getHeight(), self.scale)
  self.minimap = Widget(0, 0, w, h, pixelperTile/self.map.tilewidth)

  self.maincamera = Camera(self.main.canvas)
  self.minimapcamera = Camera(self.minimap.canvas)
  
  Render.drawMinimap(self, self.minimap.canvas, self.minimapcamera)
  love.graphics.setCanvas()
  
  self.unitslayer = self.map:convertToCustomLayer('Units')
  self.unitslayer.draw = drawUnitsLayer
  self.unitslayer.map = self.map
  self.unitslayer.units = self.units
  self.unitslayer.objects = self.objects
end

function Render:drawMinimap(canvas, camera)
 -- save original visibility state in properties
  for i,layer in ipairs(self.map.layers) do
    layer.properties.visible = layer.visible or false
    layer.visible = layer.properties.minimap or false
  end
  camera:fit(self.map, canvas)
  love.graphics.setCanvas(canvas)
  love.graphics.clear(0,0,0.1,1)
  self.map:draw(camera:getMapArgs())
  -- restore original state
  for i,layer in ipairs(self.map.layers) do
    layer.visible = layer.properties.visible
  end
end

function Render:drawMainMap(canvas, camera)
  local map = self.map
  -- draw map
  love.graphics.setCanvas(canvas)
  love.graphics.clear(0,0,0.3,1)
  local unit = self.units[1]
  camera:setFromTile(map, unit.pos.x, unit.pos.y, 1) 
  --camera:fit(self.map, self.main_canvas)
  self.map:draw(camera:getMapArgs())
  
  love.graphics.replaceTransform(camera:getTransform())
  if self.grid then
    local g = options['g'] and self.grid:draw()
  end  
  -- redraw units layer (transparent)
  
  map.layers.Units.properties.opacity = map.layers.Units.opacity
  map.layers.Units.opacity = 0.2
  --love.graphics.setColorMask(false, true, false, false)
  map:drawLayer(map.layers.Units)
  --love.graphics.setColorMask(true, true, true, true)
  map.layers.Units.opacity = map.layers.Units.properties.opacity
end

function Render:draw()
  love.graphics.setColor(1,1,1,1)
  Render.drawMainMap(self, self.main.canvas, self.maincamera)
  
  love.graphics.setCanvas()
  love.graphics.replaceTransform(love.math.newTransform())
  self.main:draw(self.main_canvas)
  self.minimap:draw(self.minimap_canvas)
end

return Render