local bullet = require "src/bullet"
local anim8 = require "lib/anim8"
local normal = {}

function normal:load()
  
    self.color = {0,0,255}
    self.playersheetWalk = love.graphics.newImage('assests/playersheet1.png')
    local playeranimeWalk = anim8.newGrid(201, 278, self.playersheetWalk:getWidth(), self.playersheetWalkgetHeight())
    Walkanimation = anim8.newAnimation(g('1-28',1), 1/28)
end
function normal:move(x,y)
    local dst_x = self.x + x*self.speed
    local dst_y = self.y + y*self.speed
    self.x,self.y = self.game.world:move(self, dst_x,dst_y)
end
function normal:shoot()
    local angle = 0
    self.game.spawn(bullet:load(self.game,self.x,self.y,angle))
end
return normal
