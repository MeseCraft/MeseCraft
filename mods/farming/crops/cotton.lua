
local S = farming.intllib

-- wild cotton as a source of cotton seed and a chance of cotton itself
minetest.register_node("farming:cotton_wild", {
	description = S("Wild Cotton"),
	drawtype = "plantlike",
	waving = 1,
	tiles = {"farming_cotton_wild.png"},
	inventory_image = "farming_cotton_wild.png",
	wield_image = "farming_cotton_wild.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	groups = {snappy = 3, attached_node = 1, flammable = 4},
	drop = {
		items = {
			{items = {"farming:cotton"}, rarity = 2},
			{items = {"farming:seed_cotton"}, rarity = 1}
		}
	},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-6 / 16, -8 / 16, -6 / 16, 6 / 16, 5 / 16, 6 / 16}
	}
})

-- cotton seeds
minetest.register_node("farming:seed_cotton", {
	description = S("Cotton Seed"),
	tiles = {"farming_cotton_seed.png"},
	inventory_image = "farming_cotton_seed.png",
	wield_image = "farming_cotton_seed.png",
	drawtype = "signlike",
	groups = {seed = 1, snappy = 3, attached_node = 1, flammable = 4},
	paramtype = "light",
	paramtype2 = "wallmounted",
	walkable = false,
	sunlight_propagates = true,
	selection_box = farming.select,
	on_place = function(itemstack, placer, pointed_thing)
		return farming.place_seed(itemstack, placer, pointed_thing, "farming:cotton_1")
	end
})

-- cotton
minetest.register_craftitem("farming:cotton", {
	description = S("Cotton"),
	inventory_image = "farming_cotton.png",
	groups = {flammable = 4}
})

-- string
minetest.register_craftitem("farming:string", {
	description = S("String"),
	inventory_image = "farming_string.png",
	groups = {flammable = 2}
})

-- cotton to wool
minetest.register_craft({
	output = "wool:white",
	recipe = {
		{"farming:cotton", "farming:cotton"},
		{"farming:cotton", "farming:cotton"}
	}
})

-- cotton to string
minetest.register_craft({
	output = "farming:string 2",
	recipe = {
		{"farming:cotton"},
		{"farming:cotton"}
	}
})

-- can be used as fuel
minetest.register_craft({
	type = "fuel",
	recipe = "farming:string",
	burntime = 1
})

minetest.register_craft({
	type = "fuel",
	recipe = "farming:cotton",
	burntime = 1
})

-- cotton definition
local def = {
	drawtype = "plantlike",
	tiles = {"farming_cotton_1.png"},
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	drop =  "",
	selection_box = farming.select,
	groups = {
		snappy = 3, flammable = 4, plant = 1, attached_node = 1,
		not_in_creative_inventory = 1, growing = 1
	},
	sounds = default.node_sound_leaves_defaults()
}

-- stage 1
minetest.register_node("farming:cotton_1", table.copy(def))

-- stage 2
def.tiles = {"farming_cotton_2.png"}
minetest.register_node("farming:cotton_2", table.copy(def))

-- stage 3
def.tiles = {"farming_cotton_3.png"}
minetest.register_node("farming:cotton_3", table.copy(def))

-- stage 4
def.tiles = {"farming_cotton_4.png"}
minetest.register_node("farming:cotton_4", table.copy(def))

-- stage 5
def.tiles = {"farming_cotton_5.png"}
def.drop = {
	items = {
		{items = {"farming:seed_cotton"}, rarity = 1}
	}
}
minetest.register_node("farming:cotton_5", table.copy(def))

-- stage 6
def.tiles = {"farming_cotton_6.png"}
def.drop = {
	items = {
		{items = {"farming:cotton"}, rarity = 1},
		{items = {"farming:cotton"}, rarity = 2}
	}
}
minetest.register_node("farming:cotton_6", table.copy(def))

-- stage 7
def.tiles = {"farming_cotton_7.png"}
def.drop = {
	items = {
		{items = {"farming:cotton"}, rarity = 1},
		{items = {"farming:cotton"}, rarity = 2},
		{items = {"farming:seed_cotton"}, rarity = 1},
		{items = {"farming:seed_cotton"}, rarity = 2}
	}
}
minetest.register_node("farming:cotton_7", table.copy(def))

-- stage 8 (final)
def.tiles = {"farming_cotton_8.png"}
def.groups.growing = nil
def.drop = {
	items = {
		{items = {"farming:cotton"}, rarity = 1},
		{items = {"farming:cotton"}, rarity = 2},
		{items = {"farming:cotton"}, rarity = 3},
		{items = {"farming:seed_cotton"}, rarity = 1},
		{items = {"farming:seed_cotton"}, rarity = 2},
		{items = {"farming:seed_cotton"}, rarity = 3}
	}
}
minetest.register_node("farming:cotton_8", table.copy(def))

-- add to registered_plants
farming.registered_plants["farming:cotton"] = {
	crop = "farming:cotton",
	seed = "farming:seed_cotton",
	minlight = 13,
	maxlight = 15,
	steps = 8
}

--[[ Cotton using api
farming.register_plant("farming:cotton", {
	description = "Cotton seed",
	inventory_image = "farming_cotton_seed.png",
	groups = {flammable = 2},
	steps = 8,
})]]
