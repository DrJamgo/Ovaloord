require 'middleclass'
Unit = class('Unit')

require 'utils/map'

Unit.speed = 1
Unit.radius = 0.4

Unit.size = {x=32, y=64}
Unit.offset = {x=-16, y=-48}

function Unit:initialize(game, tx, ty)
  -- references
  self.game = game
  -- physics
  self.tx, self.ty = tx, ty
end

function Unit:_moveToTile(dt, targetTile)
  -- find path
  if not self.path or self.target ~= targetTile then
    local astar = AStar(self.game.grid)
    local start = {x=math.floor(self.tx+0.5), y=math.floor(self.ty+0.5)}
    self.path = astar:findPath(start, self.game.goal)
    self.pathindex = 0
    self.node = nil
    self.target = targetTile
  end
  
  -- select next node
  if self.path and not self.node then
    self.pathindex = self.pathindex + 1
    local nodes = self.path:getNodes()
    self.node = nodes[self.pathindex]
    if not self.node then
      self.path = nil
    end
  end
  
 -- check if node is walkable
  self.moving = false
  if self.node then
    if self.game.grid:claimNode(self.node, self) then
      self.stuck = nil
      self.moving = true
      if self:_move(dt, self.node.location) then
        self.node = nil
      end
    else
      self.stuck = (self.stuck or 0) + dt
      if self.stuck > 3 then
        self.path = nil
        self.stuck = 0
      end
    end
  end
end

function Unit:_move(dt, location)
  local dx = location.x - self.tx
  local dy = location.y - self.ty
  local distance = math.sqrt(dx*dx + dy*dy)
  local step = self.speed * dt
  if distance > step then
    self.tx = self.tx + (dx / distance) * step
    self.ty = self.ty + (dy / distance) * step
    return false
  else
    self.tx = self.node.location.x
    self.ty = self.node.location.y
    return true
  end
end

function Unit:update(dt)
  self:_moveToTile(dt, self.game.goal)
end

function Unit:draw()
  local wx, wy = gamemap.getPixelFromTile(self.game.map, {x=self.tx, y=self.ty})
   
  self.rect = {
    wx + self.offset.x, 
    wy + self.offset.y,
    self.size.x,
    self.size.y
  }
  self.circle = {
    wx,
    wy,
    self.size.x / 2
  }
  
  love.graphics.setColor(self.stuck and 1 or 0,0.5,0.5)
  love.graphics.circle("line",unpack(self.circle))
  love.graphics.rectangle("line",unpack(self.rect))
  
  love.graphics.setColor(0,0,0,0.3)
  if self.path then
    local nodes = self.path:getNodes()
    for i=1,#nodes-1 do
      local x1, y1 = gamemap.getPixelFromTile(self.game.map, nodes[i].location)
      local x2, y2 = gamemap.getPixelFromTile(self.game.map, nodes[i+1].location)
      love.graphics.line(x1, y1, x2, y2)
    end
  end
  
end