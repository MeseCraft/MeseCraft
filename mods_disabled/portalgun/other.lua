local pgad_rules={{x = 1, y = 0, z = 0},{x =-1, y = 0, z = 0},{x = 0, y = 1, z = 0},{x = 0, y =-1, z = 0},{x = 0, y = 0, z = 1},{x = 0, y = 0, z =-1}}


minetest.register_node("portalgun:cplps1", {
	description = "Close player portal",
	tiles = {"portalgun_gray.png"},
	groups = {mesecon=2,snappy = 3, not_in_creative_inventory=0},
	sounds = default.node_sound_stone_defaults(),
	is_ground_content = false,
	mesecons = {effector = {
		action_on = function (pos, node)
		for i, ob in pairs(minetest.get_objects_inside_radius(pos, 6)) do
			if ob and ob:is_player() then
				portal_delete(ob:get_player_name(),0)
			end
		end
		minetest.swap_node(pos, {name="portalgun:cplps2"})
		minetest.after((2), function(pos)
			minetest.swap_node(pos, {name="portalgun:cplps1"})
		end, pos)


		return false
	end,
	}}
})



minetest.register_node("portalgun:cplps2", {
	description = "Close player portal",
	tiles = {"portalgun_gray.png^[colorize:#ffe85977"},
	groups = {mesecon=2,snappy = 3, not_in_creative_inventory=1},
	sounds = default.node_sound_stone_defaults(),
	is_ground_content = false,
	paramtype = "light",
	light_source = 4,
})



minetest.register_node("portalgun:sign_v", {
	description = "Sign V",
	tiles = {"portalgun_v.png"},
	inventory_image = "portalgun_v.png",
	drop="portalgun:sign_x",
	drawtype = "nodebox",
	groups = {mesecon=2,snappy = 3, not_in_creative_inventory=1},
	sounds = default.node_sound_wood_defaults(),
	is_ground_content = false,
	paramtype2 = "facedir",
	paramtype = "light",
	light_source = 5,
	node_box = {
	type="fixed",
	fixed={-0.5,-0.5,0.45,0.5,0.5,0.5}},
	mesecons = {effector = {
		action_off = function (pos, node)
		minetest.swap_node(pos, {name="portalgun:sign_x", param2=minetest.get_node(pos).param2})
	end,
	}}
})


minetest.register_node("portalgun:sign_x", {
	description = "Sign X",
	tiles = {"portalgun_x.png"},
	inventory_image = "portalgun_x.png",
	drawtype = "nodebox",
	groups = {mesecon=2,snappy = 3, not_in_creative_inventory=0},
	sounds = default.node_sound_wood_defaults(),
	is_ground_content = false,
	paramtype2 = "facedir",
	paramtype = "light",
	light_source = 3,
	node_box = {
	type="fixed",
	fixed={-0.5,-0.5,0.45,0.5,0.5,0.5}},
	mesecons = {effector = {
		action_on = function (pos, node)
		minetest.swap_node(pos, {name="portalgun:sign_v", param2=minetest.get_node(pos).param2})
		end,
	}}
})


local portaltarget_sig={
{1,"portalgun_blue.png"},
{2,"portalgun_orange.png"},
}

for ii = 1, #portaltarget_sig, 1 do

minetest.register_node("portalgun:portaltarget_" .. portaltarget_sig[ii][1], {
	description = "Portal target " .. portaltarget_sig[ii][1] ,
	tiles = {"portalgun_testblock.png^" .. portaltarget_sig[ii][2]},
	groups = {mesecon = 2,cracky=2},
	mesecons = {receptor = {state = "off"}},
	sounds = default.node_sound_stone_defaults(),
	is_ground_content = false,
	paramtype2 = "facedir",
	paramtype = "light",
	on_timer = function (pos, elapsed)
		for i, ob in pairs(minetest.get_objects_inside_radius(pos, 2)) do
			if ob:get_luaentity() and ob:get_luaentity().portalgun and ob:get_luaentity().project==portaltarget_sig[ii][1] then
				mesecon.receptor_on(pos)

				return true
			end
		end
		mesecon.receptor_off(pos)
		return true
	end,
	on_construct = function(pos)
		if not mesecon then return false end
		minetest.get_node_timer(pos):start(2)
	end,
})
end



minetest.register_node("portalgun:button", {
	description = "Button",
	tiles = {"portalgun_bu.png"},
	groups = {cracky = 3,mesecon=1},
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	selection_box = {type = "fixed",fixed = { -0.2, -0.5, -0.2, 0.2, 0.85, 0.2 }},
	sounds = default.node_sound_defaults(),
	mesecons = {receptor = {state = "off"}},
	on_rightclick = function(pos, node, clicker)
		mesecon.receptor_on(pos)
		minetest.get_node_timer(pos):start(2)
		minetest.sound_play("default_dig_dig_immediate", {pos=pos,max_hear_distance = 10, gain = 1})
	end,
	on_timer = function (pos, elapsed)
		mesecon.receptor_off(pos)
	end,
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.25, -0.5, -0.25, 0.25, 0.7, 0.25},
			{-0.125, 0.5, -0.125, 0.125, 0.77, 0.125},
		}}
		


})

minetest.register_node("portalgun:dmgblock_1", {
	description = "Damage block (hurts when not active)",
	tiles = {"portalgun_powerwall.png"},
	groups = {cracky = 1,mesecon=2},
	drawtype="glasslike",
	paramtype="light",
	alpha = 50,
	sunlight_propagates = true,
	sounds = default.node_sound_stone_defaults(),
	walkable=false,
	damage_per_second = 5,
	mesecons = {conductor = {
		state = mesecon.state.off,
		onstate = "portalgun:dmgblock_2",
		rules = pgad_rules
	}},
})
minetest.register_node("portalgun:dmgblock_2", {
	description = "Damage block",
	tiles = {"portalgun_gravity.png"},
	groups = {mesecon=2,not_in_creative_inventory=1},
	drawtype="airlike",
	pointable=false,
	sunlight_propagates = true,
	drop="portalgun:dmgblock_1",
	paramtype="light",
	walkable=false,
	mesecons = {conductor = {
		state = mesecon.state.on,
		offstate = "portalgun:dmgblock_1",
		rules = pgad_rules
	}},
})













minetest.register_on_respawnplayer(function(player)
	local name=player:get_player_name()
	minetest.after(1, function(name)
		if portalgun.checkpoints[name]~=nil then
			player:move_to(portalgun.checkpoints[name])
		end
	end, name)

end)
minetest.register_on_leaveplayer(function(player)
	local name=player:get_player_name()
	if portalgun.checkpoints[name]~=nil then
		portalgun.checkpoints[name]=nil
	end
end)
minetest.register_node("portalgun:autocheckpoint", {
	description = "Checkpoint (teleports to here on death)",
	tiles = {"portalgun_checkpoint.png"},
	groups = {cracky = 3,not_in_creative_inventory=0},
	paramtype = "light",
	sunlight_propagates = true,
	light_source = 5,
	sounds = default.node_sound_stone_defaults(),
	drawtype="nodebox",
	node_box = {
	type="fixed",
	fixed={-0.5,-0.5,-0.5,0.5,-0.4,0.5}},
	on_construct = function(pos)
		minetest.get_meta(pos):set_string("infotext","Checkpoint")
		minetest.get_node_timer(pos):start(2)
	end,
	on_timer = function (pos, elapsed)
		for i, ob in pairs(minetest.get_objects_inside_radius(pos, 1.5)) do
			if ob:is_player() then
				local name=ob:get_player_name()
				if portalgun.checkpoints[name]~=nil then
					local cp=portalgun.checkpoints[name]
					if cp.x==pos.x and cp.y==pos.y and cp.z==pos.z then
						return true
					end
				end
				portal_delete(name,0)
				portalgun_portal[name]=nil
				portalgun.checkpoints[name]=pos
				minetest.sound_play("portalgun_checkpoint", {pos=pos,max_hear_distance = 5, gain = 1})
				minetest.chat_send_player(name, "<Portalgun> You will spawn here next time you die")
			end
		end
		return true
	end,
})

minetest.register_node("portalgun:powerdoor1_1", {
	description = "Power door",
	inventory_image = "portalgun_powerwall.png",
	wield_image = "portalgun_powerwall.png",
	groups = {mesecon=1,unbreakable = 1,not_in_creative_inventory=0},
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	sounds = default.node_sound_stone_defaults(),
	drawtype="nodebox",
	alpha = 160,
	node_box = {
	type="fixed",
	fixed={-0.5,-0.5,0.4,0.5,0.5,0.5}},
	tiles = {
		{
			name = "portalgun_powerwall1.png",
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 0.2,
			},
		},
	},
after_place_node = function(pos, placer, itemstack)
		local name=placer:get_player_name()
		minetest.get_meta(pos):set_string("owner",name)
		local p2=minetest.get_node(pos)
		pos.y=pos.y+1
		local n=minetest.get_node(pos)
		if n.name=="air" then
			minetest.set_node(pos,{name="portalgun:powerdoor1_2",param2=p2.param2})
			minetest.get_meta(pos):set_string("owner",name)
		end
	end,
on_punch = function(pos, node, player, pointed_thing)
		local meta = minetest.get_meta(pos);
		if meta:get_string("owner")==player:get_player_name() then
			minetest.node_dig(pos,minetest.get_node(pos),player)
			pos.y=pos.y+1
			local un=minetest.get_node(pos).name
			if un=="portalgun:powerdoor1_2" then
				minetest.set_node(pos,{name="air"})
			end
			pos.y=pos.y-1
			return true
		end
	end,
	mesecons = {conductor = {
		state = mesecon.state.off,
		onstate = "portalgun:powerdoor2_1",
		rules = pgad_rules
	}},
})

minetest.register_node("portalgun:powerdoor1_2", {
	description = "Power door",
	inventory_image = "portalgun_powerwall.png",
	groups = {mesecon=1,unbreakable = 1,not_in_creative_inventory=1},
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	sounds = default.node_sound_stone_defaults(),
	drawtype="nodebox",
	alpha = 160,
	node_box = {
	type="fixed",
	fixed={-0.5,-0.5,0.4,0.5,0.5,0.5}},
	tiles = {
		{
			name = "portalgun_powerwall1.png",
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 0.2,
			},
		},
	},
on_punch = function(pos, node, player, pointed_thing)
		local meta = minetest.get_meta(pos);
		if meta:get_string("owner")==player:get_player_name() then
			minetest.set_node(pos,{name="air"})
			pos.y=pos.y-1
			local un=minetest.get_node(pos).name
			if un=="portalgun:powerdoor1_1" then
				minetest.node_dig(pos,minetest.get_node(pos),player)
			end
			pos.y=pos.y+1
			return true
		end
	end,
	mesecons = {conductor = {
		state = mesecon.state.off,
		onstate = "portalgun:powerdoor2_2",
		rules = pgad_rules
	}},
})

minetest.register_node("portalgun:powerdoor2_1", {
	description = "Power door",
	inventory_image = "portalgun_powerwall.png",
	groups = {unbreakable=1,mesecon=1,not_in_creative_inventory=1},
	paramtype = "light",
	sunlight_propagates = true,
	drawtype="airlike",
	walkable = false,
	pointable = false,
	diggable = false,
	mesecons = {conductor = {
		state = mesecon.state.on,
		offstate = "portalgun:powerdoor1_1",
		rules = pgad_rules
	}},
})

minetest.register_node("portalgun:powerdoor2_2", {
	description = "Power door",
	inventory_image = "portalgun_powerwall.png",
	groups = {unbreakable=1,mesecon=1,not_in_creative_inventory=1},
	paramtype = "light",
	sunlight_propagates = true,
	drawtype="airlike",
	walkable = false,
	pointable = false,
	diggable = false,
	mesecons = {conductor = {
		state = mesecon.state.on,
		offstate = "portalgun:powerdoor1_2",
		rules = pgad_rules
	}},
})


minetest.register_node("portalgun:delayer", {
	description = "Delayer (Punsh to change time)",
	tiles = {"portalgun_delayer.png","portalgun_testblock.png"},
	groups = {dig_immediate = 2,mesecon=1},
	sounds = default.node_sound_stone_defaults(),
	paramtype = "light",
	sunlight_propagates = true,
	drawtype="nodebox",
	node_box = {
	type="fixed",
	fixed={-0.5,-0.5,-0.5,0.5,-0.4,0.5}},
on_punch = function(pos, node, player, pointed_thing)
		if minetest.is_protected(pos, player:get_player_name())==false then
			local meta = minetest.get_meta(pos)
			local time=meta:get_int("time")
			if time>=10 then time=0 end
			meta:set_int("time",time+1)
			meta:set_string("infotext","Delayer (" .. (time+1) ..")")
		end
	end,


	on_construct = function(pos)
			local meta = minetest.get_meta(pos)
			meta:set_int("time",1)
			meta:set_string("infotext","Delayer (1)")
			meta:set_int("case",0)
	end,
	on_timer = function (pos, elapsed)
		local meta = minetest.get_meta(pos)
		if meta:get_int("case")==2 then
			meta:set_int("case",0)
			mesecon.receptor_off(pos)
		end
		if meta:get_int("case")==1 then
			meta:set_int("case",2)
			mesecon.receptor_on(pos)
			minetest.get_node_timer(pos):start(meta:get_int("time"))
		end
		return false
	end,

	mesecons = {effector = {
		action_on = function (pos, node)
			local meta = minetest.get_meta(pos)
			if meta:get_int("case")==0 then
				meta:set_int("case",1)
				minetest.get_node_timer(pos):start(meta:get_int("time"))
			end

		end,
	}}
})


minetest.register_node("portalgun:testblocks", {
	description = "Trapblock",
	tiles = {"portalgun_testblock.png"},
	groups = {cracky = 1,mesecon=2},
	sounds = default.node_sound_stone_defaults(),
	mesecons = {conductor = {
		state = mesecon.state.off,
		onstate = "portalgun:testblocks2",
		rules = pgad_rules
	}},
})
minetest.register_node("portalgun:testblocks2", {
	description = "Damage block",
	tiles = {"portalgun_gravity.png"},
	groups = {mesecon=2,not_in_creative_inventory=1},
	drawtype="airlike",
	pointable=false,
	sunlight_propagates = true,
	drop="portalgun:testblocks",
	paramtype="light",
	walkable=false,
	mesecons = {conductor = {
		state = mesecon.state.on,
		offstate = "portalgun:testblocks",
		rules = pgad_rules
	}},
})

minetest.register_node("portalgun:door_1", {
	description = "Mesecon Door",
	drop="portalgun:door_1",
	drawtype = "nodebox",
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.125, 0.5, 0.5, 0.125},
		}
	},
	tiles = {"portalgun_testblock.png"},
	groups = {mesecon=1,cracky = 1, level = 2, not_in_creative_inventory=0},
	sounds = default.node_sound_stone_defaults(),
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	is_ground_content = false,
after_place_node = function(pos, placer, itemstack, pointed_thing)
	local p={x=pos.x,y=pos.y+1,z=pos.z}
	if minetest.registered_nodes[minetest.get_node(p).name].walkable then
		return false
	else
		minetest.set_node(p, {name = "portalgun:door_2",param2=minetest.get_node(pos).param2})
	end
	end,



	mesecons = {effector = {
		action_on = function (pos, node)
	local p={x=pos.x,y=pos.y+1,z=pos.z}
	minetest.swap_node(p, {name="portalgun:door_open_2", param2=minetest.get_node(pos).param2})
	minetest.swap_node(pos, {name="portalgun:door_open_1", param2=minetest.get_node(pos).param2})
	minetest.sound_play("portalgun_door", {pos=pos, gain = 1, max_hear_distance = 5})
		end,
	}},
after_dig_node = function (pos, name, digger)
	minetest.set_node({x=pos.x,y=pos.y+1,z=pos.z}, {name = "air"})
	end,
})

minetest.register_node("portalgun:door_2", {
	description = "Door 2-1",
	drawtype = "nodebox",
	drop="portalgun:door_1",
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.125, 0.5, 0.5, 0.125},
		}
	},
	tiles = {"portalgun_testblock.png"},
	groups = {mesecon=1,cracky = 1, level = 2, not_in_creative_inventory=1},
	sounds = default.node_sound_wood_defaults(),
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	is_ground_content = false,
	mesecons = {effector = {
		action_on = function (pos, node)
	local p={x=pos.x,y=pos.y-1,z=pos.z}
	minetest.swap_node(p, {name="portalgun:door_open_1", param2=minetest.get_node(pos).param2})
	minetest.swap_node(pos, {name="portalgun:door_open_2", param2=minetest.get_node(pos).param2})
	minetest.sound_play("portalgun_door", {pos=pos, gain = 1, max_hear_distance = 5})

		end,
	}},
after_dig_node = function (pos, name, digger)
	minetest.set_node({x=pos.x,y=pos.y-1,z=pos.z}, {name = "air"})
	end,
})

minetest.register_node("portalgun:door_open_1", {
	description = "Door (open) 2-o-1",
	drop="portalgun:door_1",
	drawtype = "nodebox",
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = {
			{0.41, -0.5, -0.124, 1.41, 0.5, 0.125},
		}
	},
	tiles = {"portalgun_testblock.png"},
	groups = {mesecon=1,cracky = 1, level = 2, not_in_creative_inventory=1},
	sounds = default.node_sound_wood_defaults(),
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	is_ground_content = false,
after_dig_node = function (pos, name, digger)
	minetest.set_node({x=pos.x,y=pos.y+1,z=pos.z}, {name = "air"})
	end,
	mesecons = {effector = {
		action_off = function (pos, node)
	local p={x=pos.x,y=pos.y+1,z=pos.z}
	minetest.sound_play("portalgun_door", {pos=pos, gain = 1, max_hear_distance = 5})
	minetest.swap_node(p, {name="portalgun:door_2", param2=minetest.get_node(pos).param2})
	minetest.swap_node(pos, {name="portalgun:door_1", param2=minetest.get_node(pos).param2})
		end,
	}}
})

minetest.register_node("portalgun:door_open_2", {
	description = "Door (open) 2-o-1",
	drawtype = "nodebox",
	drop="portalgun:door_1",
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = {
			{0.41, -0.5, -0.124, 1.41, 0.5, 0.125},
		}
	},
	tiles = {"portalgun_testblock.png"},
	groups = {mesecon=1,cracky = 1, level = 2, not_in_creative_inventory=1},
	sounds = default.node_sound_wood_defaults(),
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	is_ground_content = false,
after_dig_node = function (pos, name, digger)
	minetest.set_node({x=pos.x,y=pos.y-1,z=pos.z}, {name = "air"})
	end,
	mesecons = {effector = {
		action_off = function (pos, node)
	local p={x=pos.x,y=pos.y-1,z=pos.z}
	minetest.sound_play("portalgun_door", {pos=pos, gain = 1, max_hear_distance = 5})
	minetest.swap_node(p, {name="portalgun:door_1", param2=minetest.get_node(pos).param2})
	minetest.swap_node(pos, {name="portalgun:door_2", param2=minetest.get_node(pos).param2})
		end,
	}}
})
