T = {}
T.player = {'This is you!'}

-- worldmap objects and levels
T.yourpyramid = {'Your Pyramid', 'Once it was covered by water, now it is revealed!'}
T.endlessdesert = {'The great desert', 'Nothing but endless sand..'}
T.driedoutoasis = {'A dried out Oasis', 'This was a refuge of life in the sparse desert.'}
T.desertvillage = {'\1Desert Village', 'Lets see if there are some souls to harvest..'}

-- level objects
T.road = {'Road'}

function T.get(name)
  if T[name] then
    return T[name][1],T[name][2]
  end
  return '%'..tostring(name)..'%',nil
end