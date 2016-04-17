local bullet = require "src/bullet"
local anim8 = require "lib/anim8"
    
local player = {}
player.keylist = {}
function player:load(game,x,y)
    local o = {}
    setmetatable(o,self)
    self.__index = self
    o.name = "player"
    o.color = {255,255,255}
    o.w = 201
    o.h = 278
    o.x = x
    o.y = y
    o.speed = 10
    o.game = game
    o.transforms = {require"src/transform_normal",require"src/transform_galinha"}--,require"transform_perneta"}
    o.game.world:add(o,o.x,o.y,o.w,o.h)
    o:change(1)
    
    o.playersheetWalk = love.graphics.newImage('assets/playersheet1.png')
    local playeranimeWalk = anim8.newGrid(201, 278, playersheetWalk:getWidth(), playersheetWalk:getHeight())
    o.Walkanimation = anim8.newAnimation(playeranimeWalk('1-7','1-4'), 1/28)
    
    return o
end

function player:move(x,y)
    self.transforms[self.transform].move(self,x,y)
end
function player:shoot()
    self.transforms[self.transform].shoot(self)
end

function player:keypressed(key)
   addToSet(player.keylist, key)
   
end

function player:keyreleased(key)
    removeFromSet(player.keylist, key)
end

function player:update(dt)
  
  local speed = dt * 10
    local control ={
        a = function() self:move(-speed,0) end,
        w = function() self:move(0,-speed) end,
        s = function() self:move(0,speed) end,
        d = function() self:move(speed,0) end,
        space = function() self:shoot() end
    }
    
    for key,v in pairs(player.keylist) do
      if control[key] then control[key]() end 
    end    
    
    self.Walkanimation:update(dt)
    --self.transforms[self.transform]:update(dt)
end
function player:change(new)
    self.transform = new
    self.transforms[self.transform].load(self)
end
function player:beat()
    self:change(math.random(1,#self.transforms))
end

function player:draw()
    self.Walkanimation:draw(self.playersheetWalk, self.x,self.y, 0, 1, 1, 0, 0)
    love.graphics.setColor(self.color)
    love.graphics.rectangle("line",self.x,self.y,self.w,self.h)
    
    
    --self.transforms[self.transform]:draw()
end
return player
