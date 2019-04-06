local state = require 'state'
local world = require 'world'

return function(x,y)
	local entity = {
		id = 'border',
		x = x,
		y = y,
		w = 22 * 2,
		h = 16 * 2,
		health = 10,
	}

	entity.body = love.physics.newBody(world, entity.x, entity.y, 'static')
	entity.shape = love.physics.newRectangleShape(entity.w, entity.h)
	entity.fixture = love.physics.newFixture(entity.body, entity.shape)
	entity.fixture:setUserData(entity)

	entity.load = function(self)
		entity.image = love.graphics.newImage("sprites/barrier.png")
	end

	entity.update = function(self, dt)
		if self.health <= 0 then
			self.remove = true
			self.fixture:destroy()
		end
	end

	entity.draw = function(self)
		local x, y = self.body:getWorldPoints(self.shape:getPoints())
		love.graphics.setColor(0,1,0,self.health / 10)
		love.graphics.draw(self.image, x, y, self.body:getAngle(), 2, 2)
	end

	entity.postSolve = function(self, id)
		for _, id_list in pairs({'bullet', 'bullet_invader'}) do
			if id == id_list then
				if self.health > 0 then
					self.health = self.health - 1
				end
			end
		end
	end

	return entity
end
