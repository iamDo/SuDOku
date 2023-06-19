function love.load()
  Object = require "libs.classic.classic"
  require "square"
  require "gamegrid"
  require "cell"
  gameGrid = GameGrid(10, 10, 300)
  cell = Cell(20, 20, 300/9, "9")
end

function love.update(dt)
end

function love.draw()
  gameGrid:draw()
  cell:draw()
end
