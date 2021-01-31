-- internationalization boilerplate
local S, NS = settlements.S, settlements.NS

-----------------------------------------------------------------------------
-- Admin tools

local half_map_chunk_size = settlements.half_map_chunk_size

-- manually place buildings, for debugging only
minetest.register_craftitem("settlements:settlement_tool", {
	description = S("Settlements build tool"),
	inventory_image = "settlements_settlement_marker.png",
	stack_max = 1,
	
	-- build settlement
	on_use = function(itemstack, placer, pointed_thing)
		local player_name = placer:get_player_name()
		if not minetest.check_player_privs(placer, "server") then
			minetest.chat_send_player(player_name, S("You need the server privilege to use this tool."))
			return
		end

		local center_surface = pointed_thing.under
		if center_surface then
			local minp = vector.subtract(center_surface, half_map_chunk_size+16) -- add 16 node border to simulate extended mapgen border
			local maxp = vector.add(center_surface, half_map_chunk_size+16)
			if settlements.generate_settlement(minp, maxp) then
				minetest.chat_send_player(player_name, S("Created new settlement at @1", minetest.pos_to_string(center_surface)))
			else
				minetest.chat_send_player(player_name, S("Unable to create new settlement at @1", minetest.pos_to_string(center_surface)))
			end
		end
	end,
})

local c_dirt_with_grass	= minetest.get_content_id("default:dirt_with_grass")
local all_schematics
local function get_all_schematics()
	if not all_schematics then
		all_schematics = {}
		for _, settlement_def in pairs(settlements.registered_settlements) do
			for _, building_info in ipairs(settlement_def.schematics) do
				table.insert(all_schematics, building_info)
			end
		end
	end
	return all_schematics
end

minetest.register_craftitem("settlements:single_building_tool", {
	description = S("Settlements tool for building: @1", S("Unset")),
	inventory_image = "settlements_building_marker.png",
	stack_max = 1,
	
	on_place = function(itemstack, placer, pointed_thing)
		local meta = itemstack:get_meta()
		local index = meta:get_int("index")
		local all_schematics = get_all_schematics()
		
		index = index + 1
		if index > #all_schematics then
			index = 1
		end

		meta:set_int("index", index)
		local desc_string = S("Settlements tool for building: @1", all_schematics[index].name)
		meta:set_string("description", desc_string)
		minetest.chat_send_player(placer:get_player_name(), desc_string)
		return itemstack
	end,
	
	-- build single house
	on_use = function(itemstack, placer, pointed_thing)
		if not minetest.check_player_privs(placer, "server") then
			minetest.chat_send_player(placer:get_player_name(), S("You need the server privilege to use this tool."))
			return
		end
		
		local meta = itemstack:get_meta()
		local index = meta:get_int("index")
		local selected_building = get_all_schematics()[index]
		if not selected_building then
			return
		end

		local center_surface = pointed_thing.under
		if center_surface then
			local built_house = {}
			built_house.schematic_info = selected_building
			built_house.center_pos = center_surface -- we're not terraforming so this doesn't matter
			built_house.build_pos_min = center_surface
			built_house.rotation = "0"
			built_house.surface_mat = c_dirt_with_grass

			local vm = minetest.get_voxel_manip()
			local maxp = vector.add(center_surface, selected_building.schematic.size)
			local emin, emax = vm:read_from_map(center_surface, maxp)

			settlements.place_building(vm, built_house, {def={}})
			minetest.chat_send_player(placer:get_player_name(), S("Built @1", selected_building.name))
			vm:write_to_map()
		end
	end,
})

minetest.register_craftitem("settlements:mark_location_tool", {
	description = S("Settlements tool for marking: @1", S("Unset")),
	inventory_image = "settlements_location_marker.png",
	stack_max = 1,
	
	on_place = function(itemstack, placer, pointed_thing)
		local meta = itemstack:get_meta()
		local settlement_type = meta:get_string("type")
		
		if settlement_type == "" then
			settlement_type = next(settlements.registered_settlements)
		else
			settlement_type = next(settlements.registered_settlements, settlement_type)
			if not settlement_type then
				settlement_type = next(settlements.registered_settlements)
			end
		end

		meta:set_string("type", settlement_type)
		local desc_string = S("Settlements tool for marking: @1", settlement_type)
		meta:set_string("description", desc_string)
		minetest.chat_send_player(placer:get_player_name(), desc_string)
		return itemstack
	end,
	
	-- Mark a settlement here, regardless of environment
	on_use = function(itemstack, placer, pointed_thing)
		if not minetest.check_player_privs(placer, "server") then
			minetest.chat_send_player(placer:get_player_name(), S("You need the server privilege to use this tool."))
			return
		end
		
		local meta = itemstack:get_meta()
		local settlement_type = meta:get_string("type")
		local settlement_def = settlements.registered_settlements[settlement_type]
		if not settlement_def then
			return
		end

		local center_surface = pointed_thing.under
		if center_surface then
			center_surface = vector.add(center_surface, {x=0, y=2, z=0})
			local existing_area = named_waypoints.get_waypoints_in_area("settlements", vector.subtract(center_surface, 5), vector.add(center_surface, 5))
			if next(existing_area) then
				minetest.chat_send_player(placer:get_player_name(), S("There's already a settlement at @1", minetest.pos_to_string(center_surface)))
				return
			end
		
			local name = settlement_def.generate_name(center_surface)
			minetest.chat_send_player(placer:get_player_name(), S("Marked settlement @1 at @2", name, minetest.pos_to_string(center_surface)))
			-- add settlement to list
			named_waypoints.add_waypoint("settlements", center_surface, {name=name, settlement_type = settlement_type})
		end
	end,
})
