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
   
    if not self.transform_data[self.transform] then    
        local t = {}
        t.playersheetWalk = love.graphics.newImage('assets/Default_Walk_armless.png')
        t.playeranimeWalk = anim8.newGrid(237, 357, t.playersheetWalk:getWidth(), t.playersheetWalk:getHeight())
        t.Walkanimation = anim8.newAnimation(t.playeranimeWalk('1-10','1-3'), 1/30)
        
        t.playersheetWalkARM = love.graphics.newImage('assets/Overlay_Guitarra_Walk.png')
        t.playeranimeWalkARM = anim8.newGrid(237, 355, t.playersheetWalkARM:getWidth(), t.playersheetWalkARM:getHeight())
        t.ARMWalkanimation = anim8.newAnimation(t.playeranimeWalkARM('1-10','1-3'), 1/30)
        
        t.playersheetATK = love.graphics.newImage('assets/Default_Atack_ARMLESS.png')
        t.playeranimeATK = anim8.newGrid(259, 334, t.playersheetATK:getWidth(), t.playersheetATK:getHeight())
        t.Atkanimation = anim8.newAnimation(t.playeranimeATK('1-10','1-3'), 1/30)
        self.transform_data[self.transform] = t    
    end
    
    
end

function normal:update(dt)
  
  local t = self.transform_data[self.transform]
  t.Walkanimation:update(dt)
  t.ARMWalkanimation:update(dt)
  t.Atkanimation:update(dt)
  
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
  local t = self.transform_data[self.transform]

  if self.dir == 1 then
    if self.shot == false then
       t.Walkanimation:draw(t.playersheetWalk, self.x,self.y, 0, self.scalex, self.scaley, 0, 0,0,0)
       t.ARMWalkanimation:draw(t.playersheetWalkARM, self.x,self.y, 0, self.scalex, self.scaley, 0, 0,0,0)
       elseif self.shot == true then
         t.Atkanimation:draw(t.playersheetATK, self.x,self.y, 0, self.scalex, self.scaley, 0, 0,0,0)
    end
  else
       t.Walkanimation:draw(t.playersheetWalk, self.x+self.w,self.y, 0, self.dir*self.scalex,self.scaley, 0, 0,0,0)
       t.ARMWalkanimation:draw(t.playersheetWalkARM,  self.x+self.w,self.y, 0, self.dir*self.scalex,self.scaley, 0, 0,0,0)
  end
  
  
  love.graphics.print(tostring(shot))
    
end
return normal
