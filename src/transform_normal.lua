local bullet = require "src/bullet_player"
local anim8 = require "lib/anim8"
local normal = {}

--local sprites = { walk = 'assets/Default_Walk_armless.png' } 
--atkclick = false 

function mousepressed(x,y,button, istouch )
  atkclick = false
   if button == 1 then
    atkclick = true
  end
end

function mousereleased( x, y, button, istouch )
  if button == 1  then
    atkclick = false
  end
end

function normal:load()
   
    playersheetWalk = love.graphics.newImage('assets/Default_Walk_armless.png')
    playeranimeWalk = anim8.newGrid(237, 357, playersheetWalk:getWidth(), playersheetWalk:getHeight())
    Walkanimation = anim8.newAnimation(playeranimeWalk('1-10','1-3'), 1/30)
    
    playersheetWalkARM = love.graphics.newImage('assets/Overlay_Guitarra_Walk.png')
    playeranimeWalkARM = anim8.newGrid(237, 355, playersheetWalkARM:getWidth(), playersheetWalkARM:getHeight())
    ARMWalkanimation = anim8.newAnimation(playeranimeWalkARM('1-10','1-3'), 1/30)
    
    playersheetATK = love.graphics.newImage('assets/Default_Atack_ARMLESS.png')
    playeranimeATK = anim8.newGrid(259, 334, playersheetATK:getWidth(), playersheetATK:getHeight())
    Atkanimation = anim8.newAnimation(playeranimeATK('1-10','1-3'), 1/30)
    
    
end

function normal:update(dt)
  
  Walkanimation:update(dt)
  ARMWalkanimation:update(dt)
  Atkanimation:update(dt)
  
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

function normal:draw(dir,x,y,scalex,scaley,w,shot)
  if dir == 1 then
    if shot == false then
       Walkanimation:draw(playersheetWalk, x,y, 0, scalex, scaley, 0, 0,0,0)
       ARMWalkanimation:draw(playersheetWalkARM, x,y, 0, scalex, scaley, 0, 0,0,0)
       elseif shot == true then
         Atkanimation:draw(playersheetATK, x,y, 0, scalex, scaley, 0, 0,0,0)
    end
  else
       Walkanimation:draw(playersheetWalk, x+w,y, 0, dir*scalex,scaley, 0, 0,0,0)
       ARMWalkanimation:draw(playersheetWalkARM,  x+w,y, 0, dir*scalex,scaley, 0, 0,0,0)
  end
  
  
  love.graphics.print(tostring(shot))
    
end
return normal
