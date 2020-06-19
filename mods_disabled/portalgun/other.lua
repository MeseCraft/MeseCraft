local pgad_rules={{x = 1, y = 0, z = 0},{x =-1, y = 0, z = 0},{x = 0, y = 1, z = 0},{x = 0, y =-1, z = 0},{x = 0, y = 0, z = 1},{x = 0, y = 0, z =-1}}

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

minetest.register_on_respawnplayer(function(player)
	local name=player:get_player_name()
	minetest.after(1, function(name)
		if portalgun.checkpoints[name]~=nil then
			player:move_to(portalgun.checkpoints[name])
		end
	end, name)

end)

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