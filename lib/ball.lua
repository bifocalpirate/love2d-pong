local Rectangle = require ('lib/rectangle')
local Paddle = require ('lib/paddle')

local Ball = {}
Ball.__index = Ball

--@param x number
--@param y number
--@param speed number
--@param radius number
--@param color number[]
Ball.new = function(x,y,speed, radius, color)
    local self = setmetatable({x=x,y=y,
                                vx=speed,vy=speed, 
                                radius=radius,
                                color=color or {1,1,1}, --if color not passed in it's nil
                                ball_is_attached_to_paddle=false},Ball)
    return self
end

function Ball:draw()
    love.graphics.push("all")
    
    love.graphics.setColor({0,0,0})
    love.graphics.circle('fill',  self.x+2, self.y+1,  self.radius)    
    
    love.graphics.setColor(self.color)
    love.graphics.circle('fill',  self.x, self.y,  self.radius)    
    love.graphics.pop()
end

function Ball:getSpeed()
    return self.vx, self.vy
end

function Ball:getPosition()
    return self.x, self.y
end

function Ball:setSpeed(vx, vy)
    self.vx = vx
    self.vy = vy
end

function Ball:can_move_x(x0, y0, width, height)    
    local nx = self.x + self.vx
    return nx - self.radius >= x0 and nx + self.radius <=  x0 + width
    
end

function Ball:can_move_y(x0, y0, width, height)
    local ny = self.y + self.vy
    return ny-self.radius >= y0 and ny+self.radius <= height+y0
end

---@param paddle Paddle
function Ball:attach_ball_to_paddle(paddle)
    --take a snapshot of where the ball is now
    local px, py = paddle:getPosition()
    self.paddle = paddle    
    self.attached_to_paddle_x = self.x
    self.paddle_offset_y = self.y-py
    self.ball_is_attached_to_paddle = true
end

---@param paddle Paddle
function Ball:update_y_position_by_paddle(paddle)
    local px, py = paddle:getPosition()
    self.y = py + self.paddle_offset_y
end

function Ball:detach_ball_from_paddle()
    self.ball_is_attached_to_paddle = false
    self.paddle = nil
end
function Ball:is_attached_to_paddle()
    return self.ball_is_attached_to_paddle
end

function Ball:get_attached_paddle()
    return self.paddle
end

function Ball:collides_with_paddle(paddle)
    local px, py, pw, ph = paddle:getMetrics()
    local cx = self.x + self.vx
    local cy = self.y + self.vy
    local nearest_x = math.max(px, math.min(cx, px+pw))
    local nearest_y = math.max(py, math.min(cy, py+ph))
    local dx, dy = cx - nearest_x, cy -nearest_y
    return dx*dx+dy*dy < self.radius*self.radius    
end

function Ball:move()
    self.x = self.x + self.vx
    self.y = self.y + self.vy
end

return Ball