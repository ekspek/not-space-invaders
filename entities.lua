local player = require 'entities.player'
local invader = require 'entities.invader'
local bullet = require 'entities.bullet'
local bullet_invader = require 'entities.bullet_invader'
local barrier = require 'entities.barrier'
local border = require 'entities.border'
local border_bottom = require 'entities.border_bottom'
local border_top = require 'entities.border_top'
local gameover = require 'entities.gameover'
local debug = require 'entities.debug'

local entities = {
	border(-10, 0, 10, love.graphics.getHeight()),
	border(love.graphics.getWidth(), 0, 10, love.graphics.getHeight()),
	border_top(0,0),
	border_bottom(0, love.graphics.getHeight() - 30),

	player(love.graphics.getWidth() / 2 - 16, love.graphics.getHeight() * 0.9),
	--debug(),
}

--[[
for i = 1,11 do
	table.insert(entities, invader((20 + ((love.graphics.getWidth() - 40) / 11) * i) - 16, 100 + 30, 3))
end

for j = 2,3 do
	for i = 1,11 do
		table.insert(entities, invader((20 + ((love.graphics.getWidth() - 40) / 11) * i) - 16, 100 + j * 30, 2))
	end
end

for j = 4,5 do
	for i = 1,11 do
		table.insert(entities, invader((20 + ((love.graphics.getWidth() - 40) / 11) * i) - 16, 100 + j * 30, 1))
	end
end

for i = 1,4 do
	table.insert(entities, barrier((love.graphics.getWidth() / 5) * i, love.graphics.getHeight() * 0.8))
end

entities.respawnInvaders = function(self, dt)
	for i = 1,11 do
		table.insert(entities, invader((20 + ((love.graphics.getWidth() - 40) / 11) * i) - 16, 100 + 30, 3))
	end
	
	for j = 2,3 do
		for i = 1,11 do
			table.insert(entities, invader((20 + ((love.graphics.getWidth() - 40) / 11) * i) - 16, 100 + j * 30, 2))
		end
	end
	
	for j = 4,5 do
		for i = 1,11 do
			table.insert(entities, invader((20 + ((love.graphics.getWidth() - 40) / 11) * i) - 16, 100 + j * 30, 1))
		end
	end

	for i = 1,4 do
		table.insert(entities, barrier((love.graphics.getWidth() / 5) * i, love.graphics.getHeight() * 0.8))
	end

	for _, entity in ipairs(entities) do
		if entity.load then entity:load() end
	end
end
--]]

entities.update = function(self, dt)
end

return entities
