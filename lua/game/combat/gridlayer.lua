require 'middleclass'
require 'utils/vec'

GridLayer = class('GridLayer')

local COST = {}
COST.ROAD = 0.7
COST.OTHER = 1
COST.UNIT_MOVING = 2
COST.UNIT_STANDING = 5

debug = {}

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
        if layer.data and layer.data[y][x] then
          if layer.data[y][x].type == 'road' then
            cost = math.min(cost, COST.ROAD)
          elseif layer.properties.movecost then
            cost = math.min(cost, layer.properties.movecost)
          end
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
        elseif unit.nextNode and not self:locationsAreEqual(unit.nextNode, location) then
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
  
  for id,loc in pairs(debug) do
    local color = (id >= self.numtiles and {1,0,0,1}) or ({0,1,0,1})
    local offset = (id >= self.numtiles and 0.5) or 0
    local wx,wy = self.map:convertTileToPixel(loc.x,loc.y+offset)
    love.graphics.setColor(unpack(color))
    love.graphics.print(tostring(id), wx-self.map.tilewidth, wy-self.map.tileheight)
  end
  
  for y=1,map.height do
    for x=1,map.width do
      if not self.static[y][x] then
        love.graphics.setColor(0,0,0,0.5)
        local wx,wy = self.map:convertTileToPixel(x,y)
        love.graphics.rectangle("fill", wx, wy, -self.map.tilewidth, -self.map.tileheight)
      end
      if self.static[y][x] and self.static[y][x].walk == false then
        love.graphics.setColor(1,0,0,0.5)
        local wx,wy = self.map:convertTileToPixel(x,y)
        love.graphics.rectangle("fill", wx, wy, -self.map.tilewidth, -self.map.tileheight)
      elseif self.static[y][x] then
        local cost = self.static[y][x].cost
        love.graphics.setColor(cost/2,0.5,0.5,0.5)
        local wx,wy = self.map:convertTileToPixel(x,y)
        --love.graphics.print(tostring(self.static[y][x].cost), wx-self.map.tilewidth, wy-self.map.tileheight)
      end
      local unit = self.dynamic[y][x]
      if unit then
        love.graphics.setColor(0,0,1,0.5)
        local wx,wy = self.map:convertTileToPixel(x,y)
        local wux, wuy = self.map:convertTileToPixel(unit.pos.x, unit.pos.y)
        love.graphics.rectangle("fill", wx, wy, -self.map.tilewidth, -self.map.tileheight)
        love.graphics.line(wx-16, wy-16, wux - 16, wuy - 16)
        
        if unit.path then
          for i=1,#unit.path.nodes-1 do
            node1 = unit.path.nodes[i]
            node2 = unit.path.nodes[i+1]
            
            local w1x,w1y = 
              self.map:convertTileToPixel(node1.location.x, node1.location.y)
            local w2x,w2y =
              self.map:convertTileToPixel(node2.location.x, node2.location.y)
            
            local color = ((node2.action == 'move') and {0,1,0,0.5}) or {1,0,0,0.5}
            love.graphics.setColor(unpack(color))
            love.graphics.line(w1x-16, w1y-16, w2x - 16, w2y - 16)
          end
        end
      end
    end
  end
  love.graphics.setColor(1,1,1,1)
end


function GridLayer:getNode(location, selfunit, fromnode)
  -- Here you make sure the requested node is valid (i.e. on the map, not blocked)
  local x,y = location.x,location.y
  if y >= 1 and y <= #self.static then
    local static = self.static[y][x]
    if static then
      local cost = static.cost
      local unit = self.dynamic[y][x]
      local id = static.id
      if unit and selfunit ~= unit then
        cost = cost * ((unit.moving and COST.UNIT_MOVING) or COST.UNIT_STANDING)
      end
      local node = Node(static.location, cost, id, fromnode)
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

function GridLayer:getAdjacentNodes(curnode, dest, unit)
  -- Given a node, return a table containing all adjacent nodes
  -- The code here works for a 2d tile-based game but could be modified
  -- for other types of node graphs
  local result = {}
  local melee = {}
  local range = {}
  
  local goal = dest
  if dest.node then
    goal = dest.node.location
  end
  
  if unit then
    if unit.move then
      result = unit.move:getNodes(self, curnode, goal)
    end
    if unit.melee then
      melee = unit.melee:getNodes(self, curnode, dest)
      table.extend(result, melee or {})
    end
    if unit.range then
      range = unit.range:getNodes(self, curnode, dest)
      table.extend(result, range or {})
    end
  end
  
  return result, melee, range
end

function GridLayer:locationsAreEqual(nodeA, locOrTarget)
  if not locOrTarget.id then
    return nodeA.location.x == locOrTarget.x and nodeA.location.y == locOrTarget.y
  else
    return locOrTarget.id + self.numtiles == nodeA.lid
  end
end