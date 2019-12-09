require 'game/widget'
ControlWidget = class('ControlWidget', TiledWidget)

function ControlWidget:initialize(fraction, map, scale)
  local w,h = map.tilewidth * map.width * scale, map.tileheight * map.height * scale
  local y = love.graphics:getHeight() - h
  
  TiledWidget.initialize(self, map, 0, y, w, h, 2)
  
  self.camera:fit(map)
  self.fraction = fraction
  self.map = map
  self.tile = nil
  
  self.unitcap = 4
  self.unitpool = {4,9,18}
  
  self.spirits = {}
  self.spiritslayer = map:convertToCustomLayer('Spirits', nil)
  self.spiritslayer.spirits = self.spirits
  self.spiritslayer.map = map
  self.spiritslayer.draw = drawSpirits
  self.spiritslayer.update = updateSpirits
  
  self:addSpirit(1)
  self:addSpirit(2)
  self:addSpirit(2)
  
  for i=1,self.unitcap do
    self:addUnit()
  end
end

function updateSpirits(layer, dt)
  local x,y = layer.map:convertTileToPixel(1,5)
  for i,spirit in ipairs(layer.spirits) do
    spirit.pos.x = 1
    local targetY = 5.5-((i-1) * 0.5)
    local diff = targetY - spirit.pos.y
    spirit.pos.y = spirit.pos.y + (diff) * 0.1
    spirit:update(dt)
  end
end

function drawSpirits(layer)
  for _,spirit in ipairs(layer.spirits) do
    spirit:draw()
  end
end

function ControlWidget:addSpirit(tier)
  local spirit = SpiritOrb(self.map, {x=1, y=0.0}, SpiritOrb.colors[tier])
  table.insert(self.spirits, spirit)
end

function ControlWidget:addUnit(id)
  for i=1,self.unitcap do
    local x = i+2
    local y = 7
    if not self.map.layers.Units.data[y][x] then
      if not id then
        id = self.unitpool[love.math.random(1, #self.unitpool)]
      end
      self.map:setLayerTile('Units', x, y, id)
      return id
    end
  end
end

function ControlWidget:mousepressed(gx,gy,button,isTouch)
  local tile, layer, x, y = self:getTileAtPosition(gx, gy)
  if tile and tile.type and tile.type ~= '' and _G[tile.type] then
    if self.spirits[1] then
      self.fraction:addUnit(tile.type, self.fraction.spawn)
      self.map:setLayerTile(layer.name, x, y, 0)
      table.remove(self.spirits, 1)
      self:addUnit()
    end
  end
end

function ControlWidget:update(dt)
  TiledWidget.update(self, dt)
  self.map:update(dt)
end

function ControlWidget:draw()
  -- save current canvas
  local targetCanvas = love.graphics.getCanvas()
  
  love.graphics.setCanvas(self.canvas)
  love.graphics.clear(0,0,0,0)
  self.map:draw(self.camera:getMapArgs())
  if self.cursortile and self.cursortile.type then
    love.graphics.printf(self.cursortile.type, self.cursor[1]-200, self.cursor[2], 400, 'center',0, 1)
  end
  
  -- restore target canvas and draw to it
  love.graphics.setCanvas(targetCanvas)
  Widget.draw(self)
end