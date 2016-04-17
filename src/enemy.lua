local anim8 = require "lib/anim8"


local enemy = {}
function enemy:load(game,x,y)
    local o = {}
    setmetatable(o,self)
    self.__index = self
    
    o.name = "enemy"
    o.w = 50
    o.h = 50
    o.life = 2
    o.x = x
    o.y = y
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
    self.game.world:remove(self)
    self = nil
end
function enemy:hit(o)
    if o.name == "bullet" then
        self.life = self.life - 1
        if self.life <= 0 then
--            self:die()
        end
    end
end
function enemy:update(dt)
    local dst_x = self.x - self.speed*dt
    local dst_y = self.y
    self.x,self.y = self.game.world:move(self, dst_x,dst_y)
    --self.Walkanimation:update(dt)
end

function enemy:draw()
    --self.Walkanimation:draw(self.enemysheetWalk, self.x,self.y, 0, 1, 1, 0, 0)
    love.graphics.setColor(self.color)
    love.graphics.rectangle("line",self.x,self.y,self.w,self.h)
end
return enemy
