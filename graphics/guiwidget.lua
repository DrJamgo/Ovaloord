require('graphics/mainviewwidget')
GuiWidget = class('GuiWidget', MainViewWidget)

function GuiWidget:initialize(map, ...)  
  MainViewWidget.initialize(self, map, ...)
  
  self.camera:fit(map)
  self.map = map
end

function GuiWidget:mousepressed(gx,gy,button,isTouch)
  local lx,ly = self.transform:inverseTransformPoint(gx, gy)
  tx, ty = self.map:convertPixelToTile(lx, ly)
  tx = math.floor(tx + 1)
  ty = math.floor(ty + 1)
  local layer = self.map.layers['Tile Layer 1']
  print("x/y: "..tx..'/'..ty)
  print(layer.data[ty][tx].id)
end