local state = require 'state'
local world = require 'world'
local font = require 'font'

return function(x,y)
	local entity = {
		id = 'border_bottom',
		x = x,
		y = y,
		w = love.graphics.getWidth(),
		h = 30,
	}

	entity.body = love.physics.newBody(world, entity.x + (entity.w / 2), entity.y + (entity.h / 2), 'static')
	entity.shape = love.physics.newRectangleShape(entity.w, entity.h)
	entity.fixture = love.physics.newFixture(entity.body, entity.shape)
	entity.fixture:setUserData(entity)

	entity.load = function(self)
		self.image = love.graphics.newImage('sprites/player.png')
	end

	entity.draw = function(self)
		local x, y = self.body:getWorldPoints(self.shape:getPoints())
		love.graphics.setColor(0,1,0,1)
		love.graphics.rectangle('fill', x, y, self.w, 2)

		for i = 1, math.min(8, (state.player.lives - 1)) do
			love.graphics.draw(self.image, x + 15 + i * 32, y + 4, nil, 2, 2)
		end

		love.graphics.setColor(1,1,1,1)
		love.graphics.setFont(font)
		love.graphics.print(state.player.lives, x + 8, y + 6)
		love.graphics.print("CREDIT 00", x + 300, y + 6)
	end

	return entity
end
