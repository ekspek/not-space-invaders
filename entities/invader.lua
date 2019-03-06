local world = require 'world'

return function(x,y)
	local entity = {
		id = 'invader',
		x = x,
		y = y,
		w = 32,
		h = 16,
	}

	entity.body = love.physics.newBody(world, x, y, 'dynamic')
	entity.body:setMass(10)
	entity.body:setLinearVelocity(0,0)
	entity.shape = love.physics.newRectangleShape(entity.w, entity.h)
	entity.fixture = love.physics.newFixture(entity.body, entity.shape)
	entity.fixture:setUserData(entity)

	entity.draw = function(self)
		love.graphics.setColor(1,1,1,1)
		love.graphics.polygon('fill', self.body:getWorldPoints(self.shape:getPoints()))
	end

	return entity
end
