local world = require 'world'
local entities = require 'entities'
local bullet = require 'entities.bullet'

function love.load()
	love.graphics.setBackgroundColor(0.1, 0.1, 0.1)
end

function love.update(dt)
	local i = 1
	while i <= #entities do
		local entity = entities[i]

		if entity.update then entity:update(dt) end

		if entity.remove then
			table.remove(entities, i)
		else
			i = i + 1
		end
	end

	world:update(dt)
end

function love.draw(dt)
	for _, entity in ipairs(entities) do
		if entity.draw then entity:draw() end
	end
end

function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	end

	if key == 'space' then
		for _, entity in ipairs(entities) do
			if entity.id then
				if entity.id == 'player' then
					table.insert(entities, bullet(entity.x + (entity.w / 2) - 1, entity.y))
				end
			end
		end
	end
end

