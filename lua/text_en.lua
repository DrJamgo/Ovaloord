T = {}
T.player = {'This is you!'}

T.desertvillage = {'Desert Village', 'Lets see if there are some souls to harvest..'}
T.driedoutoasis = {'A dried out Oasis', 'This was a refuge of life in the sparse desert.'}
T.pyramid = {'Your Pyramid', 'Once it was covered by the water in the oasis, now it is revealed! You are free again!'}

function T.get(name)
  if T[name] then
    return T[name][1],T[name][2]
  end
  return '['..name..']',nil
end