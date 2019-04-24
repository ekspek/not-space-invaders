local world = love.physics.newWorld(0,0)

local callback = {}

function callback.beginContact(fixture_a, fixture_b, contact)
	local a = fixture_a:getUserData()
	local b = fixture_b:getUserData()

	if a.beginContact then a:beginContact(b.id) end
	if b.beginContact then b:beginContact(a.id) end
end

function callback.endContact(fixture_a, fixture_b, contact)
	local a = fixture_a:getUserData()
	local b = fixture_b:getUserData()

	if a.endContact then a:endContact(b.id) end
	if b.endContact then b:endContact(a.id) end
end

function callback.preSolve(fixture_a, fixture_b, contact)
	local a = fixture_a:getUserData()
	local b = fixture_b:getUserData()

	if a.preSolve then a:preSolve(b.id) end
	if b.preSolve then b:preSolve(a.id) end
end

function callback.postSolve(fixture_a, fixture_b, contact)
	local a = fixture_a:getUserData()
	local b = fixture_b:getUserData()

	if a.postSolve then a:postSolve(b.id) end
	if b.postSolve then b:postSolve(a.id) end
	--print("Collision detected between " .. a.id .. " and " .. b.id .. ".")
end

world:setCallbacks(callback.beginContact, callback.endContact, callback.preSolve, callback.postSolve)

return world
