local Class = require 'libs.hump.class'
local Entity = require 'entity'

local world = require 'world'

local Bullet = Class{ __includes = Entity }

function Bullet:init(x, y)
	Entity:init()

	self.id = 'bullet'
	self.x = x
	self.y = y
	self.w = 2
	self.h = 8
	self.speed = 500
	self.remove = false

	self.body = love.physics.newBody(world, self.x, self.y, 'dynamic')
	self.shape = love.physics.newRectangleShape(self.w, self.h)
	self.fixture = love.physics.newFixture(self.body, self.shape)
	self.fixture:setUserData(self)
	
	local ox, oy, mass, inertia = self.body:getMassData()
	self.body:setMassData(ox, oy, mass + 0.09, inertia)
	
	self.body:setLinearVelocity(0, -self.speed)
	self.body:setBullet(true)

	sound = love.audio.newSource("sfx/shoot.wav", "static")
	sound:play()
end

function Bullet:update(dt)
	-- Check if outside of playable area
	-- Could be replaced by checking for collision with borders instead
	local border = 0 -- positive means outside screen
	local x1, y1, x2, y2, x3, y3, x4, y4 = self.body:getWorldPoints(self.shape:getPoints())
	self.x = x1
    self.y = y1
	local xmin = math.min(x1, x2, x3, x4)
	local xmax = math.max(x1, x2, x3, x4)
	local ymin = math.min(y1, y2, y3, y4)
	local ymax = math.max(y1, y2, y3, y4)

	self.remove = self.remove
		or xmax < -border
		or xmin > love.graphics.getWidth() + border
		or ymax < -border
		or ymin > love.graphics.getHeight() + border

	local vx, vy = self.body:getLinearVelocity()
	if math.abs(vy) < 50 then self.remove = true end
end

function Bullet:draw()
	love.graphics.setColor(1,1,1,1)
	love.graphics.polygon('fill', self.body:getWorldPoints(self.shape:getPoints()))
end

function Bullet:postSolve(id)
	for _, id_list in pairs({'invader1', 'invader2', 'invader3', 'border', 'border_bottom', 'player', 'barrier'}) do
		if id == id_list then
			self.body:setLinearVelocity(0,0)
			self.body:setAngularVelocity(0,0)
			self.remove = true
			self.fixture:destroy()
		end
	end
end

return Bullet
