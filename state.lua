local state = {
	player = {},
	invader = {},
	frame = 0,
	frame_double = 0,
	pace = 5, -- Invader speed
}

state.player.left = false
state.player.right = false
state.player.firebuffer = false
state.player.firehold = false

state.invader.count = 0
state.invader.direction = 'right'

state.update = function(self, dt)
	self.frame_double = (self.frame_double + dt * self.pace) % 2
	self.frame = math.floor(self.frame_double)
end

return state
