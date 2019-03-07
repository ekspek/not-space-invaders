local state = require 'state'

return function(x,y)
	local entity = {
		id = 'player',
		x = x,
		y = y,
		w = 13 * 2,
		h = 8 * 2,
		speed = 300, -- pixels per second
	}

	entity.quads_death = {}

	entity.load = function(self)
		self.image = love.graphics.newImage("sprites/player.png")
		self.image_death = love.graphics.newImage("sprites/player_death.png")
		table.insert(self.quads_death, love.graphics.newQuad(0, 0, 13, 8, self.image_death:getDimensions()))
		table.insert(self.quads_death, love.graphics.newQuad(16, 0, 13, 8, self.image_death:getDimensions()))
	end

	entity.update = function(self, dt)
		if state.player.left then
			if self.x - self.speed * dt > 0 then
				self.x = self.x - self.speed * dt
			else
				self.x = 0
			end
		elseif state.player.right then
			if self.x + self.speed * dt < love.graphics.getWidth() - self.w then
				self.x = self.x + self.speed * dt
			else
				self.x = love.graphics.getWidth() - self.w
			end
		end
	end

	entity.draw = function(self)
		love.graphics.setColor(0,1,0,1)
		love.graphics.draw(self.image, self.x, self.y, 0, 2, 2)
	end

	return entity
end
