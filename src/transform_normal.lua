local bullet = require "src/bullet"
local normal = {}
function normal:load()
    self.color = {0,0,255}
end
function normal:move(x,y)
    local dst_x = self.x + x*self.speed
    local dst_y = self.y + y*self.speed
    self.x,self.y = self.game.world:move(self, dst_x,dst_y)
end
function normal:shoot()
    local angle = 0
    self.game.spawn(bullet:load(self.game,self.x+self.w,self.y,angle))
end
return normal
