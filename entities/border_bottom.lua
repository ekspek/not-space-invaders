local Class = require 'libs.hump.class'
local Entity = require 'entity'

local world = require 'world'
local font = require 'font'

BorderBottom = Class{ __includes = Entity }

function BorderBottom:init(x, y)
	Entity:init()

	self.id = 'border_bottom'
	self.x = x
	self.y = y
	self.w = love.graphics.getWidth()
	self.h = 30

	self.body = love.physics.newBody(world, self.x + (self.w / 2), self.y + (self.h / 2), 'static')
	self.shape = love.physics.newRectangleShape(self.w, self.h)
	self.fixture = love.physics.newFixture(self.body, self.shape)
	self.fixture:setUserData(self)

	self.image = love.graphics.newImage('sprites/player.png')
end

function BorderBottom:draw()
	local x, y = self.body:getWorldPoints(self.shape:getPoints())
	love.graphics.setColor(0,1,0,1)
	love.graphics.rectangle('fill', x, y, self.w, 2)

	for i = 1, math.min(8, (Gamestate.current().player.lives - 1)) do
		love.graphics.draw(self.image, x + 15 + i * 32, y + 4, nil, 2, 2)
	end

	love.graphics.setColor(1,1,1,1)
	love.graphics.setFont(font)
	love.graphics.print(Gamestate.current().player.lives, x + 8, y + 6)
	love.graphics.print("CREDIT 00", x + 300, y + 6)
end

return BorderBottom
