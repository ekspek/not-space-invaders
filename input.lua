local pressmap = {
	escape = function() love.event.quit() end,
	space = function() Gamestate.current().player.firebuffer = true end,
	left = function() Gamestate.current().player.left = true end,
	right = function() Gamestate.current().player.right = true end,
	f = function() Gamestate.current().player.firehold = true end,
}

local releasemap = {
	space = function() Gamestate.current().player.firebuffer = false end,
	left = function() Gamestate.current().player.left = false end,
	right = function() Gamestate.current().player.right = false end,
	f = function() Gamestate.current().player.firehold = false end,
}

local pressmap_joystick = {
	dpleft = pressmap.left,
	dpright = pressmap.right,
	y = pressmap.f,
	b = pressmap.space,
}

local releasemap_joystick = {
	dpleft = releasemap.left,
	dpright = releasemap.right,
	y = releasemap.f,
	b = releasemap.space,
}

return {
	press = function(key)
		if pressmap[key] then
			pressmap[key]()
		elseif pressmap_joystick[key] then
			pressmap_joystick[key]()
		end
	end,
	release = function(key)
		if releasemap[key] then
			releasemap[key]()
		elseif releasemap_joystick[key] then
			releasemap_joystick[key]()
		end
	end,
}

