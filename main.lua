local state = require 'state'
local world = require 'world'
local input = require 'input'
local entities = require 'entities'
local bullet = require 'entities.bullet'
local bullet_invader = require 'entities.bullet_invader'
local gameover = require 'entities.gameover'
local win = require 'entities.win'

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
			if state.player.firebuffer and state.player.bullets <= 0 and not state.frozen then
				table.insert(entities, bullet(math.floor(entity.x + (entity.w / 2)), entity.y - 5))
				state.player.firebuffer = false
			end

			---[[ debug test option
			if state.player.firehold and not state.frozen then
				table.insert(entities, bullet(math.floor(entity.x + (entity.w / 2)), entity.y - 5))
			end
			--]]

			state.player.bullets = 0
		end

		if (entity.id == 'invader1' or entity.id == 'invader2' or entity.id == 'invader3') and state.player.alive then
			state.invader.count = state.invader.count + 1

			if entity.outside_right then
				invader_outside_right = true
			elseif entity.outside_left then
				invader_outside_left = true
			end

			if entity.overflow then
				state.gameover = true
				state.player.alive = false
			end

			-- Invader free space checking mechanism
			--
			-- Before firing, every invader has to check for free space
			-- below it to make sure it doesn't hit another invader
			-- This is done by casting two rays from each invader's
			-- lower side and checking for collisions with other invaders
			-- If none are found the firing is validated
			local _, _, x2, y2, x3, y3, _, _ = entity.body:getWorldPoints(entity.shape:getPoints())
			local theta = entity.body:getAngle()
			local r = 100
			local rayhitinvader = false

			x2 = x2 + 5
			x3 = x3 - 5

			local invadercheck_raycast = function(fixture, x, y, xn, yn, fraction)
				local data = fixture:getUserData()
				if data.id == 'invader1' or data.id == 'invader2' or data.id == 'invader3' then
					rayhitinvader = true
					return 1
				else
					return 0
				end
			end

			world:rayCast(x2, y2, x2 - r * math.sin(theta), y2 + r * math.cos(theta), invadercheck_raycast)
			world:rayCast(x3, y3, x3 - r * math.sin(theta), y3 + r * math.cos(theta), invadercheck_raycast)

			if not rayhitinvader and entity.health > 0 then
				if math.random() < 0.005 then
					table.insert(entities, bullet_invader(math.floor(entity.x + (entity.w / 2)), entity.y + entity.h + 10, 0))
					if entity.fire then entity:fire() end
				end
			end
		end

		if entity.id == 'bullet' then
			state.player.bullets = state.player.bullets + 1
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

	if state.gameover then
		table.insert(entities, gameover())
	elseif state.win then
		table.insert(entities, win())
	end

	if state.player.alive then
		world:update(dt)
	end

	state:update(dt)

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

		if entity.id == 'invader1' or entity.id == 'invader2' or entity.id == 'invader3' then
			local x, y = entity.body:getPosition() --entity.body:getWorldPoints(entity.shape:getPoints())
			local theta = entity.body:getAngle()
			local r = 100

			love.graphics.setColor(0,1,0)
			love.graphics.line(x, y, x - 100 * math.sin(theta), y + 100 * math.cos(theta))
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

function love.gamepadpressed(joystick, button)
	input.press(button)
end

function love.gamepadreleased(joystick, button)
	input.release(button)
end
