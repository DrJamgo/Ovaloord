require 'middleclass'
PageManager = class('PageManager')
PageManager.active = nil
PageManager.pages = {}

function PageManager.switch(newPage)
  
  if type(newPage) == 'string' then
    newPage = PageManager.pages[newPage]
  end
  
  if newPage and PageManager.active ~= newPage then
    if PageManager.active then
      PageManager.active:leave()
    end
    PageManager.active = newPage
    PageManager.active:enter()
  end
end

function PageManager.set(name, page)
  PageManager.pages[name] = page
end

function PageManager.draw(...)
  if PageManager.active and PageManager.active.draw then
    PageManager.active:draw(...)
  end
end

function PageManager.update(...)
  if PageManager.active and PageManager.active.update then
    PageManager.active:update(...)
  end
end

function PageManager.forwardMouseEvent(...)
  if PageManager.active then
    PageManager.active.forwardMouseEvent(PageManager.active, ...)
  end
end

Page = class('Page')
function Page:initialize(game)
  self.game = game
end

function Page:enter()
  -- do nothing
end

function Page:leave()
  -- do nothing
end

function Page:update(dt)
  if self.widgets then
    for _,widget in ipairs(self.widgets) do
      widget:update(dt)
    end
  end
  return false
end

function Page:draw()
  love.graphics.setColor(1,1,1,1)
  love.graphics.setCanvas()
  love.graphics.replaceTransform(love.math.newTransform())
  
  if self.widgets then
    for _,widget in ipairs(self.widgets) do
      widget:draw()
    end
  end
end

function Page:forwardMouseEvent(f, x, y, ...)
  if self.widgets then
    for i=1,#self.widgets do
      -- iterate in reverse order to process last dawn widgets first
      local widget = self.widgets[#self.widgets + 1 - i]
      if widget:test(x,y) and widget[f] then
        if widget[f](widget, x,y,...) then
          return
        end
      end
    end
  end
end

---------- WorldPage ----------
WorldPage = class('WorldPage', Page)

function WorldPage:initialize(game)
  Page.initialize(self, game)
  
  self.control = ControlWidget(game, game.scale)
  self.world = World(game)
  self.hud = HudWidget(game.state)
  self.widgets = {self.world, self.control, self.hud}
end

function WorldPage:enter()
  self.game:setMusic('Jungle2.wav')
end

---------- CombatPage ----------
CombatPage = class('CombatPage', Page)

function CombatPage:initialize(game)
  Page.initialize(self, game)
  
  self.control = PageManager.pages['worldpage'].control
  self.hud = PageManager.pages['worldpage'].hud
end

function CombatPage:enter()
  local levelname = self.game.state.currentlevel
  local objectives = levels.getObjectives(levelname)
  local objective = objectives[self.game.state.levels[levelname]+1] or Objective()
  

  self.combat = Combat(self.game, objective)
  self.combat.unitslayer.controlwidget = self.control
  self.control:setFraction(self.combat.fractions['Undead'])
  self.objective = ObjectiveWidget(objective)
  self.widgets = {self.combat, self.control, self.hud, self.objective}
  
  self.game:setMusic(self.combat.map.properties.music)
end

function CombatPage:leave()
  self.control:setFraction(nil)
  options['r'] = true
end
