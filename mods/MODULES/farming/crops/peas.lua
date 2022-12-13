
local S = farming.intllib

-- Textures for Pea crop and Peas were done by Andrey01

-- pea pod
minetest.register_craftitem("farming:pea_pod", {
	description = S("Pea Pod"),
	inventory_image = "farming_pea_pod.png",
	groups = {seed = 2, food_pea_pod = 1, flammable = 2},
	on_place = function(itemstack, placer, pointed_thing)
		return farming.place_seed(itemstack, placer, pointed_thing, "farming:pea_1")
	end
})

minetest.register_craftitem("farming:peas", {
	description = S("Peas"),
	inventory_image = "farming_pea_peas.png",
	groups = {food_peas = 1, flammable = 2},
	on_use = minetest.item_eat(1)
})

minetest.register_craft({
	type = "shapeless",
	output = "farming:peas",
	recipe = {"farming:pea_pod"}
})

-- pea soup
minetest.register_craftitem("farming:pea_soup", {
	description = S("Pea Soup"),
	inventory_image = "farming_pea_soup.png",
	groups = {flammable = 2},
	on_use = minetest.item_eat(4, "farming:bowl")
})

minetest.register_craft({
	type = "shapeless",
	output = "farming:pea_soup",
	recipe = {"group:food_peas", "group:food_peas", "group:food_bowl"}
})

local def = {
	drawtype = "plantlike",
	tiles = {"farming_pea_1.png"},
	paramtype = "light",
	paramtype2 = "meshoptions",
	place_param2 = 3,
	sunlight_propagates = true,
	waving = 1,
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
minetest.register_node("farming:pea_1", table.copy(def))

-- stage 2
def.tiles = {"farming_pea_2.png"}
minetest.register_node("farming:pea_2", table.copy(def))

-- stage 3
def.tiles = {"farming_pea_3.png"}
minetest.register_node("farming:pea_3", table.copy(def))

-- stage 4
def.tiles = {"farming_pea_4.png"}
minetest.register_node("farming:pea_4", table.copy(def))

-- stage 5
def.tiles = {"farming_pea_5.png"}
def.groups.growing = nil
def.drop = {
	max_items = 5, items = {
		{items = {"farming:pea_pod"}, rarity = 1},
		{items = {"farming:pea_pod"}, rarity = 2},
		{items = {"farming:pea_pod"}, rarity = 3},
		{items = {"farming:pea_pod"}, rarity = 5}
	}
}
minetest.register_node("farming:pea_5", table.copy(def))

-- add to registered_plants
farming.registered_plants["farming:pea_pod"] = {
	crop = "farming:pea",
	seed = "farming:pea_pod",
	minlight = 13,
	maxlight = 15,
	steps = 5
}
