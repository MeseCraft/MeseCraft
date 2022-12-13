-- firefly/init.lua

-- Load support for MT game translation.
local S = minetest.get_translator(minetest.get_current_modname())

local bottle = df_dependencies.node_name_glass_bottle

minetest.register_node("df_dependencies:firefly", {
	description = S("Firefly"),
	drawtype = "plantlike",
	tiles = {{
		name = "fireflies_firefly_animated.png",
		animation = {
			type = "vertical_frames",
			aspect_w = 16,
			aspect_h = 16,
			length = 1.5
		},
	}},
	inventory_image = "fireflies_firefly.png",
	wield_image =  "fireflies_firefly.png",
	waving = 1,
	paramtype = "light",
	sunlight_propagates = true,
	buildable_to = true,
	walkable = false,
	groups = {catchable = 1, destroy_by_lava_flow=1},
	selection_box = {
		type = "fixed",
		fixed = {-0.1, -0.1, -0.1, 0.1, 0.1, 0.1},
	},
	light_source = 6,
	floodable = true,
	_mcl_blast_resistance = 0.2,
	_mcl_hardness = 0.2,
	on_place = function(itemstack, placer, pointed_thing)
		local player_name = placer:get_player_name()
		local pos = pointed_thing.above

		if not minetest.is_protected(pos, player_name) and
				not minetest.is_protected(pointed_thing.under, player_name) and
				minetest.get_node(pos).name == "air" then
			minetest.set_node(pos, {name = "df_dependencies:firefly"})
			minetest.get_node_timer(pos):start(1)
			itemstack:take_item()
		end
		return itemstack
	end,
	on_timer = function(pos, elapsed)
		if minetest.get_node_light(pos) > 11 then
			minetest.set_node(pos, {name = "df_dependencies:hidden_firefly"})
		end
		minetest.get_node_timer(pos):start(30)
	end
})

minetest.register_node("df_dependencies:hidden_firefly", {
	description = S("Hidden Firefly"),
	drawtype = "airlike",
	inventory_image = "fireflies_firefly.png^default_invisible_node_overlay.png",
	wield_image =  "fireflies_firefly.png^default_invisible_node_overlay.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	drop = "",
	groups = {not_in_creative_inventory = 1, destroy_by_lava_flow=1},
	floodable = true,
	_mcl_blast_resistance = 0.2,
	_mcl_hardness = 0.2,
	on_place = function(itemstack, placer, pointed_thing)
		local player_name = placer:get_player_name()
		local pos = pointed_thing.above

		if not minetest.is_protected(pos, player_name) and
				not minetest.is_protected(pointed_thing.under, player_name) and
				minetest.get_node(pos).name == "air" then
			minetest.set_node(pos, {name = "df_dependencies:hidden_firefly"})
			minetest.get_node_timer(pos):start(1)
			itemstack:take_item()
		end
		return itemstack
	end,
	on_timer = function(pos, elapsed)
		if minetest.get_node_light(pos) <= 11 then
			minetest.set_node(pos, {name = "df_dependencies:firefly"})
		end
		minetest.get_node_timer(pos):start(30)
	end
})


-- bug net
minetest.register_tool("df_dependencies:bug_net", {
	description = S("Bug Net"),
	inventory_image = "fireflies_bugnet.png",
	on_use = function(itemstack, player, pointed_thing)
		local player_name = player and player:get_player_name() or ""
		if not pointed_thing or pointed_thing.type ~= "node" or
				minetest.is_protected(pointed_thing.under, player_name) then
			return
		end
		local node_name = minetest.get_node(pointed_thing.under).name
		local inv = player:get_inventory()
		if minetest.get_item_group(node_name, "catchable") == 1 then
			minetest.set_node(pointed_thing.under, {name = "air"})
			local stack = ItemStack(node_name.." 1")
			local leftover = inv:add_item("main", stack)
			if leftover:get_count() > 0 then
				minetest.add_item(pointed_thing.under, node_name.." 1")
			end
		end
		if not minetest.is_creative_enabled(player_name) then
			itemstack:add_wear_by_uses(256)
			return itemstack
		end
	end
})

minetest.register_craft( {
	output = "df_dependencies:bug_net",
	recipe = {
		{df_dependencies.node_name_string, df_dependencies.node_name_string},
		{df_dependencies.node_name_string, df_dependencies.node_name_string},
		{"group:stick", ""}
	}
})


-- firefly in a bottle
minetest.register_node("df_dependencies:firefly_bottle", {
	description = S("Firefly in a Bottle"),
	inventory_image = "fireflies_bottle.png",
	wield_image = "fireflies_bottle.png",
	tiles = {{
		name = "fireflies_bottle_animated.png",
		animation = {
			type = "vertical_frames",
			aspect_w = 16,
			aspect_h = 16,
			length = 1.5
		},
	}},
	drawtype = "plantlike",
	paramtype = "light",
	sunlight_propagates = true,
	light_source = 9,
	walkable = false,
	groups = {vessel = 1, dig_immediate = 3, attached_node = 1, material_glass = 1, destroy_by_lava_flow=1},
	selection_box = {
		type = "fixed",
		fixed = {-0.25, -0.5, -0.25, 0.25, 0.3, 0.25}
	},
	sounds = df_dependencies.sound_glass(),
	on_rightclick = function(pos, node, player, itemstack, pointed_thing)
		local lower_pos = {x = pos.x, y = pos.y + 1, z = pos.z}
		if minetest.is_protected(pos, player:get_player_name()) or
				minetest.get_node(lower_pos).name ~= "air" then
			return
		end

		local upper_pos = {x = pos.x, y = pos.y + 2, z = pos.z}
		local firefly_pos

		if not minetest.is_protected(upper_pos, player:get_player_name()) and
				minetest.get_node(upper_pos).name == "air" then
			firefly_pos = upper_pos
		elseif not minetest.is_protected(lower_pos, player:get_player_name()) then
			firefly_pos = lower_pos
		end

		if firefly_pos then
			minetest.add_item(pos, bottle)
			minetest.set_node(pos, {name = "air"})
			minetest.set_node(firefly_pos, {name = "df_dependencies:firefly"})
			minetest.get_node_timer(firefly_pos):start(1)
		end
	end
})

minetest.register_craft( {
	output = "df_dependencies:firefly_bottle",
	type = "shapeless",
	recipe = {"df_dependencies:firefly", bottle},
})
