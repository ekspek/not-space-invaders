local Class = require 'libs.hump.class'
local Entity = require 'entity'

local state = require 'state'

local Debug = Class{ __includes = Entity }

function Debug:init()
	Entity:init()

	self.fps = 0
end

function Debug:update(dt)
	self.fps = math.floor(1/dt)
end

function Debug:draw()
	love.graphics.setColor(1,1,1,1)
	love.graphics.getFont()
	love.graphics.print("fps = " .. self.fps, 0, love.graphics.getHeight() - 15)
	love.graphics.print("frame = " .. state.frame_double, 0, love.graphics.getHeight() - 30)
	love.graphics.print("invaders = " .. state.invader.count, 0, love.graphics.getHeight() - 45)
	love.graphics.print("direction = " .. state.invader.direction, 0, love.graphics.getHeight() - 60)
end

return Debug
