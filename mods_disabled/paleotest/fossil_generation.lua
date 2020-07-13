-- Fossil Ore Definition
	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "paleotest:desert_fossil_block",
		wherein        = "default:desert_stone",
		clust_scarcity = 32 * 32 * 32,
		clust_num_ores = 3,
		clust_size     = 2,
		y_min           = -28,
		y_max           = 28,
	})

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "paleotest:fossil_block",
		wherein        = "default:stone",
		clust_scarcity = 32 * 32 * 32,
		clust_num_ores = 3,
		clust_size     = 2,
		y_min          = -28000,
		y_max           = 0,
	})


-- Override desert_sandstone to drop bones?
minetest.override_item("default:desert_sandstone", {
	drop = {
		max_items = 1,
		items = {
				{items = {'paleotest:prehistoric_bone'},rarity = 1000,},
				{items = {'default:desert_sandstone'},}
		}
	},
})

-- Override default:permafrost to drop prehistoric_bones.
minetest.override_item("default:permafrost", {
	drop = {
		max_items = 1,
		items = {
				{items = {'paleotest:prehistoric_bone'},rarity = 1000,},
				{items = {'default:permafrost'},}
		}
	},
})

-- Override default:permafrost_with_moss to drop prehistoric_bones.
minetest.override_item("default:permafrost_with_moss", {
	drop = {
		max_items = 1,
		items = {
				{items = {'paleotest:prehistoric_bone'},rarity = 1000,},
				{items = {'default:permafrost_with_moss'},}
		}
	},
})

-- Override default:permafrost_with_stones to drop prehistoric_bones.
minetest.override_item("default:permafrost_with_stones", {

	drop = {
		max_items = 1,
		items = {
				{items = {'paleotest:prehistoric_bone'},rarity = 1000,},
				{items = {'default:permafrost_with_moss'},}
		}
	},
})