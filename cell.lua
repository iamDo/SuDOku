Cell = Square:extend()

function Cell:new(x, y, length, number, color)
  Cell.super.new(self, x, y, length, 1, color)
  self.number = number
  self.hovered = false
  self.textScale = 0.004*length -- magic number for scale chosen by visual testing
  self.textOffset = -length
end

function Cell:draw()
  Cell.super.draw(self)
  love.graphics.print(self.number, self.dims.left, self.dims.top, 0, self.textScale, self.textScale, self.textOffset)
 end
