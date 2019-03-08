local state = require 'state'

local pressmap = {
	escape = function() love.event.quit() end,
	space = function() state.player.firebuffer = true end,
	left = function() state.player.left = true end,
	right = function() state.player.right = true end,
	f = function() state.player.firehold = true end,
}

local releasemap = {
	space = function() state.player.firebuffer = false end,
	left = function() state.player.left = false end,
	right = function() state.player.right = false end,
	f = function() state.player.firehold = false end,
}

local pressmap_joystick = {
	dpleft = pressmap.left,
	dpright = pressmap.right,
	y = pressmap.f,
}

local releasemap_joystick = {
	dpleft = releasemap.left,
	dpright = releasemap.right,
	y = releasemap.f,
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

