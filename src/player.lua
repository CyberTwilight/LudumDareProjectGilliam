local player = {}
function player:load(x,y)
    local o = {}
    setmetatable(o,self)
    self.__index = self
    
    o.w = 10
    o.h = 10
    o.x = x
    o.y = y
    print("hi") 
    
    return o
end

function player:update(dt)
end

function player:draw()
    love.graphics.rectangle("fill",self.x,self.y,self.w,self.h)
end
return player
