
local enemy = {}
function enemy:load(x,y)
    local o = {}
    setmetatable(o,self)
    self.__index = self
    
    o.w = 50
    o.h = 50
    o.x = x
    o.y = y
    o.speed = 10
    o.color = {math.random(0,255),math.random(0,100),math.random(0,100)}
    
    return o
end
function enemy:beat()
end
function enemy:update(dt)
    self.x = self.x - self.speed*dt
end

function enemy:draw()
    love.graphics.setColor(self.color)
    love.graphics.rectangle("fill",self.x,self.y,self.w,self.h)
end
return enemy
