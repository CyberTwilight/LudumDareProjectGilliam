local anim8 = require "lib/anim8"
local cron = require "lib/cron"
local player = {}

local playerFilter = function(item, other)
  if     other.name == "bullet"   then return 'cross'
  elseif other.name == "aim"   then return 'cross'
  elseif other.name == "enemy"   then return 'touch'
  end
  -- else return nil  
end

function player:load(game,x,y,playeraim)
    local o = {}
    setmetatable(o,self)
    self.__index = self
    o.name = "player"
    o.color = {255,255,255}
    o.dir = 1
    o.w = game.W/12
    o.h = game.H/6
    o.sprite_w = 201
    o.sprite_h = 278
    o.scalex = o.w/o.sprite_w
    o.scaley = o.h/o.sprite_h
    o.x = x
    o.y = y-o.h
    o.aim = playeraim
    o.speed = 10
    o.cooldown = 0.5
    o.cooldown_var = false
    o.beats = 1
    o.game = game
    o.keylist = {}
    o.transforms = {require"src/transform_normal",require"src/transform_galinha",require"src/transform_perneta"}
    o.game.world:add(o,o.x,o.y,o.w,o.h)
    o:change(1)
    
    o.playersheetWalk = love.graphics.newImage('assets/playersheet1.png')
    local playeranimeWalk = anim8.newGrid(o.sprite_w,o.sprite_h, playersheetWalk:getWidth(), playersheetWalk:getHeight())
    o.Walkanimation = anim8.newAnimation(playeranimeWalk('1-7','1-4'), 1/28)
    
    return o
end

function player:move(x,y)  
    self.transforms[self.transform].move(self,x,y, playerFilter)
end
function player:shoot()
    --local angle = 0--270 -- calcular o coeficiente angular entre o mouse e o player
    local angle = 0
    
    if self.dir == 1 then
      angle = math.atan2(self.aim.y - (self.y + 50), self.aim.x - (self.x + self.w))
    else
      angle = math.atan2(self.aim.y - (self.y + 50), (self.aim.x-10) - self.x)
    end
    
    --print(self.aim.y, (self.y + 50), angle)
    
    if math.abs(angle) > 1.5708 then
      self.dir = -1
    else
      self.dir = 1
    end
  
    if not self.cooldown_var then
        self.transforms[self.transform].shoot(self, angle)
        self.cooldown_var  = true
        self.cooldown_timer = cron.after(self.cooldown,function() self.cooldown_var = false end)
    end
end

function player:keypressed(key)
   if key ~= nil then addToSet(self.keylist, key) end
end

function player:keyreleased(key)
    if key ~= nil then removeFromSet(self.keylist, key) end
end

function player:mousepressed(x, y, button, istouch)
    if button ~= nil then addToSet(self.keylist, "m"..button) end
end

function player:mousereleased(x, y, button, istouch)
    if button ~= nil then removeFromSet(self.keylist, "m"..button) end
end

function player:update(dt)
  if self.cooldown_timer then
      self.cooldown_timer:update(dt)
  end
  local speed = dt * 10
    local control ={
        a = function() 
            self.dir = -1
            self:move(-speed,0) 
        end,
        w = function() self:move(0,-speed) end,
        s = function() self:move(0,speed) end,
        d = function() 
            self.dir = 1
            self:move(speed,0) 
        end,
        space = function() self:shoot() end,
        m1 = function() self:shoot() end
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
    self.beats = self.beats + 1
    if self.beats == 8 then
        self:change(math.random(1,#self.transforms))
        self.beats = 1
    end
end

function player:draw()
    if self.dir == 1 then
        self.Walkanimation:draw(self.playersheetWalk, self.x,self.y, 0, self.scalex, self.scaley, 0, 0,0,0)
    else
        self.Walkanimation:draw(self.playersheetWalk, self.x+self.w,self.y, 0, self.dir*self.scalex, self.scaley, 0, 0,0,0)
    end
    if __debug then
        love.graphics.setColor(self.color)
        love.graphics.rectangle("line",self.x,self.y,self.w,self.h)
        
        if self.dir == 1 then -- marcacao da arma
        love.graphics.circle("fill",self.x + self.w,self.y + 50, 10)
      else
        love.graphics.circle("fill",self.x,self.y + 50, 10)
        end
    end
    
    --self.transforms[self.transform]:draw()
end
return player
