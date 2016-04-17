local bullet = require "src/bullet"
local perneta = {}
function perneta:load()
    self.color = {255,0,0}
end
function perneta:move(x,y)
    local dst_x = self.x + x*self.speed
    local dst_y = self.y + y*self.speed
    self.x,self.y = self.game.world:move(self, dst_x,dst_y)
end
function perneta:shoot(angle)
    self.game.spawn(bullet:load(self.game,self.x+self.w,self.y,angle))
end
return perneta
