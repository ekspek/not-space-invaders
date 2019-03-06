return function(x, y)
	local entity = {
		id = 'invader'
		x = x,
		y = y,
		w = 32,
		h = 16,
	}

	entity.draw = function(self)
		love.graphics.setColor(1,1,1,1)
		love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
	end

	return entity
end
