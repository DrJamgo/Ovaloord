require 'middleclass'

PathHandler = class('Path')

function PathHandler:initialize()
end

function PathHandler:setMap(map)
  self.map = map
end

function PathHandler:getNode(location)
  -- Here you make sure the requested node is valid (i.e. on the map, not blocked)
  if location.x > self.map.width or location.y > self.map.height then
    -- print 'location is outside of map on right or bottom'
    return nil
  end

  if location.x < 1 or location.y < 1 then
    -- print 'location is outside of map on left or top'
    return nil
  end

  for _,layer in ipairs(self.map.layers) do
    if layer.properties.nowalk then
      if layer.data[location.y][location.x] then
        return nil
      end
    end
  end
  
  local cost = 2
  if self.map.layers.Roads.data[location.y][location.x] then
    cost = 1
  end

  if self.map.layers.Units.data[location.y][location.x] then
    return nil
  end

  return Node(location, cost, location.x + location.y * self.map.width)
end


function PathHandler:getAdjacentNodes(curnode, dest)
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

function PathHandler:locationsAreEqual(a, b)
  return a.x == b.x and a.y == b.y
end

function PathHandler:_handleNode(x, y, fromnode, destx, desty)
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