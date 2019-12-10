require 'middleclass'
Cursor = class("Cursor")
Cursor.scale = 2
Cursor.textbox = 200
Cursor.tooltipdelay = 2
Cursor.charheight = 17

function Cursor:initialize(widget)
  self.widget = widget
  self.brief = nil
  self.screen = vec2(0,0)
  self.pos = vec2(0,0)
  self.object = nil
end

function Cursor:update(dt)
  local x, y = love.mouse.getPosition()
  if self.widget:test(x,y) then
    self.screen.x, self.screen.y = x,y
    local tileOrObject = self.widget:getTileAtPosition(self.screen.x, self.screen.y)
    
    if tileOrObject and (tileOrObject.name or tileOrObject.type) then
      self.brief, self.long = self.widget:getObjectDecription(tileOrObject)
      if self.brief then
        if self.object == tileOrObject then
          self.time = (self.time or 0) + dt
        else
          self.time = 0
        end
        self.object = tileOrObject
        local ox, oy
        if tileOrObject.x and tileOrObject.y then
          ox, oy = math.ceil(tileOrObject.x + tileOrObject.width/2) , math.ceil(tileOrObject.y + tileOrObject.height/2)
          self.pos.x, self.pos.y = self.widget:convertMapToScreen(ox, oy)
        else
          self.pos.x, self.pos.y = x,y
        end
      end
    else
      self.brief = nil
      self.object = nil
    end
  else
    self.brief = nil
    self.object = nil
  end
end

function Cursor:draw()
  if self.brief then
    love.graphics.printf(self.brief, self.pos.x-(Cursor.textbox/2)*self.scale, self.pos.y-Cursor.charheight*self.scale, Cursor.textbox, 'center', 0,self.scale)
  end
  if self.brief and self.long and self.time > self.tooltipdelay then
    local scale = 1.5
    love.graphics.printf(self.long, self.pos.x-(Cursor.textbox/2)*scale, self.pos.y, Cursor.textbox, 'center', 0,scale)
  end
end