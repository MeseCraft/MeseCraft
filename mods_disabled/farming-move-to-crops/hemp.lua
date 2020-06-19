
local S = farming.intllib

-- hemp seeds
minetest.register_node("farming:seed_hemp", {
	description = S("Hemp Seed"),
	tiles = {"farming_hemp_seed.png"},
	inventory_image = "farming_hemp_seed.png",
	wield_image = "farming_hemp_seed.png",
	drawtype = "signlike",
	groups = {seed = 1, snappy = 3, attached_node = 1},
	paramtype = "light",
	paramtype2 = "wallmounted",
	walkable = false,
	sunlight_propagates = true,
	selection_box = farming.select,
	on_place = function(itemstack, placer, pointed_thing)
		return farming.place_seed(itemstack, placer, pointed_thing, "farming:hemp_1")
	end,
})

-- harvested hemp
minetest.register_craftitem("farming:hemp_leaf", {
	description = S("Hemp Leaf"),
	inventory_image = "farming_hemp_leaf.png",
})

-- hemp oil
minetest.register_node("farming:hemp_oil", {
	description = S("Bottle of Hemp Oil"),
	drawtype = "plantlike",
	tiles = {"farming_hemp_oil.png"},
	inventory_image = "farming_hemp_oil.png",
	wield_image = "farming_hemp_oil.png",
	paramtype = "light",
	is_ground_content = false,
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-0.25, -0.5, -0.25, 0.25, 0.3, 0.25}
	},
	groups = {food_oil = 1, vessel = 1, dig_immediate = 3, attached_node = 1},
	sounds = default.node_sound_glass_defaults(),
})

minetest.register_craft( {
	output = "farming:hemp_oil",
	recipe = {
		{"farming:hemp_leaf", "farming:hemp_leaf", "farming:hemp_leaf"},
		{"farming:hemp_leaf", "farming:hemp_leaf", "farming:hemp_leaf"},
		{"", "vessels:glass_bottle", ""}
	}
})

minetest.register_craft( {
	output = "farming:hemp_oil",
	recipe = {
		{"farming:seed_hemp", "farming:seed_hemp", "farming:seed_hemp"},
		{"farming:seed_hemp", "farming:seed_hemp", "farming:seed_hemp"},
		{"farming:seed_hemp", "vessels:glass_bottle", "farming:seed_hemp"}
	}
})

minetest.register_craft({
	type = "fuel",
	recipe = "farming:hemp_oil",
	burntime = 20,
	replacements = {{ "farming:hemp_oil", "vessels:glass_bottle"}}
})

-- hemp fibre
minetest.register_craftitem("farming:hemp_fibre", { 
	description = S("Hemp Fibre"),
	inventory_image = "farming_hemp_fibre.png",
})

minetest.register_craft( {
	output = "farming:hemp_fibre 8",
	recipe = {
		{"farming:hemp_leaf", "farming:hemp_leaf", "farming:hemp_leaf"},
		{"farming:hemp_leaf", "bucket:bucket_water", "farming:hemp_leaf"},
		{"farming:hemp_leaf", "farming:hemp_leaf", "farming:hemp_leaf"}
	},
	replacements = {{ "bucket:bucket_water", "bucket:bucket_empty"}}
})

minetest.register_craft( {
	output = "farming:hemp_fibre 8",
	recipe = {
		{"farming:hemp_leaf", "farming:hemp_leaf", "farming:hemp_leaf"},
		{"farming:hemp_leaf", "bucket:bucket_river_water", "farming:hemp_leaf"},
		{"farming:hemp_leaf", "farming:hemp_leaf", "farming:hemp_leaf"}
	},
	replacements = {{ "bucket:bucket_river_water", "bucket:bucket_empty"}}
})

-- hemp block
minetest.register_node("farming:hemp_block", {
	description = S("Hemp Block"),
	tiles = {"farming_hemp_block.png"},
	paramtype = "light",
	groups = {snappy = 1, oddly_breakable_by_hand = 1, flammable = 2}
})

minetest.register_craft( {
	output = "farming:hemp_block",
	recipe = {
		{"farming:hemp_fibre", "farming:hemp_fibre", "farming:hemp_fibre"},
		{"farming:hemp_fibre", "farming:hemp_fibre", "farming:hemp_fibre"},
		{"farming:hemp_fibre", "farming:hemp_fibre", "farming:hemp_fibre"}
	},
})

-- check and register stairs
if minetest.global_exists("stairs") then

	if stairs.mod and stairs.mod == "redo" then

		stairs.register_all("hemp_block", "farming:hemp_block",
			{snappy = 1, flammable = 2},
			{"farming_hemp_block.png"},
			"Hemp Block",
			default.node_sound_leaves_defaults())
	else

		stairs.register_stair_and_slab("hemp_block", "farming:hemp_block",
			{snappy = 1, flammable = 2},
			{"farming_hemp_block.png"},
			"Hemp Block Stair",
			"Hemp Block Slab",
			default.node_sound_leaves_defaults())
	end
end

-- paper
minetest.register_craft( {
	output = "default:paper",
	recipe = {
		{"farming:hemp_fibre", "farming:hemp_fibre", "farming:hemp_fibre"},
	}
})

-- string
minetest.register_craft( {
	output = "farming:cotton",
	recipe = {
		{"farming:hemp_fibre"},
		{"farming:hemp_fibre"},
		{"farming:hemp_fibre"},
	}
})

-- hemp rope
minetest.register_node("farming:hemp_rope", {
	description = S("Hemp Rope"),
	walkable = false,
	climbable = true,
	sunlight_propagates = true,
	paramtype = "light",
	tiles = {"farming_hemp_rope.png"},
	wield_image = "farming_hemp_rope.png",
	inventory_image = "farming_hemp_rope.png",
	drawtype = "plantlike",
	groups = {flammable = 2, choppy = 3, oddly_breakable_by_hand = 3},
	sounds =  default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-1/7, -1/2, -1/7, 1/7, 1/2, 1/7},
	},
})

-- string
minetest.register_craft( {
	output = "farming:hemp_rope 6",
	recipe = {
		{"farming:hemp_fibre", "farming:hemp_fibre", "farming:hemp_fibre"},
		{"farming:cotton", "farming:cotton", "farming:cotton"},
		{"farming:hemp_fibre", "farming:hemp_fibre", "farming:hemp_fibre"},
	}
})

-- hemp definition
local crop_def = {
	drawtype = "plantlike",
	tiles = {"farming_hemp_1.png"},
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
minetest.register_node("farming:hemp_1", table.copy(crop_def))

-- stage 2
crop_def.tiles = {"farming_hemp_2.png"}
minetest.register_node("farming:hemp_2", table.copy(crop_def))

-- stage 3
crop_def.tiles = {"farming_hemp_3.png"}
minetest.register_node("farming:hemp_3", table.copy(crop_def))

-- stage 4
crop_def.tiles = {"farming_hemp_4.png"}
minetest.register_node("farming:hemp_4", table.copy(crop_def))

-- stage 5
crop_def.tiles = {"farming_hemp_5.png"}
minetest.register_node("farming:hemp_5", table.copy(crop_def))

-- stage 6
crop_def.tiles = {"farming_hemp_6.png"}
crop_def.drop = {
	items = {
		{items = {'farming:hemp_leaf'}, rarity = 2},
		{items = {'farming:seed_hemp'}, rarity = 1},
	}
}
minetest.register_node("farming:hemp_6", table.copy(crop_def))

-- stage 7
crop_def.tiles = {"farming_hemp_7.png"}
crop_def.drop = {
	items = {
		{items = {'farming:hemp_leaf'}, rarity = 1},
		{items = {'farming:hemp_leaf'}, rarity = 3},
		{items = {'farming:seed_hemp'}, rarity = 1},
		{items = {'farming:seed_hemp'}, rarity = 3},
	}
}
minetest.register_node("farming:hemp_7", table.copy(crop_def))

-- stage 8 (final)
crop_def.tiles = {"farming_hemp_8.png"}
crop_def.groups.growing = 0
crop_def.drop = {
	items = {
		{items = {'farming:hemp_leaf 2'}, rarity = 1},
		{items = {'farming:hemp_leaf'}, rarity = 2},
		{items = {'farming:seed_hemp'}, rarity = 1},
		{items = {'farming:seed_hemp'}, rarity = 2},
	}
}
minetest.register_node("farming:hemp_8", table.copy(crop_def))

-- add to registered_plants
farming.registered_plants["farming:hemp"] = {
	crop = "farming:hemp",
	seed = "farming:seed_hemp",
	minlight = 13,
	maxlight = 15,
	steps = 8
}
