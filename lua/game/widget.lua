require('middleclass')
Widget = class('Widget')
Widget.content = vec2(320,240)

function Widget:initialize(x, y, w, h, scale)
  self.rect = {x, y, w, h}
  self.scale = scale or math.floor(math.min(h / self.content.y, w / self.content.x))
  
  self.canvas = love.graphics.newCanvas(w / self.scale, h / self.scale)
  self.canvas:setFilter('nearest', 'nearest')
  self.cursor = Cursor(self)
  
  local hscale = self:getWidth() / self.canvas:getWidth()
  local vscale = self:getHeight() / self.canvas:getHeight()
  self.transform = love.math.newTransform(x,y,0,hscale,vscale)
end

function Widget:getDimensions()
  return self.rect[3], self.rect[4]
end

function Widget:getWidth()
  return self.rect[3]
end

function Widget:getHeight()
  return self.rect[4]
end

function Widget:test(mx,my)
  local x,y,w,h = unpack(self.rect)
  return mx >= x and mx <= x + w and my >= y and my <= y + h
end

function Widget:update(dt)
end

function Widget:draw()
  love.graphics.push()
  local x,y,w,h = unpack(self.rect)
  love.graphics.replaceTransform(self.transform)
  love.graphics.setColor(1,1,1,1)
  love.graphics.draw(self.canvas)
  love.graphics.pop()
  --love.graphics.rectangle("line",x,y,w,h)
end

----------- TextWidget ----------
TextWidget = class('TextWidget', Widget)
TextWidget.align = 'left'
TextWidget.scale = T.defaultscale
TextWidget.color = {1,1,1,1}

function TextWidget:initialize(...)
  Widget.initialize(self,...)
  self.scale = self.scale
  self.anim = 0
  self.text = ''
end

function TextWidget:update(dt)
  -- do nothing
end

function TextWidget:draw()
  local targetCanvas = love.graphics.getCanvas()
  love.graphics.setCanvas(self.canvas)
  love.graphics.clear(0,0,0,0)
  love.graphics.printf({self.color, self.text}, 0, 0, 
    (self.width)/self.scale, 
    self.align, 0,
    self.scale)
  -- restore target canvas and draw to it
  love.graphics.setCanvas(targetCanvas)
  Widget.draw(self)
end

----------- HudWidget ----------
HudWidget = class('HudWidget', TextWidget)
HudWidget.align = 'right'
HudWidget.width = 160
HudWidget.height = 200

function HudWidget:initialize(state, ...)
  self.state = state
  TextWidget.initialize(self, love.graphics.getWidth()-16-self.width, 0, self.width, self.height, 1)
end

function HudWidget:update(dt)
  self.anim = (self.anim or 1) + dt 
  
  local textscale = T.defaultscale * 1.5 * (1 + 0.3 * math.sin(math.min(math.pi, self.anim * 10)))
  local text = ''
  for tier,souls in ipairs(self.state.souls) do
    text = text..S.tier[tier]..tostring(souls)..'\n'
  end
  self.scale = textscale
  self.text = text
end

----------- ObjectiveWidget ----------
ObjectiveWidget = class('ObjectiveWidget', TextWidget)
ObjectiveWidget.width = 660
ObjectiveWidget.height = 200
ObjectiveWidget.align = 'left'
function ObjectiveWidget:initialize(objective, ...)
  self.objective = objective
  self.scale = T.defaultscale
  TextWidget.initialize(self, 0+16, 0, self.width, self.height, 1)
end

function ObjectiveWidget:update(dt)
  self.text = self.objective:getText()
  local f = math.max(0,math.min(1,self.objective.animincrement))
  if self.objective.closed then
    f = 1
  end
  self.color = {f,1,f,1}
  self.scale = self.objective.textscale
end

----------- TiledWidget ----------

TiledWidget = class('TiledWidget', Widget)

function TiledWidget:initialize(map, ...)  
  Widget.initialize(self, ...)
  self.map = map
  self.camera = Camera(self.canvas)
end

function TiledWidget:update(dt)
  self.camera:update(dt)
  self.cursor:update(dt)
end

function TiledWidget:mousemoved(x,y,...)
  self.cursor:set(x,y)
  local tileOrObject
  if x and y then
    tileOrObject = self:getTileAtPosition(x, y)
  end
  return tileOrObject ~= nil
end

function TiledWidget:getMapFromScreen(screenx, screeny)
  -- transform from screen to canvas pixels
  local canvasx, canvasy = self.transform:inverseTransformPoint(screenx, screeny)
  -- transform from canvas to map pixels
  return self.camera.transform:inverseTransformPoint(canvasx, canvasy)
end

function TiledWidget:convertMapToScreen(mx, my)
  local canvasx, canvasy = self.camera.transform:transformPoint(mx, my)
  return self.transform:transformPoint(canvasx, canvasy)
end

function TiledWidget:getTileAtPosition(...)
  local mapx, mapy = self:getMapFromScreen(...)
  -- transform from map pixels to map tiles
  local tx, ty = self.map:convertPixelToTile(mapx, mapy)
  tx = math.floor(tx + 1)
  ty = math.floor(ty + 1)
  for i=1,#self.map.layers do
    local layer = self.map.layers[#self.map.layers + 1 - i]
    if layer.data and layer.data[ty] then
      local tile = layer.data[ty][tx]
      if tile then return tile, layer, tx, ty end
    end
    for _,object in pairs(layer.objects or {}) do
      if object.visible ~= false then
        local x,y = object.x, object.y
        local w,h = object.width, object.height
        if object.sprite and not w then
          x,y = object.sprite.x, object.sprite.y
          w,h = object.sprite.width, object.sprite.height
        end
        if x and mapx >= x and mapx <= x + w and mapy >= y and mapy <= y + h then
          return object, layer
        end
      end
    end
  end
  return nil
end

function TiledWidget:getObjectDecription(object)
  if object.brief then
    return object.brief, ((object.unlocked and S.unlock)or S.locked)..(object.long or '')
  elseif object.name then
    return T.get(object.name)
  elseif object.type and object.type ~= '' then
    if _G[object.type] and _G[object.type].brief then
      return _G[object.type].brief, _G[object.type].long
    end
    return T.get(object.type)
  end
end

function TiledWidget:draw()
  Widget.draw(self)
  self.cursor:draw()
end