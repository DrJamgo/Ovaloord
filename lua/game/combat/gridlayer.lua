require 'middleclass'
require 'utils/vec'

GridLayer = class('GridLayer')

local COST = {}
COST.ROAD = 1
COST.OTHER = 2
COST.UNIT_MOVING = 2
COST.UNIT_STANDING = 5

function GridLayer:initialize(map)
  map:addCustomLayer('grid',nil,self)
  self.draw = GridLayer.draw
  self.update = GridLayer.update
  
  self.map = map
  
  self.static = {}
  self.dynamic = {}
  self.numtiles = map.height * map.width
  for y=1,map.height do
    self.static[y] = {}
    self.dynamic[y] = {}
    for x=1,map.width do
      local walk = true
      local shoot = true
      local cost = COST.OTHER
      for _,layer in ipairs(self.map.layers) do
        if layer.data and layer.data[y][x] then
            walk = walk and layer.properties.nowalk == nil
            shoot = shoot and layer.properties.noshoot == nil
        end
        if layer.data and layer.data[y][x] and layer.data[y][x].type == 'road' then
          cost = COST.ROAD
        end
      end
      if walk or shoot then
        self.static[y][x] = {location = vec2(x,y), cost=cost, id=y*map.width+x, shoot=shoot, walk=walk}
      end
    end
  end
end

function GridLayer:update(dt)
  for y=1,self.map.height do
    for x=1,self.map.width do
      local unit = self.dynamic[y][x]
      if unit then
        local location = vec2(x,y)
        if unit.hp <= 0 then
          self.dynamic[y][x] = nil
        elseif unit.nextNode and not self:locationsAreEqual(unit.nextNode.location, location) then
          local diff = vec2_sub(unit.pos, location)
          local dist = math.max(math.abs(diff.x), math.abs(diff.y))
          if dist > unit.radius * 2 then
            self.dynamic[y][x] = nil
          end
        end
      end
    end
  end
end
  
function GridLayer:draw()
  local map = self.map
  
  for y=1,map.height do
    for x=1,map.width do
      if not self.static[y][x] then
        love.graphics.setColor(0,0,0,0.5)
        local wx,wy = self.map:convertTileToPixel(x,y)
        love.graphics.rectangle("fill", wx, wy, -self.map.tilewidth, -self.map.tileheight)
      end
      if self.static[y][x] and self.static[y][x].walk ==false then
        love.graphics.setColor(1,0,0,0.5)
        local wx,wy = self.map:convertTileToPixel(x,y)
        love.graphics.rectangle("fill", wx, wy, -self.map.tilewidth, -self.map.tileheight)
      end
      local unit = self.dynamic[y][x]
      if unit then
        love.graphics.setColor(0,0,1,0.5)
        local wx,wy = self.map:convertTileToPixel(x,y)
        local wux, wuy = self.map:convertTileToPixel(unit.pos.x, unit.pos.y)
        love.graphics.rectangle("fill", wx, wy, -self.map.tilewidth, -self.map.tileheight)
        love.graphics.line(wx-16, wy-16, wux - 16, wuy - 16)
      end
      if self.cursor and self.cursor[1] == x and self.cursor[2] == y then
        love.graphics.setColor(1,1,1,1.0)
        local wx,wy = self.map:convertTileToPixel(x,y)
        love.graphics.rectangle("line", wx, wy, -self.map.tilewidth, -self.map.tileheight)
        love.graphics.print(x .. ',' .. y, wx, wy)
        
        if unit then
          local text = unit.class.name ..'\n'
          text = text .. string.format("hp %.1f/%.1f\n",unit.hp, unit.class.hp)
          if unit.stuck then
            text = text .. string.format("stuck %.1f\n",unit.stuck)
          end
          if unit.attack then
            text = text .. string.format("%s %.1f/%.1f/%.1f\n",unit.attack.class.name, unit.attack.time, unit.attack.trigger, unit.attack.cooldown)
          end
          if unit.idle and unit.idle:isActive() then
            text = text .. string.format("idle %.1f/%.1f\n", unit.idle.time, unit.idle.cooldown)
          end
          love.graphics.print(text, wx, wy,0,0.8,0.8,32,128)
        end
      end
    end
  end
  love.graphics.setColor(1,1,1,1)
end


function GridLayer:getNode(location)
  -- Here you make sure the requested node is valid (i.e. on the map, not blocked)
  local x,y = location.x,location.y
  if y >= 1 and y <= #self.static then
    local static = self.static[y][x]
    if static then
      local cost = static.cost
      local unit = self.dynamic[y][x]
      if unit then
        cost = cost * ((unit.moving and COST.UNIT_MOVING) or COST.UNIT_STANDING)
      end
      local node = Node(static.location, cost, static.id)
      node.unit = unit
      node.shoot = static.shoot
      node.walk = static.walk
      return node
    end
  end

  return nil
end

function GridLayer:claimNode(node, unit)
  local x,y = node.location.x, node.location.y
  if (not self.dynamic[y][x]) or (self.dynamic[y][x] == unit) then
    self.dynamic[y][x] = unit
    return true
  else
    return false
  end
end

GridLayer.adjecentOffsets = {
  vec2( 1, 0),
  vec2( 0, 1),
  vec2(-1, 0),
  vec2( 0,-1)
}

function GridLayer:getAdjacentNodes(curnode, dest)
  -- Given a node, return a table containing all adjacent nodes
  -- The code here works for a 2d tile-based game but could be modified
  -- for other types of node graphs
  local result = {}
  
  for _,delta in ipairs(self.adjecentOffsets) do
    table.insert(result, 
      self:_handleMoveNodes(vec2_add(curnode.location, delta), curnode, dest))
  end
  return result
end

function GridLayer:locationsAreEqual(a, b)
  return a.x == b.x and a.y == b.y
end

function GridLayer:_handleMoveNodes(loc, fromnode, dest)
  -- Fetch a Node for the given location and set its parameters
  local n = self:getNode(loc)

  if n ~= nil and n.walk then
    local dx = math.max(loc.x, dest.x) - math.min(loc.x, dest.x)
    local dy = math.max(loc.y, dest.y) - math.min(loc.y, dest.y)
    local emCost = dx + dy

    n.mCost = n.mCost + fromnode.mCost
    n.score = n.mCost + emCost
    n.parent = fromnode
    n.action = 'move'

    return n
  end
  
  return nil
end