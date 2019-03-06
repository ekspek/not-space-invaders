local world = require 'world'
local state = require 'state'

return function(x,y)
	local entity = {
		id = 'invader',
		x = x,
		y = y,
		w = 22,
		h = 16,
	}
	
	entity.quads = {}

	entity.body = love.physics.newBody(world, x, y, 'dynamic')
	entity.body:setMass(10)
	entity.body:setLinearVelocity(0,0)
	entity.shape = love.physics.newRectangleShape(entity.w, entity.h)
	entity.fixture = love.physics.newFixture(entity.body, entity.shape)
	entity.fixture:setUserData(entity)
	
	entity.load = function(self)
		self.image = love.graphics.newImage("sprites/inv2.png")
		table.insert(self.quads, love.graphics.newQuad(0, 0, 11, 8, self.image:getDimensions()))
		table.insert(self.quads, love.graphics.newQuad(16, 0, 11, 8, self.image:getDimensions()))
	end

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
		local x, y = self.body:getWorldPoints(self.shape:getPoints())
		love.graphics.setColor(1,1,1,1)
		if math.floor(state.second) % 2 == 0 then
			love.graphics.draw(self.image, self.quads[1], x, y, self.body:getAngle(), 2, 2)
		else
			love.graphics.draw(self.image, self.quads[2], x, y, self.body:getAngle(), 2, 2)
		end
	end

	return entity
end
