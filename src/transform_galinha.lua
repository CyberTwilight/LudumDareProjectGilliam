local bullet = require "src/bullet_player"
local anim8 = require "lib/anim8"
local galinha = {}
function galinha:load()
    --self.color = {0,255,0}
    print(self)
    print(self.transform_data)
    if not self.transform_data[self.transform] then    
        local t = {}
        t.playersheetWalk = love.graphics.newImage('assets/Galinha_WALK.png')
        t.playeranimeWalk = anim8.newGrid(317, 426, t.playersheetWalk:getWidth(), t.playersheetWalk:getHeight())
        t.Walkanimation = anim8.newAnimation(t.playeranimeWalk('1-10','1-3'), 1/30)
        self.transform_data[self.transform] = t    
    end
       
    
    
    
end
function galinha:move(x,y,filter)
    local dst_x = self.x + x*self.speed
    local dst_y = self.y + y*self.speed
    dst_y = clamp(dst_y,self.game.roof-self.h,self.game.floor-self.h)
    self.x,self.y = self.game.world:move(self, dst_x,dst_y,filter)

end
function galinha:update(dt)
  
  self.transform_data[self.transform].Walkanimation:update(dt)
  
end
function galinha:shoot(angle)
    if self.dir == 1 then
        self.game.spawn(bullet:load(self.game,self.x+self.w,self.y,angle))
    else
        self.game.spawn(bullet:load(self.game,self.x-10,self.y,angle))
    end
end
function galinha:draw()
  local img = self.transform_data[self.transform].playersheetWalk
  local anim = self.transform_data[self.transform].Walkanimation
  if self.dir == 1 then
    if self.shot == false then
       anim:draw(img, self.x-50,self.y-50, 0, self.scalex, self.scaley, 0, 0,0,0)
       --ARMWalkanimation:draw(playersheetWalkARM, x,y, 0, scalex, scaley, 0, 0,0,0)
       elseif self.shot == true then
         --Atkanimation:draw(playersheetATK, x,y, 0, scalex, scaley, 0, 0,0,0)
    end
  else
       anim:draw(img, self.x+self.w+50,self.y-50, 0, self.dir*self.scalex,self.scaley, 0, 0,0,0)
       --ARMWalkanimation:draw(playersheetWalkARM,  x+w,y, 0, dir*scalex,scaley, 0, 0,0,0)
  end
  
  
end
return galinha
