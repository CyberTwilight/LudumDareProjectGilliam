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
    o.dir = dir
    o.life = 2
    o.hit_var = false
    o.x = x
    o.y = y-o.h
    o.recover = 0.2
    o.speed = 100
    o.color = {math.random(0,255),math.random(0,100),math.random(0,100)}
    o.game = game 
    o.game.world:add(o,o.x,o.y,o.w,o.h)
    --o.action_timer = cron.every(0.01,o.action,o)
    --[[o.enemysheetWalk = love.graphics.newImage('assets/soldado_inimigo_marcha.png')
    local enemyanimeWalk = anim8.newGrid(256, 256, self.enemysheetWalk:getWidth(), self.enemysheetWalk:getHeight())
    o.Walkanimation = anim8.newAnimation(enemyanimeWalk('1-4',1), 0.5)
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
        self.game.spawn(bullet:load(self.game,self.x+self.w,self.y,angle))
    else
        angle = math.pi
        self.game.spawn(bullet:load(self.game,self.x-10,self.y,angle))

    end
end
function enemy:action()
    if not self.hit_var then
        local dice = math.random()
        if dice>0.8 then
            --nothing
        elseif dice>0.6 then
            self:shoot()
        else
            self.x,self.y = self.game.world:move(self, self.dst_x,self.dst_y,Filter)
        end
    end
end

function enemy:update(dt)
    self.dst_x = self.x - self.dir*self.speed*dt
    self.dst_y = self.y
    if self.hit_timer then
        self.hit_timer:update(dt)
    end
    --self.action_timer:update(dt)
    --self.Walkanimation:update(dt)
end

function enemy:draw()
    --self.Walkanimation:draw(self.enemysheetWalk, self.x,self.y, 0, 1, 1, 0, 0)
    if self.hit_var then
        love.graphics.setColor(255,255,255)
    else
        love.graphics.setColor(self.color)
    end
    love.graphics.rectangle("line",self.x,self.y,self.w,self.h)
end
return enemy
