
jumpdrive.signs_compat = function(pos1, pos2)
	local nodes = minetest.find_nodes_in_area(pos1, pos2, {"group:display_api"})
	if nodes then
		for _,pos in pairs(nodes) do
			minetest.log("action", "[jumpdrive] updating display @ " .. minetest.pos_to_string(pos))
			display_api.update_entities(pos)
		end
	end
end
