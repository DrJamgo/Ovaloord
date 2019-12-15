local STI = require 'sti/sti'
require 'game/unit/lpcsprite'
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
  self.layer = self.map:convertToCustomLayer('Units')
  self.layer.draw = drawUnits
  self.layer.update = updateUnits
  self.layer.objects = {}
  self.layer.map = self.map

  for i=1,#self.unitpool do
    local objects = self.layer.objects
    local name = self.unitpool[i]
    local x,y = self.map:convertTileToPixel(i+1.45, 6.1)
    local newUnit = {sprite=LPCSprite(_G[name].spritepath)}
    newUnit.x, newUnit.y = x,y
    newUnit.width, newUnit.height = 32,16
    newUnit.name = name
    newUnit.type = name
    newUnit.cooldown = 0.0
    newUnit.cooldowntime = 2.0
    newUnit.brief = _G[name].brief
    newUnit.long = _G[name].long
    objects[#objects+1] = newUnit
  end
end

function updateUnits(layer, dt)
  for i,object in ipairs(layer.objects) do
    object.cooldown = math.max(0, (object.cooldown - dt))
  end
end

function drawUnits(layer)
  for i,object in ipairs(layer.objects) do
    if object.cooldown > 0 then
      local time = (object.cooldown / object.cooldowntime) * (5/6)
      love.graphics.setColor(1-time, 1-time, 1-time, 1)
      object.sprite:drawAnimation(object.x, object.y, 'prone', 4, time)
    else
      love.graphics.setColor(1,1,1,1)
      object.sprite:drawAnimation(object.x, object.y, 'stand', 1, 0)
    end
  end
end

function ControlWidget:setFraction(fraction)
  self.fraction = fraction
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
        if (souls[tier] or 0) >= cost and tile.cooldown == 0 then
          souls[tier] = souls[tier] - cost
          tile.cooldown = tile.cooldowntime
          self.fraction:addUnit(tile.type, self.fraction.spawn)
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
  
  local dir = (options['r'] and (-1)) or 1
  self.transformshift = math.max(0, math.min(self.shiftamount, self.transformshift + dir * dt * 1000))
  self.transform = self.defaulttransform:clone()
  self.transform:translate(0, self.transformshift)
  
  self.map.layers.UnitButtons.visible = (options['r'] or self.fraction) and true
  self.map.layers.Units.visible = self.map.layers.UnitButtons.visible
  self.map.layers.Tier.visible = self.map.layers.UnitButtons.visible
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