local special_leaves = dofile(minetest.get_modpath("leaves_in_the_wind").."/special_leaves.lua")

local pi_over2 = (math.pi/2)
local _3pi_over2 = 3*pi_over2

local ppos, pyaw, dx, dz, yaw, isBehind -- Allocate

minetest.register_abm({
	interval = 30,
	chance = 5,
	catch_up = false,
	nodenames = {"group:leaves"},
	action = function(npos, node, ...)
		if not minetest.registered_nodes[node.name] then return end
		npos.y = npos.y - 1
		local in_node = minetest.registered_nodes[minetest.get_node(npos).name]
		if in_node then
			if in_node.walkable then return end
		else
			return
		end
		--print(minetest.pos_to_string(npos))
		local particle = { --Default leaf particle
			pos = {x=npos.x+0.1,y=npos.y+0.25,z=npos.z+0.1},
			 -- If these aren't floats, for some reason, particles will end up in the corners of nodes.
			-- Implement fix from CupnPlateGames -- https://github.com/MeseCraft/MeseCraft/issues/62
			texture = "(single_leaf_texture_mask"..math.random(1,2)..".png^[mask:"..
			-- Take this leaf's texture and mask it with the shape of a single leaf
			(minetest.registered_nodes[node.name].tiles[1] or "default_leaves.png").. 
			")^[transform"..math.random(0,7), --Flip it around for some randomness
			velocity = {
				x=math.sin((os.clock()%2000)/80)*0.25,
				y = -0.6,
				z=math.sin((os.clock()%2000)/80)*0.33,
			},
			size=2,
			expirationtime = 24,
			collisiondetection = true,
			collision_removal = true,
			vertical = false,
			leaf_spawn_chance = 70,
			spawn_radius = 44
		}
		local override = special_leaves[node.name]
		if type(override) == "table" then
			for k,v in pairs(override) do
				particle[k] = v
			end
		end
		
		for k,v in pairs(particle) do
			if type(v) == "function" then 
				 -- since values in tables are static,
				 -- and we often want things to be a bit more random, 
				 -- let particles implement a function call. 
				particle[k] = v(particle, npos, node, ...)
			end
		end
		
		if math.abs(particle.velocity.x) < 0.01 or math.abs(particle.velocity.z) < 0.01 then
			particle.collision_removal = false
			-- Collision seems to get confused if particles are moving very slowly.
			-- I'm not sure why, but frankly, I'm sick of working with engine code,
			-- so here's me chickening out instead.
		end
		
		if particle.leaf_spawn_chance >= 1 and math.random() < (1/particle.leaf_spawn_chance) then
			for _,player in pairs(minetest.get_connected_players()) do
				ppos = player:get_pos()
				pyaw = player:get_look_horizontal()
				dx = (ppos.x-npos.x)
				dz = (ppos.z-npos.z)
				isBehind = true
				yaw = nil
				
				if dz<0 then
					yaw = -math.atan(dx/dz)
				elseif dz>0 then
					yaw = math.pi-math.atan(dx/dz)
				elseif dx<0 then
					yaw = 0
				else
					yaw = math.pi
				end
				if yaw then
					local yaw_diff = ((yaw - pyaw)%(2*math.pi))
					isBehind = (yaw_diff > pi_over2) and (yaw_diff < _3pi_over2)
				end
				if math.sqrt(
					math.sqrt(dx^2 + dz^2)^2 -- Horizontal hypotenuse
					+
					(ppos.y-npos.y)^2
				) <= (isBehind and (particle.spawn_radius/4) or particle.spawn_radius) then -- Reduce spawn radius significantly behind the player
					particle.playername = player:get_player_name()
					minetest.add_particle(table.copy(particle))
				end
			end
		end
	end,
})
