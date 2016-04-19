local bullet = require "src/bullet_player"
local anim8 = require "lib/anim8"
local galinha = {}
function galinha:load()
    --self.color = {0,255,0}
    
    playersheetWalk = love.graphics.newImage('assets/Galinha_WALK.png')
    playeranimeWalk = anim8.newGrid(317, 426, playersheetWalk:getWidth(), playersheetWalk:getHeight())
    Walkanimation = anim8.newAnimation(playeranimeWalk('1-10','1-3'), 1/30)
       
    
    
    
end
function galinha:move(x,y,filter)
    local dst_x = self.x + x*self.speed
    local dst_y = self.y + y*self.speed
    dst_y = clamp(dst_y,self.game.roof-self.h,self.game.floor-self.h)
    self.x,self.y = self.game.world:move(self, dst_x,dst_y,filter)

end
function galinha:update(dt)
  
  Walkanimation:update(dt)
  
end
function galinha:shoot(angle)
    if self.dir == 1 then
        self.game.spawn(bullet:load(self.game,self.x+self.w,self.y,angle))
    else
        self.game.spawn(bullet:load(self.game,self.x-10,self.y,angle))
    end
end
function galinha:draw(dir,x,y,scalex,scaley,w,shot)
  if dir == 1 then
    if shot == false then
       Walkanimation:draw(playersheetWalk, x-50,y-50, 0, scalex, scaley, 0, 0,0,0)
       --ARMWalkanimation:draw(playersheetWalkARM, x,y, 0, scalex, scaley, 0, 0,0,0)
       elseif shot == true then
         --Atkanimation:draw(playersheetATK, x,y, 0, scalex, scaley, 0, 0,0,0)
    end
  else
       Walkanimation:draw(playersheetWalk, x+w+50,y-50, 0, dir*scalex,scaley, 0, 0,0,0)
       --ARMWalkanimation:draw(playersheetWalkARM,  x+w,y, 0, dir*scalex,scaley, 0, 0,0,0)
  end
  
  
end
return galinha
