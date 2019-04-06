local state = require 'state'
local font = require 'font'

return function(x,y)
	local entity = {
		id = 'border_top',
		x = x,
		y = y,
		w = love.graphics.getWidth(),
		h = 30,
	}

	entity.load = function(self)
	end

	entity.draw = function(self)
		love.graphics.setColor(love.graphics.getBackgroundColor())
		love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)

		local measures = {
			math.floor(love.graphics.getWidth() / 3),
			math.floor(2 * love.graphics.getWidth() / 3),
			4,
			4 + font:getHeight() + 14
		}

		love.graphics.setColor(1,1,1,1)
		love.graphics.setFont(font)
		love.graphics.printf("SCORE<1>", 0, measures[3], measures[1], 'center')
		love.graphics.printf("HI-SCORE", measures[1], measures[3], measures[1], 'center')
		love.graphics.printf("SCORE<2>", measures[2], measures[3], measures[1], 'center')
		love.graphics.printf(string.format("%.4d", state.score1), 0, measures[4], measures[1], 'center')
		love.graphics.printf(string.format("%.4d", state.hiscore), measures[1], measures[4], measures[1], 'center')
		love.graphics.printf(string.format("%.4d", state.score2), measures[2], measures[4], measures[1], 'center')
	end

	return entity
end
