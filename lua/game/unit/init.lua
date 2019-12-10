require 'middleclass'
Unit = class('Unit')

require 'utils/map'
require 'utils/vec'
require 'game/effect'
require 'game/unit/lpcsprite'
require 'game/unit/ability'
require 'astar/astar'

Unit.speed = 2
Unit.radius = 0.45
Unit.spritepath = 'assets/sprites/default.png'
Unit.stuckpatience = 0.5
Unit.tier = 0
Unit.sight = 6

function Unit:initialize(map, fraction, spawn)
  -- references
  self.map = map
  self.fraction = fraction
  self.spawn = spawn
  self.type = self.class.name
  
  -- physics
  self.pos = vec2(spawn.x, spawn.y)
  self.node = self.map.layers.grid:getNode(spawn)
  self.map.layers.grid:claimNode(self.node, self)
  if self.melee then
    self.melee = Melee(self, unpack(self.melee))
  end
  if self.range then
    self.range = Range(self, unpack(self.range))
  end
  self.move = Move(self)
  self.idle = Ability(self, 1.0 + math.random(1,10)/10, 1.0, 1.0)
  
  -- appearance
  self.sprite = LPCSprite(self.spritepath)

  require('utils/microscope')('Unit.dot', self, 2, 'nometatables')
end
--
-- WRAPPERS for GRID
--
function Unit:getAdjacentNodes(curnode, dest)
  local move = self.map.layers.grid:getAdjacentNodes(curnode, dest)
  local melee = self.melee and self.melee:getNodes(self.map.layers.grid, self.node) or {}
  local range = self.range and self.range:getNodes(self.map.layers.grid, self.node) or {}
  return move, melee, range
end

function Unit:locationsAreEqual(...)
  return self.map.layers.grid:locationsAreEqual(...)
end

function Unit:getNode(...)
  return self.map.layers.grid:getNode(...)
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
    if not self.map.layers.grid:locationsAreEqual(self.node.location, targetTile) then
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
    else
      self.attack = nil
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
      if self.map.layers.grid:claimNode(self.nextNode, self) then
        self.stuck = nil
        self.moving = true
        self.move:activate(self.nextNode.location)
      else
        if self.fraction:isEnemy(self.nextNode.unit) then
          self.path = nil
          self.nextNode = nil
        end
        self.stuck = (self.stuck or 0) + dt
        if self.stuck > self.stuckpatience then
          self.path = nil
          self.stuck = 0
        end
      end
    elseif self.nextNode.action and self.attack then
      if self.attack:validateTarget(self.node, self.nextNode.unit) then
        self.attack:activate(self.nextNode.unit)
      else
        self.nextNode = nil
      end
    end
  else
    self.idle:activate()
  end
end

function Unit:hit(dmg, unit)
  self.hp = self.hp - dmg
  self.ishit = 0.2
end

function Unit:update(dt)
  if self.hp and self.hp <= 0 then
    self.prone = math.min(1, (self.prone or 0) + dt * 2)
    if self.prone == 1 and not self.dead then
      self.dead = 0
      if self.fraction.name ~= 'Undead' then
        self.map:addObject(
          SpiritEffect(self.map, self.pos, SpiritEffect.colors[self.tier]))
      else
        self.map:addObject(
          SpiritEffect(self.map, self.pos, {0.2,0.2,0.2,1}))
      end
    elseif self.dead then
      self.dead = self.dead + dt
    end
  elseif self.idle:isActive() then
    self.idle:update(dt)
  elseif self.move:isActive() then
    local trigger = self.move:update(dt)
    if trigger then
      self.node = self.nextNode
      self.nextNode = nil
      self.map.objective:eventUnitOnNode(self, self.node)
    end
  elseif self.attack and self.attack:isActive() then
    local trigger = self.attack:update(dt)
  else
    local target = self.fraction:getUnitTarget(self)
    if target then
      self:_moveToTile(dt, target[2])
    end
  end
  
  self.ishit = (self.ishit or 0) - dt
end

function Unit:draw()
  local wx, wy = gamemap.getPixelFromTile(self.map, {x=self.pos.x, y=self.pos.y})
  self.circle = {
    wx,
    wy,
    self.radius * self.map.tilewidth
  }
  
  --love.graphics.setColor(self.stuck and 1 or 0,0.5,0.5)
  --love.graphics.circle("line",unpack(self.circle))
  
  if self.ishit > 0 then
    love.graphics.setColor(1, 0.5, 0.5, 1)
  end
  
  if self.prone then
    self.sprite:drawAnimation(wx, wy, 'prone', 4, self.prone)
    self.node = nil
    self.nextNode = nil
  elseif self.attack then
    self.sprite:drawAnimation(wx, wy, self.attack.anim, self.dir, self.attack:getProgress())
  else
    self.movedist = math.min(1, self.move:getProgress())
    self.sprite:drawAnimation(wx, wy, (self.stuck and 'stand') or 'move', self.dir, self.movedist)
  end
  
  --love.graphics.print(tostring(self.id), wx, wy)
  --love.graphics.print(tostring(self.hp), wx, wy-32)
  
  --[[
  --love.graphics.setColor(0,0,0,1)
  if self.path then
    local nodes = self.path:getNodes()
    for i=1,#nodes-1 do
      local x1, y1 = gamemap.getPixelFromTile(self.map, nodes[i].location)
      local x2, y2 = gamemap.getPixelFromTile(self.map, nodes[i+1].location)
      love.graphics.line(x1, y1, x2, y2)
    end
  end
  ]]--
  
end