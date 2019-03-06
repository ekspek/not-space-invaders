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

local invader = {
	w = 32,
	h = 16,
}

invader.draw = function(self,x,y)
	love.graphics.setColor(1,1,1,1)
	love.graphics.rectangle('fill', x, y, invader.w, invader.h)
end

player.fire = function()
	local bullet = {
		w = 2,
		h = 8,
		speed = 300, -- pixels per second
	}

	bullet.x = player.x + (player.w / 2) - (bullet.w / 2)
	bullet.y = player.y - bullet.h

	bullet.draw = function(self)
		love.graphics.setColor(1,1,1,1)
		love.graphics.rectangle('fill', bullet.x, bullet.y, bullet.w, bullet.h)
	end

	bullet.update = function(self, dt)
		bullet.y = bullet.y - bullet.speed * dt
	end

	return bullet
end

bullets = {}

function love.load()
	love.graphics.setBackgroundColor(0.1, 0.1, 0.1)
end

function love.update(dt)
	if love.keyboard.isDown('left') then
		if player.x - player.speed * dt > 0 then
			player.x = player.x - player.speed * dt
		else
			player.x = 0
		end
	elseif love.keyboard.isDown('right') then
		if player.x + player.speed * dt < love.graphics.getWidth() - player.w then
			player.x = player.x + player.speed * dt
		else
			player.x = love.graphics.getWidth() - player.w
		end
	end

	for _, bullet in ipairs(bullets) do
		if bullet.update then bullet:update(dt) end
	end
end

function love.draw(dt)
	player.draw()

	for j = 1,5 do
		for i = 1,11 do
			invader:draw(100 + ((love.graphics.getWidth() - 200) / 11) * (i - 1), 20 + j * 50)
		end
	end

	for _, bullet in ipairs(bullets) do
		if bullet.draw then bullet:draw() end
	end
end

function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	end

	if key == 'space' then
		table.insert(bullets, player.fire())
	end
end

