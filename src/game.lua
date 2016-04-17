local player = require "src/player"
local soldier = require "src/enemy"
local tank = require "src/enemy_tank"
local map = require "src/background"
local cron = require "lib/cron"
local bump = require "lib/bump"
local aim = require "src/aim"

local game = {}
function game.load()
    local music = {bpm = 124,path = "assets/music.mp3",offset = 1}
    local song = love.audio.newSource(music.path)
    song:play()
    game.world = bump.newWorld(10)
    game.spawn(cron.after(music.offset, game.spawn, cron.every(1/(music.bpm/60),game.beat)))
    game.W,game.H = love.graphics.getDimensions()
    game.floor = game.H
    game.roof = 3*game.H/4
    game.play_area = game.floor - game.roof
    map.load()
    
    playeraim = aim:load(game, game.W/2,game.H/2) 
    game.spawn(player:load(game,game.W/2,game.floor-10, playeraim))
    game.spawn(playeraim)
    game.enemy_count = 0
    game.spawn_rate = 0.5
    game.wave_rate = 1
    game.waves = {{5,0},{10,1},{15,3},{20,5},{25,10}}
    game.curr_wave = 1
    game.next_wave()
    
    
end
function game.next_wave()
    if game.waves[game.curr_wave] then
        game.wave(game.waves[game.curr_wave][1],soldier)
        game.wave(game.waves[game.curr_wave][2],tank)
        game.curr_wave = game.curr_wave + 1
    else
        print "victory"
        --change_scene("victory")
    end
end
function game.create_enemy(typ)
    local dice = math.random()
    if dice < 0.5 then
        game.spawn(typ:load(game,game.W,dice*game.play_area+game.roof,1))
    else
        game.spawn(typ:load(game,0,dice*game.play_area+game.roof,-1))
    end
    game.enemy_count = game.enemy_count + 1
end
function game.wave(num_enemies,typ)
    if num_enemies > 0 then
        game.create_enemy(typ)
    end
    game.spawn(cron.after(game.spawn_rate,game.wave,num_enemies-1,typ))
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
function game.mousemoved( x, y, dx, dy )
  foreach(game.objs,function(o) if o.mousemoved then o:mousemoved( x, y, dx, dy ) end end)
end
function game.beat()
    foreach(game.objs,function(x) if x.beat then x:beat() end end)
end

function game.draw()
    map.draw()
    foreach(game.objs,function(x) if x.draw then x:draw() end end)
end
return game
