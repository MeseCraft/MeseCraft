local is_player_near = function (name, pos)
	local objs = minetest.get_objects_inside_radius(pos, 0.5)
	for _, oir in pairs(objsp) do
		if oir:is_player() and oir:get_player_name() == name then
			return true
		end
	end
	return false
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
	local meta = minetest.get_meta(pos)
	local param2 = node.param2
	local name = clicker:get_player_name()
	local sitting = meta:get_string("is_sit")

	if name == sitting then
		meta:set_string("is_sit", nil)
		pos.y = pos.y-0.5
		clicker:set_pos(pos)
		clicker:set_eye_offset({x=0,y=0,z=0}, {x=0,y=0,z=0})
		set_player_fixed(clicker, false)
		default.player_attached[name] = false
		default.player_set_animation(clicker, "stand", 30)
	elseif sitting == nil or not minetest.get_player_ip(sitting) or not is_player_near(sitting, pos) then
		meta:set_string("is_sit", name)
		clicker:set_eye_offset({x=0,y=-7,z=2}, {x=0,y=0,z=0})
		set_player_fixed(clicker, true)
		clicker:set_pos(pos)
		default.player_attached[name] = true
		--clicker:set_attach(node)
		default.player_set_animation(clicker, "sit", 30)
		if param2 == 0 then
			clicker:set_look_yaw(3.15)
		elseif param2 == 1 then
			clicker:set_look_yaw(7.9)
		elseif param2 == 2 then
			clicker:set_look_yaw(6.28)
		elseif param2 == 3 then
			clicker:set_look_yaw(4.75)
		else return end
	end
end
