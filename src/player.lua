local player = {}
function player:load(x,y)
    local o = {}
    setmetatable(o,self)
    self.__index = self
    
    o.w = 50
    o.h = 50
    o.x = x
    o.y = y
    
    return o
end

function player:move(x,y)

end
function player:jump()

end

function player:keypressed(key)
    local control ={
        a = function() self:move(-1,0) end,
        w = function() self:jump() end,
        --s = function() self:move(0,1) end,
        d = function() self:move(1,0) end
    }
    control[key]()
end
function player:update(dt)
end

function player:draw()
    love.graphics.setColor({255,255,255})
    love.graphics.rectangle("fill",self.x,self.y,self.w,self.h)
end
return player
