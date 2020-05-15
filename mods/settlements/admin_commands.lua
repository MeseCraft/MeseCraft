-- internationalization boilerplate
local S, NS = settlements.S, settlements.NS

local visual_range = tonumber(minetest.settings:get("settlements_visibility_range")) or 600

local function get_nearest_settlement_within_range(pos, range, name)
	local min_edge = vector.subtract(pos, range)
	local max_edge = vector.add(pos, range)
	local settlement_list = named_waypoints.get_waypoints_in_area("settlements", min_edge, max_edge)

	local min_dist = range + 1 -- start with number beyond range
	local min_settlement = nil
	for id, settlement in pairs(settlement_list) do
		local distance = vector.distance(pos, settlement.pos)
		if distance < min_dist and settlement.data.discovered_by[name] then
			min_dist = distance
			min_settlement = settlement
		end
	end

	return min_settlement
end

minetest.register_chatcommand("settlements_rename_nearest", {
	description = S("Change the name of the nearest settlement you can see"),
	params = S("The new name for this settlement, or nothing to generate a new random name"),
	privs = {["server"]=true},
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		local player_pos = player:get_pos()

		local settlement = get_nearest_settlement_within_range(player_pos, visual_range, name)

		if settlement ~= nil then
			local data = settlement.data
			if param == "" then
				local def
				if data.settlement_type then
					def = settlements.registered_settlements[data.settlement_type]
				end
				if not def then
					minetest.chat_send_player(name, S("Missing settlement definition for @1", data.settlement_type))
					return
				end
				param = def.generate_name(min_pos)
			end
			local oldname = data.name
			data.name = param
			named_waypoints.update_waypoint("settlements", settlement.pos, data)
			minetest.chat_send_player(name, S("Renamed @1 to @2.", oldname, param))
			return
		end

		minetest.chat_send_player(name, S("No known settlements within @1m found.", visual_range))
	end,
})

minetest.register_chatcommand("settlements_regenerate_names", {
	description = S("Regenerate the names for all settments of a particular type"),
	params = S("The settlement type"),
	privs = {["server"]=true},
	func = function(name, param)
		if param == "" then
			minetest.chat_send_player(name, S("A non-empty settlement type parameter is required"))
			return
		end
		local settlement_def = settlements.registered_settlements[param]
		if not settlement_def then
			minetest.chat_send_player(name, S("Unrecognized settlement type"))
			return
		end

		local settlement_list = named_waypoints.get_waypoints_in_area("settlements",
			{x=-32000, y=-32000, z=-32000}, {x=32000, y=32000, z=32000})
		for id, settlement in pairs(settlement_list) do
			local data = settlement.data
			if data.settlement_type == param then
				local pos = settlement.pos
				local oldname = data.name
				data.name = settlement_def.generate_name(pos)
				named_waypoints.update_waypoint("settlements", pos, data)
				minetest.chat_send_player(name, S("Renamed @1 to @2", oldname, data.name))
				minetest.log("action", "[settlements] Renamed " .. oldname .. " to " .. data.name)
			end
		end
	end,
})

minetest.register_chatcommand("settlements_remove_nearest", {
	description = S("Remove the nearest settlement within a certain range (default 40)"),
	params = S("range"),
	privs = {["server"] = true},
	func = function(name, param)
		local range = tonumber(param) or 40
		local player = minetest.get_player_by_name(name)
		local player_pos = player:get_pos()
		local settlement = get_nearest_settlement_within_range(player_pos, range, name)

		if settlement ~= nil then
			named_waypoints.remove_waypoint("settlements", settlement.pos)
			minetest.log("action", "[settlements] Removed " .. settlement.data.name)
			minetest.chat_send_player(name, S("Settlement @1 successfully removed.", settlement.data.name))
		else
			minetest.chat_send_player(name, S("No known settlements within @1m found.", range))
		end
	end,
})

local half_map_chunk_size = settlements.half_map_chunk_size
local map_chunk_size = half_map_chunk_size * 2

minetest.register_chatcommand("settlements_create_in_mapchunk", {
	description = S("Create a new settlement centered in your current mapchunk"),
	privs = {["server"] = true},
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		local player_pos = player:get_pos()
		local minp = {}
		-- Map chunk origin is at {x=-32,y=-32,z=-32}
		local minp = vector.subtract(vector.multiply(vector.floor(vector.divide(vector.add(player_pos, 32), map_chunk_size)), map_chunk_size), 32)

		local maxp = vector.add(minp, map_chunk_size-1)
		local centerp = vector.add(minp, half_map_chunk_size)

		local settlement_list = settlements.settlements_in_world:get_areas_in_area(minp, maxp, true)
		if next(settlement_list) then
			minetest.chat_send_player(name, S("Settlement already exists in this mapchunk"))
			return
		end
		if settlements.generate_settlement(vector.subtract(minp,16), vector.add(maxp,16)) then -- add borders to simulate mapgen borders
			minetest.chat_send_player(name, S("Created new settlement at @1", minetest.pos_to_string(centerp)))
		else
			minetest.chat_send_player(name, S("Unable to create new settlement at @1", minetest.pos_to_string(centerp)))
		end
	end,
})
