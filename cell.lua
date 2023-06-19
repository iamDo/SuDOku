Cell = Square:extend()

function Cell:new(x, y, length, number)
  Cell.super.new(self, x, y, length, 1)
  self.number = number
  self.textScale = self.length*0.05
end

function Cell:draw()
  Cell.super.draw(self)
  love.graphics.print(self.number, self.dims.left, self.dims.top, 0, self.textScale)
 end
