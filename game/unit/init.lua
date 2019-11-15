require 'middleclass'
Unit = class('Unit')

require 'utils/map'
require 'game/unit/lpcsprite'

Unit.speed = 1
Unit.radius = 0.4

Unit.size = {x=32, y=64}
Unit.offset = {x=-16, y=-48}

function Unit:initialize(game, tx, ty)
  -- references
  self.game = game
  -- physics
  self.pos = vec2(tx, ty)
end

function Unit:_moveToTile(dt, targetTile)
  -- find path
  if not self.path or self.target ~= targetTile then
    local astar = AStar(self.game.grid)
    local start = {x=math.floor(self.pos.x+0.5), y=math.floor(self.pos.y+0.5)}
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
  local diff = vec2_sub(location, self.pos)
  local step = self.speed * dt
  local distance
  self.moveinc, distance = vec2_norm(diff, step)
  if distance > step then
    self.pos = vec2_add(self.pos, self.moveinc)
    return false
  else
    copy(self.pos, location)
    return true
  end
end

function Unit:_update(dt, target)
  if target[1] == 'move' then
    self:_moveToTile(dt, target[2])
  end
  if target[1] == 'attack' then
    -- TODO: implement attack
  end
end

function Unit:update(dt)
  -- default behaviour: move to game.goal..
  self:_update(dt, {'move', self.game.goal})
end

function Unit:draw()
  local wx, wy = gamemap.getPixelFromTile(self.game.map, {x=self.pos.x, y=self.pos.y})
   
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