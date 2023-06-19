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
  self:operateOnAllCellsByCondition(
    function(cell)
      return true
    end,
    function(cell)
      cell:update(dt)
      if cell:isPointInside(mouseX, mouseY) then
        cell.hovered = true
      else
        cell.hovered = false
      end
      if cell.hovered and love.mouse.isDown(1) then
        if self.selectedCell ~= nil then
          self.selectedCell.selected = false
        end
        self.selectedCell = cell
        self.selectedCell.selected = true
      end
    end
  )

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
  self:drawSelectedCell()

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

function GameGrid:operateOnAllCellsByCondition(condition, operation)
  for i=1,9 do
    for j=1,9 do
      if condition(self.cells[i][j]) then
        operation(self.cells[i][j])
      end
    end
  end
end

function GameGrid:drawCellsByCondition(condition)
  self:operateOnAllCellsByCondition(condition,
    function(cell)
      cell:draw()
    end)
end

function GameGrid:drawCells()
  self:drawCellsByCondition(
    function(cell)
      return true
    end
  )
end

function GameGrid:drawHoveredCell()
  self:drawCellsByCondition(
    function(cell)
      return cell.hovered
    end
  )
end

function GameGrid:drawSelectedCell()
  self:drawCellsByCondition(
    function(cell)
      return cell.selected
    end
  )
end
