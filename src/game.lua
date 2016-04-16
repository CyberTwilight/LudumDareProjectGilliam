local player = require "src/player"
local enemy = require "src/enemy"
local cron = require "lib/cron"
local bump = require "lib/bump"
local game = {}
function game.load()
    game.world = bump.newWorld(10)
    local music = {bpm = 1,path = "assets/music.mp3"}
    game.spawn(cron.every(music.bpm,game.beat))
    local W,H = love.graphics.getDimensions()
    game.floor = H*3/4
    game.spawn(player:load(game,0,game.floor-10))
    game.wave(5)
end
function game.wave(num_enemies)
    for i=1,num_enemies do
        game.spawn(enemy:load(game,400+60*i,game.floor-10))
    end
end
function game.spawn(obj)
    game.objs = game.objs or {}
    table.insert(game.objs,obj)
end
function game.update(dt)
    foreach(game.objs,function(x) if x.update then x:update(dt) end end)
end
function game.keypressed(key)
    foreach(game.objs,function(x) if x.keypressed then x:keypressed(key) end end)
end
function game.beat()
    foreach(game.objs,function(x) if x.beat then x:beat() end end)
end

function game.draw()
    foreach(game.objs,function(x) if x.draw then x:draw() end end)
end
return game
