
--[[
	Original textures from GeMinecraft
	http://www.minecraftforum.net/forums/mapping-and-modding/minecraft-mods/wip-mods/1440575-1-2-5-generation-minecraft-beta-1-2-farming-and
]]

local S = farming.intllib

-- corn
minetest.register_craftitem("farming:corn", {
	description = S("Corn"),
	inventory_image = "farming_corn.png",
	groups = {food_corn = 1, flammable = 2},
	on_place = function(itemstack, placer, pointed_thing)
		return farming.place_seed(itemstack, placer, pointed_thing, "farming:corn_1")
	end,
	on_use = minetest.item_eat(3),
})

-- corn on the cob (texture by TenPlus1)
minetest.register_craftitem("farming:corn_cob", {
	description = S("Corn on the Cob"),
	inventory_image = "farming_corn_cob.png",
	groups = {food_corn_cooked = 1, flammable = 2},
	on_use = minetest.item_eat(5),
})

minetest.register_craft({
	type = "cooking",
	cooktime = 10,
	output = "farming:corn_cob",
	recipe = "group:food_corn"
})

-- cornstarch
minetest.register_craftitem("farming:cornstarch", {
	description = S("Cornstarch"),
	inventory_image = "farming_cornstarch.png",
	groups = {food_cornstarch = 1, flammable = 2},
})

minetest.register_craft({
	output = "farming:cornstarch",
	recipe = {
		{"group:food_mortar_pestle", "group:food_corn_cooked", "group:food_baking_tray"},
		{"", "group:food_bowl", ""},
	},
	replacements = {
		{"group:food_mortar_pestle", "farming:mortar_pestle"},
		{"group:food_baking_tray", "farming:baking_tray"},
	}
})

-- corn definition
local crop_def = {
	drawtype = "plantlike",
	tiles = {"farming_corn_1.png"},
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
minetest.register_node("farming:corn_1", table.copy(crop_def))

-- stage 2
crop_def.tiles = {"farming_corn_2.png"}
minetest.register_node("farming:corn_2", table.copy(crop_def))

-- stage 3
crop_def.tiles = {"farming_corn_3.png"}
minetest.register_node("farming:corn_3", table.copy(crop_def))

-- stage 4
crop_def.tiles = {"farming_corn_4.png"}
minetest.register_node("farming:corn_4", table.copy(crop_def))

-- stage 5
crop_def.tiles = {"farming_corn_5.png"}
minetest.register_node("farming:corn_5", table.copy(crop_def))

-- stage 6
crop_def.tiles = {"farming_corn_6.png"}
crop_def.visual_scale = 1.9 -- 1.45
minetest.register_node("farming:corn_6", table.copy(crop_def))

-- stage 7
crop_def.tiles = {"farming_corn_7.png"}
crop_def.drop = {
	items = {
		{items = {'farming:corn'}, rarity = 2},
		{items = {'farming:corn'}, rarity = 3},
	}
}
minetest.register_node("farming:corn_7", table.copy(crop_def))

-- stage 8 (final)
crop_def.tiles = {"farming_corn_8.png"}
crop_def.groups.growing = 0
crop_def.drop = {
	items = {
		{items = {'farming:corn 2'}, rarity = 1},
		{items = {'farming:corn 2'}, rarity = 2},
		{items = {'farming:corn 2'}, rarity = 4},
	}
}
minetest.register_node("farming:corn_8", table.copy(crop_def))

-- add to registered_plants
farming.registered_plants["farming:corn"] = {
	crop = "farming:corn",
	seed = "farming:corn",
	minlight = 13,
	maxlight = 15,
	steps = 8
}
