---@class Rectangle
---@field x number
---@field y number
---@field width number
---@field height number
local Rectangle= {}
Rectangle.__index = Rectangle

---@param x number
---@param y number
---@param width number
---@param height number
Rectangle.new = function(x,y,width,height)
    local self=setmetatable({x=x, y=y, width=width, height=height}, Rectangle)
    return self
end

---@param other Rectangle
function Rectangle:intersects(other)
  return self.x < other.x + other.width
     and self.x + self.width > other.x
     and self.y < other.y + other.height
     and self.y + self.height > other.y
end

---@param other Rectangle
function Rectangle.is_contained_within(other)    
    return self.x >= other.x 
    and self.y >= other.y 
    and self.x + self.width <= other.x + other.width  
    and self.y + self.height <= other.y + other.height
end

return Rectangle