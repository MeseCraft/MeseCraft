
local S = farming.intllib

--= Sugar

minetest.register_craftitem("farming:sugar", {
	description = S("Sugar"),
	inventory_image = "farming_sugar.png",
	groups = {food_sugar = 1, flammable = 3},
})

minetest.register_craft({
	type = "cooking",
	cooktime = 3,
	output = "farming:sugar 2",
	recipe = "default:papyrus",
})


--= Salt

minetest.register_node("farming:salt", {
	description = ("Salt"),
	inventory_image = "farming_salt.png",
	wield_image = "farming_salt.png",
	drawtype = "plantlike",
	visual_scale = 0.8,
	paramtype = "light",
	tiles = {"farming_salt.png"},
	groups = {food_salt = 1, vessel = 1, dig_immediate = 3,
			attached_node = 1},
	sounds = default.node_sound_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-0.25, -0.5, -0.25, 0.25, 0.3, 0.25}
	},
})

minetest.register_craft({
	type = "cooking",
	cooktime = 15,
	output = "farming:salt",
	recipe = "bucket:bucket_water",
	replacements = {{"bucket:bucket_water", "bucket:bucket_empty"}}
})

--= Rose Water

minetest.register_node("farming:rose_water", {
	description = ("Rose Water"),
	inventory_image = "farming_rose_water.png",
	wield_image = "farming_rose_water.png",
	drawtype = "plantlike",
	visual_scale = 0.8,
	paramtype = "light",
	tiles = {"farming_rose_water.png"},
	groups = {food_rose_water = 1, vessel = 1, dig_immediate = 3,
			attached_node = 1},
	sounds = default.node_sound_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-0.25, -0.5, -0.25, 0.25, 0.3, 0.25}
	},
})

minetest.register_craft({
	output = "farming:rose_water",
	recipe = {
		{"flowers:rose", "flowers:rose", "flowers:rose"},
		{"flowers:rose", "flowers:rose", "flowers:rose"},
		{"bucket:bucket_water", "group:food_pot", "vessels:glass_bottle"},
	},
	replacements = {
		{"bucket:bucket_water", "bucket:bucket_empty"},
		{"group:food_pot", "farming:pot"},
	}
})

--= Turkish Delight

minetest.register_craftitem("farming:jelly_delight", {
	description = S("Jelly Delight"),
	inventory_image = "farming_turkish_delight.png",
	groups = {flammable = 3},
	on_use = minetest.item_eat(2),
})

minetest.register_craft({
	output = "farming:jelly_delight 4",
	recipe = {
		{"group:food_gelatin", "group:food_sugar", "group:food_gelatin"},
		{"group:food_sugar", "group:food_rose_water", "group:food_sugar"},
		{"group:food_cornstarch", "group:food_sugar", "dye:pink"},
	},
	replacements = {
		{"group:food_cornstarch", "ethereal:bowl"},
		{"group:food_rose_water", "vessels:glass_bottle"},
	},
})

--= Garlic Bread

minetest.register_craftitem("farming:garlic_bread", {
	description = S("Garlic Bread"),
	inventory_image = "farming_garlic_bread.png",
	groups = {flammable = 3},
	on_use = minetest.item_eat(2),
})

minetest.register_craft({
	type = "shapeless",
	output = "farming:garlic_bread",
	recipe = {"group:food_toast", "group:food_garlic_clove", "group:food_garlic_clove"},
})

--= Donuts (thanks to Bockwurst for making the donut images)

minetest.register_craftitem("farming:donut", {
	description = S("Donut"),
	inventory_image = "farming_donut.png",
	on_use = minetest.item_eat(4),
})

minetest.register_craft({
	output = "farming:donut 3",
	recipe = {
		{"", "group:food_wheat", ""},
		{"group:food_wheat", "group:food_sugar", "group:food_wheat"},
		{"", "group:food_wheat", ""},
	}
})

minetest.register_craftitem("farming:donut_chocolate", {
	description = S("Chocolate Donut"),
	inventory_image = "farming_donut_chocolate.png",
	on_use = minetest.item_eat(6),
})

minetest.register_craft({
	output = "farming:donut_chocolate",
	recipe = {
		{'group:food_cocoa'},
		{'farming:donut'},
	}
})

minetest.register_craftitem("farming:donut_apple", {
	description = S("Apple Donut"),
	inventory_image = "farming_donut_apple.png",
	on_use = minetest.item_eat(6),
})

minetest.register_craft({
	output = "farming:donut_apple",
	recipe = {
		{'default:apple'},
		{'farming:donut'},
	}
})

--= Porridge Oats

minetest.register_craftitem("farming:porridge", {
	description = S("Porridge"),
	inventory_image = "farming_porridge.png",
	on_use = minetest.item_eat(6, "ethereal:bowl"),
})

minetest.after(0, function()

	local fluid = "bucket:bucket_water"
	local fluid_return = "bucket:bucket_water"

	if minetest.get_modpath("mobs") and mobs and mobs.mod == "redo" then
		fluid = "group:food_milk"
		fluid_return = "mobs:bucket_milk"
	end

	minetest.register_craft({
		type = "shapeless",
		output = "farming:porridge",
		recipe = {
			"group:food_barley", "group:food_barley", "group:food_wheat",
			"group:food_wheat", "group:food_bowl", fluid
		},
		replacements = {{fluid_return, "bucket:bucket_empty"}}
	})

	minetest.register_craft({
		type = "shapeless",
		output = "farming:porridge",
		recipe = {
			"group:food_oats", "group:food_oats", "group:food_oats",
			"group:food_oats", "group:food_bowl", fluid
		},
		replacements = {{fluid_return, "bucket:bucket_empty"}}
	})
end)

--= Jaffa Cake

minetest.register_craftitem("farming:jaffa_cake", {
	description = S("Jaffa Cake"),
	inventory_image = "farming_jaffa_cake.png",
	on_use = minetest.item_eat(6),
})

minetest.register_craft({
	type = "shapeless",
	output = "farming:jaffa_cake",
	recipe = {
		"farming:baking_tray", "group:food_egg", "group:food_sugar",
		"group:food_flour", "group:food_cocoa", "group:food_orange",
		"mobs:bucket_milk"
	},
	replacements = {
		{"farming:baking_tray", "farming:baking_tray"},
		{"mobs:bucket_milk", "bucket:bucket_empty"}
	}
})
