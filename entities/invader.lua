local world = require 'world'
local state = require 'state'

return function(invader,x,y)
	local entity = {
		id = 'invader' .. invader,
		x = x,
		y = y,
	}
	
	if invader == 1 then
		entity.w = 12 * 2
		entity.h = 8 * 2
	elseif invader == 2 then
		entity.w = 11 * 2
		entity.h = 8 * 2
	elseif invader == 3 then
		entity.w = 8 * 2
		entity.h = 8 * 2
	end
	
	entity.quads = {}

	entity.body = love.physics.newBody(world, x, y, 'dynamic')
	entity.body:setMass(32)
	entity.body:setLinearVelocity(0,0)
	entity.body:setLinearDamping(1)
	entity.body:setAngularDamping(1)
	entity.shape = love.physics.newRectangleShape(entity.w, entity.h)
	entity.fixture = love.physics.newFixture(entity.body, entity.shape)
	entity.fixture:setUserData(entity)
	
	entity.load = function(self)
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
		
		local dx, dy = self.body:getLinearVelocity()
		local dv = math.abs(dx) + math.abs(dy)
		
		if dv < 2 and self.body:getAngularVelocity() < 0.1 then
			self.body:setAngle(0)
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
