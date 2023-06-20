function love.load()
  Object = require "libs.classic.classic"
  inspect = require "libs.inspect.inspect"
  require "square"
  require "gamegrid"
  require "cell"

  local gridWidth = 300
  local font = love.graphics.newFont("fonts/font.otf", gridWidth) -- for some reason this is a good scale

  love.graphics.setFont(font)
  gameGrid = GameGrid(10, 10, gridWidth)
  pressedKeys = {}
end

function keyPadToNumber(key)
  if string.match(key, "kp%d") then
    key = string.gsub(key, "kp", "")
  end
  return key
end

function love.keypressed(key)
  pressedKeys[keyPadToNumber(key)] = true
end

function love.keyreleased(key)
  pressedKeys[keyPadToNumber(key)] = nil
end

function love.update(dt)
  gameGrid:update(dt)
end

function love.draw()
  gameGrid:draw()
end
