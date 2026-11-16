if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
    require("lldebugger").start()    
end

local love_errorhandler= love.errorhandler

local Paddle = require('lib/paddle')
local Ball = require('lib/ball')
local MathUtils = require('lib/mathutils')

local WIDTH=800
local HEIGHT=600
local x0=1
local y0=1

local BALL_RADIUS = 25
local PADDLE_WIDTH = 20
local PADDLE_HEIGHT = 100
local score = 0

local ball_colour = {1,0.5,0.4}
local ball = Ball.new(115,205,3, BALL_RADIUS, ball_colour)

local paddle_color = {0.3,0.4,1}

local paddle = Paddle.new(WIDTH-3*PADDLE_WIDTH,50,PADDLE_WIDTH,PADDLE_HEIGHT,paddle_color, 3)
local auto_paddle = Paddle.new(15,50,PADDLE_WIDTH,PADDLE_HEIGHT,paddle_color, 3)

local background = nil;

function love.errorhandler(msg)
    if lldebugger then
        error(msg,2)
    else
        return love_errorhandler
    end
end


local function drawBoard()
    local l = love.graphics.getLineWidth()
    love.graphics.setLineWidth(5)    
    love.graphics.setColor(0.4,0.8,0,60)
    love.graphics.rectangle('line',x0,y0,WIDTH-1,HEIGHT-1)
    love.graphics.setLineWidth(l)    
end

local function drawBalls()    
    ball:draw()
end

local function drawScore()
    love.graphics.setColor(1,1,1) 
    love.graphics.print("Score: "..score, 10, 10)
end

local function drawPaddles()    
    paddle:draw()
    auto_paddle:draw()
end

function love.load()
    background = love.graphics.newImage('images/background.png')    
end

function love.update(dt)
    if (love.keyboard.isDown('q')) then
        love.exit()
    end        

    if (love.keyboard.isDown('a')) then
        if auto_paddle:try_set_direction('north',y0,HEIGHT) then
            auto_paddle:move()
        end       
    end

    if (love.keyboard.isDown('z')) then
    if auto_paddle:try_set_direction('south',y0,HEIGHT) then
            auto_paddle:move()
        end
    end

    if love.keyboard.isDown('space') then
        if (ball:is_attached_to_paddle()) then
            ball:detach_ball_from_paddle()
        end
    end

    if love.keyboard.isDown('up') then        
        if paddle:try_set_direction('north',y0,HEIGHT) then            
            paddle:move()
        end
    end

    if love.keyboard.isDown('down') then        
        if paddle:try_set_direction('south',y0,HEIGHT) then            
            paddle:move()
        end
    end            
    
    local bvx, bvy = ball:getSpeed()
    
    --board edges check
    if not ball:can_move_x(x0, y0, WIDTH, HEIGHT) then        
        bvx = -bvx    
    end    
    --board edges check
    if not ball:can_move_y(x0, y0, WIDTH, HEIGHT) then
        bvy = -bvy
    end

    --if ball is moving down and collides with paddle reverse direction
    if not MathUtils.sign_is_positive(bvy) and 
        (ball:collides_with_paddle(paddle) or
        ball:collides_with_paddle(auto_paddle)) then
        bvx = -bvx
    end
    -- if balls moving up and collides with paddle reverse direction
    if MathUtils.sign_is_positive(-bvy) and 
        (ball:collides_with_paddle(paddle) or
        ball:collides_with_paddle(auto_paddle)) then
        bvx = -bvx
    end

    -- if balls moving left and collides with paddle reverse direction
    if not MathUtils.sign_is_positive(bvx) and 
        (ball:collides_with_paddle(paddle) or
        ball:collides_with_paddle(auto_paddle)) then
        bvy = -bvy
    end
    -- if balls moving right and collides with paddle reverse direction
    if MathUtils.sign_is_positive(bvx) and 
        (ball:collides_with_paddle(paddle) or
        ball:collides_with_paddle(auto_paddle)) then
        bvy = bvy
    end

    if ball:collides_with_paddle(auto_paddle) then
        score = score+1
    end    
    
    ball:setSpeed(bvx,bvy)

    if (not ball:is_attached_to_paddle()) then
        ball:move()               
    else
        ball:update_y_position_by_paddle(ball:get_attached_paddle())
    end        
        
end

function love.draw()    
    love.graphics.clear()        
    local sw, sh = love.graphics.getDimensions()
    local iw, ih = background:getDimensions()
    love.graphics.draw(background,0,0,0,sw/iw,sh/ih)
    drawBoard()
    drawPaddles()
    drawBalls()            
    drawScore()    
end