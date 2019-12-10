require 'game/objective'

levels = {}

levels.desertvillage = {
  objectives={
    ObjectiveReach({40,8}, 3, nil, {'village'}, {nil,3})
  }
}

function levels.getObjectives(levelname)
  if levels[levelname] then
    if levels[levelname].objectives then
      return levels[levelname].objectives
    end
  end
  return {}
end
