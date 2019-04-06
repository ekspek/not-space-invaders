local state = require 'state'
local world = require 'world'

return function(x,y,w,h)
	local entity = {
		id = 'border',
		x = x,
		y = y,
		w = w,
		h = h,
	}

	entity.body = love.physics.newBody(world, entity.x + (entity.w / 2), entity.y + (entity.h / 2), 'static')
	entity.shape = love.physics.newRectangleShape(entity.w, entity.h)
	entity.fixture = love.physics.newFixture(entity.body, entity.shape)
	entity.fixture:setRestitution(2)
	entity.fixture:setFriction(1)
	entity.fixture:setUserData(entity)

	return entity
end
