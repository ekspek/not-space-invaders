local Class = require 'libs.hump.class'
local Entity = require 'entity'

local font = require 'font'

BorderTop = Class{ __includes = Entity }

function BorderTop:init(x, y)
	Entity:init()

	self.id = 'border_top'
	self.x = x
	self.y = y
	self.w = love.graphics.getWidth()
	self.h = 30
end

function BorderTop:draw()
	love.graphics.setColor(love.graphics.getBackgroundColor())
	love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)

	local measures = {
		math.floor(love.graphics.getWidth() / 3),
		math.floor(2 * love.graphics.getWidth() / 3),
		4,
		4 + font:getHeight() + 14
	}

	love.graphics.setColor(1,1,1,1)
	love.graphics.setFont(font)
	love.graphics.printf("SCORE<1>", 0, measures[3], measures[1], 'center')
	love.graphics.printf("HI-SCORE", measures[1], measures[3], measures[1], 'center')
	love.graphics.printf("SCORE<2>", measures[2], measures[3], measures[1], 'center')
	love.graphics.printf(string.format("%.4d", Gamestate.current().score1), 0, measures[4], measures[1], 'center')
	love.graphics.printf(string.format("%.4d", Gamestate.current().hiscore), measures[1], measures[4], measures[1], 'center')
	love.graphics.printf(string.format("%.4d", Gamestate.current().score2), measures[2], measures[4], measures[1], 'center')
end

return BorderTop

