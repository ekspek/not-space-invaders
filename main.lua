local state = require 'state'
local world = require 'world'
local input = require 'input'
local entities = require 'entities'
local bullet = require 'entities.bullet'

function love.load()
	love.graphics.setDefaultFilter('linear', 'nearest', 0)
	
	love.graphics.setBackgroundColor(0,0,0)
	
	for _, entity in ipairs(entities) do
		if entity.load then entity:load() end
	end
end

function love.update(dt)
	local hasinvaders = false

	local i = 1
	while i <= #entities do
		local entity = entities[i]

		if entity.update then entity:update(dt) end

		-- Firing mechanism
		--
		-- Create a bullet at the player's position if the fire button
		-- has been pressed and the current selected entity is the player
		-- This was necessary to get the player's position
		if entity.id == 'player' then
			if state.player.firebuffer then
				table.insert(entities, bullet(entity.x + (entity.w / 2) - 1, entity.y))
				state.player.firebuffer = false
			end

			---[[ debug test option
			if state.player.firehold then
				table.insert(entities, bullet(entity.x + (entity.w / 2) - 1, entity.y))
			end
			--]]
		end

		if entity.id == 'invader' then
			hasinvaders = true
		end

		if entity.remove then
			table.remove(entities, i)
		else
			i = i + 1
		end
	end

	world:update(dt)
end

function love.draw(dt)
	for _, entity in ipairs(entities) do
		if entity.draw then entity:draw() end
	end
end

function love.keypressed(key)
	input.press(key)
end

function love.keyreleased(key)
	input.release(key)
end
