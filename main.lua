local state = require 'state'
local world = require 'world'
local input = require 'input'
local entities = require 'entities'
local bullet = require 'entities.bullet'
local bullet_invader = require 'entities.bullet_invader'
local gameover = require 'entities.gameover'
local sfx = require 'sfx'

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

	if state.reset == true then
		entities.respawnInvaders(dt)
		state.level = state.level + 1
	end

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
			if state.reset == true then
				entity.body:setPosition(love.graphics.getWidth() / 2 - 16, love.graphics.getHeight() * 0.9)
			end

			if state.player.firebuffer and state.player.bullets <= 0 and not state.frozen then
				table.insert(entities, bullet(math.floor(entity.x + (entity.w / 2)), entity.y - 5))
				state.player.firebuffer = false
			end

			---[[ debug test option
			if state.player.firehold and not state.frozen then
				table.insert(entities, bullet(math.floor(entity.x + (entity.w / 2)), entity.y - 10))
			end
			--]]

			state.player.bullets = 0
		end

		if (entity.id == 'invader1' or entity.id == 'invader2' or entity.id == 'invader3') and state.player.alive then
			state.invader.count = state.invader.count + 1

			if entity.outside_right and entity.health > 0 then
				invader_outside_right = true
			elseif entity.outside_left and entity.health > 0 then
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
			local _, _, _, _, x3, y3, x4, y4 = entity.body:getWorldPoints(entity.shape:getPoints())
			local theta = entity.body:getAngle()
			local r = 150
			local rayhitinvader = false

			x3 = x3 - 5 * math.cos(theta)
			y3 = y3 - 5 * math.sin(theta)
			x4 = x4 + 5 * math.cos(theta)
			y4 = y4 + 5 * math.sin(theta)

			local invadercheck_raycast = function(fixture, x, y, xn, yn, fraction)
				local data = fixture:getUserData()
				if data.id == 'invader1' or data.id == 'invader2' or data.id == 'invader3' then
					rayhitinvader = true
					return 1
				else
					return 0
				end
			end

			world:rayCast(x3, y3, x3 - r * math.sin(theta), y3 + r * math.cos(theta), invadercheck_raycast)
			world:rayCast(x4, y4, x4 - r * math.sin(theta), y4 + r * math.cos(theta), invadercheck_raycast)

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

		sfx.invadermove:update()

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
		elseif state.invader.direction == 'down' then
			state.invader.direction = 'right'
		end
	end

	if state.gameover then
		table.insert(entities, gameover())
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
			local _, _, _, _, x3, y3, x4, y4 = entity.body:getWorldPoints(entity.shape:getPoints())
			local theta = entity.body:getAngle()
			local r = 150

			x3 = x3 - 5 * math.cos(theta)
			y3 = y3 - 5 * math.sin(theta)
			x4 = x4 + 5 * math.cos(theta)
			y4 = y4 + 5 * math.sin(theta)

			love.graphics.setColor(0,1,0)
			love.graphics.line(x3, y3, x3 - r * math.sin(theta), y3 + r * math.cos(theta))
			love.graphics.line(x4, y4, x4 - r * math.sin(theta), y4 + r * math.cos(theta))
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
