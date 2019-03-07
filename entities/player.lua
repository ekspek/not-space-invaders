local state = require 'state'
local world = require 'world'

return function(x,y)
	local entity = {
		id = 'player',
		x = x,
		y = y,
		w = 13 * 2,
		h = 8 * 2,
		speed = 300, -- pixels per second
		alive = true,
	}

	entity.quads_death = {}
	local death_frame = 0
	
	entity.body = love.physics.newBody(world, entity.x, entity.y, 'kinematic')
	entity.shape = love.physics.newRectangleShape(entity.w, entity.h - 3 * 2)
	entity.fixture = love.physics.newFixture(entity.body, entity.shape)
	entity.fixture:setUserData(entity)

	entity.load = function(self)
		self.image = love.graphics.newImage("sprites/player.png")
		self.image_death = love.graphics.newImage("sprites/player_death.png")
		table.insert(self.quads_death, love.graphics.newQuad(-1, 0, 13, 8, self.image_death:getDimensions()))
		table.insert(self.quads_death, love.graphics.newQuad(16, 0, 13, 8, self.image_death:getDimensions()))
	end

	entity.update = function(self, dt)
		self.x, self.y = self.body:getWorldPoints(self.shape:getPoints())
		
		if state.player.left == state.player.right then
			self.body:setLinearVelocity(0,0)
		elseif state.player.left then
			if self.x - self.speed * dt > 0 then
				self.body:setLinearVelocity(-self.speed, 0)
			else
				self.x = 0
				self.body:setLinearVelocity(0,0)
			end
		elseif state.player.right then
			if self.x + self.speed * dt < love.graphics.getWidth() - self.w then
				self.body:setLinearVelocity(self.speed, 0)
			else
				self.x = love.graphics.getWidth() - self.w
				self.body:setLinearVelocity(0,0)
			end
		end
		
		death_frame = (death_frame + 12 * dt) % 2
	end

	entity.draw = function(self)
		love.graphics.setColor(0,1,0,1)
		if not self.alive then
			love.graphics.draw(self.image_death, self.quads_death[math.floor(death_frame) + 1], self.x, self.y - 3 + 2, nil, 2, 2)
		else
			love.graphics.draw(self.image, self.x, self.y - 3 * 2, 0, 2, 2)
		end
	end

	return entity
end
