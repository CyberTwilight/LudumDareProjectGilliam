local utils = require "src/utils"
local intro = require "src/intro"
local menu = require "src/menu"
local game = require "src/game"
local map = require "map/background"

function love.load()
    love.keyboard.setKeyRepeat( true )
    scenes = { intro = intro, menu = menu, game = game}
    change_scene("intro")
    map.load()
end
function change_scene(new)
    scene = new
    scenes[scene].load()
end
function love.update(dt)
    scenes[scene].update(dt)
end
function love.keypressed(key)
    scenes[scene].keypressed(key)
end
function love.draw()
    map.draw()
    scenes[scene].draw()
    
    
end
