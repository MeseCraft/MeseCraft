looped_node_sound = {}

--looped_node_sound.register({
--	node_list = {},
--	sound = <SimpleSoundSpec>,
--	radius = ,
--	cycle_time =,
--	gain_per_node =,
--	max_gain =,
--	max_hear_distance =,	
--})

looped_node_sound.register = function(def)
	local handles = {}
	local timer = 0
	
	-- Parameters
	local radius = def.radius or 8 -- node search radius around player
	local cycle = def.cycle_time or 3 -- Cycle time for sound updates
	assert(def.node_list, "[looped_sound_node] register function called without a node_list in its definition")
	assert(def.sound, "[looped_sound_node] register function called without a sound in its definition")
	local node_list = def.node_list
	local sound = def.sound
	local gain_per_node = def.gain_per_node or 0.125
	local gain_max = def.max_gain or 1.0
	local max_hear_distance = def.max_hear_distance or 32

	-- Update sound for player
	local function update_player_sound(player)
		local player_name = player:get_player_name()
		-- Search for nodes in radius around player
		local ppos = player:get_pos()
		local areamin = vector.subtract(ppos, radius)
		local areamax = vector.add(ppos, radius)
		local fpos, num = minetest.find_nodes_in_area(
			areamin,
			areamax,
			node_list
		)
		-- Total number of nodes in radius
		local total = 0
		for _, count in pairs(num) do
			total = total + count
		end
		-- Stop previous sound
		if handles[player_name] then
			minetest.sound_stop(handles[player_name])
		end
		-- If nodes
		if total > 0 then
			-- Find centre of node positions
			local fposmid = fpos[1]
			-- If more than 1 node
			if #fpos > 1 then
				local fposmin = areamax
				local fposmax = areamin
				for i = 1, #fpos do
					local fposi = fpos[i]
					if fposi.x > fposmax.x then
						fposmax.x = fposi.x
					end
					if fposi.y > fposmax.y then
						fposmax.y = fposi.y
					end
					if fposi.z > fposmax.z then
						fposmax.z = fposi.z
					end
					if fposi.x < fposmin.x then
						fposmin.x = fposi.x
					end
					if fposi.y < fposmin.y then
						fposmin.y = fposi.y
					end
					if fposi.z < fposmin.z then
						fposmin.z = fposi.z
					end
				end
				fposmid = vector.divide(vector.add(fposmin, fposmax), 2)
			end
			-- Play sound
			local handle = minetest.sound_play(sound, {
				pos = fposmid,
				to_player = player_name,
				gain = math.min(total * gain_per_node, gain_max),
				max_hear_distance = max_hear_distance,
				loop = true -- In case of lag
			})
			-- Store sound handle for this player
			if handle then
				handles[player_name] = handle
			else
				handles[player_name] = nil
			end
		else
			handles[player_name] = nil
		end
	end

	-- Cycle for updating players sounds
	minetest.register_globalstep(function(dtime)
		timer = timer + dtime
		if timer < cycle then
			return
		end

		timer = 0
		local players = minetest.get_connected_players()
		for n = 1, #players do
			update_player_sound(players[n])
		end
	end)

	-- Stop sound and clear handle on player leave
	minetest.register_on_leaveplayer(function(player)
		local player_name = player:get_player_name()
		if handles[player_name] then
			minetest.sound_stop(handles[player_name])
			handles[player_name] = nil
		end
	end)
end