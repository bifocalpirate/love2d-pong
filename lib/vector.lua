local Vector={}
Vector.__index = Vector

Vector.new = function(x,y,vx,vy)
    local self=setmetatable({x=x,y=y,vx=vx,vy=vy},Vector)
    return self
end

Vector.setSpeed = function (self,vx,vy)
    self.vx=vx;
    self.vy=vy;
end

Vector.getSpeed = function(self)
    return self.vx,self.vy
end

Vector.getPosition = function(self)
    return self.x, self.y
end

Vector.setPosition = function(self,x,y)
    self.x = x
    self.y = y
    
end

Vector.move = function(self)
    self.x = self.x + self.vx
    self.y = self.y + self.vy
end

return Vector
