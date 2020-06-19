
--[[
	Textures edited from:
	http://www.minecraftforum.net/forums/mapping-and-modding/minecraft-mods/1288375-food-plus-mod-more-food-than-you-can-imagine-v2-9)
]]

local S = farming.intllib

-- tomato
minetest.register_craftitem("farming:tomato", {
	description = S("Tomato"),
	inventory_image = "farming_tomato.png",
	groups = {food_tomato = 1, flammable = 2},
	on_place = function(itemstack, placer, pointed_thing)
		return farming.place_seed(itemstack, placer, pointed_thing, "farming:tomato_1")
	end,
	on_use = minetest.item_eat(4),
})

-- tomato definition
local crop_def = {
	drawtype = "plantlike",
	tiles = {"farming_tomato_1.png"},
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
minetest.register_node("farming:tomato_1", table.copy(crop_def))

-- stage2
crop_def.tiles = {"farming_tomato_2.png"}
minetest.register_node("farming:tomato_2", table.copy(crop_def))

-- stage 3
crop_def.tiles = {"farming_tomato_3.png"}
minetest.register_node("farming:tomato_3", table.copy(crop_def))

-- stage 4
crop_def.tiles = {"farming_tomato_4.png"}
minetest.register_node("farming:tomato_4", table.copy(crop_def))

-- stage 5
crop_def.tiles = {"farming_tomato_5.png"}
minetest.register_node("farming:tomato_5", table.copy(crop_def))

-- stage 6
crop_def.tiles = {"farming_tomato_6.png"}
minetest.register_node("farming:tomato_6", table.copy(crop_def))

-- stage 7
crop_def.tiles = {"farming_tomato_7.png"}
crop_def.drop = {
	items = {
		{items = {'farming:tomato'}, rarity = 2},
		{items = {'farming:tomato'}, rarity = 4},
	}
}
minetest.register_node("farming:tomato_7", table.copy(crop_def))

-- stage 8 (final)
crop_def.tiles = {"farming_tomato_8.png"}
crop_def.groups.growing = 0
crop_def.drop = {
	items = {
		{items = {'farming:tomato 3'}, rarity = 1},
		{items = {'farming:tomato 3'}, rarity = 2},
	}
}
minetest.register_node("farming:tomato_8", table.copy(crop_def))

-- add to registered_plants
farming.registered_plants["farming:tomato"] = {
	crop = "farming:tomato",
	seed = "farming:tomato",
	minlight = 13,
	maxlight = 15,
	steps = 8
}
