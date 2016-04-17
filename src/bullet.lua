local bullet = {}

local bulletFilter = function(item, other)
  if     other.isBullet   then return 'cross'
  elseif other.isPlayer   then return 'cross'
  elseif other.isEnemy   then return 'slide'
  end
  -- else return nil  
end

function bullet:load(game,x,y,angle)
    local o = {}
    setmetatable(o,self)
    self.__index = self
    
    o.name = "bullet"
    o.w = 10
    o.h = 10
    o.x = x
    o.y = y + 50
    o.angle = angle
    o.speed = 100
    o.color = {math.random(0,100),math.random(0,255),math.random(0,100)}
    o.game = game 
    o.game.world:add(o,o.x,o.y,o.w,o.h)
    return o
end
function bullet:beat()
end
function bullet:die()
    --self.game.world:remove(self)
    --self = nil
end
function bullet:update(dt)
    local dst_x = self.x + math.cos(self.angle)*self.speed*dt
    local dst_y = self.y + math.sin(self.angle)*self.speed*dt
    local cols = {}
    self.x,self.y,cols= self.game.world:move(self, dst_x,dst_y, bulletFilter)
    local dead = false
    for k,v in ipairs(cols) do
        if v.other.hit then
            v.other:hit(self)
        end
        if v.other.name =="enemy" then 
            dead = true
        end
    end
    if dead then
        self:die()
    end
end

function bullet:draw()
    love.graphics.setColor(self.color)
    love.graphics.rectangle("fill",self.x,self.y,self.w,self.h)
end
return bullet
