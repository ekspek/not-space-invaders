local player = require 'entities.player'
local invader = require 'entities.invader'
local bullet = require 'entities.bullet'
local debug = require 'entities.debug'

local entities = {
	player(love.graphics.getWidth() / 2 - 16, love.graphics.getHeight() * 0.8),
	debug(),
}

for i = 1,11 do
	table.insert(entities, invader(3, (20 + ((love.graphics.getWidth() - 40) / 11) * i) - 16, 40 + 30))
end

for j = 2,3 do
	for i = 1,11 do
		table.insert(entities, invader(2, (20 + ((love.graphics.getWidth() - 40) / 11) * i) - 16, 40 + j * 30))
	end
end

for j = 4,5 do
	for i = 1,11 do
		table.insert(entities, invader(1, (20 + ((love.graphics.getWidth() - 40) / 11) * i) - 16, 40 + j * 30))
	end
end

return entities
