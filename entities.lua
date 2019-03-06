local player = require 'entities.player'
local invader = require 'entities.invader'
local bullet = require 'entities.bullet'

local entities = {
	player(love.graphics.getWidth() / 2 - 16, love.graphics.getHeight() * 0.8),
}

for j = 1,5 do
	for i = 1,11 do
		table.insert(entities, invader(100 + ((love.graphics.getWidth() - 200) / 11) * (i - 1), 20 + j * 50))
	end
end

return entities
