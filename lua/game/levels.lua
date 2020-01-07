require 'game/objective'

levels = {}
levels.desertvillage = {
  objectives={
    ObjectiveReach({40,5}, 3, nil, {'randomunit'}, {3,2}),
    ObjectiveReach({40,5}, 5, nil, {'cap'}, {3,2}),
    ObjectiveReach({40,5}, 8, nil, {'village'}, {3,2})
  }
}
levels.village = {
  objectives={
    ObjectiveReach({40,11}, 5, nil, {'Pirate'}, {3,4}),
    ObjectiveReach({40,11}, 5, nil, {'rangervillage'}, {3,4}),
    ObjectiveReach({40,11}, 5, nil, {'randomunit'}, {3,4}),
  }
}
levels.rangervillage = {
  objectives={
    ObjectiveReach({40,8}, 10, nil, {'rangervillage'},{}, {4,4})
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
