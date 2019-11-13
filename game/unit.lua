require 'middleclass'
Unit = class('Unit')

require 'utils/map'

function Unit:initialize(game, tx, ty)
  self.game = game
  self.wx, self.wy = gamemap.getPixelFromTile(self.game.map, {x=tx, y=ty})
  
  self.speed = 320
  self.size = {x=32, y=64}
  self.offset = {x=-16, y=-48}
end 

function Unit:update(dt)
  if not self.path then
    local astar = AStar(self.game.grid)
    local start = gamemap.getTileFromObject(self.game.map, {x=self.wx, y=self.wy})
    self.path = astar:findPath(start, self.game.goal)
    self.pathindex = 0
  end
  if self.path and not self.node then
    self.pathindex = self.pathindex + 1
    local nodes = self.path:getNodes()
    self.node = nodes[self.pathindex]
    if not self.node then
      self.path = nil
    end
  end
  
  if self.node then
    local gwx, gwy = gamemap.getPixelFromTile(self.game.map, self.node.location)
    local dx = gwx - self.wx
    local dy = gwy - self.wy
    local distance = math.sqrt(dx*dx + dy*dy)
    local step = self.speed * dt
    if distance > step then
      self.wx = self.wx + (dx / distance) * step
      self.wy = self.wy + (dy / distance) * step
    else
      self.wx = gwx
      self.wy = gwy
      self.node = nil
    end
  end
end

function Unit:draw()
  self.rect = {
    self.wx + self.offset.x, 
    self.wy + self.offset.y,
    self.size.x,
    self.size.y
  }
  self.circle = {
    self.wx,
    self.wy,
    self.size.x / 2
  }
  
  love.graphics.circle("line",unpack(self.circle))
  love.graphics.rectangle("line",unpack(self.rect))
  
  if self.path then
    local nodes = self.path:getNodes()
    for i=1,#nodes-1 do
      local x1, y1 = gamemap.getPixelFromTile(self.game.map, nodes[i].location)
      local x2, y2 = gamemap.getPixelFromTile(self.game.map, nodes[i+1].location)
      love.graphics.line(x1, y1, x2, y2)
    end
  end
  
end