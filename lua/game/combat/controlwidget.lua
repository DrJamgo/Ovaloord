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
  
  local layerobjects = self.map.layers.Research.objects
  local researchobjects = {}
  for _,object in ipairs(layerobjects) do
    local known = (self.game.state.souls[_G[object.name].tier] ~= nil)
    local newUnit = self:_newDrawable(object.name, object.x, object.y)
    researchobjects[#researchobjects+1] = newUnit
  end
  self.researchlayer = self.map:convertToCustomLayer('Research')
  self.researchlayer.draw = drawResearch
  self.researchlayer.update = updateResearch
  self.researchlayer.objects = researchobjects
  self.researchlayer.widget = self
  
  self:_updateUnitPool()
end

function ControlWidget:_newDrawable(name, x, y)
  local newUnit = {sprite=LPCSprite(_G[name].spritepath)}
  newUnit.x, newUnit.y = x,y
  newUnit.width, newUnit.height = 32,16
  newUnit.name = name
  newUnit.type = name
  newUnit.cooldown = 0.0
  newUnit.cooldowntime = 2.0
  newUnit.brief = _G[name].brief
  newUnit.long = _G[name].long
  return newUnit
end

function ControlWidget:_updateUnitPool()
  self.layer.objects = {}
  local objects = self.layer.objects
  for i=1,#self.unitpool do
    local name = self.unitpool[i]
    local x,y = self.map:convertTileToPixel(i+1.45, 6.1)
    objects[#objects+1] = self:_newDrawable(name, x, y)
  end
end

function drawResearch(layer)
  drawUnits(layer)
  local cap = layer.widget.game.state.selectioncap
  local sel = #layer.widget.unitpool
  local x,y = layer.widget.map:convertTileToPixel(1,6.2)
  local rb = ((sel == cap) and 1) or 0
  love.graphics.setColor(1,rb,rb,1)
  love.graphics.print(string.format(" %d/%d", sel, cap),x,y,0,1)
end

function updateResearch(layer, dt)
  for _,object in ipairs(layer.objects) do
    object.unlocked = table.searchByValue(layer.widget.game.state.research, object.name) ~= nil
    object.visible = (layer.widget.game.state.souls[_G[object.name].tier] ~= nil)
  end
end

function updateUnits(layer, dt)
  for i,object in ipairs(layer.objects) do
    object.cooldown = math.max(0, (object.cooldown - dt))
  end
end

function drawUnits(layer)
  for i,object in ipairs(layer.objects) do
    if object.visible == false then
      -- do nothing
    elseif object.unlocked == false then
      love.graphics.setColor(0.1,0.1,0.1,0.6)
      object.sprite:drawAnimation(object.x, object.y, 'stand', 1, 0)
    elseif object.cooldown > 0 then
      local time = (object.cooldown / object.cooldowntime) * (5/6)
      love.graphics.setColor(1-time-0.2, 1-time-0.2, 1-time-0.2, 1)
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
      if layer.name == 'Units' then
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
        else
          for i,selected in ipairs(self.unitpool) do
            if selected == tile.type then
              table.remove(self.unitpool, i)
              self:_updateUnitPool()
              break
            end
          end
        end
      end
      if layer.name == 'Research' and tile.unlocked and self.game.state.selectioncap > #self.unitpool then
        table.insert(self.unitpool, tile.name)
        self:_updateUnitPool()
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
  self.map.layers.Research.visible = options['r']
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