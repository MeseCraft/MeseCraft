
--[[
	Original textures from Crops Plus mod
	Copyright (C) 2018 Grizzly Adam
	https://forum.minetest.net/viewtopic.php?f=9&t=19488
]]

local S = farming.intllib

-- peppercorn (seed)
minetest.register_craftitem("farming:peppercorn", {
	description = S("Peppercorn"),
	inventory_image = "crops_peppercorn.png",
	groups = {seed = 1, food_peppercorn = 1, flammable = 3},
	on_place = function(itemstack, placer, pointed_thing)
		return farming.place_seed(itemstack, placer, pointed_thing, "farming:pepper_1")
	end
})

-- green pepper
minetest.register_craftitem("farming:pepper", {
	description = S("Pepper"),
	inventory_image = "crops_pepper.png",
	on_use = minetest.item_eat(2),
	groups = {food_pepper = 1, flammable = 3}
})

minetest.register_craft({
	type = "shapeless",
	output = "farming:peppercorn",
	recipe = {"farming:pepper"}
})

-- ground pepper
minetest.register_node("farming:pepper_ground", {
	description = S("Ground Pepper"),
	inventory_image = "crops_pepper_ground.png",
	wield_image = "crops_pepper_ground.png",
	drawtype = "plantlike",
	visual_scale = 0.8,
	paramtype = "light",
	tiles = {"crops_pepper_ground.png"},
	groups = {
		vessel = 1, food_pepper_ground = 1,
		dig_immediate = 3, attached_node = 1
	},
	sounds = default.node_sound_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-0.25, -0.5, -0.25, 0.25, 0.3, 0.25}
	}
})

minetest.register_craft( {
	output = "farming:pepper_ground",
	type = "shapeless",
	recipe = {"group:food_peppercorn", "vessels:glass_bottle", "farming:mortar_pestle"},
	replacements = {{"group:food_mortar_pestle", "farming:mortar_pestle"}}
})

-- crop definition
local def = {
	drawtype = "plantlike",
	tiles = {"crops_pepper_plant_1.png"},
	paramtype = "light",
	paramtype2 = "meshoptions",
	place_param2 = 1,
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
minetest.register_node("farming:pepper_1", table.copy(def))

-- stage 2
def.tiles = {"crops_pepper_plant_2.png"}
minetest.register_node("farming:pepper_2", table.copy(def))

-- stage 3
def.tiles = {"crops_pepper_plant_3.png"}
minetest.register_node("farming:pepper_3", table.copy(def))

-- stage 4
def.tiles = {"crops_pepper_plant_4.png"}
minetest.register_node("farming:pepper_4", table.copy(def))

-- stage 5
def.tiles = {"crops_pepper_plant_5.png"}
def.groups.growing = 0
def.drop = {
	items = {
		{items = {"farming:pepper 2"}, rarity = 1},
		{items = {"farming:pepper"}, rarity = 2},
		{items = {"farming:pepper"}, rarity = 3}
	}
}
minetest.register_node("farming:pepper_5", table.copy(def))

-- add to registered_plants
farming.registered_plants["farming:pepper"] = {
	crop = "farming:pepper",
	seed = "farming:peppercorn",
	minlight = 13,
	maxlight = 15,
	steps = 5
}
