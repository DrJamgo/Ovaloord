-- Class to handle gamestate.
-- Keeps track of Map obstacles and Unit positions

require 'middleclass'
Grid = class('Grid')

function Grid:initialize(map)
  self.map = map
  self.static = {}
  for y=1,map.height do
    self.static[y] = {}
    for x=1,map.width do
      local walk = true
      local cost = 2
      for _,layer in ipairs(self.map.layers) do
        if layer.properties.nowalk then
          if layer.data[y][x] then
            walk = false
          end
        end
        if layer.data and layer.data[y][x] and layer.data[y][x].type == 'road' then
          cost = 1
        end
      end
      if walk then
        self.static[y][x] = {location = {x=x, y=y}, cost=cost, id=y*map.width+x}
      end
    end
  end
end

function Grid:update()
  
end

function Grid:getNode(location)
  -- Here you make sure the requested node is valid (i.e. on the map, not blocked)
  local static = self.static[location.y][location.x]
  if static then
    return Node(static.location, static.cost, static.id)
  end

  return nil
end


function Grid:getAdjacentNodes(curnode, dest)
  -- Given a node, return a table containing all adjacent nodes
  -- The code here works for a 2d tile-based game but could be modified
  -- for other types of node graphs
  local result = {}
  local cl = curnode.location
  local dl = dest
  
  local n = false
  
  n = self:_handleNode(cl.x + 1, cl.y, curnode, dl.x, dl.y)
  if n then
    table.insert(result, n)
  end

  n = self:_handleNode(cl.x - 1, cl.y, curnode, dl.x, dl.y)
  if n then
    table.insert(result, n)
  end

  n = self:_handleNode(cl.x, cl.y + 1, curnode, dl.x, dl.y)
  if n then
    table.insert(result, n)
  end

  n = self:_handleNode(cl.x, cl.y - 1, curnode, dl.x, dl.y)
  if n then
    table.insert(result, n)
  end
  
  return result
end

function Grid:locationsAreEqual(a, b)
  return a.x == b.x and a.y == b.y
end

function Grid:_handleNode(x, y, fromnode, destx, desty)
  -- Fetch a Node for the given location and set its parameters
  local loc = {
    x = x,
    y = y
  }
  
  local n = self:getNode(loc)
  
  if n ~= nil then
    local dx = math.max(x, destx) - math.min(x, destx)
    local dy = math.max(y, desty) - math.min(y, desty)
    local emCost = dx + dy
    
    n.mCost = n.mCost + fromnode.mCost
    n.score = n.mCost + emCost
    n.parent = fromnode
    
    return n
  end
  
  return nil
end