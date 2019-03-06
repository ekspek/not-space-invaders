local invader = {
	w = 32,
	h = 16,
}

invader.draw = function(self,x,y)
	love.graphics.setColor(1,1,1,1)
	love.graphics.rectangle('fill', x, y, invader.w, invader.h)
end

return invader
