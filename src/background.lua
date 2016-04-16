local map = {}

function map.load()
    background = love.graphics.newImage("assets/background.jpg")
  
end
function map.update(dt)
  
end
function map.draw()
    love.graphics.setColor(255,255,255)
    love.graphics.draw(background,0,0)
    
    

end
return map
