local state = require 'state'
local font = require 'font'

return function()
	local entity = {
		id = 'gameover',
		w = 200,
		h = 50,
	}

	entity.x = love.graphics.getWidth() / 2 - entity.w / 2
	entity.y = love.graphics.getHeight() / 2 - entity.h / 2

	local timer = 0
	local string = "GAME OVER"

	entity.draw = function(self)
		love.graphics.setColor(love.graphics.getBackgroundColor())
		love.graphics.rectangle('fill', entity.x, entity.y, entity.w, entity.h)

		love.graphics.setFont(font)
		love.graphics.setColor(1,1,1,1)
		love.graphics.printf(string, entity.x, entity.y + (entity.h / 2) - (font:getHeight() / 2), entity.w, 'center')
	end

	return entity
end
