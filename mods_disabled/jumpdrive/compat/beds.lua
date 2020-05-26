local bed_bottoms = {"beds:bed_bottom", "beds:fancy_bed_bottom"}

-- Calculate a bed's middle position (where players would spawn)
local function calc_bed_middle(bed_pos, facedir)
	local dir = minetest.facedir_to_dir(facedir)
	local bed_middle = {
		x = bed_pos.x + dir.x / 2,
		y = bed_pos.y,
		z = bed_pos.z + dir.z / 2
	}
	return bed_middle
end

jumpdrive.beds_compat = function(target_pos1, target_pos2, delta_vector)
	if beds == nil or
			beds.spawn == nil or
			beds.save_spawns == nil then
		-- Something is wrong. Don't do anything
		return
	end

	-- Look for beds in target area
	local beds_list = minetest.find_nodes_in_area(target_pos1, target_pos2, bed_bottoms)

	if next(beds_list) ~= nil then
		-- We found some beds!
		local source_pos1 = vector.subtract(target_pos1, delta_vector)
		local source_pos2 = vector.subtract(target_pos2, delta_vector)

		-- Look for players with spawn in source area
		local affected_players = {}
		for name, pos in pairs(beds.spawn) do
			-- pos1 and pos2 must already be sorted
			if pos.x >= source_pos1.x and pos.x <= source_pos2.x and
					pos.y >= source_pos1.y and pos.y <= source_pos2.y and
					pos.z >= source_pos1.z and pos.z <= source_pos2.z then
				table.insert(affected_players, name)
			end
		end

		if next(affected_players) ~= nil then
			-- Some players seem to be affected.
			-- Iterate over all beds
			for _, pos in pairs(beds_list) do
				local facedir = minetest.get_node(pos).param2
				local old_middle = calc_bed_middle(vector.subtract(pos, delta_vector), facedir)

				for _, name in ipairs(affected_players) do
					local spawn = beds.spawn[name]
					if spawn.x == old_middle.x and
							spawn.y == old_middle.y and
							spawn.z == old_middle.z then
						---- Player spawn seems to match old bed position; update
						beds.spawn[name] = calc_bed_middle(pos, facedir)
						minetest.log("action",
								"[jumpdrive] Updated bed spawn for player " .. name)
					end
				end
			end
			-- Tell beds mod to save the new spawns.
			beds.save_spawns()
		end
	end
end
