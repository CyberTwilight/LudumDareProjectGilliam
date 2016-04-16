local player = require "src/player"
local enemy = require "src/enemy"
local cron = require "lib/cron"
local game = {}
function game.load()
    num_enemies = 1
    music = {bpm = 1,path = "assets/music.mp3"}
    cron.every(music.bpm,game.beat)
    p = player:load(0,0)
    enemies = {}
    for i=1,num_enemies do
        table.insert(enemies,enemy:load(400+math.random(0,20),0))
    end
end

function game.update(dt)
    p:update(dt)
    foreach(enemies,function(x) x:update(dt) end)
end

function game.beat()
    p:beat()
    foreach(enemies,function(x) x:beat() end)
end

function game.draw()
    p:draw()
    foreach(enemies,function(x) x:draw() end)
end
return game
