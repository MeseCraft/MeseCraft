-- lib_mount by Blert2112 (edited by TenPlus1)

local is_50 = minetest.get_modpath("player_api") -- 5.x compatibility

local abs, cos, floor, sin, sqrt, pi =
		math.abs, math.cos, math.floor, math.sin, math.sqrt, math.pi

--
-- Helper functions
--

local node_ok = function(pos, fallback)

	fallback = fallback or mobs.fallback_node

	local node = minetest.get_node_or_nil(pos)

	if node and minetest.registered_nodes[node.name] then
		return node
	end

	return {name = fallback}
end


local function node_is(pos)

	local node = node_ok(pos)

	if node.name == "air" then
		return "air"
	end

	if minetest.get_item_group(node.name, "lava") ~= 0 then
		return "lava"
	end

	if minetest.get_item_group(node.name, "liquid") ~= 0 then
		return "liquid"
	end

	if minetest.registered_nodes[node.name].walkable == true then
		return "walkable"
	end

	return "other"
end


local function get_sign(i)

	i = i or 0

	if i == 0 then
		return 0
	else
		return i / abs(i)
	end
end


local function get_velocity(v, yaw, y)

	local x = -sin(yaw) * v
	local z =  cos(yaw) * v

	return {x = x, y = y, z = z}
end


local function get_v(v)
	return sqrt(v.x * v.x + v.z * v.z)
end


local function force_detach(player)

	if not player then return end

	local attached_to = player:get_attach()

	if not attached_to then
		return
	end

	local entity = attached_to:get_luaentity()

	if entity and entity.driver
	and entity.driver == player then
		entity.driver = nil
	end

	player:set_detach()

	local name = player:get_player_name()

	if is_50 then
		player_api.player_attached[name] = false
		player_api.set_animation(player, "stand", 30)
	else
		default.player_attached[name] = false
		default.player_set_animation(player, "stand", 30)
	end

	player:set_eye_offset({x = 0, y = 0, z = 0}, {x = 0, y = 0, z = 0})
	player:set_properties({visual_size = {x = 1, y = 1}})
end


minetest.register_on_leaveplayer(function(player)
	force_detach(player)
end)


minetest.register_on_shutdown(function()

	local players = minetest.get_connected_players()

	for i = 1, #players do
		force_detach(players[i])
	end
end)


minetest.register_on_dieplayer(function(player)
	force_detach(player)
	return true
end)


-- Just for correct detaching
local function find_free_pos(pos)

	local check = {
		{x = 1,  y = 0, z =  0},
		{x = 1,  y = 1, z =  0},
		{x = -1, y = 0, z =  0},
		{x = -1, y = 1, z =  0},
		{x = 0,  y = 0, z =  1},
		{x = 0,  y = 1, z =  1},
		{x = 0,  y = 0, z = -1},
		{x = 0,  y = 1, z = -1}
	}

	for _, c in pairs(check) do

		local npos = {x = pos.x + c.x, y = pos.y + c.y, z = pos.z + c.z}
		local node = minetest.get_node_or_nil(npos)

		if node and node.name then

			local def = minetest.registered_nodes[node.name]

			if def and not def.walkable and
					def.liquidtype == "none" then
				return npos
			end
		end
	end

	return pos
end


function mobs.attach(entity, player)

	entity.player_rotation = entity.player_rotation or {x = 0, y = 0, z = 0}
	entity.driver_attach_at = entity.driver_attach_at or {x = 0, y = 0, z = 0}
	entity.driver_eye_offset = entity.driver_eye_offset or {x = 0, y = 0, z = 0}
	entity.driver_scale = entity.driver_scale or {x = 1, y = 1}

	local rot_view = 0

	if entity.player_rotation.y == 90 then
		rot_view = pi / 2
	end

	local attach_at = entity.driver_attach_at
	local eye_offset = entity.driver_eye_offset

	entity.driver = player

	force_detach(player)

	if is_50 then
		player_api.player_attached[player:get_player_name()] = true
	else
		default.player_attached[player:get_player_name()] = true
	end

	player:set_attach(entity.object, "", attach_at, entity.player_rotation)
	player:set_eye_offset(eye_offset, {x = 0, y = 0, z = 0})

	player:set_properties({
		visual_size = {
			x = entity.driver_scale.x,
			y = entity.driver_scale.y
		}
	})

	minetest.after(0.2, function()

		if player and player:is_player() then

			if is_50 then
				player_api.set_animation(player, "sit", 30)
			else
				default.player_set_animation(player, "sit", 30)
			end
		end
	end)

	player:set_look_horizontal(entity.object:get_yaw() - rot_view)
end


function mobs.detach(player)

	force_detach(player)

	minetest.after(0.1, function()

		if player and player:is_player() then

			local pos = find_free_pos(player:get_pos())

			pos.y = pos.y + 0.5

			player:set_pos(pos)
		end
	end)
end


function mobs.drive(entity, moving_anim, stand_anim, can_fly, dtime)

	local yaw = entity.object:get_yaw() or 0
	local rot_view = 0

	if entity.player_rotation.y == 90 then
		rot_view = pi / 2
	end

	local acce_y = 0
	local velo = entity.object:get_velocity() ; if not velo then return end

	entity.v = get_v(velo) * get_sign(entity.v)

	-- process controls
	if entity.driver then

		local ctrl = entity.driver:get_player_control()

		-- move forwards
		if ctrl.up then

			entity.v = entity.v + entity.accel * dtime

		-- move backwards
		elseif ctrl.down then

			if entity.max_speed_reverse == 0 and entity.v == 0 then
				return
			end

			entity.v = entity.v - entity.accel * dtime
		end

		-- mob rotation
		local horz

		if entity.alt_turn == true then

			horz = yaw

			if ctrl.left then
				horz = horz + 0.05

			elseif ctrl.right then
				horz = horz - 0.05
			end
		else
			horz = entity.driver:get_look_horizontal() or 0
		end

		entity.object:set_yaw(horz - entity.rotate)

		if can_fly then

			-- fly up
			if ctrl.jump then

				velo.y = velo.y + 1

				if velo.y > entity.accel then velo.y = entity.accel end

			elseif velo.y > 0 then

				velo.y = velo.y - dtime

				if velo.y < 0 then velo.y = 0 end
			end

			-- fly down
			if ctrl.sneak then

				velo.y = velo.y - 1

				if velo.y < -entity.accel then velo.y = -entity.accel end

			elseif velo.y < 0 then

				velo.y = velo.y + dtime

				if velo.y > 0 then velo.y = 0 end
			end
		else
			-- jump
			if ctrl.jump then

				if velo.y == 0 then
					velo.y = velo.y + entity.jump_height
					acce_y = acce_y + (acce_y * 3) + 1
				end
			end
		end
	end

	-- if not moving then set animation and return
	if entity.v == 0 and velo.x == 0 and velo.y == 0 and velo.z == 0 then

		if stand_anim then
			mobs:set_animation(entity, stand_anim)
		end

		return
	end

	-- set moving animation
	if moving_anim then
		mobs:set_animation(entity, moving_anim)
	end

	-- Stop!
	local s = get_sign(entity.v)

	entity.v = entity.v - 0.02 * s

	if s ~= get_sign(entity.v) then

		entity.object:set_velocity({x = 0, y = 0, z = 0})
		entity.v = 0

		return
	end

	-- enforce speed limit forward and reverse
	if entity.v > entity.max_speed_forward then
		entity.v = entity.max_speed_forward
	elseif entity.v < -entity.max_speed_reverse then
		entity.v = -entity.max_speed_reverse
	end

	-- Set position, velocity and acceleration
	local p = entity.object:get_pos()

	if not p then return end

	local new_acce = {x = 0, y = entity.fall_speed, z = 0}

	p.y = p.y - 0.5

	local ni = node_is(p)
	local v = entity.v

	if ni == "air" then

		if can_fly == true then
			new_acce.y = 0
		end

	elseif ni == "liquid" or ni == "lava" then

		if ni == "lava" and entity.lava_damage ~= 0 then

			entity.lava_counter = (entity.lava_counter or 0) + dtime

			if entity.lava_counter > 1 then

				minetest.sound_play("default_punch", {
					object = entity.object,
					max_hear_distance = 5
				}, true)

				entity.object:punch(entity.object, 1.0, {
					full_punch_interval = 1.0,
					damage_groups = {fleshy = entity.lava_damage}
				}, nil)

				entity.lava_counter = 0
			end
		end

		local terrain_type = entity.terrain_type

		if terrain_type == 2 or terrain_type == 3 then

			new_acce.y = 0
			p.y = p.y + 1

			if node_is(p) == "liquid" then

				if velo.y >= 5 then
					velo.y = 5
				elseif velo.y < 0 then
					new_acce.y = 20
				else
					new_acce.y = 5
				end
			else
				if abs(velo.y) < 1 then

					local pos = entity.object:get_pos()

					if not pos then return end

					pos.y = floor(pos.y) + 0.5
					entity.object:set_pos(pos)
					velo.y = 0
				end
			end
		else
			v = v * 0.25
		end
	end

	local new_velo = get_velocity(v, yaw - rot_view, velo.y)

	new_acce.y = new_acce.y + acce_y

	entity.object:set_velocity(new_velo)
	entity.object:set_acceleration(new_acce)

	entity.v2 = v
end


-- directional flying routine by D00Med (edited by TenPlus1)
function mobs.fly(entity, _, speed, shoots, arrow, moving_anim, stand_anim)

	local ctrl = entity.driver:get_player_control() ; if not ctrl then return end
	local velo = entity.object:get_velocity()
	local dir = entity.driver:get_look_dir()
	local yaw = entity.driver:get_look_horizontal() + 1.57

	if not ctrl or not velo then return end

	if ctrl.up then

		entity.object:set_velocity({
			x = dir.x * speed,
			y = dir.y * speed + 2,
			z = dir.z * speed
		})

	elseif ctrl.down then

		entity.object:set_velocity({
			x = -dir.x * speed,
			y =  dir.y * speed + 2,
			z = -dir.z * speed
		})

	elseif not ctrl.down or ctrl.up or ctrl.jump then
		entity.object:set_velocity({x = 0, y = -2, z = 0})
	end

	entity.object:set_yaw(yaw + pi + pi / 2 - entity.rotate)

	-- firing arrows
	if ctrl.LMB and ctrl.sneak and shoots then

		local pos = entity.object:get_pos()
		local obj = minetest.add_entity({
			x = pos.x + 0 + dir.x * 2.5,
			y = pos.y + 1.5 + dir.y,
			z = pos.z + 0 + dir.z * 2.5}, arrow)

		local ent = obj:get_luaentity()

		if ent then

			ent.switch = 1 -- for mob specific arrows
			ent.owner_id = tostring(entity.object) -- so arrows dont hurt entity you are riding
			local vec = {x = dir.x * 6, y = dir.y * 6, z = dir.z * 6}

			yaw = entity.driver:get_look_horizontal()

			obj:set_yaw(yaw + pi / 2)
			obj:set_velocity(vec)
		else
			obj:remove()
		end
	end

	-- change animation if stopped
	if velo.x == 0 and velo.y == 0 and velo.z == 0 then
		mobs:set_animation(entity, stand_anim)
	else
		-- moving animation
		mobs:set_animation(entity, moving_anim)
	end
end
