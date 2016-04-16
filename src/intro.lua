local cron = require "lib/cron"
local intro = {}
function intro.load()
    intro.timer = cron.after(0.5,change_scene,"game")
end

function intro.update(dt)
    intro.timer:update(dt)
end

function intro.draw()
    love.graphics.print("intro",100,100)
end
return intro
