local player = {
	w = 32,
	h = 16,
	speed = 300, -- pixels per second
}

player.x = love.graphics.getWidth() / 2 - (player.w / 2)
player.y = love.graphics.getHeight() * 0.8

player.draw = function(self)
	love.graphics.setColor(1,1,1,1)
	love.graphics.rectangle('fill', player.x, player.y, player.w, player.h)
	love.graphics.setColor(love.graphics.getBackgroundColor())
	love.graphics.rectangle('fill', player.x, player.y, player.w, player.h / 2)
	love.graphics.setColor(1,1,1,1)
	love.graphics.rectangle('fill', player.x + (player.w / 2) - 2, player.y, 4, player.h)
end

return player
