return function(x,y)
	local bullet = {
		x = x,
		y = y,
		w = 2,
		h = 8,
		speed = 300, -- pixels per second
		offscreen = false
	}

	bullet.draw = function(self)
		love.graphics.setColor(1,1,1,1)
		love.graphics.rectangle('fill', bullet.x, bullet.y, bullet.w, bullet.h)
	end

	bullet.update = function(self, dt)
		bullet.y = bullet.y - bullet.speed * dt

		if bullet.y + bullet.h < -2 then
			bullet.offscreen = true
		end
	end

	--bullet.getWidth = function(self) return bullet.w end
	--bullet.getHeight = function(self) return bullet.h end

	return bullet
end
