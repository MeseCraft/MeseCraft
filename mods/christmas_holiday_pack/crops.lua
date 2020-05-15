-- PEPPERMINT
	-- Peppermint Leaf
	minetest.register_craftitem("christmas_holiday_pack:peppermint", {
		description = "Peppermint Leaf",
		inventory_image = "christmas_holiday_pack_peppermint_leaf.png",
		groups = {food_peppermint = 1, flammable = 2},
		on_use = minetest.item_eat(3),
	})

	-- Peppermint Seeds
	minetest.register_node("christmas_holiday_pack:peppermint_seeds", {
		description = "Peppermint Seeds",
		tiles = {"christmas_holiday_pack_peppermint_seeds.png"},
		inventory_image = "christmas_holiday_pack_peppermint_seeds.png",
		wield_image = "christmas_holiday_pack_peppermint_seeds.png",
		drawtype = "signlike",
		groups = {seed = 1, snappy = 3, attached_node = 1, flammable = 4},
		paramtype = "light",
		paramtype2 = "wallmounted",
		walkable = false,
		sunlight_propagates = true,
		selection_box = farming.select,
		on_place = function(itemstack, placer, pointed_thing)
			return farming.place_seed(itemstack, placer, pointed_thing, "christmas_holiday_pack:peppermint_0")
		end,
	})

	-- Peppermint Definition
	local crop_def = {
		drawtype = "plantlike",
		tiles = {"christmas_holiday_pack_peppermint_stage_0.png"},
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
	minetest.register_node("christmas_holiday_pack:peppermint_0", table.copy(crop_def))

	-- Stage 1
	crop_def.tiles = {"christmas_holiday_pack_peppermint_stage_1.png"}
	minetest.register_node("christmas_holiday_pack:peppermint_1", table.copy(crop_def))

	-- Stage 2
	crop_def.tiles = {"christmas_holiday_pack_peppermint_stage_2.png"}
	crop_def.drop = {
		items = {
			{items = {"christmas_holiday_pack:peppermint"}, rarity = 2},
		}
	}
	minetest.register_node("christmas_holiday_pack:peppermint_2", table.copy(crop_def))

	-- Stage 3
	crop_def.tiles = {"christmas_holiday_pack_peppermint_stage_3.png"}
	crop_def.groups.growing = 0
	crop_def.drop = {
		items = {
			{items = {"christmas_holiday_pack:peppermint"}, rarity = 1},
			{items = {"christmas_holiday_pack:peppermint"}, rarity = 1},
			{items = {"christmas_holiday_pack:peppermint"}, rarity = 2},
			{items = {"christmas_holiday_pack:peppermint_seeds"}, rarity = 1},
			{items = {"christmas_holiday_pack:peppermint_seeds"}, rarity = 2},
		}
	}
	minetest.register_node("christmas_holiday_pack:peppermint_3", table.copy(crop_def))


	-- Add to Registered Plants
	farming.registered_plants["christmas_holiday_pack:peppermint"] = {
		crop = "christmas_holiday_pack:peppermint",
		seed = "christmas_holiday_pack:peppermint_seeds",
		minlight = 13,
		maxlight = 15,
		steps = 4,
	}


-- GINGER

-- Ginger Root
minetest.register_craftitem("christmas_holiday_pack:ginger", {
	description = "Ginger Root",
	inventory_image = "christmas_holiday_pack_ginger_root.png",
	groups = {food_ginger = 1, flammable = 2},
	on_use = minetest.item_eat(3),
	on_place = function(itemstack, placer, pointed_thing)
		return farming.place_seed(itemstack, placer, pointed_thing, "christmas_holiday_pack:ginger_0")
	end,
})

-- Ginger Definition
local crop_def = {
	drawtype = "plantlike",
	tiles = {"christmas_holiday_pack_ginger_stage_0.png"},
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
minetest.register_node("christmas_holiday_pack:ginger_0", table.copy(crop_def))

-- Stage 1
crop_def.tiles = {"christmas_holiday_pack_ginger_stage_1.png"}
minetest.register_node("christmas_holiday_pack:ginger_1", table.copy(crop_def))

-- Stage 2
crop_def.tiles = {"christmas_holiday_pack_ginger_stage_2.png"}
crop_def.drop = {
	items = {
		{items = {"christmas_holiday_pack:ginger"}, rarity = 2},
	}
}
minetest.register_node("christmas_holiday_pack:ginger_2", table.copy(crop_def))

-- Stage 3
crop_def.tiles = {"christmas_holiday_pack_ginger_stage_3.png"}
crop_def.groups.growing = 0
crop_def.drop = {
	items = {
		{items = {"christmas_holiday_pack:ginger"}, rarity = 1},
		{items = {"christmas_holiday_pack:ginger"}, rarity = 1},
		{items = {"christmas_holiday_pack:ginger"}, rarity = 2},
	}
}
minetest.register_node("christmas_holiday_pack:ginger_3", table.copy(crop_def))


-- Add to Registered Plants
farming.registered_plants["christmas_holiday_pack:ginger"] = {
	crop = "christmas_holiday_pack:ginger",
	seed = "christmas_holiday_pack:ginger",
	minlight = 13,
	maxlight = 15,
	steps = 4,
}
