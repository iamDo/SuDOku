Cell = Square:extend()

function Cell:new(x, y, length, number, color)
  Cell.super.new(self, x, y, length, 1, color)
  self.baseColor = color
  self.number = number
  self.hovered = false
  self.selected = false
  self.textScale = 0.004*length -- magic number for scale chosen by visual testing
  self.textOffset = -length
end

function Cell:draw()
  Cell.super.draw(self)
  if self.selected then
    self.color = {0, 255, 0}
  elseif self.hovered then
    self.color = {255, 0, 0}
  else
    self.color = self.baseColor
  end
  love.graphics.print(self.number, self.dims.left, self.dims.top, 0, self.textScale, self.textScale, self.textOffset)
 end

function Cell:update(dt)
  self.hovered = false
end
