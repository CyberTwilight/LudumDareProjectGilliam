local cron = require "lib/cron"
local bump = require "lib/bump"

local intro = {}

local introworld = bump.newWorld(10)
local debugmode = true

local introFilter = function(item, other)
  if     other.name == "button"   then return 'cross'
  end
  -- else return nil  
end


function intro.mousepressed(x,y,button, istouch )
  click1 = false
   if button == 1 then
    click1 = true
  end
end

function intro.mousereleased( x, y, button, istouch )
  if button == 1  then
    click1 = false
  end
end
function intro.load()
    --intro.timer = cron.after(0.5,change_scene,"game")
    terrycursor = love.graphics.newImage("assets/TerryCursor.png")
    titleart = love.graphics.newImage("assets/TitleScreen.png")
    
    W,H = love.graphics.getDimensions()
    intro.button1 = { name  = "button1"} 
    intro.mouse = { name = "mouse"} 
    b1 = { h = 180 , w = 180}

    
    introworld:add(intro.button1, 550,212, b1.w,b1.h)
    introworld:add(intro.mouse,50,50,20,20)
    b1x,b1y,b1w,b1h = introworld:getRect(intro.button1)
    m1x,m1y,m1w,m1h = introworld:getRect(intro.mouse)
end

function intro.update(dt)
    --intro.timer:update(dt)
    mousex,mousey = love.mouse.getPosition()
    AMX, AMY, cols, len = introworld:move(intro.mouse,mousex,mousey,introFilter)
    --items, len = introworld:queryRect((W/2)-(b1.w/2),(H/2)+(b1.h/2),b1w,b1h)
    items, len = introworld:queryPoint(mousex,mousey)
    if len == 1 and click1 == true and mousey > b1y and mousey < b1y+b1h then
      
    change_scene("game")
    
    end
end

function intro.draw()
     
    if len == 1 and click1 == true and mousey > b1y and mousey < b1y+b1h then
      love.graphics.print("test",200,200)
    end
    love.graphics.draw(titleart,0,0)
    love.graphics.rectangle("line",b1x,b1y,b1w,b1h)
    --love.graphics.setColor(175,125,215)
    love.graphics.draw(terrycursor,AMX-25,AMY-25,0,0.1,0.1)
    --love.graphics.rectangle("line",AMX,AMY,m1w,m1h)
    --[[
    love.graphics.print(tostring(AMX),100,100)
    love.graphics.print(tostring(mousex),100,140)
    love.graphics.print(tostring(mousey),130,140)
    love.graphics.print(tostring(len),100,150)
    love.graphics.print(tostring(click1),100,160)
  ]]--

    
    
end
return intro
