local bullet = require "src/bullet_player"
local anim8 = require "lib/anim8"
local normal = {}

function normal:load()
  
    self.color = {0,0,255}
    playersheetWalk = love.graphics.newImage('assets/playersheet1.png')
    local playeranimeWalk = anim8.newGrid(201, 278, playersheetWalk:getWidth(), playersheetWalk:getHeight())
    Walkanimation = anim8.newAnimation(playeranimeWalk('1-7','1-4'), 1/28)
  
end

function normal:update(dt)
  
  --Walkanimation:update(dt)
  
  
end
function normal:move(x,y,filter)
    local dst_x = self.x + x*self.speed
    local dst_y = self.y + y*self.speed
    dst_y = clamp(dst_y,self.game.roof-self.h,self.game.floor-self.h)
    self.x,self.y = self.game.world:move(self, dst_x,dst_y,filter)
end
function normal:shoot(angle)
    if self.dir == 1 then
        self.game.spawn(bullet:load(self.game,self.x+self.w,self.y,angle))
    else
        self.game.spawn(bullet:load(self.game,self.x-10,self.y,angle))

    end
end

function normal:draw()
  Walkanimation:draw(playersheetWalk, self.x,self.y, 0, 1, 1, 0, 0)
  
end
return normal
