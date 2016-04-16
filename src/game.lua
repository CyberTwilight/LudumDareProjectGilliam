local player = require "src/player"
local cron = require "lib/cron"
local game = {}
function game.load()
    music = {bpm = 1,path = "assets/music.mp3"}
    cron.every(music.bpm,game.beat)

end

function game.update(dt)

end

function game.beat()
    
end

function game.draw()
    love.graphics.print("game",100,100)
end
return game
