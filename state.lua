local state = {
	player = {},
	invader = {},
	frame = 0,
	frame_double = 0,
	pace = 1, -- Invader speed
}

state.player.left = false
state.player.right = false
state.player.firebuffer = false
state.player.firehold = false
state.player.alive = true

state.invader.count = 0
state.invader.direction = 'right'

state.update = function(self, dt)
	if not self.player.alive then
		self.pace = 0
		self.frame = 0
		self.frame_double = 0
		self.player.left = false
		self.player.right = false
		self.player.firebuffer = false
		self.player.firehold = false
	else
		self.frame_double = (self.frame_double + dt * self.pace) % 2
		self.frame = math.floor(self.frame_double)
		
		if self.invader.count > 0 then
			self.pace = 55 / self.invader.count
		else
			self.pace = 1
		end
	end
end

return state
