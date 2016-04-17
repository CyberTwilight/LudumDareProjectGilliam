local player = require "src/player"
local enemy = require "src/enemy"
local map = require "src/background"
local cron = require "lib/cron"
local bump = require "lib/bump"
local game = {}
function game.load()
    local music = {bpm = 124,path = "assets/music.mp3",offset = 1}
    local song = love.audio.newSource(music.path)
    song:play()
    game.world = bump.newWorld(10)
    game.spawn(cron.after(music.offset, game.spawn, cron.every(1/(music.bpm/60),game.beat)))
    game.W,game.H = love.graphics.getDimensions()
    game.floor = game.H*3/4
    map.load()
    game.spawn(player:load(game,game.W/2,game.floor-10))
    game.enemy_count = 0
    game.spawn_rate = 0.5
    game.wave_rate = 1
    game.waves = {5,10,15}
    game.curr_wave = 1
    game.next_wave()
end
function game.next_wave()
    if game.waves[game.curr_wave] then
        game.wave(game.waves[game.curr_wave])
        game.curr_wave = game.curr_wave + 1
    else
        print "victory"
        --change_scene("victory")
    end
end
function game.create_enemy()
    local dice = math.random()
    if dice < 0.5 then
        game.spawn(enemy:load(game,game.W,game.floor-10,1))
    else
        game.spawn(enemy:load(game,0,game.floor-10,-1))
    end
    game.enemy_count = game.enemy_count + 1
end
function game.wave(num_enemies)
    for i=1,num_enemies do
        game.spawn(cron.after(game.spawn_rate,game.create_enemy))
    end
end
function game.spawn(obj)
    game.objs = game.objs or {}
    table.insert(game.objs,obj)
end
function game.remove(obj)
    for k,v in pairs(game.objs) do
        if obj == v then 
            if obj.name == "enemy" then
                game.enemy_count = game.enemy_count - 1
                if game.enemy_count == 0 then
                    game.spawn(cron.after(game.wave_rate,game.next_wave))
                end
            end
            game.objs[k] = nil 
        end 
    end
end

function game.update(dt)
    foreach(game.objs,function(x) if x.update then x:update(dt) end end)
end
function game.keypressed(key)
    foreach(game.objs,function(x) if x.keypressed then x:keypressed(key) end end)
end
function game.keyreleased(key)
    foreach(game.objs,function(x) if x.keyreleased then x:keyreleased(key) end end)
end
function game.mousepressed( x, y, button, istouch )
  foreach(game.objs,function(o) if o.mousepressed then o:mousepressed(x, y, button, istouch) end end)
end
function game.mousereleased( x, y, button, istouch )
  foreach(game.objs,function(o) if o.mousereleased then o:mousereleased(x, y, button, istouch) end end)
end  
function game.beat()
    foreach(game.objs,function(x) if x.beat then x:beat() end end)
end

function game.draw()
    map.draw()
    foreach(game.objs,function(x) if x.draw then x:draw() end end)
end
return game
