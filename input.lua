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

return {
	press = function(key)
		if pressmap[key] then
			pressmap[key]()
		end
	end,
	release = function(key)
		if releasemap[key] then
			releasemap[key]()
		end
	end,
}

