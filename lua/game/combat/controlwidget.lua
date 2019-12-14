local STI = require 'sti/sti'
require 'game/widget'
ControlWidget = class('ControlWidget', TiledWidget)

function ControlWidget:initialize(game, scale)
  local map = STI('lua/maps/gui_units.lua')
  local w,h = map.tilewidth * map.width * scale, map.tileheight * map.height * scale
  local y = love.graphics:getHeight() - h
  
  TiledWidget.initialize(self, map, 0, y, w, h, 2)
  
  self.shiftamount = map.tileheight * 6
  self.transformshift = self.shiftamount
  self.defaulttransform = self.transform:clone()
  self.camera:fit(map)
  self.game = game

  self.tile = nil
  for i,tileset in ipairs(map.tilesets) do
    if tileset.name == 'undead' then
      self.idoffset = tileset.firstgid - 1
    end
  end

  self.unitpool = self.game.state.active
  self.unitcap = 4

  for i=1,self.unitcap do
    self:addUnit()
  end
end

function ControlWidget:setFraction(fraction)
  self.fraction = fraction
end

function ControlWidget:addUnit(id)

end

function ControlWidget:mousepressed(gx,gy,button,isTouch)
  local tile, layer, x, y = self:getTileAtPosition(gx, gy)
  if tile and tile.type then
    if tile.type ~= '' and _G[tile.type] then
      if self.fraction then
        local unitclass = _G[tile.type]
        local souls = self.game.state.souls
        local tier = _G[tile.type].tier or 0
        local cost = 1
        if (souls[tier] or 0) >= cost then
          souls[tier] = souls[tier] - cost
          self.fraction:addUnit(tile.type, self.fraction.spawn)
          self.map:setLayerTile(layer.name, x, y, 0)
          self:addUnit()
        end
      end
      return true
    elseif tile.type == 'Research' then
      options['r'] = not options['r']
      return true
    elseif tile.type == 'Quit' then
      self.game:exitCombat()
      return true
    end
  end
end

function ControlWidget:update(dt)
  TiledWidget.update(self, dt)
  self.map:update(dt)
  
  for i=1,#self.unitpool do
    local x = i+2
    local y = 7
    local id = (_G[self.unitpool[i]].id or 0) + self.idoffset
    self.map:setLayerTile('Units', x, y, id)
  end
  
  local dir = (options['r'] and (-1)) or 1
  self.transformshift = math.max(0, math.min(self.shiftamount, self.transformshift + dir * dt * 1000))
  self.transform = self.defaulttransform:clone()
  self.transform:translate(0, self.transformshift)
  
  self.map.layers.UnitButtons.visible = (options['r'] or self.fraction) and true
  self.map.layers.Units.visible = self.map.layers.UnitButtons.visible
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