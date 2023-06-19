function love.load()
  Object = require "libs.classic.classic"
  inspect = require "libs.inspect.inspect"
  require "square"
  require "gamegrid"
  require "cell"

  local font = love.graphics.newFont("fonts/font.otf", 300)
  love.graphics.setFont(font)

  gameGrid = GameGrid(10, 10, 300)
end

function love.update(dt)
  gameGrid:update(dt)
end

function love.draw()
  gameGrid:draw()
end
