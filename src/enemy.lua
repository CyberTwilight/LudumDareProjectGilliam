local anim8 = require "lib/anim8"
local cron = require "lib/cron"

local enemy = {}
function enemy:load(game,x,y,dir)
    local o = {}
    setmetatable(o,self)
    self.__index = self
    
    o.name = "enemy"
    o.w = 50
    o.h = 50
    o.dir = dir
    o.life = 2
    o.hit_var = false
    o.x = x
    o.y = y
    o.recover = 0.2
    o.speed = 10
    o.color = {math.random(0,255),math.random(0,100),math.random(0,100)}
    o.game = game 
    o.game.world:add(o,o.x,o.y,o.w,o.h)
    
    --[[o.enemysheetWalk = love.graphics.newImage('assets/soldado_inimigo_marcha.png')
    local enemyanimeWalk = anim8.newGrid(256, 256, self.enemysheetWalk:getWidth(), self.enemysheetWalk:getHeight())
    o.Walkanimation = anim8.newAnimation(enemyanimeWalk('1-4',1), 0.5)
    ]]--
    
    return o
end
function enemy:beat()
end
function enemy:die()
    if self.game.world:hasItem(self) then
        self.game.world:remove(self)
    end
    self.game.remove(self)
end
function enemy:hit(o)
    if o.name == "bullet" then
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
function enemy:update(dt)
    if self.hit_timer then
        self.hit_timer:update(dt)
    end
    local dst_x = self.x - self.dir*self.speed*dt
    local dst_y = self.y
    self.x,self.y = self.game.world:move(self, dst_x,dst_y)
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
