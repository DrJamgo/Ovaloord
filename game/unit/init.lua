require 'middleclass'
Unit = class('Unit')

require 'utils/map'
require 'utils/vec'
require 'game/unit/lpcsprite'
require 'game/unit/ability'
require 'astar/astar'

Unit.speed = 0.5
Unit.radius = 0.45
Unit.spritepath = 'res/sprites/default.png'
Unit.stuckpatience = 2

function Unit:initialize(game, fraction, spawn)
  -- references
  self.game = game
  self.fraction = fraction
  self.spawn = spawn
  
  -- physics
  self.pos = vec2(spawn.x, spawn.y)
  self.node = self.game.grid:getNode(spawn)
  self.game.grid:claimNode(self.node, self)
  if self.melee then
    self.melee = Melee(unpack(self.melee))
  end
  if self.range then
    self.range = Range(unpack(self.range))
  end
  
  -- appearance
  self.sprite = LPCSprite(self.spritepath)
  self.moveinc = vec2(0,1)
end
--
-- WRAPPERS for GRID
--
function Unit:getAdjacentNodes(curnode, dest)
  local move = self.game.grid:getAdjacentNodes(curnode, dest)
  local melee = self.melee and self.melee:getNodes(self.game.grid, self, self.node) or {}
  local range = self.range and self.range:getNodes(self.game.grid, self, self.node) or {}
  return move, melee, range
end

function Unit:locationsAreEqual(...)
  return self.game.grid:locationsAreEqual(...)
end

function Unit:getNode(...)
  return self.game.grid:getNode(...)
end

function Unit:_faceNode(node)
  if node then
    local diff = vec2_sub(node.location, self.node.location)

    -- 1=right, 2=down, 3=left, 4=up
    self.dir = (math.floor((math.atan2(diff.y, diff.x) / math.pi * 2 + 0.5))) % 4 + 1
  end
end

function Unit:_moveToTile(dt, targetTile)
  -- find path
  if not self.path or self.target ~= targetTile then
    if not self.game.grid:locationsAreEqual(self.node.location, targetTile) then
      local astar = AStar(self)
      local start = {x=math.floor(self.pos.x+0.5), y=math.floor(self.pos.y+0.5)}
      self.path = astar:findPath(start, targetTile)
      self.pathindex = 0
      self.nextNode = nil
      self.target = targetTile
    end
  end
  
  -- check if enemy in melee range
  if not self.nextNode then
    local move, melee, range = self:getAdjacentNodes(self.node, self.node.location)
    if melee[1] then
      self.nextNode = melee[1]
      self.attack = self.melee
      self:_faceNode(self.nextNode)
    elseif range[1] then
      self.nextNode = range[1]
      self.attack = self.range
      self:_faceNode(self.nextNode)
    end
  end
  
  -- select next node
  if self.path and not self.nextNode then
    self.pathindex = self.pathindex + 1
    local nodes = self.path:getNodes()
    self.nextNode = nodes[self.pathindex]
    self:_faceNode(self.nextNode)
    if not self.nextNode then
      self.path = nil
    end
  end
  
 -- check if node is walkable
  self.moving = false
  if self.nextNode then
    if self.nextNode.action == 'move' then
      if self.game.grid:claimNode(self.nextNode, self) then
        self.stuck = nil
        self.moving = true
        if self:_move(dt, self.nextNode.location) then
          self.node = self.nextNode
          self.nextNode = nil
        end
      else
        self.stuck = (self.stuck or 0) + dt
        if self.stuck > self.stuckpatience then
          self.path = nil
          self.stuck = 0
        end
      end
    elseif self.nextNode.action and self.attack then
      if self.attack:validateTarget(self, self.node, self.nextNode.unit) then
        self.attack:activate(self, self.nextNode.unit)
      else
        self.nextNode = nil
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

function Unit:hit(dmg, unit)
  self.hp = self.hp - dmg
  self.ishit = 0.2
end

function Unit:update(dt)
  if self.hp and self.hp <= 0 then
    self.prone = math.min(1, (self.prone or 0) + dt * 2)
  elseif self.attack and self.attack:isActive() then
    local trigger = self.attack:update(dt)
  else
    local target = self.fraction:getUnitTarget(self)
    if target then
      self:_update(dt, target)
    end
  end
  
  self.ishit = (self.ishit or 0) - dt
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
  
  if self.ishit > 0 then
    love.graphics.setColorMask(false, true, true, false)
  end
  
  if self.prone then
    self.sprite:drawAnimation(wx, wy, 'prone', 4, self.prone)
    self.node = nil
    self.nextNode = nil
  elseif self.moving then
    local _, diff = vec2_norm(self.moveinc or {x=0, y=0})
    self.movedist = (self.movedist or 0) + diff
    self.sprite:drawAnimation(wx, wy, (self.stuck and 'stand') or 'move', self.dir, self.movedist)
  elseif self.attack and self.attack:isActive() then
    self.sprite:drawAnimation(wx, wy, self.attack.anim, self.dir, self.attack:getProgress())
  else
    self.sprite:drawAnimation(wx, wy, 'stand', self.dir, 0)
  end
  
  love.graphics.setColorMask()
  
  --love.graphics.print(tostring(self.id), wx, wy)
  --love.graphics.print(tostring(self.hp), wx, wy-32)
  
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