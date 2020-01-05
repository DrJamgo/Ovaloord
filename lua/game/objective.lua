require 'middleclass'
Objective = class('Objective')

Objective.amount = 1
Objective.textscale = T.defaultscale
Objective.animationtime = 1.5
Objective.factorInc = 0.05
Objective.factorComplete = 0.2

function Objective:initialize()
  self.time = 0
  self.progress = 0
  self.animincrement = -0.5
  
  local text = T.get('reward')..': '
  for _,levelname in ipairs(self.unlocks or {}) do
    text = text..S.unlock..T.get(levelname)..' '
  end
  for tier,amount in pairs(self.souls or {}) do
    text = text..S.tier[tier]..tostring(amount)..' '
  end
  self.rewardtext = text
end

function Objective:draw()
  local f = math.max(0,math.min(1,self.animincrement))
  if self.closed then
    f = 1
  end
  local color = {f,1,f,1}
  love.graphics.printf({color, self:getText()}, 0, 0, love.graphics.getWidth()/self.textscale, 'left', 0, self.textscale)
end

function Objective:getText()
  local text = T.get(self.class.name)
  text = string.format(text, self.unittype or T.get('anyunit'), self.progress, self.amount)..'\n  '..self.rewardtext
  if self:isFinished() then
    text = text..'\n'..T.ObjectiveLeave[1]
  end
  return text
end

function Objective:isFinished()
  return self.progress >= self.amount
end

function Objective:update(dt, game)
  if love.keyboard.isDown('w') and options.cheats then
    self.progress = self.amount
  end
  self.time = self.time + dt
  if self:isFinished() then
    if not self.animcomplete then
      self.animcomplete = 0
    else
      self.animcomplete = self.animcomplete + dt
      self.textscale = self.class.textscale * (1 + self.factorComplete * math.sin(math.min(math.pi, self.animcomplete * 5)))
      if self.animcomplete > self.animationtime and not self.closed then
        self.closed = true
      end
    end
  else
    self.textscale = self.class.textscale * (1 + self.factorInc * math.sin(math.min(math.pi, self.animincrement * 10)))
    self.animincrement = self.animincrement + dt
  end
end

function Objective:giveReward(game)
  game:reward(self.unlocks or {}, self.souls or {})
end

function Objective:_addProgress(amount)
  self.progress = math.min(self.progress+amount,self.amount)
  self.animincrement = 0
end

function Objective:eventUnitOnNode(unit, node)
end
function Objective:eventUnitDies(unit)
end

ObjectiveReach = class('ObjectiveReach', Objective)
function ObjectiveReach:initialize(tile, amount, unittype, unlocks, souls)
  self.tile = {x=tile[1],y=tile[2]}
  self.amount = amount
  self.unittype = unittype
  self.unlocks = unlocks
  self.souls = souls
  Objective.initialize(self)
end

function ObjectiveReach:eventUnitOnNode(unit, node)
  if unit.fraction.name == 'Undead' then
    if node.location.x == self.tile.x and node.location.y == self.tile.y then
      if not self.unittype or unit.class.name == self.unittype  or unit.icon == self.unittype then
        self:_addProgress(1)
      end
      --local souls = {}
      --souls[unit.tier] = 1
      --self.game:reward({},souls)
      unit:hit(1000)
    end
  end
end

ObjectiveKill = class('ObjectiveKill', Objective)
function ObjectiveKill:initialize(amount, unittype, unlocks, souls)
  self.amount = amount
  self.unittype = unittype
  self.unlocks = unlocks
  self.souls = souls
  Objective.initialize(self)
end

function ObjectiveKill:eventUnitDies(unit)
  if unit.fraction.name ~= 'Undead' then
    if not self.unittype or unit.class.name == self.unittype then
      self:_addProgress(1)
    end
  end
end
