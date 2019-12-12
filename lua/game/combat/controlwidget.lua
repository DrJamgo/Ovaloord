local STI = require 'sti/sti'
require 'game/widget'
ControlWidget = class('ControlWidget', TiledWidget)

function ControlWidget:initialize(fraction, scale)
  local map = STI('lua/maps/gui_units.lua')
  local w,h = map.tilewidth * map.width * scale, map.tileheight * map.height * scale
  local y = love.graphics:getHeight() - h
  
  TiledWidget.initialize(self, map, 0, y, w, h, 2)
  
  self.shiftamount = map.tileheight * 6
  self.transformshift = 0
  self.defaulttransform = self.transform:clone()
  self.camera:fit(map)
  self.fraction = fraction

  self.tile = nil
  
  self.unitcap = 4
  self.unitpool = {4,9,18}
  
  for i=1,self.unitcap do
    self:addUnit()
  end
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
    local unitclass = _G[tile.type]
    local souls = self.fraction.game.game.state.souls
    local tier = _G[tile.type].tier or 0
    local cost = 1
    if (souls[tier] or 0) >= cost then
      souls[tier] = souls[tier] - cost
      self.fraction:addUnit(tile.type, self.fraction.spawn)
      self.map:setLayerTile(layer.name, x, y, 0)
      self:addUnit()
    end
  elseif tile and tile.type and tile.type == 'Master' then
    options['r'] = not options['r']
  end
end

function ControlWidget:update(dt)
  TiledWidget.update(self, dt)
  self.map:update(dt)
  
  local dir = (options['r'] and (-1)) or 1
  self.transformshift = math.max(0, math.min(self.shiftamount, self.transformshift + dir * dt * 1000))
  self.transform = self.defaulttransform:clone()
  self.transform:translate(0, self.transformshift)
end

function ControlWidget:draw()
  -- save current canvas
  local targetCanvas = love.graphics.getCanvas()
  
  love.graphics.setCanvas(self.canvas)
  love.graphics.clear(0,0,0,0)
  self.map:draw(self.camera:getMapArgs())
  -- restore target canvas and draw to it
  love.graphics.setCanvas(targetCanvas)
  
  TiledWidget.draw(self)
end