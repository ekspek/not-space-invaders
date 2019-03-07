local state = {
	player = {},
	frame = 0,
	frame_double = 0,
	pace = 1, -- Invader speed
	invadercount = 0
}

state.player.left = false
state.player.right = false
state.player.firebuffer = false
state.player.firehold = false

state.update = function(self, dt)
	self.frame_double = (self.frame_double + dt * self.pace) % 2
	self.frame = math.floor(self.frame_double)
end

return state
