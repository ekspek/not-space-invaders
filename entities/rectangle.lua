local Class = require 'libs.hump.class'
local Entity = require 'entity'

local Rectangle = Class{ __includes = Entity }

function Rectangle:init(x, y, w, h)
	self.x = x
	self.y = y
	self.w = w
	self.h = h
end

function Rectangle:update(dt)
	self.x = self.x + 5 * dt
	self.y = self.y + 5 * dt
end

function Rectangle:draw()
	love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
end
