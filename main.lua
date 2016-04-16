local utils = require "src/utils"
local intro = require "src/intro"
local menu = require "src/menu"
local game = require "src/game"
function love.load()
    scenes = { intro = intro, menu = menu, game = game}
    change_scene("intro")
end
function change_scene(new)
    scene = new
    scenes[scene].load()
end
function love.update(dt)
    scenes[scene].update(dt)
end

function love.draw()
    scenes[scene].draw()
end
