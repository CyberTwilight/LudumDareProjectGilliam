local bullet = require "src/bullet_player"
local perneta = {}
function perneta:load()
    self.color = {255,0,0}
end
function perneta:move(x,y)
    local dst_x = self.x + x*self.speed
    local dst_y = self.y + y*self.speed
    self.x,self.y = self.game.world:move(self, dst_x,dst_y)
end
function perneta:shoot()
    if self.dir == 1 then
        angle = 0
        self.game.spawn(bullet:load(self.game,self.x+self.w,self.y,angle))
    else
        angle = math.pi
        self.game.spawn(bullet:load(self.game,self.x-10,self.y,angle))
    end
end
return perneta
