
--https://github.com/minetest-mods/technic/blob/master/technic/machines/HV/forcefield.lua

local is_int = function(value)
	return type(value) == 'number' and math.floor(value) == value
end

jumpdrive.digiline_effector = function(pos, _, channel, msg)

	local msgt = type(msg)
	if msgt ~= "table" then
		return
	end

	local meta = minetest.get_meta(pos)

	local set_channel = meta:get_string("channel")
	if set_channel == "" then
		-- backward compatibility with old static channel
		set_channel = "jumpdrive"
	end

	if channel ~= set_channel then
		return
	end

	local radius = jumpdrive.get_radius(pos)
	local targetPos = jumpdrive.get_meta_pos(pos)

	local distance = vector.distance(pos, targetPos)
	local power_req = jumpdrive.calculate_power(radius, distance, pos, targetPos)

	if msg.command == "get" then
		digilines.receptor_send(pos, digilines.rules.default, set_channel, {
			powerstorage = meta:get_int("powerstorage"),
			radius = radius,
			position = pos,
			target = targetPos,
			distance = distance,
			power_req = power_req
		})

	elseif msg.command == "reset" then
		meta:set_int("x", pos.x)
		meta:set_int("y", pos.y)
		meta:set_int("z", pos.z)
		jumpdrive.update_formspec(meta, pos)

	elseif msg.command == "set" then

		if msg.key and msg.value then
			local value = tonumber(msg.value)

			if value == nil then
				-- not a number
				return
			end
			-- backward compatibility with old less flexible set command
			if msg.key == "x" then
				meta:set_int("x", value)
			elseif msg.key == "y" then
				meta:set_int("y", value)
			elseif msg.key == "z" then
				meta:set_int("z", value)
			elseif msg.key == "radius" then
				if value >= 1 and value <= jumpdrive.config.max_radius then
					meta:set_int("radius", value)
				end
			end
		else
			-- API requires integers for coord values, noop for everything else
			if is_int(msg.x) then meta:set_int("x", msg.x) end
			if is_int(msg.y) then meta:set_int("y", msg.y) end
			if is_int(msg.z) then meta:set_int("z", msg.z) end
			if is_int(msg.r) and msg.r <= jumpdrive.config.max_radius then
				meta:set_int("radius", msg.r)
			end
			if msg.formupdate then
				jumpdrive.update_formspec(meta, pos)
			end
		end

	elseif msg.command == "simulate" or msg.command == "show" then
		local success, resultmsg = jumpdrive.simulate_jump(pos)

		digilines.receptor_send(pos, digilines.rules.default, set_channel, {
			success=success,
			msg=resultmsg
		})

	elseif msg.command == "jump" then
		local success, timeormsg = jumpdrive.execute_jump(pos)

		local send_pos = pos
		if success then
			-- send new message in target pos
			send_pos = targetPos
			digilines.receptor_send(send_pos, digilines.rules.default, set_channel, {
				success = success,
				time = timeormsg
			})
		else
			digilines.receptor_send(send_pos, digilines.rules.default, set_channel, {
				success = success,
				msg = timeormsg
			})
		end
	end
end
