local Class = require 'libs.hump.class'
local Entity = require 'entity'
local world = require 'world'

local Barrier = Class{ __includes = Entity }

function Barrier:init(x, y)
	Entity:init()

	self.id = 'barrier'
	self.x = x
	self.y = y
	self.w = 22 * 2
	self.h = 16 * 2

	self.health_init = 20
	self.health = self.health_init

	self.body = love.physics.newBody(world, self.x, self.y, 'static')
	self.shape = love.physics.newRectangleShape(self.w, self.h)
	self.fixture = love.physics.newFixture(self.body, self.shape)
	self.fixture:setUserData(self)

	self.image = love.graphics.newImage("sprites/barrier.png")
end

function Barrier:update(dt)
	if self.health <= 0 then
		self.remove = true
		self.fixture:destroy()
	end
end

function Barrier:draw()
	local x, y = self.body:getWorldPoints(self.shape:getPoints())
	love.graphics.setColor(0,1,0,self.health / self.health_init)
	love.graphics.draw(self.image, x, y, self.body:getAngle(), 2, 2)
end

function Barrier:postSolve(id)
	for _, id_list in pairs({'bullet', 'bullet_invader'}) do
		if id == id_list then
			if self.health > 0 then
				self.health = self.health - 1
			end
		end
	end
end

return Barrier
