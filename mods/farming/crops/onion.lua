
--[[
	Original textures from Crops Plus mod
	Copyright (C) 2018 Grizzly Adam
	https://forum.minetest.net/viewtopic.php?f=9&t=19488
]]

local S = farming.intllib

-- potato
minetest.register_craftitem("farming:onion", {
	description = S("Onion"),
	inventory_image = "crops_onion.png",
	groups = {food_onion = 1, flammable = 3},
	on_place = function(itemstack, placer, pointed_thing)
		return farming.place_seed(itemstack, placer, pointed_thing, "farming:onion_1")
	end,
	on_use = minetest.item_eat(1),
})

-- crop definition
local crop_def = {
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
minetest.register_node("farming:onion_1", table.copy(crop_def))

-- stage 2
crop_def.tiles = {"crops_onion_plant_2.png"}
minetest.register_node("farming:onion_2", table.copy(crop_def))

-- stage 3
crop_def.tiles = {"crops_onion_plant_3.png"}
minetest.register_node("farming:onion_3", table.copy(crop_def))

-- stage 4
crop_def.tiles = {"crops_onion_plant_4.png"}
minetest.register_node("farming:onion_4", table.copy(crop_def))

-- stage 5
crop_def.tiles = {"crops_onion_plant_5.png"}
crop_def.groups.growing = 0
crop_def.drop = {
	items = {
		{items = {'farming:onion 2'}, rarity = 1},
		{items = {'farming:onion'}, rarity = 2},
		{items = {'farming:onion'}, rarity = 2},
		{items = {'farming:onion'}, rarity = 5},
	}
}
minetest.register_node("farming:onion_5", table.copy(crop_def))

-- add to registered_plants
farming.registered_plants["farming:onion"] = {
	crop = "farming:onion",
	seed = "farming:onion",
	minlight = 13,
	maxlight = 15,
	steps = 5
}
