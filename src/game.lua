local player = require "src/player"
local enemy = require "src/enemy"
local cron = require "lib/cron"
local hx = require "lib/hxdx/hxdx"
local game = {}
function game.load()
    local num_enemies = 5
    local music = {bpm = 1,path = "assets/music.mp3"}
    game.spawn(cron.every(music.bpm,game.beat))
    local W,H = love.graphics.getDimensions()
    local floor = H*3/4
    --game.floor = wall:load(0,floor)
    game.spawn(player:load(0,floor-10))
    for i=1,num_enemies do
        game.spawn(enemy:load(400+60*i,floor-10))
    end
end

function game.spawn(obj)
    game.objs = game.objs or {}
    table.insert(game.objs,obj)
end
function game.update(dt)
    foreach(game.objs,function(x) if x.update then x:update(dt) end end)
end

function game.beat()
    foreach(game.objs,function(x) if x.beat then x:beat() end end)
end

function game.draw()
    foreach(game.objs,function(x) if x.draw then x:draw() end end)
end
return game
