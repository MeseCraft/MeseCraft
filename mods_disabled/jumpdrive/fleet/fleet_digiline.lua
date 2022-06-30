
local is_int = function(value)
	return type(value) == 'number' and math.floor(value) == value
end

jumpdrive.fleet.is_active = function(pos)
	local meta = minetest.get_meta(pos)
	return meta:get_int("active") > 0
end

jumpdrive.fleet.get_fleet_data = function(pos, target_pos, engines_pos_list)
	local t0 = minetest.get_us_time()

-- get some more or less useful data from fleet
	local engines = {}
	local max_power_req = 0
	local total_power_req = 0
	local distance = nil
	local active = jumpdrive.fleet.is_active(pos)

	local delta_vector = nil
	if target_pos then
		delta_vector = vector.subtract(target_pos, pos)
		distance = vector.distance(pos, target_pos)
	end

	if not active then
		for _,engine_pos in ipairs(engines_pos_list) do
			local engine_meta = minetest.get_meta(engine_pos)
			local powerstorage = engine_meta:get_int("powerstorage")
			local radius = jumpdrive.get_radius(engine_pos)
			local engine_target_pos = nil
			local engine_distance = nil
			local engine_power_req = 0
			if target_pos then
				engine_target_pos = vector.add(engine_pos, delta_vector)
				engine_distance = vector.distance(engine_pos, engine_target_pos)
				engine_power_req = jumpdrive.calculate_power(radius, engine_distance, engine_pos, engine_target_pos)
				if engine_power_req > max_power_req then
					max_power_req = engine_power_req
				end
				total_power_req = total_power_req + engine_power_req
			end
			table.insert(engines, {
				power_req = engine_power_req,
				powerstorage = powerstorage,
				radius = radius,
				position = engine_pos,
				target = engine_target_pos,
				distance = engine_distance,
			})
		end
	end

	local t1 = minetest.get_us_time()
	minetest.log("action", "[jumpdrive-fleet] fleet data collection took " ..
		(t1 - t0) .. " us @ " .. minetest.pos_to_string(pos))

	return {
		active = active,
		engines = engines,
		max_power_req = max_power_req,
		total_power_req = total_power_req,
		position = pos,
		target = target_pos,
		distance = distance,
	}
end

jumpdrive.fleet.get_engines_sorted = function(pos)
	local t0 = minetest.get_us_time()
	local engines_pos_list = jumpdrive.fleet.find_engines(pos)
	local t1 = minetest.get_us_time()
	minetest.log("action", "[jumpdrive-fleet] backbone traversing took " ..
		(t1 - t0) .. " us @ " .. minetest.pos_to_string(pos))

	-- sort by distance, farthes first
	jumpdrive.fleet.sort_engines(pos, engines_pos_list)

	return engines_pos_list
end

jumpdrive.fleet.digiline_async_simulate = function(pos, channel, owner, engines)
	local index = 1
	local meta = minetest.get_meta(pos)
	local msglist = {}
	local async_check
	async_check = function()
		if meta:get_int("active") < 1 then
			-- operation aborted by user while there's still work to do
			digilines.receptor_send(pos, digilines.rules.default, channel, {
				success = false,
				index = index,
				count = #engines,
				msg = "simulation aborted",
			})
			return
		end

		local engine_pos = engines[index]
		local success, msg = jumpdrive.simulate_jump(engine_pos, owner, false)

		if not success then
			digilines.receptor_send(pos, digilines.rules.default, channel, {
				success=false,
				pos=engine_pos,
				msg=msg,
			})
			meta:set_int("active", 0)
			jumpdrive.fleet.update_formspec(meta, pos)
			return
		end
		table.insert(msglist, msg)

		if index < #engines then
			-- more drives to check
			index = index + 1
			minetest.after(1, async_check)

		elseif index >= #engines then
			-- done
			digilines.receptor_send(pos, digilines.rules.default, channel, {
				success=true,
				count=index,
				msgs=msglist,
			})
			meta:set_int("active", 0)
			jumpdrive.fleet.update_formspec(meta, pos)
		end
	end
	meta:set_string("jump_list", minetest.serialize(engines))
	meta:set_int("active", 1)
	jumpdrive.fleet.update_formspec(meta, pos)
	minetest.after(1, async_check)
end

jumpdrive.fleet.digiline_async_jump = function(pos, target_pos, channel, owner, engines)
	local t0 = minetest.get_us_time()
	local meta = minetest.get_meta(pos)
	local all_success = false
	local msglist = {}
	local index = 1
	local async_jump
	async_jump = function()
		if engines and index and #engines >= index then
			if meta:get_int("active") < 1 then
				-- operation aborted by user while there's still work to do
				digilines.receptor_send(pos, digilines.rules.default, channel, {
					success = false,
					index = index,
					count = #engines,
					msg = "jump aborted",
				})
				return
			end

			local node_pos = engines[index]
			local success, msg = jumpdrive.execute_jump(node_pos)
			table.insert(msglist, msg)

			if success then
				-- at this point if it is the last engine the metadata does not exist anymore in the current location

				if #engines == index then
					-- last engine jumped successfully
					all_success = true
				else
					meta:set_int("jump_index", index)
				end
				-- execute for each engine and once after last engine jumped
				index = index + 1
				minetest.after(1, async_jump)
			else
				digilines.receptor_send(pos, digilines.rules.default, channel, {
					success = false,
					count = index,
					msg = msg,
					msgs = msglist,
				})
				meta:set_int("active", 0)
				jumpdrive.fleet.update_formspec(meta, pos)
			end
		else
			local targetmeta = minetest.get_meta(target_pos)
			local t1 = minetest.get_us_time()
			digilines.receptor_send(target_pos, digilines.rules.default, channel, {
				success = all_success, -- in case someone calls with zero engines should it be success or not?
				count = index,
				msgs = msglist,
				time = t1 - t0
			})
			targetmeta:set_int("active", 0)
			jumpdrive.fleet.update_formspec(targetmeta, target_pos)
		end
	end
	meta:set_string("jump_list", minetest.serialize(engines))
	meta:set_int("active", 1)
	jumpdrive.fleet.update_formspec(meta, pos)
	minetest.after(1, async_jump)
end

jumpdrive.fleet.digiline_effector = function(pos, _, channel, msg)

	if type(msg) ~= "table" then
		return
	end

	local meta = minetest.get_meta(pos)

	local set_channel = meta:get_string("channel")
	if channel ~= set_channel then
		return
	end

	local playername = meta:get_string("owner")
	if not playername then
		return
	end

	local targetPos = jumpdrive.get_meta_pos(pos)

	if msg.command == "get" then

		local engines_pos_list = jumpdrive.fleet.find_engines(pos)
		local fleetdata = jumpdrive.fleet.get_fleet_data(pos, targetPos, engines_pos_list)
		digilines.receptor_send(pos, digilines.rules.default, set_channel, fleetdata)

	elseif msg.command == "reset" then

		if jumpdrive.fleet.is_active(pos) then
			digilines.receptor_send(pos, digilines.rules.default, set_channel, {
				success = false,
				msg = "Operation not completed",
			})
			return
		end

		meta:set_int("x", pos.x)
		meta:set_int("y", pos.y)
		meta:set_int("z", pos.z)
		jumpdrive.fleet.update_formspec(meta, pos)

	elseif msg.command == "set" then

		if jumpdrive.fleet.is_active(pos) then
			digilines.receptor_send(pos, digilines.rules.default, set_channel, {
				success = false,
				msg = "Operation not completed",
			})
			return
		end

		-- API requires integers for coord values, noop for everything else
		if is_int(msg.x) then meta:set_int("x", msg.x) end
		if is_int(msg.y) then meta:set_int("y", msg.y) end
		if is_int(msg.z) then meta:set_int("z", msg.z) end
		if msg.formupdate then
			jumpdrive.fleet.update_formspec(meta, pos)
		end

	elseif msg.command == "simulate" or msg.command == "show" then

		if jumpdrive.fleet.is_active(pos) then
			digilines.receptor_send(pos, digilines.rules.default, set_channel, {
				success = false,
				msg = "Operation not completed",
			})
			return
		end

		local engines_pos_list = jumpdrive.fleet.get_engines_sorted(pos)

		if #engines_pos_list == 0 then
			return
		end

		-- apply new coordinates
		jumpdrive.fleet.apply_coordinates(pos, targetPos, engines_pos_list)

		local owner = minetest.get_player_by_name(playername)
		jumpdrive.fleet.digiline_async_simulate(pos, channel, owner, engines_pos_list)

	elseif msg.command == "jump" then

		if jumpdrive.fleet.is_active(pos) then
			digilines.receptor_send(pos, digilines.rules.default, set_channel, {
				success = false,
				msg = "Operation not completed",
			})
			return
		end

		local engines_pos_list = jumpdrive.fleet.get_engines_sorted(pos)

		if #engines_pos_list == 0 then
			return
		end

		-- apply new coordinates
		jumpdrive.fleet.apply_coordinates(pos, targetPos, engines_pos_list)

		local owner = minetest.get_player_by_name(playername)
		jumpdrive.fleet.digiline_async_jump(pos, targetPos, channel, owner, engines_pos_list)

	end
end
