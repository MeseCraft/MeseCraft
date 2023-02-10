ma_pops_furniture.sitting_players = {}

local is_player_near = function (name, pos)
	local objs = minetest.get_objects_inside_radius(pos, 0.6)
	for _, oir in pairs(objs) do
		if oir:is_player() and oir:get_player_name() == name then
			return true
		end
	end
	return false
end

local get_occupant = function(pos)
	local meta = minetest.get_meta(pos)
	local sitting = meta:get_string("is_sit")
	if sitting == nil or not minetest.get_player_ip(sitting) or not is_player_near(sitting, pos) then
		return nil
	else
		return sitting
	end
end

local set_player_fixed = function (player, is_fixed)
	local v = is_fixed and 0 or 1
	local ov = {
		speed = v,
		jump = v,
		gravity = v,
	}
	player:set_physics_override(ov)
end

if player_monoids then
	local id = "ma_pops_furniture:sitting"
	set_player_fixed = function (player, is_fixed)
		if is_fixed then
			player_monoids.speed:add_change(player, 0, id)
			player_monoids.jump:add_change(player, 0, id)
			player_monoids.gravity:add_change(player, 0, id)
		else
			player_monoids.speed:del_change(player, id)
			player_monoids.jump:del_change(player, id)
			player_monoids.gravity:del_change(player, id)
		end
	end
end

function ma_pops_furniture.sit(pos, node, clicker)
	local name = clicker:get_player_name()
	local sitting = get_occupant(pos)

	if name == sitting then
		ma_pops_furniture.force_unsit(name, true)
		pos.y = pos.y-0.5
		clicker:set_pos(pos)
	elseif not sitting then
		local meta = minetest.get_meta(pos)
		meta:set_string("is_sit", name)
		ma_pops_furniture.sitting_players[name] = pos
		clicker:set_eye_offset({x=0,y=-7,z=2}, {x=0,y=0,z=0})
		set_player_fixed(clicker, true)
		pos.y = pos.y + 0.07
		clicker:set_pos(pos)
		clicker:set_velocity({x=0,y=0,z=0})
		default.player_attached[name] = true
		default.player_set_animation(clicker, "sit", 30)
		local function check_unsit()
			local pos = ma_pops_furniture.sitting_players[name]
			if pos then
				local player = minetest.get_player_by_name(name)
				local loc = player and player:get_pos()
				if not loc or vector.distance(pos, loc) > 1 then
					ma_pops_furniture.force_unsit(name, true)
				else
					-- still sitting
					minetest.after(5, check_unsit)
				end
			end
		end
		minetest.after(5, check_unsit)
		local param2 = node.param2
		if param2 == 0 then
			clicker:set_look_yaw(math.pi)
		elseif param2 == 1 then
			clicker:set_look_yaw(math.pi / 2)
		elseif param2 == 2 then
			clicker:set_look_yaw(0)
		elseif param2 == 3 then
			clicker:set_look_yaw(-math.pi / 2)
		else return end
	end
end

ma_pops_furniture.force_unsit = function(name, do_stand)
	local pos = ma_pops_furniture.sitting_players[name]
	if pos then
		ma_pops_furniture.sitting_players[name] = nil
		local meta = minetest.get_meta(pos)
		local sitting = meta:get_string("is_sit")
		if name == sitting then
			meta:set_string("is_sit", nil)
		end
		local player = minetest.get_player_by_name(name)
		if player then
			set_player_fixed(player, false)
		end
		if do_stand and player then
			player:set_eye_offset({x=0,y=0,z=0}, {x=0,y=0,z=0})
			default.player_attached[name] = false
			default.player_set_animation(player, "stand", 30)
		end
	end
end

ma_pops_furniture.cannot_dig_while_sitting = function(pos, player)
	return get_occupant(pos) == nil
end

ma_pops_furniture.unsit_on_blast = function(pos)
	local sitting = get_occupant(pos)
	if sitting then
		ma_pops_furniture.force_unsit(sitting, true)
	end
	local node_name = minetest.get_node(pos).name
	local def = minetest.registered_nodes[node_name]
	minetest.remove_node(pos)
	return { def and def.drop or node_name }
end

minetest.register_on_dieplayer(function(player)
	ma_pops_furniture.force_unsit(player:get_player_name(), false)
end)

minetest.register_on_leaveplayer(function(player)
	ma_pops_furniture.force_unsit(player:get_player_name(), false)
end)
