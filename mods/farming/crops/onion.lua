
--[[
	Original textures from Crops Plus mod
	Copyright (C) 2018 Grizzly Adam
	https://forum.minetest.net/viewtopic.php?f=9&t=19488
]]

local S = farming.intllib

-- onion
minetest.register_craftitem("farming:onion", {
	description = S("Onion"),
	inventory_image = "crops_onion.png",
	groups = {seed = 2, food_onion = 1, flammable = 3},
	on_place = function(itemstack, placer, pointed_thing)
		return farming.place_seed(itemstack, placer, pointed_thing, "farming:onion_1")
	end,
	on_use = minetest.item_eat(1)
})

-- onion soup
minetest.register_craftitem("farming:onion_soup", {
	description = S("Onion Soup"),
	inventory_image = "farming_onion_soup.png",
	groups = {flammable = 2},
	on_use = minetest.item_eat(6, "farming:bowl")
})

minetest.register_craft({
	type = "shapeless",
	output = "farming:onion_soup",
	recipe = {
		"group:food_onion", "group:food_onion", "group:food_pot",
		"group:food_onion", "group:food_onion",
		"group:food_onion", "group:food_onion", "group:food_bowl"
	},
	replacements = {{"farming:pot", "farming:pot"}}
})

-- crop definition
local def = {
	drawtype = "plantlike",
	tiles = {"crops_onion_plant_1.png"},
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
		snappy = 3, flammable = 3, plant = 1, attached_node = 1,
		not_in_creative_inventory = 1, growing = 1
	},
	sounds = default.node_sound_leaves_defaults()
}

-- stage 1
minetest.register_node("farming:onion_1", table.copy(def))

-- stage 2
def.tiles = {"crops_onion_plant_2.png"}
minetest.register_node("farming:onion_2", table.copy(def))

-- stage 3
def.tiles = {"crops_onion_plant_3.png"}
minetest.register_node("farming:onion_3", table.copy(def))

-- stage 4
def.tiles = {"crops_onion_plant_4.png"}
minetest.register_node("farming:onion_4", table.copy(def))

-- stage 5
def.tiles = {"crops_onion_plant_5.png"}
def.groups.growing = nil
def.drop = {
	max_items = 5, items = {
		{items = {"farming:onion"}, rarity = 1},
		{items = {"farming:onion"}, rarity = 1},
		{items = {"farming:onion"}, rarity = 2},
		{items = {"farming:onion"}, rarity = 2},
		{items = {"farming:onion"}, rarity = 5},
	}
}
minetest.register_node("farming:onion_5", table.copy(def))

-- add to registered_plants
farming.registered_plants["farming:onion"] = {
	crop = "farming:onion",
	seed = "farming:onion",
	minlight = 13,
	maxlight = 15,
	steps = 5
}
