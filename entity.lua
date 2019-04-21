local Class = require 'libs.hump.class'

local Entity = Class{}

function Entity:init()
	love.graphics.setDefaultFilter('linear', 'nearest', 0)
end

function Entity:update(dt)
end

function Entity:draw()
end

return Entity
