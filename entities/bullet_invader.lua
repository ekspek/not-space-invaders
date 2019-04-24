local Class = require 'libs.hump.class'
local Entity = require 'entity'

local world = require 'world'

local Bullet_invader = Class{ __includes = Entity }

function Bullet_invader:init(x, y, angle)
	self.id = 'bullet_invader'
	self.x = x
	self.y = y
	self.w = 2
	self.h = 8 * 2
	self.angle = angle * math.pi / 180
	self.speed = 200
	self.remove = false

	self.quads = {}
	self.bullet_frame = 0
	self.chance = math.random(1,3)

	self.body = love.physics.newBody(world, self.x, self.y, 'dynamic')
	self.shape = love.physics.newRectangleShape(self.w, self.h)
	self.fixture = love.physics.newFixture(self.body, self.shape)
	self.fixture:setUserData(self)

	local ox, oy, mass, inertia = self.body:getMassData()
	self.body:setMassData(ox, oy, mass + 0.1, inertia)

	self.body:setLinearVelocity(self.speed * math.cos(self.angle - (math.pi / 2)), -self.speed * math.sin(self.angle - (math.pi / 2)))
	self.body:setAngle(-self.angle)
	self.body:setBullet(true)
    
	self.image = love.graphics.newImage("sprites/bullet.png")
	self.bar = love.graphics.newQuad(0, 0, 3, 8, self.image:getDimensions())
	self.slash = love.graphics.newQuad(8, 0, 3, 8, self.image:getDimensions())
	self.wave = {
		love.graphics.newQuad(16, 0, 3, 8, self.image:getDimensions()),
		love.graphics.newQuad(24, 0, 3, 8, self.image:getDimensions()),
	}
end

function Bullet_invader:update(dt)
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

	self.bullet_frame = (self.bullet_frame + 12 * dt) % 4
end

function Bullet_invader:draw()
	local x, y = self.body:getWorldPoints(self.shape:getPoints())
	x = x - 2

	love.graphics.setColor(1,1,1,1)
	if self.chance == 1 then
		love.graphics.draw(self.image, self.slash, x, y, self.body:getAngle(), 2, 2)
		love.graphics.draw(self.image, self.bar, x + math.sin(-self.body:getAngle()) * (15 + math.floor(self.bullet_frame) * -5), y + math.cos(-self.body:getAngle()) * (15 + math.floor(self.bullet_frame) * -5), self.body:getAngle(), 2, 2)
	elseif self.chance == 2 then
		love.graphics.draw(self.image, self.wave[math.floor(self.bullet_frame % 2) + 1], x, y, self.body:getAngle(), 2, 2)
	elseif self.chance == 3 then
		love.graphics.draw(self.image, self.slash, x, y, self.body:getAngle(), 2, 2)
		love.graphics.setColor(1,1,1,math.floor(self.bullet_frame % 2))
		love.graphics.draw(self.image, self.wave[math.floor(self.bullet_frame / 3) + 1], x, y + 4 * math.floor(self.bullet_frame / 3), self.body:getAngle(), 2, 2)
	end
end

function Bullet_invader:postSolve(id)
	for _, id_list in pairs({'invader1', 'invader2', 'invader3', 'border', 'border_bottom', 'player', 'barrier'}) do
		if id == id_list then
			self.body:setLinearVelocity(0,0)
			self.body:setAngularVelocity(0,0)
			self.remove = true
			self.fixture:destroy()
		end
	end
end

return Bullet_invader
