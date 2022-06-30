
local update_item = function(pos, node)
	-- TODO
end


jumpdrive.itemframes_compat = function(pos1, pos2)

	local nodes = minetest.find_nodes_in_area(pos1, pos2, {"itemframes:pedestal", "itemframes:frame"})

	if nodes then
		for _,pos in pairs(nodes) do
			minetest.log("action", "[jumpdrive] updating itemframe @ " .. minetest.pos_to_string(pos))
			local node = minetest.get_node(pos)
			update_item(pos, node)
		end
	end


end
