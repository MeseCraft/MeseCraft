

jumpdrive.simulate_jump = function(pos, player, show_marker)

	local targetPos = jumpdrive.get_meta_pos(pos)

	if jumpdrive.check_mapgen(pos) then
		return false, "Error: mapgen was active in this area, please try again later for your own safety!"
	end

	local meta = minetest.get_meta(pos)
	local radius = jumpdrive.get_radius(pos)
	local distance = vector.distance(pos, targetPos)

	local playername = meta:get_string("owner")

	if player ~= nil then
		playername = player:get_player_name()
	end

	local radius_vector = {x=radius, y=radius, z=radius}
	local source_pos1 = vector.subtract(pos, radius_vector)
	local source_pos2 = vector.add(pos, radius_vector)
	local target_pos1 = vector.subtract(targetPos, radius_vector)
	local target_pos2 = vector.add(targetPos, radius_vector)

	local x_overlap = (target_pos1.x <= source_pos2.x and target_pos1.x >= source_pos1.x) or
		(target_pos2.x <= source_pos2.x and target_pos2.x >= source_pos1.x)
	local y_overlap = (target_pos1.y <= source_pos2.y and target_pos1.y >= source_pos1.y) or
		(target_pos2.y <= source_pos2.y and target_pos2.y >= source_pos1.y)
	local z_overlap = (target_pos1.z <= source_pos2.z and target_pos1.z >= source_pos1.z) or
		(target_pos2.z <= source_pos2.z and target_pos2.z >= source_pos1.z)

	if x_overlap and y_overlap and z_overlap then
		return false, "Error: jump into itself! extend your jump target"
	end

	-- load chunk
	minetest.get_voxel_manip():read_from_map(target_pos1, target_pos2)

	if show_marker then
		jumpdrive.show_marker(targetPos, radius, "red")
		jumpdrive.show_marker(pos, radius, "green")
	end

	local msg = nil
	local success = true

	local blacklisted_pos_list = minetest.find_nodes_in_area(source_pos1, source_pos2, jumpdrive.blacklist)
	for _, nodepos in ipairs(blacklisted_pos_list) do
		return false, "Can't jump node @ " .. minetest.pos_to_string(nodepos)
	end

	if minetest.find_node_near(targetPos, radius, "vacuum:vacuum", true) then
		msg = "Warning: Jump-target is in vacuum!"
	end

	if minetest.find_node_near(targetPos, radius, "ignore", true) then
		return false, "Warning: Jump-target is in uncharted area"
	end

	if jumpdrive.is_area_protected(source_pos1, source_pos2, playername) then
		return false, "Jump-source is protected!"
	end

	if jumpdrive.is_area_protected(target_pos1, target_pos2, playername) then
		return false, "Jump-target is protected!"
	end

	local is_empty, empty_msg = jumpdrive.is_area_empty(target_pos1, target_pos2)

	if not is_empty then
		msg = "Jump-target is obstructed (" .. empty_msg .. ")"
		success = false
	end

	-- check preflight conditions
	local preflight_result = jumpdrive.preflight_check(pos, targetPos, radius, playername)

	if not preflight_result.success then
		-- check failed in customization
		msg = "Preflight check failed!"
		if preflight_result.message then
			msg = preflight_result.message
		end
		success = false
	end

	local power_req = jumpdrive.calculate_power(radius, distance, pos, targetPos)
	local powerstorage = meta:get_int("powerstorage")

	if powerstorage < power_req then
		-- not enough power
		msg = "Not enough power: required=" .. math.floor(power_req) .. ", actual: " .. powerstorage .. " EU"
		success = false
	end

	return success, msg
end



-- execute jump
jumpdrive.execute_jump = function(pos, player)

	local meta = minetest.get_meta(pos)

	local radius = jumpdrive.get_radius(pos)
	local targetPos = jumpdrive.get_meta_pos(pos)

	local distance = vector.distance(pos, targetPos)
	local power_req = jumpdrive.calculate_power(radius, distance, pos, targetPos)

	local radius_vector = {x=radius, y=radius, z=radius}
	local source_pos1 = vector.subtract(pos, radius_vector)
	local source_pos2 = vector.add(pos, radius_vector)
	local target_pos1 = vector.subtract(targetPos, radius_vector)
	local target_pos2 = vector.add(targetPos, radius_vector)

	local success, msg = jumpdrive.simulate_jump(pos, player, false)
	if not success then
		return false, msg
	end

	-- consume power from storage
	local powerstorage = meta:get_int("powerstorage")
	meta:set_int("powerstorage", powerstorage - power_req)

	local t0 = minetest.get_us_time()

	minetest.sound_play("jumpdrive_engine", {
		pos = pos,
		max_hear_distance = 50,
		gain = 0.7,
	})

	-- actual move
	jumpdrive.move(source_pos1, source_pos2, target_pos1, target_pos2)

	local t1 = minetest.get_us_time()
	local time_micros = t1 - t0

	minetest.log("action", "[jumpdrive] jump took " .. time_micros .. " us")

	-- show animation in source
	minetest.add_particlespawner({
		amount = 200,
		time = 2,
		minpos = source_pos1,
		maxpos = source_pos2,
		minvel = {x = -2, y = -2, z = -2},
		maxvel = {x = 2, y = 2, z = 2},
		minacc = {x = -3, y = -3, z = -3},
		maxacc = {x = 3, y = 3, z = 3},
		minexptime = 0.1,
		maxexptime = 5,
		minsize = 1,
		maxsize = 1,
		texture = "spark.png",
		glow = 5,
	})


	-- show animation in target
	minetest.add_particlespawner({
		amount = 200,
		time = 2,
		minpos = target_pos1,
		maxpos = target_pos2,
		minvel = {x = -2, y = -2, z = -2},
		maxvel = {x = 2, y = 2, z = 2},
		minacc = {x = -3, y = -3, z = -3},
		maxacc = {x = 3, y = 3, z = 3},
		minexptime = 0.1,
		maxexptime = 5,
		minsize = 1,
		maxsize = 1,
		texture = "spark.png",
		glow = 5,
	})

	return true, time_micros
end
