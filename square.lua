Square = Object:extend()

function Square:new(x, y, length, linewidth, color)
  self.x = x
  self.y = y
  self.length = length
  self.dims = {
    left = self.x,
    top = self.y,
    right = self.x + self.length,
    bottom = self.y + self.length,
  }
  self.linewidth = linewidth
  self.color = color
end

function Square:draw()
  love.graphics.setLineWidth(self.linewidth)
  love.graphics.setColor(self.color)
  love.graphics.rectangle("line", self.dims.left, self.dims.top, self.length, self.length)
end

function Square:isPointInside(x, y)
  return x > self.dims.left and x < self.dims.right
    and y > self.dims.top and y < self.dims.bottom
end
