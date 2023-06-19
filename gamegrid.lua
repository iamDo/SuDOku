GameGrid = Square:extend()

function GameGrid:new(x, y, length)
  GameGrid.super.new(self, x, y, length, 5, {255, 255, 255})
  self.subLineWidth = 3
  self.cells = {}
  self.cellLength = self.length/9
  self.selectedCell = nil

  local cellX = self.x
  local cellY = self.y
  for i=1,9 do
    self.cells[i] = {}
    for j=1,9 do
      local cell = Cell(cellX, cellY, self.cellLength, "", self.color)
      self.cells[i][j] = cell
      cellX = cellX + self.cellLength
    end
    cellX = self.x
    cellY = cellY + self.cellLength
  end
end

function GameGrid:update(dt)
  mouseX, mouseY = love.mouse.getPosition()
  for i=1,9 do
    for j=1,9 do
      local currentCell = self.cells[i][j]
      currentCell:update(dt)
      if currentCell:isPointInside(mouseX, mouseY) then
        currentCell.hovered = true
      else
        currentCell.hovered = false
      end

      if currentCell.hovered and love.mouse.isDown(1) then
        if self.selectedCell ~= nil then
          self.selectedCell.selected = false
        end
        self.selectedCell = currentCell
        self.selectedCell.selected = true
      end
    end
  end

  for i=1,9 do
    local number = tostring(i)
    if love.keyboard.isDown(number) then
      if self.selectedCell ~= nil then
        self.selectedCell.number = number
      end
    end
  end
end

function GameGrid:draw()
  GameGrid.super.draw(self)

  self:drawSubLines()
  self:drawCells()
  self:drawHoveredCell()

end

function GameGrid:drawSubLines()
  local subLineX = self.x + self.cellLength*3
  local subLineY = self.y + self.cellLength*3
  love.graphics.setLineWidth(self.subLineWidth)
  love.graphics.line(subLineX, self.dims.top, subLineX, self.dims.bottom)
  subLineX = subLineX + self.cellLength*3
  love.graphics.line(subLineX, self.dims.top, subLineX, self.dims.bottom)
  love.graphics.line(self.dims.left, subLineY, self.dims.right, subLineY)
  subLineY = subLineY + self.cellLength*3
  love.graphics.line(self.dims.left, subLineY, self.dims.right, subLineY)
end

function GameGrid:drawCells()
  for i=1,9 do
    for j=1,9 do
      self.cells[i][j]:draw()
    end
  end
end

function GameGrid:drawHoveredCell()
  for i=1,9 do
    for j=1,9 do
      if self.cells[i][j].hovered then
        self.cells[i][j]:draw()
      end
    end
  end
end
