local bullet = require "src/bullet"
local perneta = {}
function perneta:load()
    self.color = {255,0,0}
end
function perneta:move(x,y,filter)
    local dst_x = self.x + x*self.speed
    local dst_y = self.y + y*self.speed
    self.x,self.y = self.game.world:move(self, dst_x,dst_y,filter)
end
function perneta:shoot(angle)
    if self.dir == 1 then
        self.game.spawn(bullet:load(self.game,self.x+self.w,self.y,angle))
    else
        self.game.spawn(bullet:load(self.game,self.x-10,self.y,angle))
    end
end
return perneta
