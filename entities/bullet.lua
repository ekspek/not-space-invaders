local world = require 'world'

return function(x,y)
	local entity = {
		id = 'bullet',
		x = x,
		y = y,
		w = 2,
		h = 8,
		speed = 500,
		remove = false,
	}

	entity.body = love.physics.newBody(world, entity.x, entity.y, 'dynamic')
	entity.shape = love.physics.newRectangleShape(entity.w, entity.h)
	entity.fixture = love.physics.newFixture(entity.body, entity.shape)
	entity.fixture:setUserData(entity)
	
	local ox, oy, mass, inertia = entity.body:getMassData()
	entity.body:setMassData(ox, oy, mass + 0.09, inertia)
	
	entity.body:setLinearVelocity(0, -entity.speed)
	entity.body:setBullet(true)

	entity.update = function(self, dt)
		-- Check if outside of playable area
		-- Could be replaced by checking for collision with borders instead
		local border = 0 -- positive means outside screen
		local x1, y1, x2, y2, x3, y3, x4, y4 = self.body:getWorldPoints(self.shape:getPoints())
		self.x = x1
        self.y = y1
		local xmin = math.min(x1, x2, x3, x4)
		local xmax = math.max(x1, x2, x3, x4)
		local ymin = math.min(y1, y2, y3, y4)
		local ymax = math.max(y1, y2, y3, y4)

		self.remove = self.remove
			or xmax < -border
			or xmin > love.graphics.getWidth() + border
			or ymax < -border
			or ymin > love.graphics.getHeight() + border
	end

	entity.draw = function(self)
		love.graphics.setColor(1,1,1,1)
		love.graphics.polygon('fill', self.body:getWorldPoints(self.shape:getPoints()))
	end
	
	entity.postSolve = function(self, id)
		for _, id_list in pairs({'invader1', 'invader2', 'invader3', 'border', 'border_bottom', 'player'}) do
			if id == id_list then
				self.body:setLinearVelocity(0,0)
				self.body:setAngularVelocity(0,0)
				self.remove = true
				self.fixture:destroy()
			end
		end
	end

	return entity
end
