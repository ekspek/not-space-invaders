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

	entity.update = function(self, dt)
		-- Check if outside of playable area
		-- Could be replaced by checking for collision with borders instead
		local border = 40 -- positive means outside screen
		local x1, y1, x2, y2, x3, y3, x4, y4 = self.body:getWorldPoints(self.shape:getPoints())
		local xmin = math.min(x1, x2, x3, x4)
		local xmax = math.max(x1, x2, x3, x4)
		local ymin = math.min(y1, y2, y3, y4)
		local ymax = math.max(y1, y2, y3, y4)

		if xmin < -border or xmax > love.graphics.getWidth() + border then
			self.remove = true
		end
		if ymin < -border or ymax > love.graphics.getHeight() + border then
			self.remove = true
		end
	end

	entity.draw = function(self)
		love.graphics.setColor(1,1,1,1)
		love.graphics.polygon('fill', self.body:getWorldPoints(self.shape:getPoints()))
	end

	return entity
end
