local bullet = require "src/bullet"
local anim8 = require "lib/anim8"
    
local player = {}
function player:load(game,x,y)
    local o = {}
    setmetatable(o,self)
    self.__index = self
    o.color = {255,255,255}
    o.w = 50
    o.h = 50
    o.x = x
    o.y = y
    o.speed = 10
    o.game = game
    o.transforms = {require"src/transform_normal",require"src/transform_galinha"}--,require"transform_perneta"}
    o.game.world:add(o,o.x,o.y,o.w,o.h)
    o:change(1)
    return o
end

function player:move(x,y)
    self.transforms[self.transform].move(self,x,y)
end
function player:shoot()
    self.transforms[self.transform].shoot(self)
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
function player:change(new)
    self.transform = new
    self.transforms[self.transform].load(self)
end
function player:beat()
    self:change(math.random(1,#self.transforms))
end
function player:draw()
    love.graphics.setColor(self.color)
    love.graphics.rectangle("fill",self.x,self.y,self.w,self.h)
end
return player
