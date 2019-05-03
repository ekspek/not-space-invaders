local Timer = require 'libs.hump.timer'

local state = {
	player = {},
	invader = {},
	pace = 1, -- Invader speed
	pace_initial = 1,
	score1 = 0,
	score2 = 0,
	hiscore = 0,
	credits = 0,
	frozen = false,
	gameover = false,
	reset = false,
	level = 1,
}

state.player.left = false
state.player.right = false
state.player.firebuffer = false
state.player.bullets = 0
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

		-- When the invader count is zero, activates the rest flag,
		-- increases the player's lives by one and resets the horde
		-- direction
		if self.invader.count <= 0 then
			self.reset = true
			self.player.lives = self.player.lives + 1
			self.invader.direction = 'right'
		else
			self.reset = false
			self.pace = math.max(1, math.floor((55 / self.invader.count)^1.5 * (1 + ((self.level - 1) * 0.3))))
		end
	end
end

state.addscore = function(self, score)
	self.score1 = self.score1 + score
end

return state
