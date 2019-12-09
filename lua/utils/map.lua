gamemap = {}

function gamemap.getObjectByName(map, name)
  for l,layer in ipairs(map.layers) do
    for _,object in ipairs(layer.objects or {}) do
      if object.name == name then
        return object
      end
    end
  end
  return nil
end

function gamemap.getTileFromObject(map, object)
  local x,y = map:convertPixelToTile(object.x, object.y)
  return {x=math.floor(x)+1, y=math.floor(y)+1}
end

function gamemap.getPixelFromTile(map, tile)
  local wx,wy = map:convertTileToPixel(tile.x-0.5, tile.y-0.5)
  return wx, wy
end

function gamemap.getTilesInLayer(layer, callback)
  for y,col in ipairs(layer.data) do
    for x,tile in pairs(col) do
      callback(tile, {x=x, y=y})
    end
  end
end

return gamemap

