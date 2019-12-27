require 'middleclass'
require 'utils/vec'

UnitsLayer = class('UnitsLayer')

function UnitsLayer:initialize(map, game)
  for i,layer in ipairs(map.layers) do
    if layer.name == 'Units' then
      map:removeLayer(i)
      map:addCustomLayer('Units',i,self)
      self.draw = UnitsLayer.draw
      self.update = UnitsLayer.update
      break
    end
  end
  self.game = game
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
  local leading_undead = nil
  for i,object in pairs(self.objects) do
    object:update(dt)
    if object.dead and object.dead > 1 then
      self.objects[i] = nil
      if object.tier and object.fraction ~= self.game.control.fraction then
        self.game:addSpirit(object.tier)
      end
    end
  end
end
