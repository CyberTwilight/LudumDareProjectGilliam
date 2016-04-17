local bullet = require "src/bullet"
local anim8 = require "lib/anim8"
local cron = require "lib/cron"

local enemy = {}

local enemyFilter = function(item, other)
  if other.name == "player"   then return 'touch'
  elseif other.name == "enemy"   then return 'cross'
  elseif other.name == "aim"   then return 'cross'
  end
  -- else return nil  
end

function enemy:load(game,x,y,dir)
    local o = {}
    setmetatable(o,self)
    self.__index = self
    
    o.name = "enemy"
    o.w = game.W/12
    o.h = game.H/6
    o.sprite_w = 256
    o.sprite_h = 256
    o.scalex = o.w/o.sprite_w
    o.scaley = o.h/o.sprite_h
    o.dir = dir
    o.life = 2
    o.hit_var = false
    o.x = x
    o.x = clamp(o.x,0,game.W-o.w)
    o.y = y-o.h
    o.recover = 0.2
    o.cooldown = 0.5
    o.cooldown_var = false
    o.speed = 100
    o.color = {math.random(0,255),math.random(0,100),math.random(0,100)}
    o.game = game 
    o.game.world:add(o,o.x,o.y,o.w,o.h)
    
    o.dst_x = o.x
    o.dst_y = o.y
    
    o.walk = love.graphics.newImage('assets/enemy_walk.png')
    local walkanim = anim8.newGrid(o.sprite_w,o.sprite_h, o.walk:getWidth(), o.walk:getHeight())
    o.walkanim = anim8.newAnimation(walkanim('1-4',1), 0.5)
    o.shoot_img = love.graphics.newImage('assets/enemy_shoot.png')
    --o.action_timer = cron.every(0.01,o.action,o)
    --[[o.enemysheetWalk = love.graphics.newImage('assets/soldado_inimigo_marcha.png')
    local enemyanimeWalk = anim8.newGrid(256, 256, self.enemysheetWalk:getWidth(), self.enemysheetWalk:getHeight())
    o.Walkanimation = anim8.newAnimation(enemyanimeWalk('1-4',1), 0.5).
    ]]--
    
    return o
end
function enemy:beat()
    self:action()
end
function enemy:die()
    if self.game.world:hasItem(self) then
        self.game.world:remove(self)
    end
    self.game.remove(self)
end
function enemy:hit(o)
    if o.name == "bullet_player" then
        if not self.hit_var then
            self.life = self.life - 1
            self.hit_var = true
            self.hit_timer = cron.after(self.recover,function() self.hit_var = false end)
        end
        if self.life <= 0 then
            self:die()
        end
    end
end
local Filter = function(item, other)
  if other.name == "player"   then return 'touch'
  elseif other.name == "enemy"   then return 'cross'
  end
  -- else return nil  
end
function enemy:shoot()
    if self.dir == -1 then
        angle = 0
        self.game.spawn(bullet:load(self.game,self.x+self.w,self.y+self.h/4,angle))
    else
        angle = math.pi
        self.game.spawn(bullet:load(self.game,self.x-10,self.y+self.h/4,angle))

    end
end
function enemy:action()
    if not self.hit_var then
        if not self.cooldown_var then
            local dice = math.random()
            if dice>0.8 then
                    self:shoot()
                    self.cooldown_var  = true
                    self.cooldown_timer = cron.after(self.cooldown,function() self.cooldown_var = false end)
            else
                self.x,self.y = self.game.world:move(self, self.dst_x,self.dst_y,Filter)
            end
        end
    end
end

function enemy:update(dt)
    if self.cooldown_timer then
        self.cooldown_timer:update(dt)
    end
    self.dst_x = self.x - self.dir*self.speed*dt
    self.dst_y = self.y
    if self.hit_timer then
        self.hit_timer:update(dt)
    end
    --self.action_timer:update(dt)
    --self.Walkanimation:update(dt)
    self.walkanim:update(dt)
end

function enemy:draw()
    --self.Walkanimation:draw(self.enemysheetWalk, self.x,self.y, 0, 1, 1, 0, 0)
    if self.hit_var then
        love.graphics.setColor(255,255,255)
    else
        love.graphics.setColor(self.color)
    end

    if self.dir == -1 then
        if not self.cooldown_var then
            self.walkanim:draw(self.walk, self.x,self.y, 0, self.scalex, self.scaley, 0, 0,0,0)
        else
            love.graphics.draw(self.shoot_img, self.x,self.y, 0, self.scalex, self.scaley, 0, 0,0,0)
        end
    elseif self.dir == 1 then
        if not self.cooldown_var then
            self.walkanim:draw(self.walk, self.x+self.w,self.y, 0, -1*self.dir*self.scalex, self.scaley, 0, 0,0,0)
        else
            love.graphics.draw(self.shoot_img, self.x+self.w,self.y, 0, -1*self.dir*self.scalex, self.scaley, 0, 0,0,0)

        end
    end
    if __debug then
        love.graphics.rectangle("line",self.x,self.y,self.w,self.h)
    end
end
return enemy
