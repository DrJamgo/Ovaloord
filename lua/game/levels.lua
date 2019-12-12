require 'game/objective'

levels = {}
levels.desertvillage = {
  objectives={
    ObjectiveReach({40,5}, 3, S.bow, {'village'}, {3})
  }
}

levels.village = {
  objectives={
    ObjectiveReach({40,8}, 5, nil, {'rangervillage'}, {3})
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
