local state = require 'state'

return function(x,y)
	local entity = {
		id = 'player',
		x = x,
		y = y,
		w = 32,
		h = 16,
		speed = 300, -- pixels per second
	}

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
		love.graphics.setColor(1,1,1,1)
		love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
		love.graphics.setColor(love.graphics.getBackgroundColor())
		love.graphics.rectangle('fill', self.x, self.y, self.w, self.h / 2)
		love.graphics.setColor(1,1,1,1)
		love.graphics.rectangle('fill', self.x + (self.w / 2) - 2, self.y, 4, self.h)
	end

	return entity
end
