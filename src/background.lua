local map = {}

function map.load()
    background = love.graphics.newImage("assets/background.jpg")
    local W,H = love.graphics.getDimensions()
    map.scalex,map.scaley = W/background:getWidth(),H/background:getHeight()
end
function map.update(dt)
  
end
function map.draw()
    love.graphics.setColor(255,255,255)
    love.graphics.draw(background,0,0,0,map.scalex,map.scaley)
    
    

end
return map
