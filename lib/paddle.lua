local Rectangle = require ('lib/rectangle')
local MathUtils = require('lib/mathutils')

local Paddle = {}
Paddle.__index = Paddle

Paddle.new = function(x,y, width,height, colour,speed)
    local self = setmetatable({x=x, y=y, width=width,height=height, 
                    colour=colour, vx=speed,vy=speed}, Paddle)
    return self
end

Paddle.draw = function(self)    
    love.graphics.push("all")    
    love.graphics.setColor({0,0,0})
    love.graphics.rectangle('fill',self.x+2, self.y+1, self.width, self.height)    

    love.graphics.setColor(self.colour)
    love.graphics.rectangle('fill',self.x, self.y, self.width, self.height)    
    love.graphics.pop()

end

--@param direction "north"|"south"|"east"|"west"
Paddle.try_set_direction = function(self,direction,y0, height)

    local sx = math.abs(self.vx)
    local sy = math.abs(self.vy)    

    if direction=="south" then    
        sy = sy --flip the sign to positive        
    elseif direction=="north" then        
        sy = -sy --flip the sign to positive            
    elseif direction=="east" then        
        sx = sx --flip the sign to positive            
    elseif direction=="west" then        
        sx = -sx --flip the sign to positive        
    else
        error("Invalid direction"..tostring(direction))
    end

    local future_y = self.y + sy
    if (future_y <= y0+1) or (future_y + self.height > height-1) then
        return false        
    end
    self.vy = sy --update the speed
    return true
end



Paddle.getSpeed = function(self)
    return self.vx, self.vy
end

Paddle.setPosition = function(self,x,y)
    self.x = x
    self.y = y
end

Paddle.getMetrics = function(self)
    return self.x, self.y, self.width, self.height
end

Paddle.getPosition = function(self)
    return self.x, self.y
end

Paddle.move = function(self)
    --self.x = self.x + self.speed --we can only move up and down
    self.y = self.y + self.vy
end

Paddle.paddle_hit_ball_any_surface = function(self,ball_x, ball_y, ball_radius) --chec    
    -- paddle's right edge is at paddle_x + PADDLE_WIDTH
    local rect_now = Rectangle.new(self.x, self.y, self.width, self.height)
    local ball_rect = Rectangle.new(ball_x, ball_y, ball_radius, ball_radius)
    if rect_now:intersects(ball_rect) then
        return true
    end    
    return false
end

Paddle.ball_hit_for_score = function(self, ball_x, ball_y, ball_radius)
   -- paddle's right edge is at paddle_x + PADDLE_WIDTH
    return  ball_x - ball_radius <= self.x + self.width
        and ball_x - ball_radius >= self.x
        and ball_y >= self.y
        and ball_y <= self.y + self.height        
end

return Paddle