local world = require 'world'

return function(x,y,angle)
	local entity = {
		id = 'bullet_invader',
		x = x,
		y = y,
		w = 2,
		h = 8 * 2,
		angle = angle * math.pi / 180,
		speed = 200,
		remove = false,
	}

    entity.quads = {}
    local bullet_frame = 0
	local chance = math.random(1,3)

	entity.body = love.physics.newBody(world, entity.x, entity.y, 'dynamic')
	entity.shape = love.physics.newRectangleShape(entity.w, entity.h)
	entity.fixture = love.physics.newFixture(entity.body, entity.shape)
	entity.fixture:setUserData(entity)
	
	local ox, oy, mass, inertia = entity.body:getMassData()
	entity.body:setMassData(ox, oy, mass, inertia)
	
	entity.body:setLinearVelocity(entity.speed * math.cos(entity.angle - (math.pi / 2)), -entity.speed * math.sin(entity.angle - (math.pi / 2)))
	entity.body:setAngle(-entity.angle)
	entity.body:setBullet(true)
    
    entity.image = love.graphics.newImage("sprites/bullet.png")
    local bar = love.graphics.newQuad(0, 0, 3, 8, entity.image:getDimensions())
    local slash = love.graphics.newQuad(8, 0, 3, 8, entity.image:getDimensions())
    local wave = {
		love.graphics.newQuad(16, 0, 3, 8, entity.image:getDimensions()),
		love.graphics.newQuad(24, 0, 3, 8, entity.image:getDimensions()),
	}

	entity.update = function(self, dt)
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
        
        bullet_frame = (bullet_frame + 12 * dt) % 4
	end

	entity.draw = function(self)
		local x, y = self.body:getWorldPoints(self.shape:getPoints())
		x = x - 2
		
		love.graphics.setColor(1,1,1,1)
        if chance == 1 then
            love.graphics.draw(self.image, slash, x, y, self.body:getAngle(), 2, 2)
            love.graphics.draw(self.image, bar, x + math.sin(-self.body:getAngle()) * (15 + math.floor(bullet_frame) * -5), y + math.cos(-self.body:getAngle()) * (15 + math.floor(bullet_frame) * -5), self.body:getAngle(), 2, 2)
        elseif chance == 2 then
            love.graphics.draw(self.image, wave[math.floor(bullet_frame % 2) + 1], x, y, self.body:getAngle(), 2, 2)
        elseif chance == 3 then
			love.graphics.draw(self.image, slash, x, y, self.body:getAngle(), 2, 2)
			love.graphics.setColor(1,1,1,math.floor(bullet_frame % 2))
            love.graphics.draw(self.image, wave[math.floor(bullet_frame / 3) + 1], x, y + 4 * math.floor(bullet_frame / 3), self.body:getAngle(), 2, 2)
        end
	end
	
	entity.postSolve = function(self, id)
		for _, id_list in pairs({'invader1', 'invader2', 'invader3', 'border', 'border_bottom', 'player'}) do
			if id == id_list then
				self.body:setLinearVelocity(0,0)
				self.body:setAngularVelocity(0,0)
				self.remove = true
				self.fixture:destroy()
			end
		end
	end

	return entity
end
