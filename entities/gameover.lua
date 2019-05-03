local Class = require 'libs.hump.class'
local Entity = require 'entity'

local font = require 'font'

local Gameover = Class{ __includes = Entity }

function Gameover:init()
	self.id = 'gameover'
	self.w = 200
	self.h = 50

	self.x = love.graphics.getWidth() / 2 - self.w / 2
	self.y = love.graphics.getHeight() / 2 - self.h / 2

	self.timer = 0
	self.string = "GAME OVER"
end

function Gameover:draw()
	love.graphics.setColor(love.graphics.getBackgroundColor())
	love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)

	love.graphics.setFont(font)
	love.graphics.setColor(1,1,1,1)
	love.graphics.printf(self.string, self.x, self.y + (self.h / 2) - (font:getHeight() / 2), self.w, 'center')
end

return Gameover
