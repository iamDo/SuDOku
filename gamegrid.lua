GameGrid = Square:extend()

function GameGrid:new(x, y, length)
  GameGrid.super.new(self, x, y, length, 5, {255, 255, 255})
  self.subLineWidth = 3
  self.cells = {}
  self.cellLength = self.length/9

  local cellX = self.x
  local cellY = self.y
  for i=1,9 do
    self.cells[i] = {}
    for j=1,9 do
      local cell = Cell(cellX, cellY, self.cellLength, i, self.color)
      self.cells[i][j] = cell
      cellX = cellX + self.cellLength
    end
    cellX = self.x
    cellY = cellY + self.cellLength
  end
end

function GameGrid:update(dt)
  for i=1,9 do
    for j=1,9 do
      self.cells[i][j]:update(dt)
    end
  end
end

function GameGrid:draw()
  GameGrid.super.draw(self)

  love.graphics.setLineWidth(self.subLineWidth)
  local subLineX = self.x + self.cellLength*3
  love.graphics.line(subLineX, self.dims.top, subLineX, self.dims.bottom)
  subLineX = subLineX + self.cellLength*3
  love.graphics.line(subLineX, self.dims.top, subLineX, self.dims.bottom)
  local subLineY = self.y + self.cellLength*3
  love.graphics.line(self.dims.left, subLineY, self.dims.right, subLineY)
  subLineY = subLineY + self.cellLength*3
  love.graphics.line(self.dims.left, subLineY, self.dims.right, subLineY)

  for i=1,9 do
    for j=1,9 do
      self.cells[i][j]:draw()
    end
  end

  for i=1,9 do
    for j=1,9 do
      if self.cells[i][j].hovered then
        self.cells[i][j]:draw()
      end
    end
  end

end
