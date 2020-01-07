require 'utils/camera'
require 'utils/map'
require 'utils/table'
require 'game/unit/fraction'
require 'game/combat/combat'
require 'game/combat/controlwidget'
require 'game/world'
require 'middleclass'
require 'page'
require 'intro'

local STI = require "sti/sti"
Game = class('Game')

function newGameState()
  local state = {}
  state.levels = {yourpyramid=0, desertvillage=0}
  state.currentlevel = 'yourpyramid'
  state.souls = {3}
  state.research = {'Rosen'}
  state.active = {'Rosen', 'Rosen'}
  state.selectioncap = 2
  return state
end

function Game:loadGame()
  local filepath = 'save.lua'
  if love.filesystem.getInfo(filepath) then
    self.state = table.load(filepath)
  else
    self.state = newGameState()
    --table.save(self.state, filepath)
  end
end

function Game:initialize()
  self:loadGame()
  self.scale = 2
  
  PageManager.set('intropage', Intro())
  PageManager.set('worldpage', WorldPage(self))
  PageManager.set('combatpage', CombatPage(self))
  
  PageManager.switch('intropage')
  
  return self
end

local id = 1
function addObject(map, object)
  local objects = map.layers.Units.objects
  objects[id] = object
  object.id = id
  id = id + 1
end

function removeObject(map, object)
  local objects = map.layers.Units.objects
  objects[object.id] = nil
end

function Game:setMusic(file)
  if self.music then
    self.music:stop()
    self.music:release()
    self.music = nil
  end
  if file then
    self.music = love.audio.newSource('assets/music/'..file, 'stream')
    self.music:setVolume(0.2)
    self.music:setLooping(true)
    self.music:play()
  end
end

function Game:enterCombat()
  PageManager.switch('combatpage')
end

function Game:addSpirit(tier, amount)
  self.state.souls[tier]=(self.state.souls[tier] or 0) + (amount or 1)
  self.animation = 0
end

function Game:reward(unlocks, souls)
  for _,unlock in ipairs(unlocks) do
    if levels[unlock] then
      self.state.levels[unlock] = self.state.levels[unlock] or 0
    elseif unlock == 'cap' then
      self.state.selectioncap = math.min(self.state.selectioncap + 1, 8)
    elseif unlock == 'randomunit' then
      PageManager.pages.worldpage.control.research:unlockRandomUnit()
    else
      PageManager.pages.worldpage.control.research:unlockUnit(unlock)
    end
  end
  
  for tier,amount in pairs(souls) do
    self:addSpirit(tier, amount)
  end
  local levelname = self.state.currentlevel
  self.state.levels[self.state.currentlevel] = self.state.levels[self.state.currentlevel] + 1
  self.animation = 0
end

function Game:exitCombat()
  PageManager.switch('worldpage')
end

function Game:update(dt)
  dt = math.min(dt, 0.25)
  if love.keyboard.isDown('y') then dt = dt * 0.1 end
  if options['p'] then dt = 0 end
  
  --if self.state.currentlevel == 'rangervillage' then
  --  PageManager.switch(DemoFinishedPage())
  --end
  
  for _=1,(love.keyboard.isDown('x') and 10) or 1 do
    PageManager.update(dt)
  end
end

function Game:draw()
  PageManager.draw()
end

function Game:forwardMouseEvent(...)
  PageManager.forwardMouseEvent(...)
end
