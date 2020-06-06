
local S = farming.intllib

-- pineapple top
minetest.register_craftitem("farming:pineapple_top", {
	description = S("Pineapple Top"),
	inventory_image = "farming_pineapple_top.png",
	on_place = function(itemstack, placer, pointed_thing)
		return farming.place_seed(itemstack, placer, pointed_thing, "farming:pineapple_1")
	end,
})

-- pineapple
minetest.register_node("farming:pineapple", {
	description = S("Pineapple"),
	drawtype = "plantlike",
	tiles = {"farming_pineapple.png"},
	inventory_image = "farming_pineapple.png",
	wield_image = "farming_pineapple.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-0.27, -0.37, -0.27, 0.27, 0.44, 0.27}
	},
	groups = {food_pineapple = 1, fleshy = 3, dig_immediate = 3, flammable = 2},
})

-- pineapple
minetest.register_craftitem("farming:pineapple_ring", {
	description = S("Pineapple Ring"),
	inventory_image = "farming_pineapple_ring.png",
	groups = {food_pineapple_ring = 1, flammable = 2},
	on_use = minetest.item_eat(1),
})

minetest.register_craft( {
	output = "farming:pineapple_ring 5",
	type = "shapeless",
	recipe = {"group:food_pineapple"},
	replacements = {{"farming:pineapple", "farming:pineapple_top"}}
})

-- crop definition
local crop_def = {
	drawtype = "plantlike",
	visual_scale = 1.5,
	tiles = {"farming_pineapple_1.png"},
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	drop = "",
	selection_box = farming.select,
	groups = {
		snappy = 3, flammable = 2, plant = 1, attached_node = 1,
		not_in_creative_inventory = 1, growing = 1
	},
	sounds = default.node_sound_leaves_defaults()
}

-- stage 1
minetest.register_node("farming:pineapple_1", table.copy(crop_def))

-- stage 2
crop_def.tiles = {"farming_pineapple_2.png"}
minetest.register_node("farming:pineapple_2", table.copy(crop_def))

-- stage 3
crop_def.tiles = {"farming_pineapple_3.png"}
minetest.register_node("farming:pineapple_3", table.copy(crop_def))

-- stage 4
crop_def.tiles = {"farming_pineapple_4.png"}
minetest.register_node("farming:pineapple_4", table.copy(crop_def))

-- stage 5
crop_def.tiles = {"farming_pineapple_5.png"}
minetest.register_node("farming:pineapple_5", table.copy(crop_def))

-- stage 6
crop_def.tiles = {"farming_pineapple_6.png"}
minetest.register_node("farming:pineapple_6", table.copy(crop_def))

-- stage 7
crop_def.tiles = {"farming_pineapple_7.png"}
minetest.register_node("farming:pineapple_7", table.copy(crop_def))

-- stage 8 (final)
crop_def.tiles = {"farming_pineapple_8.png"}
crop_def.groups.growing = 0
crop_def.drop = {
	items = {
		{items = {'farming:pineapple'}, rarity = 1},
		{items = {'farming:pineapple'}, rarity = 15},
	}
}
minetest.register_node("farming:pineapple_8", table.copy(crop_def))

-- add to registered_plants
farming.registered_plants["farming:pineapple"] = {
	crop = "farming:pineapple",
	seed = "farming:pineapple_top",
	minlight = 13,
	maxlight = 15,
	steps = 8
}
