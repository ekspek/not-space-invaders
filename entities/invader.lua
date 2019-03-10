local world = require 'world'
local state = require 'state'

return function(x,y,invader)
	local entity = {
		id = 'invader' .. invader,
		x = x,
		y = y,
		step = 1,
		
		-- Flags to warn if the horde needs to change directions,
		-- NOT if an invader is outside of the screen.
		outside_right = false,
		outside_left = false,
		
		-- Each invader dies when their health reaches zero
		-- and they stop moving (or get to a really low velocity).
		-- Dying makes the burst animation play, and when this ends
		-- the invader is removed from the entities list.
		alive = true,
		remove = false,
		health = 1,
		
		-- Code to handle projectile fire
		firebuffer = false,
	}
	
	local death_timer = 0.5
	local step_frame = state.frame
	
	if invader == 1 then
		entity.w = 12 * 2
		entity.h = 8 * 2
	elseif invader == 2 then
		entity.w = 11 * 2
		entity.h = 8 * 2
	elseif invader == 3 then
		entity.w = 8 * 2
		entity.h = 8 * 2
	end
	
	entity.body = love.physics.newBody(world, x, y, 'dynamic')
	entity.shape = love.physics.newRectangleShape(entity.w, entity.h)
	entity.fixture = love.physics.newFixture(entity.body, entity.shape)
	entity.fixture:setUserData(entity)
	
	entity.body:setLinearVelocity(0,0)
	--entity.body:setMass(32)
	--entity.body:setInertia(500)
	entity.body:setLinearDamping(1)
	entity.body:setAngularDamping(1)
	
	entity.quads = {}
	
	entity.load = function(self)
		if invader == 1 then
			self.image = love.graphics.newImage("sprites/inv1.png")
			table.insert(self.quads, love.graphics.newQuad(0, 0, 12, 8, self.image:getDimensions()))
			table.insert(self.quads, love.graphics.newQuad(16, 0, 12, 8, self.image:getDimensions()))
		elseif invader == 2 then
			self.image = love.graphics.newImage("sprites/inv2.png")
			table.insert(self.quads, love.graphics.newQuad(0, 0, 11, 8, self.image:getDimensions()))
			table.insert(self.quads, love.graphics.newQuad(16, 0, 11, 8, self.image:getDimensions()))
		elseif invader == 3 then
			self.image = love.graphics.newImage("sprites/inv3.png")
			table.insert(self.quads, love.graphics.newQuad(0, 0, 8, 8, self.image:getDimensions()))
			table.insert(self.quads, love.graphics.newQuad(8, 0, 8, 8, self.image:getDimensions()))
		end
		
		self.image_death = love.graphics.newImage("sprites/burst.png")
	end

	entity.update = function(self, dt)
		-- Check if outside of playable area
		-- Could be replaced by checking for collision with borders instead
		local border_out = 0 -- positive means towards the outside of the screen
		local border_in = 10 -- positive means towards the inside of the screen
		local x1, y1, x2, y2, x3, y3, x4, y4 = self.body:getWorldPoints(self.shape:getPoints())
		self.x = x1
		self.y = y1
		local xmin = math.min(x1, x2, x3, x4)
		local xmax = math.max(x1, x2, x3, x4)
		local ymin = math.min(y1, y2, y3, y4)
		local ymax = math.max(y1, y2, y3, y4)
		
		self.remove = self.remove
			or xmax < -border_out
			or xmin > love.graphics.getWidth() + border_out
			or ymax < -border_out
			or ymin > love.graphics.getHeight() + border_out
		
		self.outside_left = xmin < border_in
		self.outside_right = xmax > love.graphics.getWidth() - border_in
		
		-- Resetting the angle when velocity is low
		local dx, dy = self.body:getLinearVelocity()
		local dv = math.abs(dx) + math.abs(dy)
		
		if dv < 2 and self.body:getAngularVelocity() < 0.1 then
			if self.health <= 0 then
				self.alive = false
			else
				self.body:setAngle(0)
				if step_frame ~= state.frame then
					step_frame = state.frame
					
					local x, y = self.body:getPosition()
					if state.invader.direction == 'right' then
						self.body:setPosition(x + 2, y)
					elseif state.invader.direction == 'left' then
						self.body:setPosition(x - 2, y)
					elseif state.invader.direction == 'down' then
						self.body:setPosition(x, y + 10)
					end
				end
			end
		end
		
		if not self.alive then
			death_timer = death_timer - dt
			if death_timer <= 0 then
				self.fixture:destroy()
				self.remove = true
			end
		end
	end

	entity.draw = function(self)
		local x, y = self.body:getWorldPoints(self.shape:getPoints())
		self.x = x1
        self.y = y1
		if not self.alive then
			love.graphics.setColor(1,1,1,0.5)
			love.graphics.draw(self.image_death, x, y, self.body:getAngle(), 2, 2)
		else
			love.graphics.setColor(1, 1, 1, self.health + 0.5)
			love.graphics.draw(self.image, self.quads[state.frame + 1], x, y, self.body:getAngle(), 2, 2)
		end
	end
	
	-- Mostly a debugging method for now
	entity.fire = function(self)
		self.firebuffer = true
	end
	
	entity.postSolve = function(self, id)
		for _, id_list in pairs({'bullet', 'bullet_invader'}) do
			if id == id_list then
				if self.health > 0 then
					self.health = self.health - 1
				end
			end
		end
	end

	return entity
end
