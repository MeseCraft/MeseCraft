local registered_nodes = minetest.registered_nodes
local add_particle = minetest.add_particle
local add_particlespawner = minetest.add_particlespawner
local new = vector.new
local add = vector.add
local subtract = vector.subtract

function tnt.add_effects(pos, radius, drops)
	add_particle({
		pos = pos,
		velocity = new(),
		acceleration = new(),
		expirationtime = 0.4,
		size = radius * 10,
		collisiondetection = false,
		vertical = false,
		texture = "tnt_boom.png",
		glow = 15
	})
	add_particlespawner({
		amount = 64,
		time = 0.5,
		minpos = subtract(pos, radius / 2),
		maxpos = add(pos, radius / 2),
		minvel = {x = -10, y = -10, z = -10},
		maxvel = {x = 10, y = 10, z = 10},
		minacc = new(),
		maxacc = new(),
		minexptime = 1,
		maxexptime = 2.5,
		minsize = radius * 3,
		maxsize = radius * 5,
		texture = "tnt_smoke.png"
	})

	-- we just dropped some items. Look at the items entities and pick
	-- one of them to use as texture
	local texture = "tnt_blast.png" --fallback texture
	local most = 0
	for name, stack in pairs(drops) do
		local count = stack:get_count()
		if count > most then
			most = count
			local def = registered_nodes[name]
			if def and def.tiles and def.tiles[1] then
				texture = def.tiles[1]
			end
		end
	end

	add_particlespawner({
		amount = 64,
		time = 0.1,
		minpos = subtract(pos, radius / 2),
		maxpos = add(pos, radius / 2),
		minvel = {x = -3, y = 0, z = -3},
		maxvel = {x = 3, y = 5,  z = 3},
		minacc = {x = 0, y = -10, z = 0},
		maxacc = {x = 0, y = -10, z = 0},
		minexptime = 0.8,
		maxexptime = 2.0,
		minsize = radius * 0.66,
		maxsize = radius * 2,
		texture = texture,
		collisiondetection = true,
	})
end
