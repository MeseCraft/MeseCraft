
function jumpdrive.drawers_compat(target_pos1, target_pos2)
	local nodes = minetest.find_nodes_in_area(target_pos1, target_pos2, {"group:drawer"})
	if nodes then
		for _, pos in ipairs(nodes) do
			drawers.spawn_visuals(pos)
		end
	end
end
