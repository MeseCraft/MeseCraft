
jumpdrive.fleet = {}

-- applies the new coordinates derived from the relative position of the controller
jumpdrive.fleet.apply_coordinates = function(controllerPos, targetPos, engine_pos_list)
	-- delta between source and target
	local delta_vector = vector.subtract(targetPos, controllerPos)
	minetest.log("action", "[jumpdrive-fleet] delta-vector: " .. minetest.pos_to_string(delta_vector))

	for _,node_pos in pairs(engine_pos_list) do
		local new_pos = vector.add(node_pos, delta_vector)
		minetest.log("action", "[jumpdrive-fleet] calculated vector: " .. minetest.pos_to_string(new_pos))
		jumpdrive.set_meta_pos(node_pos, new_pos)
	end
end

-- sort list by distance, farthest first
jumpdrive.fleet.sort_engines = function(pos, engine_pos_list)
	table.sort(engine_pos_list, function(a,b)
		local a_distance = vector.distance(a, pos)
		local b_distance = vector.distance(b, pos)
		return a_distance > b_distance
	end)
end

-- traverses the backbone and returns a list of engines
jumpdrive.fleet.find_engines = function(pos, visited_hashes, engine_pos_list)

	-- minetest.hash_node_position(pos)
	visited_hashes = visited_hashes or {}
	engine_pos_list = engine_pos_list or {}

	local pos1 = vector.subtract(pos, 1)
	local pos2 = vector.add(pos,1)

	-- load far-away areas
	local manip = minetest.get_voxel_manip()
	manip:read_from_map(pos1, pos2)

	local engine_nodes = minetest.find_nodes_in_area(pos1, pos2, {"jumpdrive:engine"})

	for _,node_pos in pairs(engine_nodes) do
		local hash = minetest.hash_node_position(node_pos)

		if not visited_hashes[hash] then
			-- pos not yet visited
			visited_hashes[hash] = true
			minetest.log("action", "[jumpdrive-fleet] adding engine @ " .. minetest.pos_to_string(node_pos))
			table.insert(engine_pos_list, node_pos)

			jumpdrive.fleet.find_engines(node_pos, visited_hashes, engine_pos_list)
		end
	end

	local backbone_nodes = minetest.find_nodes_in_area(pos1, pos2, {"jumpdrive:backbone"})

	for _,node_pos in pairs(backbone_nodes) do
		local hash = minetest.hash_node_position(node_pos)

		if not visited_hashes[hash] then
			-- pos not yet visited
			visited_hashes[hash] = true

			jumpdrive.fleet.find_engines(node_pos, visited_hashes, engine_pos_list)
		end
	end



	return engine_pos_list
end
