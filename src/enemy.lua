
local enemy = {}
function enemy:load(x,y)
    local o = {}
    setmetatable(o,self)
    self.__index = self
    
    o.w = 10
    o.h = 10
    o.x = x
    o.y = y
    
    
    return o
end

function enemy:update(dt)
end

function enemy:draw()
    love.graphics.rectangle("fill",self.x,self.y,self.w,self.h)
end
return enemy
