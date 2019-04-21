local bullet_invader = require 'entities.bullet_invader'
local gameover = require 'entities.gameover'
local debug = require 'entities.debug'

local Player = require 'entities.player'
local Invader = require 'entities.invader'
local Barrier = require 'entities.barrier'
local Border = require 'entities.border'
local Border_bottom = require 'entities.border_bottom'
local Border_top = require 'entities.border_top'
local Bullet = require 'entities.bullet'

local entities = {
	Border(-10, 0, 10, love.graphics.getHeight()),
	Border(love.graphics.getWidth(), 0, 10, love.graphics.getHeight()),
	Border_top(0,0),
	Border_bottom(0, love.graphics.getHeight() - 30),

	--debug(),
	Player(love.graphics.getWidth() / 2 - 16, love.graphics.getHeight() * 0.9),
}

for i = 1,11 do
	table.insert(entities, Invader((20 + ((love.graphics.getWidth() - 40) / 11) * i) - 16, 100 + 30, 3))
end

for j = 2,3 do
	for i = 1,11 do
		table.insert(entities, Invader((20 + ((love.graphics.getWidth() - 40) / 11) * i) - 16, 100 + j * 30, 2))
	end
end

for j = 4,5 do
	for i = 1,11 do
		table.insert(entities, Invader((20 + ((love.graphics.getWidth() - 40) / 11) * i) - 16, 100 + j * 30, 1))
	end
end

for i = 1,4 do
	table.insert(entities, Barrier((love.graphics.getWidth() / 5) * i, love.graphics.getHeight() * 0.8))
end

entities.respawnInvaders = function(self, dt)
	for i = 1,11 do
		table.insert(entities, Invader((20 + ((love.graphics.getWidth() - 40) / 11) * i) - 16, 100 + 30, 3))
	end
	
	for j = 2,3 do
		for i = 1,11 do
			table.insert(entities, Invader((20 + ((love.graphics.getWidth() - 40) / 11) * i) - 16, 100 + j * 30, 2))
		end
	end
	
	for j = 4,5 do
		for i = 1,11 do
			table.insert(entities, Invader((20 + ((love.graphics.getWidth() - 40) / 11) * i) - 16, 100 + j * 30, 1))
		end
	end

	for i = 1,4 do
		table.insert(entities, Barrier((love.graphics.getWidth() / 5) * i, love.graphics.getHeight() * 0.8))
	end
end

entities.update = function(self, dt)
end

return entities
