
local S = ethereal.intllib

-- Banana (Heals one heart when eaten)
minetest.register_node("ethereal:banana", {
	description = S("Banana"),
	drawtype = "torchlike",
	tiles = {"banana_single.png"},
	inventory_image = "banana_single.png",
	wield_image = "banana_single.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-0.31, -0.5, -0.31, 0.31, 0.5, 0.31}
	},
	groups = {
		food_banana = 1, fleshy = 3, dig_immediate = 3, flammable = 2,
		leafdecay = 1, leafdecay_drop = 1
	},
	drop = "ethereal:banana",
	on_use = minetest.item_eat(2),
	sounds = default.node_sound_leaves_defaults(),
	after_place_node = function(pos, placer)
		if placer:is_player() then
			minetest.set_node(pos, {name = "ethereal:banana", param2 = 1})
		end
	end,
})

-- Banana Bunch
minetest.register_node("ethereal:banana_bunch", {
	description = S("Banana Bunch"),
	drawtype = "torchlike",
	tiles = {"banana_bunch.png"},
	inventory_image = "banana_bunch.png",
	wield_image = "banana_bunch.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-0.31, -0.5, -0.31, 0.31, 0.5, 0.31}
	},
	groups = {
		fleshy = 3, dig_immediate = 3, flammable = 2,
		leafdecay = 1, leafdecay_drop = 1
	},
	drop = "ethereal:banana_bunch",
	on_use = minetest.item_eat(6),
	sounds = default.node_sound_leaves_defaults(),
	after_place_node = function(pos, placer)
		if placer:is_player() then
			minetest.set_node(pos, {name = "ethereal:banana_bunch", param2 = 1})
		end
	end,
})

-- Bunch to Single
minetest.register_craft({
	type = "shapeless",
	output = "ethereal:banana 3",
	recipe = {"ethereal:banana_bunch"}
})

minetest.register_craft({
	type = "shapeless",
	output = "ethereal:banana_bunch",
	recipe = {"ethereal:banana", "ethereal:banana", "ethereal:banana"}
})

-- Banana Dough
minetest.register_craftitem("ethereal:banana_dough", {
	description = S("Banana Dough"),
	inventory_image = "banana_dough.png",
})

minetest.register_craft({
	type = "shapeless",
	output = "ethereal:banana_dough",
	recipe = {"group:food_flour", "group:food_banana"}
})

minetest.register_craft({
	type = "cooking",
	cooktime = 14,
	output = "ethereal:banana_bread",
	recipe = "ethereal:banana_dough"
})

-- Orange (Heals 2 hearts when eaten)
minetest.register_node("ethereal:orange", {
	description = S("Orange"),
	drawtype = "plantlike",
	tiles = {"farming_orange.png"},
	inventory_image = "farming_orange.png",
	wield_image = "farming_orange.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-0.27, -0.37, -0.27, 0.27, 0.44, 0.27}
	},
	groups = {
		food_orange = 1, fleshy = 3, dig_immediate = 3, flammable = 2,
		leafdecay = 3, leafdecay_drop = 1
	},
	drop = "ethereal:orange",
	on_use = minetest.item_eat(4),
	sounds = default.node_sound_leaves_defaults(),
	after_place_node = function(pos, placer)
		if placer:is_player() then
			minetest.set_node(pos, {name = "ethereal:orange", param2 = 1})
		end
	end,
})

-- Pine Nuts (Heals 1/2 heart when eaten)
minetest.register_craftitem("ethereal:pine_nuts", {
	description = S("Pine Nuts"),
	inventory_image = "pine_nuts.png",
	wield_image = "pine_nuts.png",
	groups = {food_pine_nuts = 1, flammable = 2},
	on_use = minetest.item_eat(1),
})

-- Banana Loaf (Heals 3 hearts when eaten)
minetest.register_craftitem("ethereal:banana_bread", {
	description = S("Banana Loaf"),
	inventory_image = "banana_bread.png",
	wield_image = "banana_bread.png",
	groups = {food_bread = 1, flammable = 3},
	on_use = minetest.item_eat(6),
})

-- Coconut (Gives 4 coconut slices, each heal 1/2 heart)
minetest.register_node("ethereal:coconut", {
	description = S("Coconut"),
	drawtype = "plantlike",
	walkable = false,
	paramtype = "light",
	sunlight_propagates = true,
	tiles = {"moretrees_coconut.png"},
	inventory_image = "moretrees_coconut.png",
	wield_image = "moretrees_coconut.png",
	selection_box = {
		type = "fixed",
		fixed = {-0.31, -0.43, -0.31, 0.31, 0.44, 0.31}
	},
	groups = {
		food_coconut = 1, snappy = 1, oddly_breakable_by_hand = 1, cracky = 1,
		choppy = 1, flammable = 1, leafdecay = 3, leafdecay_drop = 1
	},
	drop = "ethereal:coconut_slice 4",
	sounds = default.node_sound_wood_defaults(),
})

-- Coconut Slice (Heals half heart when eaten)
minetest.register_craftitem("ethereal:coconut_slice", {
	description = S("Coconut Slice"),
	inventory_image = "moretrees_coconut_slice.png",
	wield_image = "moretrees_coconut_slice.png",
	groups = {food_coconut_slice = 1, flammable = 1},
	on_use = minetest.item_eat(1),
})

-- Golden Apple (Found on Healing Tree, heals all 10 hearts)
minetest.register_node("ethereal:golden_apple", {
	description = S("Golden Apple"),
	drawtype = "plantlike",
	tiles = {"default_apple_gold.png"},
	inventory_image = "default_apple_gold.png",
	wield_image = "default_apple_gold.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-0.2, -0.37, -0.2, 0.2, 0.31, 0.2}
	},
	groups = {
		fleshy = 3, dig_immediate = 3,
		leafdecay = 3,leafdecay_drop = 1
	},
	drop = "ethereal:golden_apple",
--	on_use = minetest.item_eat(20),
	on_use = function(itemstack, user, pointed_thing)
		if user then
			user:set_hp(20)
			return minetest.do_item_eat(2, nil, itemstack, user, pointed_thing)
		end
	end,
	sounds = default.node_sound_leaves_defaults(),
	after_place_node = function(pos, placer, itemstack)
		if placer:is_player() then
			minetest.set_node(pos, {name = "ethereal:golden_apple", param2 = 1})
		end
	end,
})

-- Hearty Stew (Heals 5 hearts - thanks to ZonerDarkRevention for his DokuCraft DeviantArt bowl texture)
minetest.register_craftitem("ethereal:hearty_stew", {
	description = S("Hearty Stew"),
	inventory_image = "hearty_stew.png",
	wield_image = "hearty_stew.png",
	on_use = minetest.item_eat(10, "ethereal:bowl"),
})

minetest.register_craft({
	output = "ethereal:hearty_stew",
	recipe = {
		{"group:food_onion","flowers:mushroom_brown", "group:food_tuber"},
		{"","flowers:mushroom_brown", ""},
		{"","group:food_bowl", ""},
	}
})

-- Extra recipe for hearty stew
if farming and farming.mod and farming.mod == "redo" then
minetest.register_craft({
	output = "ethereal:hearty_stew",
	recipe = {
		{"group:food_onion","flowers:mushroom_brown", "group:food_beans"},
		{"","flowers:mushroom_brown", ""},
		{"","group:food_bowl", ""},
	}
})
end

-- Bucket of Cactus Pulp
minetest.register_craftitem("ethereal:bucket_cactus", {
	description = S("Bucket of Cactus Pulp"),
	inventory_image = "bucket_cactus.png",
	wield_image = "bucket_cactus.png",
	stack_max = 1,
	groups = {vessel = 1, drink = 1},
	on_use = minetest.item_eat(2, "bucket:bucket_empty"),
})

minetest.register_craft({
	output = "ethereal:bucket_cactus",
	recipe = {
		{"bucket:bucket_empty","default:cactus"},
	}
})


-- firethorn jelly
minetest.register_craftitem("ethereal:firethorn_jelly", {
	description = S("Firethorn Jelly"),
	inventory_image = "ethereal_firethorn_jelly.png",
	wield_image = "ethereal_firethorn_jelly.png",
	on_use = minetest.item_eat(2, "vessels:glass_bottle"),
	groups = {vessel = 1},
})

if minetest.registered_items["farming:bowl"] then

minetest.register_craft({
	type = "shapeless",
	output = "ethereal:firethorn_jelly",
	recipe = {
		"farming:mortar_pestle","vessels:glass_bottle",
		"ethereal:firethorn", "ethereal:firethorn", "ethereal:firethorn",
		"bucket:bucket_water", "bucket:bucket_water", "bucket:bucket_water",
	},
	replacements = {
		{"bucket:bucket_water", "bucket:bucket_empty 3"},
		{"farming:mortar_pestle", "farming:mortar_pestle"},
	},
})
end


-- Lemon
minetest.register_node("ethereal:lemon", {
	description = S("Lemon"),
	drawtype = "plantlike",
	tiles = {"lemon.png"},
	inventory_image = "lemon_fruit.png",
	wield_image = "lemon_fruit.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-0.27, -0.37, -0.27, 0.27, 0.44, 0.27}
	},
	groups = {
		food_lemon = 1, fleshy = 3, dig_immediate = 3, flammable = 2,
		leafdecay = 3, leafdecay_drop = 1
	},
	drop = "ethereal:lemon",
	on_use = minetest.item_eat(3),
	sounds = default.node_sound_leaves_defaults(),
	after_place_node = function(pos, placer)
		if placer:is_player() then
			minetest.set_node(pos, {name = "ethereal:lemon", param2 = 1})
		end
	end,
})

-- Candied Lemon
minetest.register_craftitem("ethereal:candied_lemon", {
	description = S("Candied Lemon"),
	inventory_image = "ethereal_candied_lemon.png",
	wield_image = "ethereal_candied_lemon.png",
	groups = {food_candied_lemon = 1},
	on_use = minetest.item_eat(5),
})

minetest.register_craft({
	type = "shapeless",
	output = "ethereal:candied_lemon",
	recipe = {
		"farming:baking_tray", "ethereal:lemon", "group:food_sugar"
	},
	replacements = {
		{"farming:baking_tray", "farming:baking_tray"}
	},
})

-- Olive
minetest.register_node("ethereal:olive", {
	description = S("Olive"),
	drawtype = "plantlike",
	tiles = {"olive.png"},
	inventory_image = "olive_fruit.png",
	wield_image = "olive_fruit.png",
	visual_scale = 0.2,
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-0.1, -0.5, -0.1, 0.1, -0.3, 0.1}
	},
	groups = {
		fleshy = 3, dig_immediate = 3, flammable = 2,
		leafdecay = 3, leafdecay_drop = 1
	},
	drop = "ethereal:olive",
	on_use = minetest.item_eat(1),
	sounds = default.node_sound_leaves_defaults(),
	after_place_node = function(pos, placer)
		if placer:is_player() then
			minetest.set_node(pos, {name = "ethereal:olive", param2 = 1})
		end
	end,
})

-- Olive Oil
minetest.register_craftitem("ethereal:olive_oil", {
	description = S("Olive Oil"),
	inventory_image = "ethereal_olive_oil.png",
	wield_image = "ethereal_olive_oil.png",
	groups = {food_oil = 1, food_olive_oil = 1, vessel = 1},
})

minetest.register_craft({
	type = "shapeless",
	output = "ethereal:olive_oil",
	recipe = {
		"farming:juicer", "vessels:glass_bottle",
		"ethereal:olive", "ethereal:olive", "ethereal:olive",
		"ethereal:olive", "ethereal:olive", "ethereal:olive"
	},
	replacements = {
		{"farming:juicer", "farming:juicer"}
	},
})
