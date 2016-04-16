local bullet = {}
function bullet:load(game,x,y,angle)
    local o = {}
    setmetatable(o,self)
    self.__index = self
    
    o.w = 10
    o.h = 10
    o.x = x
    o.y = y
    o.angle = angle
    o.speed = 100
    o.color = {math.random(0,100),math.random(0,255),math.random(0,100)}
    o.game = game 
    o.game.world:add(o,o.x,o.y,o.w,o.h)
    return o
end
function bullet:beat()
end
function bullet:update(dt)
    local dst_x = self.x + math.cos(self.angle)*self.speed*dt
    local dst_y = self.y + math.sin(self.angle)*self.speed*dt
    self.x,self.y = self.game.world:move(self, dst_x,dst_y)
end

function bullet:draw()
    love.graphics.setColor(self.color)
    love.graphics.rectangle("fill",self.x,self.y,self.w,self.h)
end
return bullet
