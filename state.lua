local state = {
	player = {},
	invader = {},
	frame = 0,
	frame_double = 0,
	pace = 1, -- Invader speed
	pace_initial = 1,
	score1 = 0,
	score2 = 0,
	hiscore = 0,
	credits = 0,
	frozen = false,
	gameover = false,
	win = false,
}

state.player.left = false
state.player.right = false
state.player.firebuffer = false
state.player.firehold = false
state.player.alive = true
state.player.lives = 3
state.timer = 0

state.invader.count = 0
state.invader.direction = 'right'

state.freeze = function(self)
	self.frozen = true
	self.pace_initial = self.pace
	self.pace = 0
	self.frame = 0
	self.frame_double = 0
end

state.unfreeze = function(self)
	self.frozen = false
	self.pace = self.pace_initial
	self.player.alive = true
	self.timer = 0
end

state.update = function(self, dt)
	if not self.player.alive then
		self:freeze()
		
		if not self.gameover then
			if self.timer < 2 then
				self.timer = self.timer + dt
			else
				self.player.lives = self.player.lives - 1
				
				if self.player.lives > 0 then
					self:unfreeze()
				else
					self.gameover = true
				end
			end
		end
	else
		self.frame_double = (self.frame_double + dt * self.pace) % 2
		self.frame = math.floor(self.frame_double)
		
		if self.invader.count <= 0 or self.win then
			self:freeze()
			if self.timer < 1 then
				self.timer = self.timer + dt
			else
				self.win = true
			end
		else
			self.pace = 55 / self.invader.count
		end
	end
end

state.addscore = function(self, score)
	self.score1 = self.score1 + score
end

return state
