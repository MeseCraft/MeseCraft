
local use_player_monoids = minetest.global_exists("player_monoids")
local c_air = minetest.get_content_id("air")


-- moves the source to the target area
-- no protection- or overlap checking is done here
jumpdrive.move = function(source_pos1, source_pos2, target_pos1, target_pos2)

	minetest.log("action", "[jumpdrive] initiating jump (" ..
		minetest.pos_to_string(source_pos1) .. "-" .. minetest.pos_to_string(source_pos2) ..
		") (" .. minetest.pos_to_string(target_pos1) .. "-" .. minetest.pos_to_string(target_pos2) .. ")")

	-- step 1: copy via voxel manip
	-- https://dev.minetest.net/VoxelManip#Examples

	-- delta between source and target
	local delta_vector = vector.subtract(target_pos1, source_pos1)

	-- center of source
	local source_center = vector.add(source_pos1, vector.divide(vector.subtract(source_pos2, source_pos1), 2))
	minetest.log("action", "[jumpdrive] source-center: " .. minetest.pos_to_string(source_center))

	local t0 = minetest.get_us_time()


	-- load areas (just a precaution)
	if minetest.load_area then
		minetest.load_area(source_pos1, source_pos2)
		minetest.load_area(target_pos1, target_pos2)
	end

	-- read source
	local manip = minetest.get_voxel_manip()
	local e1, e2 = manip:read_from_map(source_pos1, source_pos2)
	local source_area = VoxelArea:new({MinEdge=e1, MaxEdge=e2})
	local source_data = manip:get_data()
	local source_param1 = manip:get_light_data()
	local source_param2 = manip:get_param2_data()

	minetest.log("action", "[jumpdrive] read source-data")

	-- write target
	manip = minetest.get_voxel_manip()
	e1, e2 = manip:read_from_map(target_pos1, target_pos2)
	local target_area = VoxelArea:new({MinEdge=e1, MaxEdge=e2})
	local target_data = manip:get_data()
	local target_param1 = manip:get_light_data()
	local target_param2 = manip:get_param2_data()

	minetest.log("action", "[jumpdrive] read target-data");

	for z=source_pos1.z, source_pos2.z do
	for y=source_pos1.y, source_pos2.y do
	for x=source_pos1.x, source_pos2.x do

		local source_index = source_area:index(x, y, z)
		local target_index = target_area:index(x+delta_vector.x, y+delta_vector.y, z+delta_vector.z)

		-- copy block id
		target_data[target_index] = source_data[source_index]

		-- copy params
		target_param1[target_index] = source_param1[source_index]
		target_param2[target_index] = source_param2[source_index]
	end
	end
	end


	manip:set_data(target_data)
	manip:set_light_data(target_param1)
	manip:set_param2_data(target_param2)
	manip:write_to_map()
	manip:update_map()

	local t1 = minetest.get_us_time()
	minetest.log("action", "[jumpdrive] step I took " .. (t1 - t0) .. " us")

	-- step 2: check meta/timers and copy if needed
	t0 = minetest.get_us_time()
	jumpdrive.move_metadata(source_pos1, source_pos2, delta_vector)
	jumpdrive.move_nodetimers(source_pos1, source_pos2, delta_vector)
	t1 = minetest.get_us_time()
	minetest.log("action", "[jumpdrive] step II took " .. (t1 - t0) .. " us")


	-- step 3: execute target region compat code
	t0 = minetest.get_us_time()
	jumpdrive.target_region_compat(source_pos1, source_pos2, target_pos1, target_pos2, delta_vector)
	t1 = minetest.get_us_time()
	minetest.log("action", "[jumpdrive] step III took " .. (t1 - t0) .. " us")


	-- step 4: move objects
	t0 = minetest.get_us_time()
	jumpdrive.move_objects(source_center, source_pos1, source_pos2, delta_vector)

	-- move players
	for _,player in ipairs(minetest.get_connected_players()) do
		local playerPos = player:get_pos()
		local player_name = player:get_player_name()

		local xMatch = playerPos.x >= (source_pos1.x-0.5) and playerPos.x <= (source_pos2.x+0.5)
		local yMatch = playerPos.y >= (source_pos1.y-0.5) and playerPos.y <= (source_pos2.y+0.5)
		local zMatch = playerPos.z >= (source_pos1.z-0.5) and playerPos.z <= (source_pos2.z+0.5)

		if xMatch and yMatch and zMatch and player:is_player() then
			minetest.log("action", "[jumpdrive] moving player: " .. player:get_player_name())

			-- override gravity if "player_monoids" is available
			-- *should* execute before the player get moved
			-- to prevent falling through not yet loaded blocks
			if use_player_monoids then
				-- modify gravity
				player_monoids.gravity:add_change(player, 0.01, "jumpdrive:gravity")

				minetest.after(3.0, function()
					-- restore gravity
					local player_deferred = minetest.get_player_by_name(player_name)
					if player_deferred then
						player_monoids.gravity:del_change(player_deferred, "jumpdrive:gravity")
					end
				end)
			end

			local new_player_pos = vector.add(playerPos, delta_vector)
			player:set_pos( new_player_pos );

			-- send moved mapblock to player
			if player.send_mapblock and type(player.send_mapblock) == "function" then
				player:send_mapblock(jumpdrive.get_mapblock_from_pos(new_player_pos))
			end
		end
	end

	t1 = minetest.get_us_time()
	minetest.log("action", "[jumpdrive] step IV took " .. (t1 - t0) .. " us")


	-- step 5: clear source area with voxel manip
	t0 = minetest.get_us_time()
	manip = minetest.get_voxel_manip()
	e1, e2 = manip:read_from_map(source_pos1, source_pos2)
	source_area = VoxelArea:new({MinEdge=e1, MaxEdge=e2})
	source_data = manip:get_data()


	for z=source_pos1.z, source_pos2.z do
	for y=source_pos1.y, source_pos2.y do
	for x=source_pos1.x, source_pos2.x do

		local source_index = source_area:index(x, y, z)
		source_data[source_index] = c_air
	end
	end
	end

	manip:set_data(source_data)
	manip:write_to_map()
	manip:update_map()

	t1 = minetest.get_us_time()
	minetest.log("action", "[jumpdrive] step V took " .. (t1 - t0) .. " us")



end
