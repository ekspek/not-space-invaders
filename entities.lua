local player = require 'entities.player'
local invader = require 'entities.invader'
local bullet = require 'entities.bullet'
local bullet = require 'entities.bullet_invader'
local border = require 'entities.border'
local debug = require 'entities.debug'

local entities = {
	player(love.graphics.getWidth() / 2 - 16, love.graphics.getHeight() * 0.8),
	border(-10, 0, 10, love.graphics.getHeight()),
	border(love.graphics.getWidth(), 0, 10, love.graphics.getHeight()),
	debug(),
}

for i = 1,11 do
	table.insert(entities, invader((20 + ((love.graphics.getWidth() - 40) / 11) * i) - 16, 40 + 30, 3))
end

for j = 2,3 do
	for i = 1,11 do
		table.insert(entities, invader((20 + ((love.graphics.getWidth() - 40) / 11) * i) - 16, 40 + j * 30, 2))
	end
end

for j = 4,5 do
	for i = 1,11 do
		table.insert(entities, invader((20 + ((love.graphics.getWidth() - 40) / 11) * i) - 16, 40 + j * 30, 1))
	end
end

return entities
