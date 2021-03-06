local Class = require 'libs.hump.class'
local Entity = require 'entity'

local world = require 'world'
local state = require 'state'

local Invader = Class{ __includes = Entity }

function Invader:init(x, y, invader)
	Entity:init()

	self.id = 'invader' .. invader
	self.x = x
	self.y = y
	self.step = 1

	-- Flags to warn if the horde needs to change directions,
	-- NOT if an invader is outside of the screen.
	self.outside_right = false
	self.outside_left = false

	-- Each invader dies when their health reaches zero
	-- and they stop moving (or get to a really low velocity).
	-- Dying makes the burst animation play, and when this ends
	-- the invader is removed from the entities list.
	self.alive = true
	self.remove = false
	self.health = 1

	-- Code to handle projectile fire
	self.firebuffer = false

	-- Flag to check if invader is below the game over treshold
	self.overflow = false

	self.death_timer = 0.5
	self.step_frame = state.frame

	if invader == 1 then
		self.w = 12 * 2
		self.h = 8 * 2
	elseif invader == 2 then
		self.w = 11 * 2
		self.h = 8 * 2
	elseif invader == 3 then
		self.w = 8 * 2
		self.h = 8 * 2
	end

	self.body = love.physics.newBody(world, x, y, 'dynamic')
	self.shape = love.physics.newRectangleShape(self.w, self.h)
	self.fixture = love.physics.newFixture(self.body, self.shape)
	self.fixture:setUserData(self)

	local ox, oy, mass, inertia = self.body:getMassData()
	self.body:setMassData(ox, oy, mass, inertia)

	self.body:setLinearVelocity(0,0)
	self.body:setLinearDamping(1)
	self.body:setAngularDamping(1)

	self.quads = {}

	if invader == 1 then
		self.image = love.graphics.newImage("sprites/inv1.png")
		table.insert(self.quads, love.graphics.newQuad(0, 0, 12, 8, self.image:getDimensions()))
		table.insert(self.quads, love.graphics.newQuad(16, 0, 12, 8, self.image:getDimensions()))
	elseif invader == 2 then
		self.image = love.graphics.newImage("sprites/inv2.png")
		table.insert(self.quads, love.graphics.newQuad(0, 0, 11, 8, self.image:getDimensions()))
		table.insert(self.quads, love.graphics.newQuad(16, 0, 11, 8, self.image:getDimensions()))
	elseif invader == 3 then
		self.image = love.graphics.newImage("sprites/inv3.png")
		table.insert(self.quads, love.graphics.newQuad(0, 0, 8, 8, self.image:getDimensions()))
		table.insert(self.quads, love.graphics.newQuad(8, 0, 8, 8, self.image:getDimensions()))
	end

	self.image_death = love.graphics.newImage("sprites/burst.png")

	self.sound_hit = love.audio.newSource("sfx/invaderkilled.wav", "static")
	self.sound_death = love.audio.newSource("sfx/ufo_highpitch.wav", "static")
end

function Invader:update(dt)
	local paceModifier = function(pixels)
		return math.floor(pixels + (pixels * (state.pace^0.15 - 1)))
	end

	-- Check if outside of playable area
	local border_out = 0 -- positive means towards the outside of the screen
	local border_in = 10 -- positive means towards the inside of the screen
	local x1, y1, x2, y2, x3, y3, x4, y4 = self.body:getWorldPoints(self.shape:getPoints())
	self.x = x1
	self.y = y1
	local xmin = math.min(x1, x2, x3, x4)
	local xmax = math.max(x1, x2, x3, x4)
	local ymin = math.min(y1, y2, y3, y4)
	local ymax = math.max(y1, y2, y3, y4)

	self.remove = self.remove
		or xmax < -border_out
		or xmin > love.graphics.getWidth() + border_out
		or ymax < -border_out
		or ymin > love.graphics.getHeight() + border_out

	self.overflow = self.overflow or ymax > 450

	self.outside_left = xmin < paceModifier(border_in)
	self.outside_right = xmax > love.graphics.getWidth() - paceModifier(border_in)

	-- Resetting the angle when velocity is low
	local dx, dy = self.body:getLinearVelocity()
	local dv = math.abs(dx) + math.abs(dy)

	if dv < 2 and self.body:getAngularVelocity() < 0.1 then
		if self.health <= 0 then
			if self.alive == true then
				self.sound_death:play()
			end
			self.alive = false
		else
			self.body:setAngle(0)
			if self.step_frame ~= state.frame then
				self.step_frame = state.frame

				local x, y = self.body:getPosition()
				if state.invader.direction == 'right' then
					self.body:setPosition(x + paceModifier(2), y)
				elseif state.invader.direction == 'left' then
					self.body:setPosition(x - paceModifier(2), y)
				elseif state.invader.direction == 'down' then
					self.body:setPosition(x, y + 10)
				end
			end
		end
	end

	if not self.alive then
		self.death_timer = self.death_timer - dt
		if self.death_timer <= 0 then
			self.fixture:destroy()
			self.remove = true
			state:addscore(100)
		end
	end
end

function Invader:draw()
	local x, y = self.body:getWorldPoints(self.shape:getPoints())
	self.x = x1
	self.y = y1
	if not self.alive then
		love.graphics.setColor(1,1,1,0.5)
		love.graphics.draw(self.image_death, x, y, self.body:getAngle(), 2, 2)
	else
		love.graphics.setColor(1, 1, 1, self.health + 0.5)
		love.graphics.draw(self.image, self.quads[state.frame + 1], x, y, self.body:getAngle(), 2, 2)
	end
end

-- Mostly a debugging method for now
function Invader:fire()
	self.firebuffer = true
end

function Invader:postSolve(id)
	for _, id_list in pairs({'bullet', 'bullet_invader'}) do
		if id == id_list then
			self.sound_hit:play()
			if self.health > 0 then
				self.health = self.health - 1
			else
				state:addscore(10)
			end
		end
	end
end

return Invader
