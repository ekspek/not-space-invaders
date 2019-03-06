local player = require 'entities.player'
local invader = require 'entities.invader'
local bullet = require 'entities.bullet'

local bullets = {}

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

	local i = 1
	while i <= #bullets do
		local bullet = bullets[i]

		if bullet.update then bullet:update(dt) end

		if bullet.offscreen then
			table.remove(bullets, i)
		else
			i = i + 1
		end
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
		table.insert(bullets, bullet(player.x + (player.w / 2) - 1, player.y))
	end
end

