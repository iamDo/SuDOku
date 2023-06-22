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
  self:operateOnAllCells(
    function(cell)
      cell:update(dt)
      self:setCellHovered(cell)
      self:setCellSelected(cell)
    end
  )

  if pressedKeys ~= nil then
    for key, _ in pairs(pressedKeys) do
      if self.selectedCell ~= nil and tonumber(key) then
        self.selectedCell.number = tonumber(key)
      end
    end
  end
  self:validate()
end


function GameGrid:draw()
  GameGrid.super.draw(self)

  -- Drawing in this order to make sure selected and hovered cells
  -- are not covered up by other cells
  self:drawSubLines()
  self:drawCells()
  self:drawHoveredCell()
  self:drawSelectedCell()
end


-- Returns if the entire grid is valid
function GameGrid:validate()
  -- Validate all rows
  for i=1, #self.cells do
    if not self:validateRow(i) then
      return false
    end
  end

  -- Validate all columns
  for i=1, #self.cells[1] do
    if not self:validateColumn(i) then
      return false
    end
  end

  -- Validate all groups
  -- TODO: actually calculate the 3 value
  for i=1, 3 do
    for j=1, 3 do
      if not self:validateGroup(i, j) then
        return false
      end
    end
  end

  return true
end


-- Returns if a row of the grid is valid
function GameGrid:validateRow(index)
  local row = self:getRow(index)
  return self:validateTable(row)
end


-- Returns if a column of the grid is valid
function GameGrid:validateColumn(index)
  local column = self:getColumn(index)
  return self:validateTable(column)
end


-- Returns if a group of the grid is valid
function GameGrid:validateGroup(x, y)
  local group = self:getGroup(x, y)
  return self:validateTable(self:flatten(group))
end


-- Returns if a table is valid
function GameGrid:validateTable(t)
  local seen = {}
  for _, cell in ipairs(t) do
    local number = cell.number
    if number ~= "" then
      if self:isValueInTable(number, seen) then
        return false
      else
        table.insert(seen, number)
      end
    end
  end
  return true
end


-- Returns the (vertical) row at the given index
function GameGrid:getRow(index)
  return self.cells[index]
end


-- Returns if a value is already present in a given table
function GameGrid:isValueInTable(value, t)
  for _, v in ipairs(t) do
    if v == value then return true end
  end
  return false
end


-- Returns the transposed version of a given table
function GameGrid:transpose(t)
  local result = {}
  for i = 1, #t[1] do
    result[i] = {}
    for j = 1, #t do
      result[i][j] = t[j][i]
    end
  end
  return result
end


-- Returns a flattened version of a given table
function GameGrid:flatten(t)
  local result = {}
  for i = 1, #t do
    for j = 1, #t[i] do
      table.insert(result, t[i][j])
    end
  end
  return result
end


-- Returns the (horizontal) column at the given index
function GameGrid:getColumn(index)
  local column = {}
  for i=1, 9 do
    table.insert(column, self.cells[i][index])
  end
  return column
end


-- Returns a 3x3 group of cells at the given coordinates
function GameGrid:getGroup(x, y)
  local x1 = (x - 1)*3 + 1
  local x2 = x1 + 2
  local y1 = (y - 1)*3 + 1
  local y2 = y1 + 2
  return self:getSelection(x1, y1, x2, y2)
end


-- Returns a group of cells between the given coordinates
function GameGrid:getSelection(x1, y1, x2, y2)
  local group = {}

  for i=x1,x2 do
    local groupRow = {}
    for j=y1,y2 do
      table.insert(groupRow, self.cells[i][j])
    end
    table.insert(group, groupRow)
  end
  return group
end


-- Sets the hovered property of the given cell
function GameGrid:setCellHovered(cell)
  local mouseX, mouseY = love.mouse.getPosition()
  if cell:isPointInside(mouseX, mouseY) then
    cell.hovered = true
  else
    cell.hovered = false
  end
end


-- Sets the selected property of the given cell
function GameGrid:setCellSelected(cell)
  if cell.hovered and love.mouse.isDown(1) then
    if self.selectedCell ~= nil then
      self.selectedCell.selected = false
    end
    self.selectedCell = cell
    self.selectedCell.selected = true
  end
end


-- Draws the sublines of the grid
function GameGrid:drawSubLines()
  local subLineX = self.x + self.cellLength*3
  local subLineY = self.y + self.cellLength*3

  love.graphics.setLineWidth(self.subLineWidth)

  -- vertical sublines
  love.graphics.line(subLineX, self.dims.top, subLineX, self.dims.bottom)
  subLineX = subLineX + self.cellLength*3
  love.graphics.line(subLineX, self.dims.top, subLineX, self.dims.bottom)

  -- horizontal subline
  love.graphics.line(self.dims.left, subLineY, self.dims.right, subLineY)
  subLineY = subLineY + self.cellLength*3
  love.graphics.line(self.dims.left, subLineY, self.dims.right, subLineY)
end


-- Performs the given operation on all cells
function GameGrid:operateOnAllCells(operation)
  for i=1,9 do
    for j=1,9 do
      operation(self.cells[i][j])
    end
  end
end


-- Performs the given operation on all cells that satisfy the given condition
function GameGrid:operateOnAllCellsByCondition(condition, operation)
  for i=1,9 do
    for j=1,9 do
      if condition(self.cells[i][j]) then
        operation(self.cells[i][j])
      end
    end
  end
end


-- Draws all cells that satisfy the given condition
function GameGrid:drawCellsByCondition(condition)
  self:operateOnAllCellsByCondition(condition,
    function(cell)
      cell:draw()
    end)
end


-- Draws all cells
function GameGrid:drawCells()
  self:drawCellsByCondition(
    function(cell)
      return true
    end
  )
end


-- Draws the hovered cell
function GameGrid:drawHoveredCell()
  self:drawCellsByCondition(
    function(cell)
      return cell.hovered
    end
  )
end


-- Draws the selected cell
function GameGrid:drawSelectedCell()
  self:drawCellsByCondition(
    function(cell)
      return cell.selected
    end
  )
end
