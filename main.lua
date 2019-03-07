local state = require 'state'
local world = require 'world'
local input = require 'input'
local entities = require 'entities'
local bullet = require 'entities.bullet'

function love.load()
	local step_frame = 0
	
	love.graphics.setDefaultFilter('linear', 'nearest', 0)
	
	love.graphics.setBackgroundColor(0,0,0)
	
	for _, entity in ipairs(entities) do
		if entity.load then entity:load() end
	end
end

function love.update(dt)
	local invader_outside_left = false
	local invader_outside_right = false
	
	state.invader.count = 0
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
				table.insert(entities, bullet(math.floor(entity.x + (entity.w / 2)), entity.y + 0))
				state.player.firebuffer = false
			end

			---[[ debug test option
			if state.player.firehold then
				table.insert(entities, bullet(math.floor(entity.x + (entity.w / 2)), entity.y + 0))
			end
			--]]
		end

		if entity.id == 'invader1' or entity.id == 'invader2' or entity.id == 'invader3' then
			state.invader.count = state.invader.count + 1
			
			if entity.outside_right then
				invader_outside_right = true
			elseif entity.outside_left then
				invader_outside_left = true
			end
		end

		if entity.remove then
			table.remove(entities, i)
		else
			i = i + 1
		end
	end

	-- Code inside this loop is run once per frame (on frame change)
	-- The speed is determined by state.pace, which specifies the
	-- changes per second
	if step_frame ~= state.frame then
		step_frame = state.frame
		
		if invader_outside_right then
			if state.invader.direction == 'down' then
				state.invader.direction = 'left'
			elseif state.invader.direction == 'right' then
				state.invader.direction = 'down'
			end
				
			if invader_outside_left then
				state.invader.direction = 'down'
			end
		elseif invader_outside_left then
			if state.invader.direction == 'down' then
				state.invader.direction = 'right'
			elseif state.invader.direction == 'left' then
				state.invader.direction = 'down'
			end
		end
	end

	state:update(dt)
	world:update(dt)
	
	-- 30FPS mode
	--love.timer.sleep(1/30)
end

function love.draw(dt)
	for _, entity in ipairs(entities) do
		if entity.draw then entity:draw() end
		
		--[[
		if entity.body then
			love.graphics.setColor(1,0,0)
			love.graphics.polygon('line', entity.body:getWorldPoints(entity.shape:getPoints()))
		end
		--]]
	end
end

function love.keypressed(key)
	input.press(key)
end

function love.keyreleased(key)
	input.release(key)
end
