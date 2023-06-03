
local has_technic_mod = minetest.get_modpath("technic")

local clust_scarcity = 64 * 64 * 64
local clust_num_ores = 6
local clust_size = 4

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "default:stone_with_copper",
	wherein        = "default:stone",
	clust_scarcity = clust_scarcity,
	clust_num_ores = clust_num_ores,
	clust_size     = clust_size,
	y_max          = mesecraft_lua.maxy - 100,
	y_min          = mesecraft_lua.miny,
})

if has_technic_mod then
	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "technic:mineral_uranium",
		wherein        = "default:stone",
		clust_scarcity = clust_scarcity,
		clust_num_ores = clust_num_ores,
		clust_size     = clust_size,
		y_max          = mesecraft_lua.maxy - 100,
		y_min          = mesecraft_lua.miny,
	})

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "technic:mineral_chromium",
		wherein        = "default:stone",
		clust_scarcity = clust_scarcity,
		clust_num_ores = clust_num_ores,
		clust_size     = clust_size,
		y_max          = mesecraft_lua.maxy - 100,
		y_min          = mesecraft_lua.miny,
	})

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "technic:mineral_zinc",
		wherein        = "default:stone",
		clust_scarcity = clust_scarcity,
		clust_num_ores = clust_num_ores,
		clust_size     = clust_size,
		y_max          = mesecraft_lua.maxy - 100,
		y_min          = mesecraft_lua.miny,
	})

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "technic:mineral_lead",
		wherein        = "default:stone",
		clust_scarcity = clust_scarcity,
		clust_num_ores = clust_num_ores,
		clust_size     = clust_size,
		y_max          = mesecraft_lua.maxy - 100,
		y_min          = mesecraft_lua.miny,
	})

	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "technic:mineral_sulfur",
		wherein        = "default:stone",
		clust_scarcity = clust_scarcity,
		clust_num_ores = clust_num_ores,
		clust_size     = clust_size,
		y_max          = mesecraft_lua.maxy - 100,
		y_min          = mesecraft_lua.miny,
	})
end

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "mesecraft_lua:radioactive_stone",
	wherein        = "default:stone",
	clust_scarcity = 8 * 8 * 8,
	clust_num_ores = 9,
	clust_size     = 3,
	y_max          = mesecraft_lua.maxy,
	y_min          = mesecraft_lua.miny,
})



