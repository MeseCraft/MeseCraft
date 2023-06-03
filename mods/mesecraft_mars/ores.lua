
local clust_scarcity = 24 * 24 * 24
local clust_num_ores = 27
local clust_size = 10


minetest.register_ore({
	ore_type       = "scatter",
	ore            = "default:clay",
	wherein        = "default:desert_stone",
	clust_scarcity = clust_scarcity,
	clust_num_ores = clust_num_ores,
	clust_size     = clust_size,
	y_max          = mesecraft_mars.y_start + mesecraft_mars.y_height,
	y_min          = mesecraft_mars.y_start,
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "mesecraft_mars:stone_with_coal",
	wherein        = "default:desert_stone",
	clust_scarcity = clust_scarcity,
	clust_num_ores = clust_num_ores,
	clust_size     = clust_size,
	y_max          = mesecraft_mars.y_start + mesecraft_mars.y_height,
	y_min          = mesecraft_mars.y_start,
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "mesecraft_mars:stone_with_iron",
	wherein        = "default:desert_stone",
	clust_scarcity = clust_scarcity,
	clust_num_ores = clust_num_ores,
	clust_size     = clust_size,
	y_max          = mesecraft_mars.y_start + mesecraft_mars.y_height,
	y_min          = mesecraft_mars.y_start,
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "mesecraft_mars:stone_with_copper",
	wherein        = "default:desert_stone",
	clust_scarcity = clust_scarcity,
	clust_num_ores = clust_num_ores,
	clust_size     = clust_size,
	y_max          = mesecraft_mars.y_start + mesecraft_mars.y_height,
	y_min          = mesecraft_mars.y_start,
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "mesecraft_mars:stone_with_tin",
	wherein        = "default:desert_stone",
	clust_scarcity = clust_scarcity,
	clust_num_ores = clust_num_ores,
	clust_size     = clust_size,
	y_max          = mesecraft_mars.y_start + mesecraft_mars.y_height,
	y_min          = mesecraft_mars.y_start,
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "mesecraft_mars:stone_with_mese",
	wherein        = "default:desert_stone",
	clust_scarcity = clust_scarcity,
	clust_num_ores = clust_num_ores,
	clust_size     = clust_size,
	y_max          = mesecraft_mars.y_start + mesecraft_mars.y_height,
	y_min          = mesecraft_mars.y_start,
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "mesecraft_mars:stone_with_gold",
	wherein        = "default:desert_stone",
	clust_scarcity = clust_scarcity,
	clust_num_ores = clust_num_ores,
	clust_size     = clust_size,
	y_max          = mesecraft_mars.y_start + mesecraft_mars.y_height,
	y_min          = mesecraft_mars.y_start,
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "mesecraft_mars:stone_with_diamond",
	wherein        = "default:desert_stone",
	clust_scarcity = clust_scarcity,
	clust_num_ores = clust_num_ores,
	clust_size     = clust_size,
	y_max          = mesecraft_mars.y_start + mesecraft_mars.y_height,
	y_min          = mesecraft_mars.y_start,
})
