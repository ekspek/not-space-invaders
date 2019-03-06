return function(x,y)
	local entity = {
		id = 'bullet',
		x = x,
		y = y,
		w = 2,
		h = 8,
		speed = 300, -- pixels per second
		remove = false
	}

	entity.draw = function(self)
		love.graphics.setColor(1,1,1,1)
		love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
	end

	entity.update = function(self, dt)
		self.y = self.y - self.speed * dt

		if self.y + self.h < -2 then
			self.remove = true
		end
	end

	--entity.getWidth = function(self) return entity.w end
	--entity.getHeight = function(self) return entity.h end

	return entity
end
