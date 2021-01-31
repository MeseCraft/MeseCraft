
local S = farming.intllib

-- beetroot
minetest.register_craftitem("farming:beetroot", {
	description = S("Beetroot"),
	inventory_image = "farming_beetroot.png",
	groups = {seed = 2, food_beetroot = 1, flammable = 2},
	on_place = function(itemstack, placer, pointed_thing)
		return farming.place_seed(itemstack, placer, pointed_thing, "farming:beetroot_1")
	end,
	on_use = minetest.item_eat(1)
})

-- beetroot soup
minetest.register_craftitem("farming:beetroot_soup", {
	description = S("Beetroot Soup"),
	inventory_image = "farming_beetroot_soup.png",
	groups = {flammable = 2},
	on_use = minetest.item_eat(6, "farming:bowl")
})

minetest.register_craft({
	type = "shapeless",
	output = "farming:beetroot_soup",
	recipe = {
		"group:food_beetroot", "group:food_beetroot",
		"group:food_beetroot", "group:food_beetroot",
		"group:food_beetroot", "group:food_beetroot","group:food_bowl"
	}
})

-- red dye
minetest.register_craft({
	type = "shapeless",
	output = "dye:red",
	recipe = {"group:food_beetroot"}
})

local def = {
	drawtype = "plantlike",
	tiles = {"farming_beetroot_1.png"},
	paramtype = "light",
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
minetest.register_node("farming:beetroot_1", table.copy(def))

-- stage 2
def.tiles = {"farming_beetroot_2.png"}
minetest.register_node("farming:beetroot_2", table.copy(def))

-- stage 3
def.tiles = {"farming_beetroot_3.png"}
minetest.register_node("farming:beetroot_3", table.copy(def))

-- stage 4
def.tiles = {"farming_beetroot_4.png"}
minetest.register_node("farming:beetroot_4", table.copy(def))

-- stage 5
def.tiles = {"farming_beetroot_5.png"}
def.groups.growing = nil
def.drop = {
	max_items = 4, items = {
		{items = {"farming:beetroot"}, rarity = 1},
		{items = {"farming:beetroot"}, rarity = 2},
		{items = {"farming:beetroot"}, rarity = 3},
		{items = {"farming:beetroot"}, rarity = 4}
	}
}
minetest.register_node("farming:beetroot_5", table.copy(def))

-- add to registered_plants
farming.registered_plants["farming:beetroot"] = {
	crop = "farming:beetroot",
	seed = "farming:beetroot",
	minlight = 13,
	maxlight = 15,
	steps = 5
}
