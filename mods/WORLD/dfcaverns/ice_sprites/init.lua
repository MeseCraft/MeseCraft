ice_sprites = {}

local modname = minetest.get_current_modname()
local S = minetest.get_translator(modname)

local ice_sprite_desc
local ice_sprite_usage
local ice_sprite_bottle_desc
local ice_sprite_bottle_usage

local node_name_glass_bottle = df_dependencies.node_name_glass_bottle
local node_name_firefly = df_dependencies.node_name_fireflies

if minetest.get_modpath("doc") then
	ice_sprite_desc = S("Ice sprites are mysterious glowing insect-like creatures that appear to be made partly of crystallized water.")
	if node_name_glass_bottle then
		if node_name_firefly then
			ice_sprite_usage = S("Ice sprites can be caught with nets and placed in bottles as sources of light and freezing cold.")
		end
		ice_sprite_bottle_desc = S("A bottle containing a captured ice sprite.")
		ice_sprite_bottle_usage = S("Ice sprites radiate both light and freezing cold.")
	end	
end
	
minetest.register_node("ice_sprites:ice_sprite", {
	description = S("Ice Sprite"),
	_doc_items_longdesc = ice_sprite_desc,
	_doc_items_usagehelp = ice_sprite_usage,
	drawtype = "plantlike",
	tiles = {{
		name = "ice_sprites_ice_sprite_animated.png",
		animation = {
			type = "vertical_frames",
			aspect_w = 16,
			aspect_h = 16,
			length = 1.5
		},
	}},
	inventory_image = "ice_sprites_ice_sprite.png",
	wield_image = "ice_sprites_ice_sprite.png",
	waving = 1,
	paramtype = "light",
	sunlight_propagates = true,
	buildable_to = true,
	is_ground_content = false,
	walkable = false,
	groups = {catchable = 1, puts_out_fire = 1, cools_lava = 1, freezes_water = 1},
	selection_box = {
		type = "fixed",
		fixed = {-0.1, -0.1, -0.1, 0.1, 0.1, 0.1},
	},
	light_source = 6,
	floodable = true,
	_mcl_blast_resistance = 0.1,
	_mcl_hardness = 0.1,
	on_place = function(itemstack, placer, pointed_thing)
		local player_name = placer:get_player_name()
		local pos = pointed_thing.above

		if not minetest.is_protected(pos, player_name) and
				not minetest.is_protected(pointed_thing.under, player_name) and
				minetest.get_node(pos).name == "air" then
			minetest.set_node(pos, {name = "ice_sprites:ice_sprite"})
			minetest.get_node_timer(pos):start(1)
			itemstack:take_item()
		end
		return itemstack
	end,
	on_timer = function(pos, elapsed)
		if minetest.get_node_light(pos) > 11 or math.random() > 0.5 then
			minetest.set_node(pos, {name = "ice_sprites:hidden_ice_sprite"})
		end
		minetest.get_node_timer(pos):start(math.random(20,40))
	end
})

minetest.register_node("ice_sprites:hidden_ice_sprite", {
	description = S("Hidden Ice Sprite"),
	drawtype = "airlike",
	inventory_image = "ice_sprites_ice_sprite.png",
	wield_image =  "ice_sprites_ice_sprite.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	is_ground_content = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	drop = "ice_sprites:ice_sprite",
	groups = {not_in_creative_inventory = 1},
	floodable = true,
	_mcl_blast_resistance = 0.1,
	_mcl_hardness = 0.1,
	on_place = function(itemstack, placer, pointed_thing)
		local player_name = placer:get_player_name()
		local pos = pointed_thing.above

		if not minetest.is_protected(pos, player_name) and
				not minetest.is_protected(pointed_thing.under, player_name) and
				minetest.get_node(pos).name == "air" then
			minetest.set_node(pos, {name = "ice_sprites:hidden_ice_sprite"})
			minetest.get_node_timer(pos):start(1)
			itemstack:take_item()
		end
		return itemstack
	end,
	on_timer = function(pos, elapsed)
		if minetest.get_node_light(pos) <= 11 then
			minetest.set_node(pos, {name = "ice_sprites:ice_sprite"})
		end
		minetest.get_node_timer(pos):start(math.random(20,40))
	end
})

-- ice sprite in a bottle
if node_name_glass_bottle then

local glass_sounds
if minetest.get_modpath("df_dependencies") then
	glass_sounds = df_dependencies.sound_glass
end

minetest.register_node("ice_sprites:ice_sprite_bottle", {
	description = S("Ice Sprite in a Bottle"),
	_doc_items_longdesc = ice_sprite_bottle_desc,
	_doc_items_usagehelp = ice_sprite_bottle_usage,
	inventory_image = "ice_sprites_bottle.png",
	wield_image = "ice_sprites_bottle.png",
	tiles = {{
		name = "ice_sprites_bottle_animated.png",
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
	is_ground_content = false,
	walkable = false,
	groups = {dig_immediate = 3, attached_node = 1, puts_out_fire = 1, cools_lava = 1, freezes_water = 1, material_glass=1},
	selection_box = {
		type = "fixed",
		fixed = {-0.25, -0.5, -0.25, 0.25, 0.3, 0.25}
	},
	_mcl_blast_resistance = 0.5,
	_mcl_hardness = 0.5,
	sounds = glass_sounds(),
	on_rightclick = function(pos, node, player, itemstack, pointed_thing)
		local lower_pos = {x = pos.x, y = pos.y + 1, z = pos.z}
		if minetest.is_protected(pos, player:get_player_name()) or
				minetest.get_node(lower_pos).name ~= "air" then
			return
		end

		local upper_pos = {x = pos.x, y = pos.y + 2, z = pos.z}
		local ice_sprite_pos

		if not minetest.is_protected(upper_pos, player:get_player_name()) and
				minetest.get_node(upper_pos).name == "air" then
			ice_sprite_pos = upper_pos
		elseif not minetest.is_protected(lower_pos, player:get_player_name()) then
			ice_sprite_pos = lower_pos
		end

		if ice_sprite_pos then
			minetest.set_node(pos, {name = node_name_glass_bottle})
			minetest.set_node(ice_sprite_pos, {name = "ice_sprites:ice_sprite"})
			minetest.get_node_timer(ice_sprite_pos):start(1)
		end
	end
})

minetest.register_craft( {
	type = "shapeless",
	output = "ice_sprites:ice_sprite_bottle",
	recipe = {"ice_sprites:ice_sprite", node_name_glass_bottle}
})
end
