
-- collect nodes with on_timer attributes
local node_names_with_timer = {}
minetest.after(4, function()
	for _,node in pairs(minetest.registered_nodes) do
		if node.on_timer then
			table.insert(node_names_with_timer, node.name)
		end
	end
	minetest.log("action", "[jumpdrive] collected " .. #node_names_with_timer .. " items with node timers")
end)


-- invoked from move.lua
jumpdrive.move_nodetimers = function(source_pos1, source_pos2, delta_vector)

	if #node_names_with_timer == 0 then
		-- no node timer-nodes or not collected yet
		return
	end

	local list = minetest.find_nodes_in_area(source_pos1, source_pos2, node_names_with_timer)

	for _,source_pos in pairs(list) do
		local target_pos = vector.add(source_pos, delta_vector)

		local source_timer = minetest.get_node_timer(source_pos)
		local target_timer = minetest.get_node_timer(target_pos)

		if source_timer:is_started() then
			-- set target timer
			target_timer:set(
				source_timer:get_timeout(),
				source_timer:get_elapsed()
			)

			-- clear source timer
			source_timer:stop()
		end
	end

end
