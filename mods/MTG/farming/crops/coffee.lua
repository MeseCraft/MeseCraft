
local S = farming.intllib

-- coffee
minetest.register_craftitem("farming:coffee_beans", {
	description = S("Coffee Beans"),
	inventory_image = "farming_coffee_beans.png",
	groups = {seed = 2, food_coffee = 1, flammable = 2},
	on_place = function(itemstack, placer, pointed_thing)
		return farming.place_seed(itemstack, placer, pointed_thing, "farming:coffee_1")
	end
})

-- cold cup of coffee
minetest.register_node("farming:coffee_cup", {
	description = S("Cup of Coffee"),
	drawtype = "torchlike",
	tiles = {"farming_coffee_cup.png"},
	inventory_image = "farming_coffee_cup.png",
	wield_image = "farming_coffee_cup.png",
	paramtype = "light",
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-0.25, -0.5, -0.25, 0.25, 0.25, 0.25}
	},
	groups = {vessel = 1, dig_immediate = 3, attached_node = 1, drink = 1},
	on_use = minetest.item_eat(2, "vessels:drinking_glass"),
	sounds = default.node_sound_glass_defaults()
})

minetest.register_alias("farming:coffee_cup_hot", "farming:coffee_cup")
minetest.register_alias("farming:drinking_cup", "vessels:drinking_glass")

minetest.register_craft( {
	output = "farming:coffee_cup",
	type = "shapeless",
	recipe = {
		"vessels:drinking_glass", "group:food_coffee",
		"bucket:bucket_water", "group:food_saucepan"},
	replacements = {
		{"bucket:bucket_water", "bucket:bucket_empty"},
		{"group:food_saucepan", "farming:saucepan"}
	}
})

-- coffee definition
local def = {
	drawtype = "plantlike",
	tiles = {"farming_coffee_1.png"},
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
minetest.register_node("farming:coffee_1", table.copy(def))

-- stage 2
def.tiles = {"farming_coffee_2.png"}
minetest.register_node("farming:coffee_2", table.copy(def))

-- stage 3
def.tiles = {"farming_coffee_3.png"}
minetest.register_node("farming:coffee_3", table.copy(def))

-- stage 4
def.tiles = {"farming_coffee_4.png"}
minetest.register_node("farming:coffee_4", table.copy(def))

-- stage 5 (final)
def.tiles = {"farming_coffee_5.png"}
def.groups.growing = nil
def.drop = {
	items = {
		{items = {"farming:coffee_beans 2"}, rarity = 1},
		{items = {"farming:coffee_beans 2"}, rarity = 2},
		{items = {"farming:coffee_beans 2"}, rarity = 3}
	}
}
minetest.register_node("farming:coffee_5", table.copy(def))

-- add to registered_plants
farming.registered_plants["farming:coffee"] = {
	crop = "farming:coffee",
	seed = "farming:coffee_beans",
	minlight = 13,
	maxlight = 15,
	steps = 5
}
