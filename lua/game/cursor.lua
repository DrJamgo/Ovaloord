require 'middleclass'
Cursor = class("Cursor")
Cursor.scale = T.defaultscale
Cursor.textbox = 80 * T.defaultscale
Cursor.tooltipdelay = 2
Cursor.charheight = 17

function Cursor:initialize(widget)
  self.widget = widget
  self.brief = nil
  self.screen = vec2(0,0)
  self.pos = vec2(0,0)
  self.object = nil
  self.time = 0
end

function Cursor:update(dt)
  local x, y = love.mouse.getPosition()
  if self.widget:test(x,y) then
    self.screen.x, self.screen.y = x,y
    local tileOrObject, layer, tx, ty = self.widget:getTileAtPosition(self.screen.x, self.screen.y)
    
    if tileOrObject and (tileOrObject.name or tileOrObject.type) then
      self.brief, self.long = self.widget:getObjectDecription(tileOrObject)
      if self.brief then
        if love.mouse.isDown(1) then
          self.time = 0
        end
        if self.object == tileOrObject then
          self.time = (self.time or 0) + dt
        else
          self.time = 0
        end
        self.object = tileOrObject
        local ox, oy = x,y
        if tileOrObject.x and tileOrObject.y then
          ox, oy = math.ceil(tileOrObject.x + tileOrObject.width/2) , math.ceil(tileOrObject.y + tileOrObject.height/2)
          self.pos.x, self.pos.y = self.widget:convertMapToScreen(ox, oy)
        elseif(tx and ty) then 
          ox, oy = self.widget.map:convertTileToPixel(tx-0.5, ty-0.5)
          self.pos.x, self.pos.y = self.widget:convertMapToScreen(ox, oy)
        else
          self.pos.x, self.pos.y = x,y
        end
      end
    else
      self.time = 0
      self.brief = nil
      self.object = nil
    end
  else
    self.brief = nil
    self.object = nil
  end
end

function Cursor:draw()
  local scale = self.scale * (1 + 0.1 * math.sin(math.min(math.pi, (self.time or 0) * 10)))
  local x,y = self.pos.x-(Cursor.textbox/2)*scale, self.pos.y-Cursor.charheight*scale
  x = math.floor(math.max(x,0))
  y = math.floor(math.max(y,0))
  
  if self.brief then
    love.graphics.printf(self.brief, x, y, Cursor.textbox, 
    'center', 0,scale)
  end
  if self.brief and self.long and self.time > self.tooltipdelay then
    local scale = self.scale / 2 * (1 + 0.1 * math.sin(math.min(math.pi, (self.time-self.tooltipdelay) * 10)))
    love.graphics.printf(self.long, self.pos.x-(Cursor.textbox/2)*scale, self.pos.y, Cursor.textbox, 'center', 0,scale)
  end
end