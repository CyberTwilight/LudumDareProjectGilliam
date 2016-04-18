local anim8 = require "lib/anim8"

local bullet = {}

local bulletFilter = function(item, other)
  if     other.name == "bullet"   then return 'cross'
  --elseif other.name == "player"   then return 'cross'
  elseif other.name == "enemy"   then return 'touch'
  end
  -- else return nil  
end

function bullet:load(game,x,y,angle)
    local o = {}
    setmetatable(o,self)
    self.__index = self
    
    o.name = "bullet_player"
    o.w = 20
    o.h = 20
    o.x = x
    o.y = y + 50
    o.angle = angle
    o.speed = 200
    o.color = {math.random(0,100),math.random(0,255),math.random(0,100)}
    o.game = game 
    o.game.world:add(o,o.x,o.y,o.w,o.h)
    
    terrysheet = love.graphics.newImage('assets/TerryShot2.png')
    local terryshot = anim8.newGrid(142,142, terrysheet:getWidth(), terrysheet:getHeight())
    o.terryshot = anim8.newAnimation(terryshot('1-7','1-4'), 1/28)
    
    return o
end
function bullet:beat()
end
function bullet:die()
    if self.game.world:hasItem(self) then
        self.game.world:remove(self)
    end
    self.game.remove(self)
    --self = nil
end
function bullet:update(dt)
   
    local dst_x = self.x + math.cos(self.angle)*self.speed*dt
    local dst_y = self.y + math.sin(self.angle)*self.speed*dt
    local cols = {}
    self.x,self.y,cols= self.game.world:move(self, dst_x,dst_y)--, bulletFilter)
    local dead = false
    for k,v in ipairs(cols) do
        if v.other.hit then
            v.other.hit(v.other,self)
        end
        if v.other.name =="enemy" then 
            dead = true
        end
    end
    if dead then
        self:die()
    end
    self.terryshot:update(dt)
end

function bullet:draw()
    self.terryshot:draw(terrysheet, self.x,self.y, 0, 0.25,0.25, 0, 0,0,0)
    --love.graphics.setColor(self.color)
    --love.graphics.rectangle("fill",self.x,self.y,self.w,self.h)
end
return bullet
