local rope_nodes = { -- Top, middle, bottom
	{"ropes:rope_top", "ropes:rope", "ropes:rope_bottom"}, -- Rope boxes
	{"ropes:ropeladder_falling", "ropes:ropeladder", "ropes:ropeladder_bottom"}, -- Rope ladders
}

jumpdrive.ropes_compat = function(target_pos1, target_pos2, delta_vector)
	if ropes == nil or
			ropes.destroy_rope == nil then
		-- Something is wrong. Don't do anything
		return
	end

	-- Bottom slice of the target area
	local target_bottom_pos1 = target_pos1
	local target_bottom_pos2 = {
		x = target_pos2.x,
		y = target_pos1.y,
		z = target_pos2.z
	}

	-- Top slice of the target area
	local target_top_pos1 = {
		x = target_pos1.x,
		y = target_pos2.y,
		z = target_pos1.z
	}
	local target_top_pos2 = target_pos2



	-- For every type of rope
	for _, rope_type_nodes in ipairs(rope_nodes) do

		-- Look for ropes hanging out of the jump area
		local ropes_hanging_out = minetest.find_nodes_in_area(
				target_bottom_pos1, target_bottom_pos2,
				{rope_type_nodes[1], rope_type_nodes[2]})

		for _, pos in ipairs(ropes_hanging_out) do
			-- Swap with a proper end node, keeping param2
			local end_node = minetest.get_node(pos)
			minetest.swap_node(pos, {
				name=rope_type_nodes[3],
				param2=end_node.param2
			})

			-- Destroy remainder of the rope below the source area
			local remainder_pos = {
				x = pos.x - delta_vector.x,
				y = pos.y - delta_vector.y - 1,
				z = pos.z - delta_vector.z
			}
			ropes.destroy_rope(remainder_pos, rope_type_nodes)
		end


		-- Look for ropes hanging into the jump area
		local ropes_hanging_in = minetest.find_nodes_in_area(
				target_top_pos1, target_top_pos2,
				rope_type_nodes)

		for _, pos in ipairs(ropes_hanging_in) do
			-- Probably there is a loose end above the source area
			local end_pos = {
				x = pos.x - delta_vector.x,
				y = pos.y - delta_vector.y + 1,
				z = pos.z - delta_vector.z
			}
			local end_node = minetest.get_node(end_pos)

			if end_node and
					(end_node.name == rope_type_nodes[1] or
					end_node.name == rope_type_nodes[2]) then

				-- Swap with a proper end node, keeping param2
				minetest.swap_node(end_pos, {
					name=rope_type_nodes[3],
					param2=end_node.param2
				})
			end

			-- Destroy remainder of the rope in the target area
			ropes.destroy_rope(pos, rope_type_nodes)
		end
	end
end
