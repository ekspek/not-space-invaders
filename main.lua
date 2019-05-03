Gamestate = require 'libs.hump.gamestate'
Timer = require 'libs.hump.timer'
local input = require 'input'

local mainGame = require 'gamestates.mainGame'

function love.load()
	Gamestate.registerEvents()
	Gamestate.switch(mainGame)
end

function love.update(dt)
end

function love.draw(dt)
end

function love.keypressed(key)
	input.press(key)
end

function love.keyreleased(key)
	input.release(key)
end

function love.gamepadpressed(joystick, button)
	input.press(button)
end

function love.gamepadreleased(joystick, button)
	input.release(button)
end
