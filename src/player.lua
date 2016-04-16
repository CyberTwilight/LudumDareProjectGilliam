local bullet = require "src/bullet"
local player = {}
function player:load(game,x,y)
    local o = {}
    setmetatable(o,self)
    self.__index = self
    
    o.w = 50
    o.h = 50
    o.x = x
    o.y = y
    o.speed = 10
    o.game = game
    o.game.world:add(o,o.x,o.y,o.w,o.h)
    return o
end

function player:move(x,y)
    local dst_x = self.x + x*self.speed
    local dst_y = self.y + y*self.speed
    self.x,self.y = self.game.world:move(self, dst_x,dst_y)
end
function player:shoot()
    local angle = 0
    self.game.spawn(bullet:load(self.game,self.x,self.y,angle))
end

function player:keypressed(key)
    local control ={
        a = function() self:move(-1,0) end,
        w = function() self:move(0,-1) end,
        s = function() self:move(0,1) end,
        d = function() self:move(1,0) end,
        space = function() self:shoot() end
    }
    if control[key] then control[key]() end
end
function player:update(dt)
end

function player:draw()
    love.graphics.setColor({255,255,255})
    love.graphics.rectangle("fill",self.x,self.y,self.w,self.h)
end
return player
