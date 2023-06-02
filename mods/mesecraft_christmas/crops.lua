-- PEPPERMINT
	-- Peppermint Leaf
	minetest.register_craftitem("mesecraft_christmas:peppermint", {
		description = "Peppermint Leaf",
		inventory_image = "mesecraft_christmas_crops_peppermint_leaf.png",
		groups = {food_peppermint = 1, flammable = 2},
		on_use = minetest.item_eat(3),
	})

	-- Peppermint Seeds
	minetest.register_node("mesecraft_christmas:peppermint_seeds", {
		description = "Peppermint Seeds",
		tiles = {"mesecraft_christmas_crops_peppermint_seeds.png"},
		inventory_image = "mesecraft_christmas_crops_peppermint_seeds.png",
		wield_image = "mesecraft_christmas_crops_peppermint_seeds.png",
		drawtype = "signlike",
		groups = {seed = 1, snappy = 3, attached_node = 1, flammable = 4},
		paramtype = "light",
		paramtype2 = "wallmounted",
		walkable = false,
		sunlight_propagates = true,
		selection_box = farming.select,
		on_place = function(itemstack, placer, pointed_thing)
			return farming.place_seed(itemstack, placer, pointed_thing, "mesecraft_christmas:peppermint_0")
		end,
	})

	-- Peppermint Definition
	local crop_def = {
		drawtype = "plantlike",
		tiles = {"mesecraft_christmas_crops_peppermint_stage_0.png"},
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

	-- Stage 0
	minetest.register_node("mesecraft_christmas:peppermint_0", table.copy(crop_def))

	-- Stage 1
	crop_def.tiles = {"mesecraft_christmas_crops_peppermint_stage_1.png"}
	minetest.register_node("mesecraft_christmas:peppermint_1", table.copy(crop_def))

	-- Stage 2
	crop_def.tiles = {"mesecraft_christmas_crops_peppermint_stage_2.png"}
	crop_def.drop = {
		items = {
			{items = {"mesecraft_christmas:peppermint"}, rarity = 2},
		}
	}
	minetest.register_node("mesecraft_christmas:peppermint_2", table.copy(crop_def))

	-- Stage 3
	crop_def.tiles = {"mesecraft_christmas_crops_peppermint_stage_3.png"}
	crop_def.groups.growing = 0
	crop_def.drop = {
		items = {
			{items = {"mesecraft_christmas:peppermint"}, rarity = 1},
			{items = {"mesecraft_christmas:peppermint"}, rarity = 1},
			{items = {"mesecraft_christmas:peppermint"}, rarity = 2},
			{items = {"mesecraft_christmas:peppermint_seeds"}, rarity = 1},
			{items = {"mesecraft_christmas:peppermint_seeds"}, rarity = 2},
		}
	}
	minetest.register_node("mesecraft_christmas:peppermint_3", table.copy(crop_def))


	-- Add to Registered Plants
	farming.registered_plants["mesecraft_christmas:peppermint"] = {
		crop = "mesecraft_christmas:peppermint",
		seed = "mesecraft_christmas:peppermint_seeds",
		minlight = 13,
		maxlight = 15,
		steps = 4,
	}


-- GINGER

-- Ginger Root
minetest.register_craftitem("mesecraft_christmas:ginger", {
	description = "Ginger Root",
	inventory_image = "mesecraft_christmas_crops_ginger_root.png",
	groups = {food_ginger = 1, flammable = 2},
	on_use = minetest.item_eat(3),
	on_place = function(itemstack, placer, pointed_thing)
		return farming.place_seed(itemstack, placer, pointed_thing, "mesecraft_christmas:ginger_0")
	end,
})

-- Ginger Definition
local crop_def = {
	drawtype = "plantlike",
	tiles = {"mesecraft_christmas_crops_ginger_stage_0.png"},
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

-- Stage 0
minetest.register_node("mesecraft_christmas:ginger_0", table.copy(crop_def))

-- Stage 1
crop_def.tiles = {"mesecraft_christmas_crops_ginger_stage_1.png"}
minetest.register_node("mesecraft_christmas:ginger_1", table.copy(crop_def))

-- Stage 2
crop_def.tiles = {"mesecraft_christmas_crops_ginger_stage_2.png"}
crop_def.drop = {
	items = {
		{items = {"mesecraft_christmas:ginger"}, rarity = 2},
	}
}
minetest.register_node("mesecraft_christmas:ginger_2", table.copy(crop_def))

-- Stage 3
crop_def.tiles = {"mesecraft_christmas_crops_ginger_stage_3.png"}
crop_def.groups.growing = 0
crop_def.drop = {
	items = {
		{items = {"mesecraft_christmas:ginger"}, rarity = 1},
		{items = {"mesecraft_christmas:ginger"}, rarity = 1},
		{items = {"mesecraft_christmas:ginger"}, rarity = 2},
	}
}
minetest.register_node("mesecraft_christmas:ginger_3", table.copy(crop_def))


-- Add to Registered Plants
farming.registered_plants["mesecraft_christmas:ginger"] = {
	crop = "mesecraft_christmas:ginger",
	seed = "mesecraft_christmas:ginger",
	minlight = 13,
	maxlight = 15,
	steps = 4,
}
