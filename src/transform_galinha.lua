local bullet = require "src/bullet"
local galinha = {}
function galinha:load()
    self.color = {0,255,0}
end
function galinha:move(x,y)
    local dst_x = self.x + x*self.speed
    local dst_y = self.y + y*self.speed
    self.x,self.y = self.game.world:move(self, dst_x,dst_y)
end
function galinha:shoot(angle)
    self.game.spawn(bullet:load(self.game,self.x+self.w,self.y,angle))
end
return galinha
