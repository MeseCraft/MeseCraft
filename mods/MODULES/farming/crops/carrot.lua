
--[[
	Original textures from PixelBox texture pack
	https://forum.minetest.net/viewtopic.php?id=4990
]]

local S = farming.intllib

-- carrot
minetest.register_craftitem("farming:carrot", {
	description = S("Carrot"),
	inventory_image = "farming_carrot.png",
	groups = {seed = 2, food_carrot = 1, flammable = 2},
	on_place = function(itemstack, placer, pointed_thing)
		return farming.place_seed(itemstack, placer, pointed_thing, "farming:carrot_1")
	end,
	on_use = minetest.item_eat(4)
})

-- carrot juice
minetest.register_craftitem("farming:carrot_juice", {
	description = S("Carrot Juice"),
	inventory_image = "farming_carrot_juice.png",
	on_use = minetest.item_eat(4, "vessels:drinking_glass"),
	groups = {vessel = 1, drink = 1}
})

minetest.register_craft({
	output = "farming:carrot_juice",
	type = "shapeless",
	recipe = {
		"vessels:drinking_glass", "group:food_carrot", "farming:juicer"
	},
	replacements = {
		{"group:food_juicer", "farming:juicer"}
	}
})

-- golden carrot
minetest.register_craftitem("farming:carrot_gold", {
	description = S("Golden Carrot"),
	inventory_image = "farming_carrot_gold.png",
	on_use = minetest.item_eat(10)
})

minetest.register_craft({
	output = "farming:carrot_gold",
	recipe = {
		{"", "default:gold_lump", ""},
		{"default:gold_lump", "group:food_carrot", "default:gold_lump"},
		{"", "default:gold_lump", ""}
	}
})

-- carrot definition
local def = {
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
minetest.register_node("farming:carrot_1", table.copy(def))

-- stage 2
def.tiles = {"farming_carrot_2.png"}
minetest.register_node("farming:carrot_2", table.copy(def))

-- stage 3
def.tiles = {"farming_carrot_3.png"}
minetest.register_node("farming:carrot_3", table.copy(def))

-- stage 4
def.tiles = {"farming_carrot_4.png"}
minetest.register_node("farming:carrot_4", table.copy(def))

-- stage 5
def.tiles = {"farming_carrot_5.png"}
minetest.register_node("farming:carrot_5", table.copy(def))

-- stage 6
def.tiles = {"farming_carrot_6.png"}
minetest.register_node("farming:carrot_6", table.copy(def))

-- stage 7
def.tiles = {"farming_carrot_7.png"}
def.drop = {
	items = {
		{items = {"farming:carrot"}, rarity = 1},
		{items = {"farming:carrot 2"}, rarity = 3}
	}
}
minetest.register_node("farming:carrot_7", table.copy(def))

-- stage 8 (final)
def.tiles = {"farming_carrot_8.png"}
def.groups.growing = nil
def.drop = {
	items = {
		{items = {"farming:carrot 2"}, rarity = 1},
		{items = {"farming:carrot 3"}, rarity = 2}
	}
}
minetest.register_node("farming:carrot_8", table.copy(def))

-- add to registered_plants
farming.registered_plants["farming:carrot"] = {
	crop = "farming:carrot",
	seed = "farming:carrot",
	minlight = 13,
	maxlight = 15,
	steps = 8
}
