local aim = {}

local aimFilter = function(item, other)
  if     other.name == "bullet"   then return 'cross'
  elseif other.name == "player"   then return 'cross'
  elseif other.name == "enemy"   then return 'cross'
  end
  -- else return nil  
end

function aim:load(game,x,y)
    local o = {}
    setmetatable(o,self)
    self.__index = self
  
    o.name = "aim"
    o.color = {255,0,0}
    o.r = 25
    o.x = x
    o.y = y
    o.game = game
    o.game.world:add(o,o.x,o.y,o.r,o.r)
    
    return o
end

function aim:move(x,y)
    self.x,self.y = self.game.world:move(self, x,y, aimFilter)
end

function aim:mousemoved(x, y, dx, dy)
    self:move(x,y)
end


function aim:draw()
    love.graphics.setColor(self.color)
    love.graphics.circle("line", self.x, self.y, self.r, self.r *2)
    love.graphics.circle("line", self.x, self.y, self.r/2, self.r)
end
return aim