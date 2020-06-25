
--[[
	Original textures from PixelBox texture pack
	https://forum.minetest.net/viewtopic.php?id=4990
]]

local S = farming.intllib

-- carrot
minetest.register_craftitem("farming:carrot", {
	description = S("Carrot"),
	inventory_image = "farming_carrot.png",
	groups = {food_carrot = 1, flammable = 2},
	on_place = function(itemstack, placer, pointed_thing)
		return farming.place_seed(itemstack, placer, pointed_thing, "farming:carrot_1")
	end,
	on_use = minetest.item_eat(4),
})

-- golden carrot
minetest.register_craftitem("farming:carrot_gold", {
	description = S("Golden Carrot"),
	inventory_image = "farming_carrot_gold.png",
	on_use = minetest.item_eat(6),
})

minetest.register_craft({
	output = "farming:carrot_gold",
	recipe = {
		{"", "default:gold_lump", ""},
		{"default:gold_lump", "group:food_carrot", "default:gold_lump"},
		{"", "default:gold_lump", ""},
	}
})

-- carrot definition
local crop_def = {
	drawtype = "plantlike",
	tiles = {"farming_carrot_1.png"},
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
minetest.register_node("farming:carrot_1", table.copy(crop_def))

-- stage 2
crop_def.tiles = {"farming_carrot_2.png"}
minetest.register_node("farming:carrot_2", table.copy(crop_def))

-- stage 3
crop_def.tiles = {"farming_carrot_3.png"}
minetest.register_node("farming:carrot_3", table.copy(crop_def))

-- stage 4
crop_def.tiles = {"farming_carrot_4.png"}
minetest.register_node("farming:carrot_4", table.copy(crop_def))

-- stage 5
crop_def.tiles = {"farming_carrot_5.png"}
minetest.register_node("farming:carrot_5", table.copy(crop_def))

-- stage 6
crop_def.tiles = {"farming_carrot_6.png"}
minetest.register_node("farming:carrot_6", table.copy(crop_def))

-- stage 7
crop_def.tiles = {"farming_carrot_7.png"}
crop_def.drop = {
	items = {
		{items = {'farming:carrot'}, rarity = 2},
	}
}
minetest.register_node("farming:carrot_7", table.copy(crop_def))

-- stage 8 (final)
crop_def.tiles = {"farming_carrot_8.png"}
crop_def.groups.growing = 0
crop_def.drop = {
	items = {
		{items = {'farming:carrot'}, rarity = 1},
		{items = {'farming:carrot 2'}, rarity = 2},
	}
}
minetest.register_node("farming:carrot_8", table.copy(crop_def))

-- add to registered_plants
farming.registered_plants["farming:carrot"] = {
	crop = "farming:carrot",
	seed = "farming:carrot",
	minlight = 13,
	maxlight = 15,
	steps = 8
}
