local cron = require "lib/cron"
local bump = require "lib/bump"

local intro = {}

local introworld = bump.newWorld(10)
local debugmode = true

function changedir ()
  if dir == 1 then
    dir = -1
  
elseif dir == -1 then
  dir = 1 
 end
 
end

local introFilter = function(item, other)
  if     other.name == "button1"   then return 'cross'
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
    
    terrycursor = love.graphics.newImage("assets/TerryCursor.png")
    titleart = love.graphics.newImage("assets/tela_start.jpg")
    rockonart = love.graphics.newImage("assets/tela_start_rockon.png")
    
    W,H = love.graphics.getDimensions()
    intro.button1 = { name  = "button1"} 
    intro.mouse = { name = "mouse"} 
    intro.button1.h = rockonart:getHeight() 
    intro.button1.w = rockonart:getWidth()
    --intro.b1.sx = W*b1.w/10
    --intro.b1.sy = H*b1.h/12 
    dir = 1
    tb = false
    
    introworld:add(intro.button1, 850*W/1366,500*H/768, intro.button1.w,intro.button1.h)
    introworld:add(intro.mouse,50,50,20,20)
    
    m1x,m1y,m1w,m1h = introworld:getRect(intro.mouse)
    intro.timer = cron.every(1.5,changedir)
    
end

function intro.update(dt)
    
    
    speed = dir*10*dt
    intro.timer:update(dt)
    
    
    b1x,b1y,b1w,b1h = introworld:getRect(intro.button1)
    mousex,mousey = love.mouse.getPosition()
    
    ABX, ABY, cols, len = introworld:move(intro.button1,b1x,b1y+speed,introFilter)
    AMX, AMY, cols, len = introworld:move(intro.mouse,mousex,mousey,introFilter)
    
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
    love.graphics.draw(rockonart,ABX,ABY)--,0,b1.sx,b1.sy)
    
    --love.graphics.setColor(175,125,215)
    love.graphics.draw(terrycursor,AMX-25,AMY-25,0,0.1,0.1)
    --love.graphics.rectangle("line",AMX,AMY,m1w,m1h)
    --[[
    love.graphics.rectangle("line",ABX,ABY,b1w,b1h)
    love.graphics.print(tostring(dir),130,140)
    love.graphics.print(tostring(tb),130,150)
    love.graphics.print(tostring(AMX),100,100)
    love.graphics.print(tostring(mousex),100,140)
    
    love.graphics.print(tostring(len),100,150)
    love.graphics.print(tostring(click1),100,160)
  ]]--

    
    
end
return intro
