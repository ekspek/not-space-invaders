local Class = require 'libs.hump.class'
local Entity = require 'entity'

local state = require 'state'
local world = require 'world'

Border = Class{ __includes = Entity }

function Border:init(x,y,w,h)
	Entity:init()

	self.id = 'border'
	self.x = x
	self.y = y
	self.w = w
	self.h = h

	self.body = love.physics.newBody(world, self.x + (self.w / 2), self.y + (self.h / 2), 'static')
	self.shape = love.physics.newRectangleShape(self.w, self.h)
	self.fixture = love.physics.newFixture(self.body, self.shape)
	self.fixture:setRestitution(2)
	self.fixture:setFriction(1)
	self.fixture:setUserData(self)
end

return Border
