local world = love.physics.newWorld(0,0)

local callback = {}

function callback.postSolve(fixture_a, fixture_b, contact)
	local a = fixture_a:getUserData()
	local b = fixture_b:getUserData()

    if a.postSolve then a:postSolve() end
	if b.postSolve then b:postSolve() end
end

world:setCallbacks(nil, nil, nil, callback.postSolve)

return world
