local bullet = require "src/bullet_player"
local anim8 = require "lib/anim8"

local perneta = {}
function perneta:load()
    if not self.transform_data[self.transform] then    
        local t = {}
        t.playersheetWalk = love.graphics.newImage('assets/Perneta_Walk_FULL.png')
        t.playeranimeWalk = anim8.newGrid(194, 415, t.playersheetWalk:getWidth(), t.playersheetWalk:getHeight())
        t.Walkanimation = anim8.newAnimation(t.playeranimeWalk('1-10','1-3'), 1/30)
        self.transform_data[self.transform] = t    
    end
end
function perneta:move(x,y,filter)
    local dst_x = self.x + x*self.speed
    local dst_y = self.y + y*self.speed
    dst_y = clamp(dst_y,self.game.roof-self.h,self.game.floor-self.h)
    self.x,self.y = self.game.world:move(self, dst_x,dst_y,filter)
end
function perneta:update(dt)
  local t = self.transform_data[self.transform]
  t.Walkanimation:update(dt)
end
function perneta:shoot(angle)
    if self.dir == 1 then
        self.game.spawn(bullet:load(self.game,self.x+self.w,self.y,angle))
    else
        self.game.spawn(bullet:load(self.game,self.x-10,self.y,angle))
    end
end
function perneta:draw(dir,x,y,scalex,scaley,w,shot)
  local t = self.transform_data[self.transform]
  if self.dir == 1 then
    if self.shot == false then
       t.Walkanimation:draw(t.playersheetWalk, self.x,self.y-50, 0, self.scalex, self.scaley, 0, 0,0,0)
       --ARMWalkanimation:draw(playersheetWalkARM, x,y, 0, scalex, scaley, 0, 0,0,0)
       elseif self.shot == true then
         --Atkanimation:draw(playersheetATK, x,y, 0, scalex, scaley, 0, 0,0,0)
    end
  else
       t.Walkanimation:draw(t.playersheetWalk, self.x+self.w,self.y-50, 0, self.dir*self.scalex,self.scaley, 0, 0,0,0)
       --ARMWalkanimation:draw(playersheetWalkARM,  x+w,y, 0, dir*scalex,scaley, 0, 0,0,0)
  end
 
  
end
return perneta
