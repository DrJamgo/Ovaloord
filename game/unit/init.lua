require 'middleclass'
Unit = class('Unit')

require 'utils/map'
require 'utils/vec'
require 'game/unit/lpcsprite'

Unit.speed = 1
Unit.radius = 0.2

function Unit:initialize(game, fraction, tx, ty)
  -- references
  self.game = game
  self.fraction = fraction
  -- physics
  self.pos = vec2(tx, ty)
  -- appearance
  self.spite = LPCSprite()
end

--
-- WRAPPERS for GRID
--
function Unit:getAdjacentNodes(...)
  return self.game.grid:getAdjacentNodes(...)
end

function Unit:locationsAreEqual(...)
  return self.game.grid:locationsAreEqual(...)
end

function Unit:getNode(...)
  return self.game.grid:getNode(...)
end

function Unit:_moveToTile(dt, targetTile)
  -- find path
  if not self.path or self.target ~= targetTile then
    local astar = AStar(self)
    local start = {x=math.floor(self.pos.x+0.5), y=math.floor(self.pos.y+0.5)}
    self.path = astar:findPath(start, self.game.goal)
    self.pathindex = 0
    self.node = nil
    self.nextNode = nil
    self.target = targetTile
  end
  
  -- select next node
  if self.path and not self.nextNode then
    self.pathindex = self.pathindex + 1
    local nodes = self.path:getNodes()
    self.nextNode = nodes[self.pathindex]
    if not self.nextNode then
      self.path = nil
    end
  end
  
 -- check if node is walkable
  self.moving = false
  if self.nextNode then
    if self.game.grid:claimNode(self.nextNode, self) then
      self.stuck = nil
      self.moving = true
      if self:_move(dt, self.nextNode.location) then
        self.node = self.nextNode
        self.nextNode = nil
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
    self.pos = vec2(location.x, location.y)
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
   
  self.circle = {
    wx,
    wy,
    self.radius * self.game.map.tilewidth
  }
  
  --love.graphics.setColor(self.stuck and 1 or 0,0.5,0.5)
  --love.graphics.circle("line",unpack(self.circle))
  
  local dir = (math.floor((math.atan2(self.moveinc.y, self.moveinc.x) / math.pi * 2 + 0.5))) % 4 + 1
  
  local _, diff = vec2_norm(self.moveinc or {x=0, y=0})
  self.spite:drawAnimation(wx, wy, (self.stuck and 'stand') or 'move', dir, diff)
  
  --[[
  --love.graphics.setColor(0,0,0,1)
  if self.path then
    local nodes = self.path:getNodes()
    for i=1,#nodes-1 do
      local x1, y1 = gamemap.getPixelFromTile(self.game.map, nodes[i].location)
      local x2, y2 = gamemap.getPixelFromTile(self.game.map, nodes[i+1].location)
      love.graphics.line(x1, y1, x2, y2)
    end
  end
  ]]--
  
end