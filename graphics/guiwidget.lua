require('graphics/mainviewwidget')
GuiWidget = class('GuiWidget', MainViewWidget)

function GuiWidget:initialize(map, ...)  
  MainViewWidget.initialize(self, map, ...)
  
  self.camera:fit(map)
end