jumpdrive.travelnet_compat = function(pos1, pos2)

	local pos_list = minetest.find_nodes_in_area(pos1, pos2, {"travelnet:travelnet"})
	if pos_list then
		for _,pos in pairs(pos_list) do
			local meta = minetest.get_meta(pos);
			minetest.log("action", "[jumpdrive] Restoring travelnet @ " .. pos.x .. "/" .. pos.y .. "/" .. pos.z)

			local owner_name = meta:get_string( "owner" );
			local station_name = meta:get_string( "station_name" );
			local station_network = meta:get_string( "station_network" );

			if (travelnet.targets[owner_name]
			and travelnet.targets[owner_name][station_network]
			and travelnet.targets[owner_name][station_network][station_name]) then

				travelnet.targets[owner_name][station_network][station_name].pos = pos

			end
		end
		if travelnet.save_data ~= nil then
			travelnet.save_data()
		end
	end
end
