require 'middleclass'

PathHandler = class('PathHandler')

function PathHandler:initialize()
end

function PathHandler:setGrid(grid)
  self.grid = grid
end
