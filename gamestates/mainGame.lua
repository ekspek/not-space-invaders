Gamestate = require 'libs.hump.gamestate'

local world = require 'world'
local input = require 'input'
local entities = require 'entities'
local bullet = require 'entities.bullet'
local bullet_invader = require 'entities.bullet_invader'
local gameover = require 'entities.gameover'
local sfx = require 'sfx'

local mainGame = {}

function mainGame:enter()
	love.graphics.setDefaultFilter('linear', 'nearest', 0)

	love.graphics.setBackgroundColor(0,0,0)

	-- Frame change timer
	self.frametimer = Timer.new()
	self.frametimer:every(1, function() self:frameChange() end)

	-- Horder direction
	self.invaderdirection = 'right'

	self.player = {}
	self.invader = {}
	self.pace = 1
	self.pace_initial = 1
	self.score1 = 0
	self.score2 = 0
	self.hiscore = 0
	self.credits = 0
	self.frozen = false
	self.gameover = false
	self.reset = false
	self.level = 1

	self.player.left = false
	self.player.right = false
	self.player.firebuffer = false
	self.player.bullets = 0
	self.player.firehold = false
	self.player.alive = true
	self.player.lives = 3
	self.timer = 0

	self.invader.count = 0
	self.invader.direction = 'right'

	-- Calling each entity's load method
	for _, entity in ipairs(entities) do
		if entity.load then entity:load() end
	end
end

function mainGame:update(dt)
	self.invader.count = 0
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
			if self.reset == true then
				entity.body:setPosition(love.graphics.getWidth() / 2 - 16, love.graphics.getHeight() * 0.9)
			end

			if self.player.firebuffer and self.player.bullets <= 0 and not self.frozen then
				table.insert(entities, bullet(math.floor(entity.x + (entity.w / 2)), entity.y - 5))
				self.player.firebuffer = false
			end

			---[[ debug test option
			if self.player.firehold and not self.frozen then
				table.insert(entities, bullet(math.floor(entity.x + (entity.w / 2)), entity.y - 10))
			end
			--]]

			self.player.bullets = 0
		end

		if (entity.id == 'invader1' or entity.id == 'invader2' or entity.id == 'invader3') and self.player.alive then
			self.invader.count = self.invader.count + 1

			if entity.overflow then
				self.gameover = true
				self.player.alive = false
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
			self.player.bullets = self.player.bullets + 1
		end

		if entity.remove then
			table.remove(entities, i)
		else
			i = i + 1
		end
	end

	if self.gameover then
		table.insert(entities, gameover())
	end

	if self.player.alive then
		world:update(dt)
	end

	if not self.frozen then
		self.frametimer:update(dt)
	end

	if not self.player.alive then
		self:freeze()

		if not self.gameover then
			if self.timer < 2 then
				self.timer = self.timer + dt
			else
				self.player.lives = self.player.lives - 1

				if self.player.lives > 0 then
					self:unfreeze()
				else
					self.gameover = true
				end
			end
		end
	else

		-- When the invader count is zero, activates the reset flag,
		-- increases the player's lives by one and resets the horde
		-- direction
		if self.invader.count <= 0 then
			self.reset = true
			self.player.lives = self.player.lives + 1
			self.invader.direction = 'right'
		else
			self.reset = false
			self.pace = math.max(1, math.floor((55 / self.invader.count)^1.5 * (1 + ((self.level - 1) * 0.3))))
		end
	end

	if self.reset == true then
		entities.respawnInvaders(dt)
		self.level = self.level + 1
	end

	-- 30FPS mode
	--love.timer.sleep(1/30)

end

function mainGame:draw(dt)
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

function mainGame:frameChange()
	sfx.invadermove:update()

	local invader_outside_left = false
	local invader_outside_right = false

	for _, entity in ipairs(entities) do
		if entity.outside_right then invader_outside_right = entity.outside_right end
		if entity.outside_left then invader_outside_left = entity.outside_left end
	end

	if invader_outside_right then
		if self.invaderdirection == 'down' then
			self.invaderdirection = 'left'
		elseif self.invaderdirection == 'right' then
			self.invaderdirection = 'down'
		end
			
		if invader_outside_left then
			self.invaderdirection = 'down'
		end
	elseif invader_outside_left then
		if self.invaderdirection == 'down' then
			self.invaderdirection = 'right'
		elseif self.invaderdirection == 'left' then
			self.invaderdirection = 'down'
		end
	elseif self.invaderdirection == 'down' then
		self.invaderdirection = 'right'
	end

	for _, entity in ipairs(entities) do
		if entity.direction then entity.direction = self.invaderdirection end
		if entity.frameChange then entity:frameChange() end
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

return mainGame
