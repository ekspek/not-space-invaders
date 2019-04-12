local sfx = {}

sfx.invadermove = {
	love.audio.newSource("sfx/fastinvader1.wav", "static"),
	love.audio.newSource("sfx/fastinvader2.wav", "static"),
	love.audio.newSource("sfx/fastinvader3.wav", "static"),
	love.audio.newSource("sfx/fastinvader4.wav", "static"),
	index = 1,
}

sfx.invadermove.update = function(self)
	self[self.index]:play()
	if self.index >= 4 then
		self.index = 1
	else
		self.index = self.index + 1
	end
end

return sfx
