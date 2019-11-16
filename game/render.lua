local Render = {}

function drawUnitsLayer(layer)
  for y=1,layer.map.height do
    for _,unit in ipairs(layer.units) do
      if unit.pos.y >= y and unit.pos.y < y+1 then
        unit:draw()
      end
    end
  end
end

function Render:load()
  Render.drawMinimap(self, self.minimap_canvas, self.minimapcamera)
  love.graphics.setCanvas()
  
  self.unitslayer = self.map:convertToCustomLayer('Units')
  self.unitslayer.draw = drawUnitsLayer
  self.unitslayer.map = self.map
  self.unitslayer.units = self.units
end

function Render:drawMinimap(canvas, camera)
 -- save original visibility state in properties
  for i,layer in ipairs(self.map.layers) do
    layer.properties.visible = layer.visible or false
    layer.visible = layer.properties.minimap or false
  end
  camera:fit(self.map, canvas)
  love.graphics.setCanvas(canvas)
  love.graphics.clear(0,0,0,1)
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
  love.graphics.clear(0,0,0,1)
  camera:setFromTile(map,9,10,self.zoom)
  self.map:draw(camera:getMapArgs())
  
  love.graphics.replaceTransform(camera:getTransform())
  if self.grid then
    --self.grid:draw()
  end  
  -- redraw units layer (transparent)
  
  map.layers.Units.properties.opacity = map.layers.Units.opacity
  map.layers.Units.opacity = 0.5
  love.graphics.setColorMask(false, true, false, false)
  map:drawLayer(map.layers.Units)
  love.graphics.setColorMask(true, true, true, true)
  map.layers.Units.opacity = map.layers.Units.properties.opacity
end

function Render:draw()
  love.graphics.setColor(1,1,1,1)
  Render.drawMainMap(self, self.main_canvas, self.maincamera)
  
  love.graphics.setCanvas()
  love.graphics.replaceTransform(love.math.newTransform())
  love.graphics.draw(self.main_canvas, 0, 0)
  love.graphics.draw(self.minimap_canvas, 0, 0)
  
  local minimap_canvas = self.minimap_canvas
  love.graphics.rectangle("line",0,0,minimap_canvas:getWidth(), minimap_canvas:getHeight())
end

return Render