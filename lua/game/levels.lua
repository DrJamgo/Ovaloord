require 'game/objective'

levels = {}
levels.desertvillage = {
  objectives={
    ObjectiveReach({40,5}, 3, nil, {'village'}, {3,2})
  }
}

levels.village = {
  objectives={
    ObjectiveReach({40,13}, 5, nil, {'rangervillage'}, {3,4})
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
