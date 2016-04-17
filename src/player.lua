local bullet = require "src/bullet"
local anim8 = require "lib/anim8"
local cron = require "lib/cron"

local player = {}
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
    o.cooldown = 0.5
    o.cooldown_var = false
    o.game = game
    o.keylist = {}
    o.transforms = {require"src/transform_normal",require"src/transform_galinha",require"src/transform_perneta"}
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
    local angle = 0--270 -- calcular o coeficiente angular entre o mouse e o player
    if not self.cooldown_var then
        self.transforms[self.transform].shoot(self, angle)
        self.cooldown_var  = true
        self.cooldown_timer = cron.after(self.cooldown,function() self.cooldown_var = false end)
    end
end

function player:keypressed(key)
   addToSet(self.keylist, key)   
end

function player:keyreleased(key)
    removeFromSet(self.keylist, key)
end

function player:mousepressed(x, y, button, istouch)
   addToSet(self.keylist, "m"..button)
   
end

function player:mousereleased(x, y, button, istouch)
    removeFromSet(self.keylist, "m"..button)
end

function player:update(dt)
  if self.cooldown_timer then
      self.cooldown_timer:update(dt)
  end
  local speed = dt * 10
    local control ={
        a = function() self:move(-speed,0) end,
        w = function() self:move(0,-speed) end,
        s = function() self:move(0,speed) end,
        d = function() self:move(speed,0) end,
        space = function() self:shoot() end,
        m1 = function() self:shoot()end
    }
    
    for key,v in pairs(self.keylist) do
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
