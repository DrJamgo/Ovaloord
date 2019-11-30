require 'middleclass'
require 'utils/vec'

UnitsLayer = class('UnitsLayer')

function UnitsLayer:initialize(map)
  for i,layer in ipairs(map.layers) do
    if layer.name == 'Units' then
      map:removeLayer(i)
      map:addCustomLayer('Units',i,self)
      self.draw = UnitsLayer.draw
      self.update = UnitsLayer.update
      break
    end
  end
  self.map = map
  self.objects = {}
end

function UnitsLayer:pushColor()
  self.color = {love.graphics.getColor( )}
end

function UnitsLayer:popColor()
  love.graphics.setColor(unpack(self.color))
end

function UnitsLayer:draw()
  self:pushColor()
  for y=1,self.map.height do
    for _,object in pairs(self.objects) do
      if object.pos.y >= y and object.pos.y < y+1 then
        self:popColor()
        object:draw()
      end
    end
  end
end

function UnitsLayer:update(dt)
  dt = math.min(dt, 0.25)
  if love.keyboard.isDown('y') then dt = dt * 0.1 end
  if options['p'] then dt = 0 end
  local leading_undead = nil
  for _=1,(love.keyboard.isDown('x') and 10) or 1 do
    for i,object in pairs(self.objects) do
      object:update(dt)
      if object.dead then
        self.objects[i] = nil
      end
    end
  end
end
