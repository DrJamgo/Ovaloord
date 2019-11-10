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

return gamemap

