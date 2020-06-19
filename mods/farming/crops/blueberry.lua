
local S = farming.intllib

-- blueberries

-- Removing redundant blueberry item from legacy.
--minetest.register_craftitem("farming:blueberries", {
--	description = S("Blueberries"),
--	inventory_image = "farming_blueberries.png",
--	groups = {food_blueberries = 1, food_blueberry = 1, food_berry = 1, flammable = 2},
--	on_place = function(itemstack, placer, pointed_thing)
--		return farming.place_seed(itemstack, placer, pointed_thing, "farming:blueberry_1")
--	end,
--	on_use = minetest.item_eat(1),
--})

-- blueberry muffin (thanks to sosogirl123 @ deviantart.com for muffin image)

minetest.register_craftitem("farming:muffin_blueberry", {
	description = S("Blueberry Muffin"),
	inventory_image = "farming_blueberry_muffin.png",
	on_use = minetest.item_eat(2),
})

minetest.register_craft({
	output = "farming:muffin_blueberry 2",
	recipe = {
		{"default:blueberries", "group:food_bread", "default:blueberries"},
	}
})

-- Blueberry Pie

minetest.register_craftitem("farming:blueberry_pie", {
	description = S("Blueberry Pie"),
	inventory_image = "farming_blueberry_pie.png",
	on_use = minetest.item_eat(6),
})

minetest.register_craft({
	output = "farming:blueberry_pie",
	type = "shapeless",
	recipe = {
		"group:food_flour", "group:food_sugar",
		"default:blueberries", "group:food_baking_tray"
	},
	replacements = {{"group:food_baking_tray", "farming:baking_tray"}}
})

-- blueberry definition
--local crop_def = {
--	drawtype = "plantlike",
--	tiles = {"farming_blueberry_1.png"},
--	paramtype = "light",
--	sunlight_propagates = true,
--	walkable = false,
--	buildable_to = true,
--	drop = "",
--	selection_box = farming.select,
--	groups = {
--		snappy = 3, flammable = 2, plant = 1, attached_node = 1,
--		not_in_creative_inventory = 1, growing = 1
--	},
--	sounds = default.node_sound_leaves_defaults()
--}

-- stage 1
--minetest.register_node("farming:blueberry_1", table.copy(crop_def))

-- stage 2
--crop_def.tiles = {"farming_blueberry_2.png"}
--minetest.register_node("farming:blueberry_2", table.copy(crop_def))

-- stage 3
--crop_def.tiles = {"farming_blueberry_3.png"}
--minetest.register_node("farming:blueberry_3", table.copy(crop_def))

-- stage 4 (final)
--crop_def.tiles = {"farming_blueberry_4.png"}
--crop_def.groups.growing = 0
--crop_def.drop = {
--	items = {
--		{items = {'farming:blueberries'}, rarity = 1},
--		{items = {'farming:blueberries'}, rarity = 10},
--	}
--}
--minetest.register_node("farming:blueberry_4", table.copy(crop_def))

-- add to registered_plants
--farming.registered_plants["farming:blueberries"] = {
--	crop = "farming:blueberry",
--	seed = "farming:blueberries",
--	minlight = 13,
--	maxlight = 15,
--	steps = 4
--}
