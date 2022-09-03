if not minetest.settings:get_bool("mapgen_helper_log_locations", false) then
	mapgen_helper.log_first_location = function()
		return
	end
	return
end

mapgen_helper.log_location_enabled = true

local worldpath = minetest.get_worldpath()
local locations = {}

local save_data = function()
	local file = io.open(worldpath.."/mapgen_helper_test_locations.json", "w")
	if file then
		local data = {}
		data.locations = locations
		file:write(minetest.serialize(data))
		file:close()
	end
end

local read_data = function()
	local file = io.open(worldpath.."/mapgen_helper_test_locations.json", "r")
	if file then
		local data = minetest.deserialize(file:read("*all"))
		locations = data.locations or {}
		-- to upgrade legacy data that didn't have counts recorded
		for _, location in pairs(locations) do
			location.count = location.count or 1
		end
		file:close()
	else
		locations = {}
	end
end
read_data()

-- logs only the first location of a particular type, ignores any subsequent ones
mapgen_helper.log_first_location = function(name, pos, desc, notes)
	if not locations[name] then
		locations[name] = {pos=pos, desc=desc, notes=notes, count = 1}
		minetest.log("info", "[mapgen_helper] recorded location " .. name .. " at " .. minetest.pos_to_string(pos) .. " with desc '" .. (desc or "") .. "'")
		save_data()
	end
end

mapgen_helper.log_location = function(name, pos, desc, notes)
	local location = locations[name] or {pos=pos, desc=desc, notes=notes, count = 0}
	locations[name] = location
	location.pos = pos
	location.desc = desc
	location.notes = notes
	location.count = location.count + 1
end


minetest.register_chatcommand("mapgen_helper_loc", {
	params = "[location name]",
	description = "sends the player to the named test location, or lists recorded locations if no parameter is given",
	privs = {server=true},
	func = function(name, param)
		if not param or param == "" then
			minetest.chat_send_player(name,"test locations available:")
			local names = {}
			for loc_name, loc in pairs(locations) do
				table.insert(names, loc_name)
			end
			table.sort(names)			
			for number, loc_name in ipairs(names) do
				minetest.chat_send_player(name, "\t"..loc_name .. " - " .. (locations[loc_name].desc or "") .. " - " .. tostring(locations[loc_name].count))
			end
			return
		end
		local loc = locations[param]
		if not loc then
			minetest.chat_send_all("test location " .. param .. " not found")
			return
		end
		local player = minetest.get_player_by_name(name)
		player:set_pos(loc.pos)
		if loc.notes then
			minetest.chat_send_player(name, loc.notes)
		end
	end,
})

local tour_index = 0
minetest.register_chatcommand("mapgen_helper_tour", {
	params = "<next|prev>",
	description = "cycles through the various recorded mapgen test locations, forward or backward",
	privs = {server=true},
	func = function(name, param)
		local names = {}
		for name, loc in pairs(locations) do
			table.insert(names, name)
		end
		table.sort(names)			
		if param == "prev" then
			tour_index = tour_index - 1
			if tour_index < 1 then
				tour_index = #names
			end
		else
			tour_index = tour_index + 1
			if tour_index > #names then
				tour_index = 1
			end
		end
		
		local loc = locations[names[tour_index]]
		local player = minetest.get_player_by_name(name)
		player:set_pos(loc.pos)
		minetest.chat_send_player(name, "Teleport to test location " .. names[tour_index])
		if loc.notes then
			minetest.chat_send_player(name, loc.notes)
		end
	end
})

minetest.register_on_shutdown(function()
	save_data()
end)