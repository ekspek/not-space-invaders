local Class = require 'libs.hump.class'
local Entity = require 'entity'

local state = require 'state'
local world = require 'world'

local Player = Class{ __includes = Entity }

function Player:init(x, y)
	Entity:init()

	self.id = 'player'
	self.x = x
	self.y = y
	self.w = 13 * 2
	self.h = 8 * 2

	self.speed = 100
	self.margin = 2
	self.alive = true

	self.quads_death = {}
	self.death_frame = 0
	self.death_timer = 0

	self.body = love.physics.newBody(world, self.x, self.y, 'kinematic')
	self.shape = love.physics.newRectangleShape(self.w, self.h - 3 * 2)
	self.fixture = love.physics.newFixture(self.body, self.shape)
	self.fixture:setUserData(self)

	self.image = love.graphics.newImage("sprites/player.png")
	self.image_death = love.graphics.newImage("sprites/player_death.png")
	table.insert(self.quads_death, love.graphics.newQuad(-1, 0, 13, 8, self.image_death:getDimensions()))
	table.insert(self.quads_death, love.graphics.newQuad(16, 0, 13, 8, self.image_death:getDimensions()))

	self.sound_death = love.audio.newSource("sfx/explosion.wav", "static")
end

function Player:update(dt)
	self.x, self.y = self.body:getWorldPoints(self.shape:getPoints())

	if state.player.left == state.player.right or state.frozen then
		self.body:setLinearVelocity(0,0)
	elseif state.player.left then
		if self.x - self.speed * dt > self.margin then
			self.body:setLinearVelocity(-self.speed, 0)
		else
			self.body:setLinearVelocity(0,0)
		end
	elseif state.player.right then
		if self.x + self.speed * dt < love.graphics.getWidth() - self.w - self.margin then
			self.body:setLinearVelocity(self.speed, 0)
		else
			self.body:setLinearVelocity(0,0)
		end
	end

	if not state.player.alive then
		self.death_frame = (self.death_frame + 12 * dt) % 2
		self.death_timer = self.death_timer + dt
	end
end

function Player:draw()
	love.graphics.setColor(0,1,0,1)
	if not state.player.alive then
		if death_timer < 1 then
			love.graphics.draw(self.image_death, self.quads_death[math.floor(self.death_frame) + 1], self.x, self.y - 3 * 2, nil, 2, 2)
		end
	else
		love.graphics.draw(self.image, self.x, self.y - 3 * 2, 0, 2, 2)
		death_timer = 0
	end
end

function Player:postSolve(id)
	if id == 'bullet_invader' or id == 'bullet' then
		self.sound_death:play()
		state.player.alive = false
	end
end

return Player
