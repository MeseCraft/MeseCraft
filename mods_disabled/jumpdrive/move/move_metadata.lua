
-- invoked from move.lua
jumpdrive.move_metadata = function(source_pos1, source_pos2, delta_vector)


	local target_pos1 = vector.add(source_pos1, delta_vector)
	local target_pos2 = vector.add(source_pos2, delta_vector)

	local target_meta_pos_list = minetest.find_nodes_with_meta(target_pos1, target_pos2)
	for _,target_pos in pairs(target_meta_pos_list) do
		minetest.log("warning", "[jumpdrive] clearing spurious meta in " .. minetest.pos_to_string(target_pos))
		local target_meta = minetest.get_meta(target_pos)
		target_meta:from_table(nil)
	end

	local meta_pos_list = minetest.find_nodes_with_meta(source_pos1, source_pos2)
	for _,source_pos in pairs(meta_pos_list) do
		local target_pos = vector.add(source_pos, delta_vector)

		local source_meta = minetest.get_meta(source_pos)
		local source_table = source_meta:to_table()

		-- copy metadata to target
		minetest.get_meta(target_pos):from_table(source_table)

		local node = minetest.get_node(source_pos)

		jumpdrive.node_compat(node.name, source_pos, target_pos)

		-- clear metadata in source
		source_meta:from_table(nil)
	end

	jumpdrive.commit_node_compat()

end
