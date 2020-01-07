local T = {}
T.player = {'This is you!'}
T.Master = {''}

-- Menu
T.Research = {'Research [R]'}
T.Settings = {'Settings [S]'}
T.Quit     = {'Quit Battle [Q]'}

-- Global strings
T.currentlevel = {'Current Level'}
T.ObjectiveReach = {S.move..'Reach end of map with %s (%d/%d)'}
T.ObjectiveKill = {S.skull..'Kill %s (%d/%d)'}
T.Objective = {S.info..'No objective.\nYou can hunt for souls and leave whenever you want with [Q].'}
T.ObjectiveLeave = {'Quit the Map with [Q] whenever you want.'}
T.reward = {'Reward'}
T.anyunit = {'any Unit'}
T.randomunit = {'random Unit'}
T.cap = {'Unit Capacity'}

-- worldmap objects and levels
T.yourpyramid = {'Your Pyramid', 'Once it was covered by water, now it is revealed!'}
T.endlessdesert = {'The great desert', 'Nothing but endless sand..'}
T.driedoutoasis = {'Dried out Oasis', 'This was a refuge of life in the sparse desert.'}

T.desertvillage = {'Desert Village', 'Lets see if we can harvest these \1 weak souls..'}
T.village = {'Village', 'Quiet and unknowing..'}
T.rangervillage = {'Ranger Village'}

-- level objects
T.road = {'Road'}

-- Unit stats

-- Unit descriptions
-- Undead
T.Rosen = {'Rosen', 'He rose to serve.'}
T.Warden = {'Warden', 'Protects ancient kings.'}
T.Revenant = {'Revenant'}

T.Zombie = {'Zombie', 'Dead  flesh knows no pain.'}
T.Cadaver = {'Cadaver'}
T.Rotter = {'Rotter'}

T.Canibal = {'Canibal', 'Tough, strong, slow..'}
T.Hitter = {'Hitter', 'Shoots from distance'}
T.Revenant = {'Revenant', 'Comes to get you..'}

-- Human
T.Peasant = {'Peasant', 'Not very good in defeindg himself..'}
T.Militia = {'Militia', 'This one found a knife somewhere.'}
T.Ranger = {'Ranger', 'Defends the woods.'}



return T