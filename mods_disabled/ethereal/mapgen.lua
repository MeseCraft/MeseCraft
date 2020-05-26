
-- clear default mapgen biomes, decorations and ores
--minetest.clear_registered_biomes()
--minetest.clear_registered_decorations()
--minetest.clear_registered_ores()

local path = minetest.get_modpath("ethereal")

dofile(path .. "/ores.lua")

path = path .. "/schematics/"

local dpath = minetest.get_modpath("default") .. "/schematics/"

-- tree schematics
dofile(path .. "orange_tree.lua")
dofile(path .. "banana_tree.lua")
dofile(path .. "bamboo_tree.lua")
dofile(path .. "birch_tree.lua")
dofile(path .. "bush.lua")
dofile(path .. "waterlily.lua")
dofile(path .. "volcanom.lua")
dofile(path .. "volcanol.lua")
dofile(path .. "frosttrees.lua")
dofile(path .. "palmtree.lua")
dofile(path .. "pinetree.lua")
dofile(path .. "yellowtree.lua")
dofile(path .. "mushroomone.lua")
dofile(path .. "willow.lua")
dofile(path .. "bigtree.lua")
dofile(path .. "redwood_tree.lua")
dofile(path .. "vinetree.lua")
dofile(path .. "sakura.lua")
dofile(path .. "igloo.lua")

--= Biomes

local add_biome = function(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p)

	if p ~= 1 then return end

	minetest.register_biome({
		name = a,
		node_dust = b,
		node_top = c,
		depth_top = d,
		node_filler = e,
		depth_filler = f,
		node_stone = g,
		node_water_top = h,
		depth_water_top = i,
		node_water = j,
		node_river_water = k,
		y_min = l,
		y_max = m,
		heat_point = n,
		humidity_point = o,
	})
end

add_biome("underground", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil,
	-31000, -192, 50, 50, 1)

add_biome("mountain", nil, "default:snow", 1, "default:snowblock", 2,
	nil, nil, nil, nil, nil, 140, 31000, 50, 50, 1)

add_biome("desert", nil, "default:desert_sand", 1, "default:desert_sand", 3,
	"default:desert_stone", nil, nil, nil, nil, 3, 23, 35, 20, ethereal.desert)

add_biome("desert_ocean", nil, "default:sand", 1, "default:sand", 2,
	"default:desert_stone", nil, nil, nil, nil, -192, 3, 35, 20, ethereal.desert)

if ethereal.glacier == 1 then

	minetest.register_biome({
		name = "glacier",
		node_dust = "default:snowblock",
		node_top = "default:snowblock",
		depth_top = 1,
		node_filler = "default:snowblock",
		depth_filler = 3,
		node_stone = "default:ice",
		node_water_top = "default:ice",
		depth_water_top = 10,
		--node_water = "",
		node_river_water = "default:ice",
		node_riverbed = "default:gravel",
		depth_riverbed = 2,
		y_min = -8,
		y_max = 31000,
		heat_point = 0,
		humidity_point = 50,
	})

	minetest.register_biome({
		name = "glacier_ocean",
		node_dust = "default:snowblock",
		node_top = "default:sand",
		depth_top = 1,
		node_filler = "default:sand",
		depth_filler = 3,
		--node_stone = "",
		--node_water_top = "",
		--depth_water_top = ,
		--node_water = "",
		--node_river_water = "",
		y_min = -112,
		y_max = -9,
		heat_point = 0,
		humidity_point = 50,
	})
end

add_biome("clearing", nil, "default:dirt_with_grass", 1, "default:dirt", 3,
	nil, nil, nil, nil, nil, 3, 71, 45, 65, 1) -- ADDED

add_biome("bamboo", nil, "ethereal:bamboo_dirt", 1, "default:dirt", 3,
	nil, nil, nil, nil, nil, 25, 70, 45, 75, ethereal.bamboo)

--add_biome("bamboo_ocean", nil, "default:sand", 1, "default:sand", 2,
	--nil, nil, nil, nil, nil, -192, 2, 45, 75, ethereal.bamboo)

add_biome("sakura", nil, "ethereal:bamboo_dirt", 1, "default:dirt", 3,
	nil, nil, nil, nil, nil, 3, 25, 45, 75, ethereal.sakura)

add_biome("sakura_ocean", nil, "default:sand", 1, "default:sand", 2,
	nil, nil, nil, nil, nil, -192, 2, 45, 75, ethereal.sakura)

add_biome("mesa", nil, "default:dirt_with_dry_grass", 1, "bakedclay:orange", 15,
	nil, nil, nil, nil, nil, 1, 71, 25, 28, ethereal.mesa)

add_biome("mesa_ocean", nil, "default:sand", 1, "default:sand", 2,
	nil, nil, nil, nil, nil, -192, 1, 25, 28, ethereal.mesa)

add_biome("alpine", nil, "default:dirt_with_snow", 1, "default:dirt", 2,
	nil, nil, nil, nil, nil, 40, 140, 10, 40, ethereal.alpine)

if minetest.registered_nodes["default:dirt_with_coniferous_litter"] then
add_biome("snowy", nil, "default:dirt_with_coniferous_litter", 1, "default:dirt",
	2, nil, nil, nil, nil, nil, 4, 40, 10, 40, ethereal.snowy)
else
add_biome("snowy", nil, "ethereal:cold_dirt", 1, "default:dirt", 2,
	nil, nil, nil, nil, nil, 4, 40, 10, 40, ethereal.snowy)
end

add_biome("frost", nil, "ethereal:crystal_dirt", 1, "default:dirt", 3,
	nil, nil, nil, nil, nil, 1, 71, 10, 40, ethereal.frost)

add_biome("frost_ocean", nil, "default:sand", 1, "default:sand", 2,
	nil, nil, nil, nil, nil, -192, 1, 10, 40, ethereal.frost)

add_biome("grassy", nil, "default:dirt_with_grass", 1, "default:dirt", 3,
	nil, nil, nil, nil, nil, 3, 91, 13, 40, ethereal.grassy)

add_biome("grassy_ocean", nil, "default:sand", 2, "default:gravel", 1,
	nil, nil, nil, nil, nil, -31000, 3, 13, 40, ethereal.grassy)

add_biome("caves", nil, "default:desert_stone", 3, "air", 8,
	nil, nil, nil, nil, nil, 4, 41, 15, 25, ethereal.caves)

add_biome("grayness", nil, "ethereal:gray_dirt", 1, "default:dirt", 3,
	nil, nil, nil, nil, nil, 2, 41, 15, 30, ethereal.grayness)

if minetest.registered_nodes["default:silver_sand"] then
	add_biome("grayness_ocean", nil, "default:silver_sand", 2, "default:sand", 2,
		nil, nil, nil, nil, nil, -192, 1, 15, 30, ethereal.grayness)
else
	add_biome("grayness_ocean", nil, "default:sand", 1, "default:sand", 2,
		nil, nil, nil, nil, nil, -192, 1, 15, 30, ethereal.grayness)
end

add_biome("grassytwo", nil, "default:dirt_with_grass", 1, "default:dirt", 3,
	nil, nil, nil, nil, nil, 1, 91, 15, 40, ethereal.grassytwo)

add_biome("grassytwo_ocean", nil, "default:sand", 1, "default:sand", 2,
	nil, nil, nil, nil, nil, -192, 1, 15, 40, ethereal.grassytwo)

add_biome("prairie", nil, "ethereal:prairie_dirt", 1, "default:dirt", 3,
	nil, nil, nil, nil, nil, 3, 26, 20, 40, ethereal.prairie)

add_biome("prairie_ocean", nil, "default:sand", 1, "default:sand", 2,
	nil, nil, nil, nil, nil, -192, 1, 20, 40, ethereal.prairie)

add_biome("jumble", nil, "default:dirt_with_grass", 1, "default:dirt", 3,
	nil, nil, nil, nil, nil, 1, 71, 25, 50, ethereal.jumble)

add_biome("jumble_ocean", nil, "default:sand", 1, "default:sand", 2,
	nil, nil, nil, nil, nil, -192, 1, 25, 50, ethereal.jumble)

if minetest.registered_nodes["default:dirt_with_rainforest_litter"] then
	add_biome("junglee", nil, "default:dirt_with_rainforest_litter", 1,
	"default:dirt", 3, nil, nil, nil, nil, nil, 1, 71, 30, 60, ethereal.junglee)
else
	add_biome("junglee", nil, "ethereal:jungle_dirt", 1, "default:dirt", 3,
		nil, nil, nil, nil, nil, 1, 71, 30, 60, ethereal.junglee)
end

add_biome("junglee_ocean", nil, "default:sand", 1, "default:sand", 2,
	nil, nil, nil, nil, nil, -192, 1, 30, 60, ethereal.junglee)

add_biome("grove", nil, "ethereal:grove_dirt", 1, "default:dirt", 3,
	nil, nil, nil, nil, nil, 3, 23, 45, 35, ethereal.grove)

add_biome("grove_ocean", nil, "default:sand", 1, "default:sand", 2,
	nil, nil, nil, nil, nil, -192, 2, 45, 35, ethereal.grove)

add_biome("mushroom", nil, "ethereal:mushroom_dirt", 1, "default:dirt", 3,
	nil, nil, nil, nil, nil, 3, 50, 45, 55, ethereal.mushroom)

add_biome("mushroom_ocean", nil, "default:sand", 1, "default:sand", 2,
	nil, nil, nil, nil, nil, -192, 2, 45, 55, ethereal.mushroom)

add_biome("sandstone", nil, "default:sandstone", 1, "default:sandstone", 1,
	"default:sandstone", nil, nil, nil, nil, 3, 23, 50, 20, ethereal.sandstone)

add_biome("sandstone_ocean", nil, "default:sand", 1, "default:sand", 2,
	nil, nil, nil, nil, nil, -192, 2, 50, 20, ethereal.sandstone)

add_biome("quicksand", nil, "ethereal:quicksand2", 3, "default:gravel", 1,
	nil, nil, nil, nil, nil, 1, 1, 50, 38, ethereal.quicksand)

add_biome("plains", nil, "ethereal:dry_dirt", 1, "default:dirt", 3,
	nil, nil, nil, nil, nil, 3, 25, 65, 25, ethereal.plains)

add_biome("plains_ocean", nil, "default:sand", 1, "default:sand", 2,
	nil, nil, nil, nil, nil, -192, 2, 55, 25, ethereal.plains)

if minetest.registered_nodes["default:dry_dirt_with_dry_grass"] then
	add_biome("savanna", nil, "default:dry_dirt_with_dry_grass", 1,
	"default:dry_dirt", 3, nil, nil, nil, nil, nil, 3, 50, 55, 25,
	ethereal.savanna)
else
	add_biome("savanna", nil, "default:dirt_with_dry_grass", 1, "default:dirt",
	3, nil, nil, nil, nil, nil, 3, 50, 55, 25, ethereal.savanna)
end

add_biome("savanna_ocean", nil, "default:sand", 1, "default:sand", 2,
	nil, nil, nil, nil, nil, -192, 1, 55, 25, ethereal.savanna)

add_biome("fiery", nil, "ethereal:fiery_dirt", 1, "default:dirt", 3,
	nil, nil, nil, nil, nil, 5, 20, 75, 10, ethereal.fiery)

add_biome("fiery_ocean", nil, "default:sand", 1, "default:sand", 2,
	nil, nil, nil, nil, nil, -192, 4, 75, 10, ethereal.fiery)

add_biome("sandclay", nil, "default:sand", 3, "default:clay", 2,
	nil, nil, nil, nil, nil, 1, 11, 65, 2, ethereal.sandclay)

add_biome("swamp", nil, "default:dirt_with_grass", 1, "default:dirt", 3,
	nil, nil, nil, nil, nil, 1, 7, 80, 90, ethereal.swamp)

add_biome("swamp_ocean", nil, "default:sand", 2, "default:clay", 2,
	nil, nil, nil, nil, nil, -192, 1, 80, 90, ethereal.swamp)

--= schematic decorations

local add_schem = function(a, b, c, d, e, f, g, h)

	if g ~= 1 then return end

	minetest.register_decoration({
		deco_type = "schematic",
		place_on = a,
		sidelen = 80,
		fill_ratio = b,
		biomes = c,
		y_min = d,
		y_max = e,
		schematic = f,
		flags = "place_center_x, place_center_z",
		replacements = h,
	})
end

if ethereal.glacier then

	-- igloo
	minetest.register_decoration({
		deco_type = "schematic",
		place_on = {"default:snowblock"},
		sidelen = 80,
		fill_ratio = 0.001,
		biomes = {"glacier"},
		y_min = 3,
		y_max = 50,
		schematic = ethereal.igloo,
		flags = "place_center_x, place_center_z",
		spawn_by = "default:snowblock",
		num_spawn_by = 8,
		rotation = "random",
	})
end

--sakura tree
add_schem({"ethereal:bamboo_dirt"}, 0.01, {"sakura"}, 7, 100, ethereal.sakura_tree, ethereal.sakura)

-- redwood tree
add_schem({"default:dirt_with_dry_grass"}, 0.0025, {"mesa"}, 1, 100, ethereal.redwood_tree, ethereal.mesa)

-- banana tree
add_schem({"ethereal:grove_dirt"}, 0.015, {"grove"}, 1, 100, ethereal.bananatree, ethereal.grove)

-- healing tree
add_schem({"default:dirt_with_snow"}, 0.01, {"alpine"}, 120, 140, ethereal.yellowtree, ethereal.alpine)

-- crystal frost tree
add_schem({"ethereal:crystal_dirt"}, 0.01, {"frost"}, 1, 100, ethereal.frosttrees, ethereal.frost)

if ethereal.mushroom then

	-- giant shroom
	minetest.register_decoration({
		deco_type = "schematic",
		place_on = {"ethereal:mushroom_dirt"},
		sidelen = 80,
		fill_ratio = 0.02,
		biomes = {"mushroom"},
		y_min = 1,
		y_max = 100,
		schematic = ethereal.mushroomone,
		flags = "place_center_x, place_center_z",
		spawn_by = "ethereal:mushroom_dirt",
		num_spawn_by = 6,
	})
end

if ethereal.fiery then

	-- small lava crater
	minetest.register_decoration({
		deco_type = "schematic",
		place_on = {"ethereal:fiery_dirt"},
		sidelen = 80,
		fill_ratio = 0.01,
		biomes = {"fiery"},
		y_min = 1,
		y_max = 100,
		schematic = ethereal.volcanom,
		flags = "place_center_x, place_center_z",
		spawn_by = "ethereal:fiery_dirt",
		num_spawn_by = 8,
	})

	-- large lava crater
	minetest.register_decoration({
		deco_type = "schematic",
		place_on = {"ethereal:fiery_dirt"},
		sidelen = 80,
		fill_ratio = 0.003,
		biomes = {"fiery"},
		y_min = 1,
		y_max = 100,
		schematic = ethereal.volcanol,
		flags = "place_center_x, place_center_z",
		spawn_by = "ethereal:fiery_dirt",
		num_spawn_by = 8,
		rotation = "random",
	})
end

-- default jungle tree
add_schem({"ethereal:jungle_dirt", "default:dirt_with_rainforest_litter"}, 0.08, {"junglee"}, 1, 100, dpath .. "jungle_tree.mts", ethereal.junglee)

-- willow tree
add_schem({"ethereal:gray_dirt"}, 0.02, {"grayness"}, 1, 100, ethereal.willow, ethereal.grayness)

-- pine tree (default for lower elevation and ethereal for higher)
add_schem({"ethereal:cold_dirt", "default:dirt_with_coniferous_litter"}, 0.025, {"snowy"}, 10, 40, ethereal.pinetree, ethereal.snowy)
add_schem({"default:dirt_with_snow"}, 0.025, {"alpine"}, 40, 140, ethereal.pinetree, ethereal.alpine)

-- default apple tree
add_schem({"default:dirt_with_grass"}, 0.02, {"jumble"}, 1, 100, dpath .. "apple_tree.mts", ethereal.grassy)
add_schem({"default:dirt_with_grass"}, 0.03, {"grassy"}, 1, 100, dpath .. "apple_tree.mts", ethereal.grassy)

-- big old tree
add_schem({"default:dirt_with_grass"}, 0.001, {"jumble"}, 1, 100, ethereal.bigtree, ethereal.jumble)

-- aspen tree
add_schem({"default:dirt_with_grass"}, 0.02, {"grassytwo"}, 1, 50, dpath .. "aspen_tree.mts", ethereal.jumble)

-- birch tree
add_schem({"default:dirt_with_grass"}, 0.02, {"grassytwo"}, 50, 100, ethereal.birchtree, ethereal.grassytwo)

-- orange tree
add_schem({"ethereal:prairie_dirt"}, 0.01, {"prairie"}, 1, 100, ethereal.orangetree, ethereal.prairie)

-- default acacia tree
if minetest.registered_nodes["default:dry_dirt_with_dry_grass"] then
	add_schem({"default:dry_dirt_with_dry_grass"}, 0.004, {"savanna"}, 1, 100,
	dpath .. "acacia_tree.mts", ethereal.savanna)
else
	add_schem({"default:dirt_with_dry_grass"}, 0.004, {"savanna"}, 1, 100,
	dpath .. "acacia_tree.mts", ethereal.savanna)
end

-- large cactus (by Paramat)
if ethereal.desert == 1 then
minetest.register_decoration({
	deco_type = "schematic",
	place_on = {"default:desert_sand"},
	sidelen = 80,
	noise_params = {
		offset = -0.0005,
		scale = 0.0015,
		spread = {x = 200, y = 200, z = 200},
		seed = 230,
		octaves = 3,
		persist = 0.6
	},
	biomes = {"desert"},
	y_min = 5,
	y_max = 31000,
	schematic = dpath .. "large_cactus.mts",
	flags = "place_center_x", --, place_center_z",
	rotation = "random",
})
end

-- palm tree
add_schem({"default:sand"}, 0.0025, {"desert_ocean"}, 1, 1, ethereal.palmtree, ethereal.desert)
add_schem({"default:sand"}, 0.0025, {"plains_ocean"}, 1, 1, ethereal.palmtree, ethereal.plains)
add_schem({"default:sand"}, 0.0025, {"sandclay"}, 1, 1, ethereal.palmtree, ethereal.sandclay)
add_schem({"default:sand"}, 0.0025, {"sandstone_ocean"}, 1, 1, ethereal.palmtree, ethereal.sandstone)
add_schem({"default:sand"}, 0.0025, {"mesa_ocean"}, 1, 1, ethereal.palmtree, ethereal.mesa)
add_schem({"default:sand"}, 0.0025, {"grove_ocean"}, 1, 1, ethereal.palmtree, ethereal.grove)
add_schem({"default:sand"}, 0.0025, {"grassy_ocean"}, 1, 1, ethereal.palmtree, ethereal.grassy)

-- bamboo tree
add_schem({"ethereal:bamboo_dirt"}, 0.025, {"bamboo"}, 1, 100, ethereal.bambootree, ethereal.bamboo)

-- bush
add_schem({"ethereal:bamboo_dirt"}, 0.08, {"bamboo"}, 1, 100, ethereal.bush, ethereal.bamboo)

-- vine tree
add_schem({"default:dirt_with_grass"}, 0.02, {"swamp"}, 1, 100, ethereal.vinetree, ethereal.swamp)

-- water pools in swamp areas if 5.0 detected
if minetest.registered_nodes["default:permafrost"] then
minetest.register_decoration({
	deco_type = "simple",
	place_on = {"default:dirt_with_grass"},
	place_offset_y = -1,
	sidelen = 16,
	fill_ratio = 0.01,
	biomes = {"swamp"},
	y_max = 2,
	y_min = 1,
	flags = "force_placement",
	decoration = "default:water_source",
	spawn_by = "default:dirt_with_grass",
	num_spawn_by = 8,
})
minetest.register_decoration({
	deco_type = "simple",
	place_on = {"default:dirt_with_grass"},
	place_offset_y = -1,
	sidelen = 16,
	fill_ratio = 0.1,
	biomes = {"swamp"},
	y_max = 2,
	y_min = 1,
	flags = "force_placement",
	decoration = "default:water_source",
	spawn_by = {"default:dirt_with_grass", "default:water_source"},
	num_spawn_by = 8,
})
end

if minetest.registered_nodes["default:dry_dirt_with_dry_grass"] then
	minetest.register_decoration({
		deco_type = "simple",
		place_on = {"default:dry_dirt_with_dry_grass"},
		sidelen = 4,
		noise_params = {
			offset = -1.5,
			scale = -1.5,
			spread = {x = 200, y = 200, z = 200},
			seed = 329,
			octaves = 4,
			persist = 1.0
		},
		biomes = {"savanna"},
		y_max = 31000,
		y_min = 1,
		decoration = "default:dry_dirt",
		place_offset_y = -1,
		flags = "force_placement",
	})
end

-- bush
minetest.register_decoration({
	deco_type = "schematic",
	place_on = {"default:dirt_with_grass", "default:dirt_with_snow"},
	sidelen = 16,
	noise_params = {
		offset = -0.004,
		scale = 0.01,
		spread = {x = 100, y = 100, z = 100},
		seed = 137,
		octaves = 3,
		persist = 0.7,
	},
	biomes = {"grassy", "grassytwo", "jumble"},
	y_min = 1,
	y_max = 31000,
	schematic = dpath .. "bush.mts",
	flags = "place_center_x, place_center_z",
})

-- Acacia bush
minetest.register_decoration({
	deco_type = "schematic",
	place_on = {"default:dirt_with_dry_grass", "default:dry_dirt_with_dry_grass"},
	sidelen = 16,
	noise_params = {
		offset = -0.004,
		scale = 0.01,
		spread = {x = 100, y = 100, z = 100},
		seed = 90155,
		octaves = 3,
		persist = 0.7,
	},
	biomes = {"savanna", "mesa"},
	y_min = 1,
	y_max = 31000,
	schematic = dpath .. "acacia_bush.mts",
	flags = "place_center_x, place_center_z",
})

-- Pine bush
if minetest.registered_nodes["default:pine_bush"] then
	minetest.register_decoration({
		name = "default:pine_bush",
		deco_type = "schematic",
		place_on = {"default:dirt_with_snow"},
		sidelen = 16,
		noise_params = {
			offset = -0.004,
			scale = 0.01,
			spread = {x = 100, y = 100, z = 100},
			seed = 137,
			octaves = 3,
			persist = 0.7,
		},
		biomes = {"alpine"},
		y_max = 31000,
		y_min = 4,
		schematic = dpath .. "pine_bush.mts",
		flags = "place_center_x, place_center_z",
	})
end

--= simple decorations

local add_node = function(a, b, c, d, e, f, g, h, i, j)

	if j ~= 1 then return end

	minetest.register_decoration({
		deco_type = "simple",
		place_on = a,
		sidelen = 80,
		fill_ratio = b,
		biomes = c,
		y_min = d,
		y_max = e,
		decoration = f,
		height_max = g,
		spawn_by = h,
		num_spawn_by = i,
	})
end

--firethorn shrub
add_node({"default:snowblock"}, 0.001, {"glacier"}, 1, 30, {"ethereal:firethorn"}, nil, nil, nil, ethereal.glacier)

-- scorched tree
add_node({"ethereal:dry_dirt"}, 0.006, {"plains"}, 1, 100, {"ethereal:scorched_tree"}, 6, nil, nil, ethereal.plains)

-- dry shrub
add_node({"ethereal:dry_dirt"}, 0.015, {"plains"}, 1, 100, {"default:dry_shrub"}, nil, nil, nil, ethereal.plains)
add_node({"default:sand"}, 0.015, {"grassy_ocean"}, 1, 100, {"default:dry_shrub"}, nil, nil, nil, ethereal.grassy)
add_node({"default:desert_sand"}, 0.015, {"desert"}, 1, 100, {"default:dry_shrub"}, nil, nil, nil, ethereal.desert)
add_node({"default:sandstone"}, 0.015, {"sandstone"}, 1, 100, {"default:dry_shrub"}, nil, nil, nil, ethereal.sandstone)
add_node({"bakedclay:red", "bakedclay:orange"}, 0.015, {"mesa"}, 1, 100, {"default:dry_shrub"}, nil, nil, nil, ethereal.mesa)

-- dry grass
if minetest.registered_nodes["default:dry_dirt_with_dry_grass"] then
	add_node({"default:dry_dirt_with_dry_grass"}, 0.25, {"savanna"}, 1, 100,
	{"default:dry_grass_2", "default:dry_grass_3", "default:dry_grass_4",
	"default:dry_grass_5"}, nil, nil, nil, ethereal.savanna)
else
	add_node({"default:dirt_with_dry_grass"}, 0.25, {"savanna"}, 1, 100,
	{"default:dry_grass_2", "default:dry_grass_3", "default:dry_grass_4",
	"default:dry_grass_5"}, nil, nil, nil, ethereal.savanna)
end

add_node({"default:dirt_with_dry_grass"}, 0.10, {"mesa"}, 1, 100, {"default:dry_grass_2",
	"default:dry_grass_3", "default:dry_grass_4", "default:dry_grass_5"}, nil, nil, nil, ethereal.mesa)
add_node({"default:desert_stone"}, 0.005, {"caves"}, 5, 40, {"default:dry_grass_2",
	"default:dry_grass_3", "default:dry_shrub"}, nil, nil, nil, ethereal.caves)

-- flowers & strawberry
add_node({"default:dirt_with_grass"}, 0.025, {"grassy"}, 1, 100, {"flowers:dandelion_white",
	"flowers:dandelion_yellow", "flowers:geranium", "flowers:rose", "flowers:tulip",
	"flowers:viola", "ethereal:strawberry_7"}, nil, nil, nil, ethereal.grassy)
add_node({"default:dirt_with_grass"}, 0.025, {"grassytwo"}, 1, 100, {"flowers:dandelion_white",
	"flowers:dandelion_yellow", "flowers:geranium", "flowers:rose", "flowers:tulip",
	"flowers:viola", "ethereal:strawberry_7"}, nil, nil, nil, ethereal.grassytwo)

-- prairie flowers & strawberry
add_node({"ethereal:prairie_dirt"}, 0.035, {"prairie"}, 1, 100, {"flowers:dandelion_white",
	"flowers:dandelion_yellow", "flowers:geranium", "flowers:rose", "flowers:tulip",
	"flowers:viola", "ethereal:strawberry_7", "flowers:chrysanthemum_green", "flowers:tulip_black"}, nil, nil, nil, ethereal.prairie)

-- crystal spike & crystal grass
add_node({"ethereal:crystal_dirt"}, 0.02, {"frost"}, 1, 100, {"ethereal:crystal_spike",
	"ethereal:crystalgrass"}, nil, nil, nil, ethereal.frost)

-- red shrub
add_node({"ethereal:fiery_dirt"}, 0.10, {"fiery"}, 1, 100, {"ethereal:dry_shrub"}, nil, nil, nil, ethereal.fiery)

-- fire flower
--add_node({"ethereal:fiery_dirt"}, 0.02, {"fiery"}, 1, 100, {"ethereal:fire_flower"}, nil, nil, nil, ethereal.fiery)

-- snowy grass
add_node({"ethereal:gray_dirt"}, 0.05, {"grayness"}, 1, 100, {"ethereal:snowygrass"}, nil, nil, nil, ethereal.grayness)
add_node({"ethereal:cold_dirt", "default:dirt_with_coniferous_litter"}, 0.05, {"snowy"}, 1, 100, {"ethereal:snowygrass"}, nil, nil, nil, ethereal.snowy)

-- cactus
add_node({"default:sandstone"}, 0.0025, {"sandstone"}, 1, 100, {"default:cactus"}, 3, nil, nil, ethereal.sandstone)
add_node({"default:desert_sand"}, 0.005, {"desert"}, 1, 100, {"default:cactus"}, 4, nil, nil, ethereal.desert)

-- wild red mushroom
add_node({"ethereal:mushroom_dirt"}, 0.01, {"mushroom"}, 1, 100, {"flowers:mushroom_fertile_red"}, nil, nil, nil, ethereal.mushroom)

local list = {
	{"junglee", {"ethereal:jungle_dirt", "default:dirt_with_rainforest_litter"}, ethereal.junglee},
	{"grassy", {"default:dirt_with_grass"}, ethereal.grassy},
	{"grassytwo", {"default:dirt_with_grass"}, ethereal.grassytwo},
	{"prairie", {"ethereal:prairie_dirt"}, ethereal.prairie},
	{"mushroom", {"ethereal:mushroom_dirt"}, ethereal.mushroom},
	{"swamp", {"default:dirt_with_grass"}, ethereal.swamp},
}

-- wild red and brown mushrooms
for _, row in pairs(list) do

if row[3] == 1 then
minetest.register_decoration({
	deco_type = "simple",
	place_on = row[2],
	sidelen = 16,
	noise_params = {
		offset = 0,
		scale = 0.009,
		spread = {x = 200, y = 200, z = 200},
		seed = 2,
		octaves = 3,
		persist = 0.66
	},
	biomes = {row[1]},
	y_min = 1,
	y_max = 120,
	decoration = {"flowers:mushroom_brown", "flowers:mushroom_red"},
})
end

end

-- jungle grass
add_node({"ethereal:jungle_dirt", "default:dirt_with_rainforest_litter"}, 0.10, {"junglee"}, 1, 100, {"default:junglegrass"}, nil, nil, nil, ethereal.junglee)
add_node({"default:dirt_with_grass"}, 0.15, {"jumble"}, 1, 100, {"default:junglegrass"}, nil, nil, nil, ethereal.jumble)
add_node({"default:dirt_with_grass"}, 0.25, {"swamp"}, 1, 100, {"default:junglegrass"}, nil, nil, nil, ethereal.swamp)

-- grass
add_node({"default:dirt_with_grass"}, 0.35, {"grassy"}, 1, 100, {"default:grass_2", "default:grass_3",
	"default:grass_4", "default:grass_5"}, nil, nil, nil, ethereal.grassy)
add_node({"default:dirt_with_grass"}, 0.35, {"grassytwo"}, 1, 100, {"default:grass_2", "default:grass_3",
	"default:grass_4", "default:grass_5"}, nil, nil, nil, ethereal.grassytwo)
add_node({"default:dirt_with_grass"}, 0.35, {"jumble"}, 1, 100, {"default:grass_2", "default:grass_3",
	"default:grass_4", "default:grass_5"}, nil, nil, nil, ethereal.jumble)
add_node({"ethereal:jungle_dirt", "default:dirt_with_rainforest_litter"}, 0.35, {"junglee"}, 1, 100, {"default:grass_2", "default:grass_3",
	"default:grass_4", "default:grass_5"}, nil, nil, nil, ethereal.junglee)
add_node({"ethereal:prairie_dirt"}, 0.35, {"prairie"}, 1, 100, {"default:grass_2", "default:grass_3",
	"default:grass_4", "default:grass_5"}, nil, nil, nil, ethereal.prairie)
add_node({"ethereal:grove_dirt"}, 0.35, {"grove"}, 1, 100, {"default:grass_2", "default:grass_3",
	"default:grass_4", "default:grass_5"}, nil, nil, nil, ethereal.grove)
add_node({"ethereal:bamboo_dirt"}, 0.35, {"bamboo"}, 1, 100, {"default:grass_2", "default:grass_3",
	"default:grass_4", "default:grass_5"}, nil, nil, nil, ethereal.bamboo)
add_node({"default:dirt_with_grass"}, 0.35, {"clearing", "swamp"}, 1, 100, {"default:grass_3",
	"default:grass_4"}, nil, nil, nil, 1)
add_node({"ethereal:bamboo_dirt"}, 0.35, {"sakura"}, 1, 100, {"default:grass_2", "default:grass_3", "default:grass_4", "default:grass_5"}, nil, nil, nil, ethereal.sakura)

-- grass on sand (and maybe blueberry bush)
if minetest.registered_nodes["default:marram_grass_1"] then

add_node({"default:sand"}, 0.25, {"sandclay"}, 3, 4, {"default:marram_grass_1",
	"default:marram_grass_2", "default:marram_grass_3"}, nil, nil, nil, ethereal.sandclay)

-- Blueberry bush
minetest.register_decoration({
	name = "default:blueberry_bush",
	deco_type = "schematic",
	place_on = {"default:dirt_with_coniferous_litter", "default:dirt_with_snow"},
	sidelen = 16,
	noise_params = {
		offset = -0.004,
		scale = 0.01,
		spread = {x = 100, y = 100, z = 100},
		seed = 697,
		octaves = 3,
		persist = 0.7,
	},
	biomes = {"snowy", "alpine"},
	y_max = 31000,
	y_min = 1,
	place_offset_y = 1,
	schematic = dpath .. "blueberry_bush.mts",
	flags = "place_center_x, place_center_z",
})
else
add_node({"default:sand"}, 0.25, {"sandclay"}, 3, 4, {"default:grass_2", "default:grass_3"}, nil, nil, nil, ethereal.sandclay)
end

-- ferns
add_node({"ethereal:grove_dirt"}, 0.2, {"grove"}, 1, 100, {"ethereal:fern"}, nil, nil, nil, ethereal.grove)
add_node({"default:dirt_with_grass"}, 0.1, {"swamp"}, 1, 100, {"ethereal:fern"}, nil, nil, nil, ethereal.swamp)

-- snow
add_node({"ethereal:cold_dirt", "default:dirt_with_coniferous_litter"}, 0.8, {"snowy"}, 4, 40, {"default:snow"}, nil, nil, nil, ethereal.snowy)
add_node({"default:dirt_with_snow"}, 0.8, {"alpine"}, 40, 140, {"default:snow"}, nil, nil, nil, ethereal.alpine)

-- wild onion
add_node({"default:dirt_with_grass"}, 0.25, {"grassy"}, 1, 100, {"ethereal:onion_4"}, nil, nil, nil, ethereal.grassy)
add_node({"default:dirt_with_grass"}, 0.25, {"grassytwo"}, 1, 100, {"ethereal:onion_4"}, nil, nil, nil, ethereal.grassytwo)
add_node({"default:dirt_with_grass"}, 0.25, {"jumble"}, 1, 100, {"ethereal:onion_4"}, nil, nil, nil, ethereal.jumble)
add_node({"ethereal:prairie_dirt"}, 0.25, {"prairie"}, 1, 100, {"ethereal:onion_4"}, nil, nil, nil, ethereal.prairie)

-- papyrus
add_node({"default:dirt_with_grass"}, 0.1, {"grassy"}, 1, 1, {"default:papyrus"}, 4, "default:water_source", 1, ethereal.grassy)
add_node({"ethereal:jungle_dirt", "default:dirt_with_rainforest_litter"}, 0.1, {"junglee"}, 1, 1, {"default:papyrus"}, 4, "default:water_source", 1, ethereal.junglee)
add_node({"default:dirt_with_grass"}, 0.1, {"swamp"}, 1, 1, {"default:papyrus"}, 4, "default:water_source", 1, ethereal.swamp)

--= Farming Redo plants

if farming and farming.mod and farming.mod == "redo" then

print ("[MOD] Ethereal - Farming Redo detected and in use")

-- potato
add_node({"ethereal:jungle_dirt", "default:dirt_with_rainforest_litter"}, 0.035, {"junglee"}, 1, 100, {"farming:potato_3"}, nil, nil, nil, ethereal.junglee)

-- carrot, cucumber, potato, tomato, corn, coffee, raspberry, rhubarb
add_node({"default:dirt_with_grass"}, 0.05, {"grassytwo"}, 1, 100, {"farming:carrot_7", "farming:cucumber_4",
	"farming:potato_3", "farming:tomato_7", "farming:corn_8", "farming:coffee_5",
	"farming:raspberry_4", "farming:rhubarb_3", "farming:blueberry_4"}, nil, nil, nil, ethereal.grassytwo)
add_node({"default:dirt_with_grass"}, 0.05, {"grassy"}, 1, 100, {"farming:carrot_7", "farming:cucumber_4",
	"farming:potato_3", "farming:tomato_7", "farming:corn_8", "farming:coffee_5",
	"farming:raspberry_4", "farming:rhubarb_3", "farming:blueberry_4",
	"farming:beetroot_5"}, nil, nil, nil, ethereal.grassy)
add_node({"default:dirt_with_grass"}, 0.05, {"jumble"}, 1, 100, {"farming:carrot_7", "farming:cucumber_4",
	"farming:potato_3", "farming:tomato_7", "farming:corn_8", "farming:coffee_5",
	"farming:raspberry_4", "farming:rhubarb_3", "farming:blueberry_4"}, nil, nil, nil, ethereal.jumble)
add_node({"ethereal:prairie_dirt"}, 0.05, {"prairie"}, 1, 100, {"farming:carrot_7", "farming:cucumber_4",
	"farming:potato_3", "farming:tomato_7", "farming:corn_8", "farming:coffee_5",
	"farming:raspberry_4", "farming:rhubarb_3", "farming:blueberry_4",
	"farming:pea_5", "farming:beetroot_5"}, nil, nil, nil, ethereal.prairie)

-- melon and pumpkin
add_node({"ethereal:jungle_dirt", "default:dirt_with_rainforest_litter"}, 0.015, {"junglee"}, 1, 1, {"farming:melon_8", "farming:pumpkin_8"}, nil, "default:water_source", 1, ethereal.junglee)
add_node({"default:dirt_with_grass"}, 0.015, {"grassy"}, 1, 1, {"farming:melon_8", "farming:pumpkin_8"}, nil, "default:water_source", 1, ethereal.grassy)
add_node({"default:dirt_with_grass"}, 0.015, {"grassytwo"}, 1, 1, {"farming:melon_8", "farming:pumpkin_8"}, nil, "default:water_source", 1, ethereal.grassytwo)
add_node({"default:dirt_with_grass"}, 0.015, {"jumble"}, 1, 1, {"farming:melon_8", "farming:pumpkin_8"}, nil, "default:water_source", 1, ethereal.jumble)

-- green beans
add_node({"default:dirt_with_grass"}, 0.035, {"grassytwo"}, 1, 100, {"farming:beanbush"}, nil, nil, nil, ethereal.grassytwo)

-- grape bushel
add_node({"default:dirt_with_grass"}, 0.025, {"grassytwo"}, 1, 100, {"farming:grapebush"}, nil, nil, nil, ethereal.grassytwo)
add_node({"default:dirt_with_grass"}, 0.025, {"grassy"}, 1, 100, {"farming:grapebush"}, nil, nil, nil, ethereal.grassy)
add_node({"ethereal:prairie_dirt"}, 0.025, {"prairie"}, 1, 100, {"farming:grapebush"}, nil, nil, nil, ethereal.prairie)

minetest.register_decoration({
	deco_type = "simple",
	place_on = {
		"default:dirt_with_grass", "ethereal:prairie_dirt",
		"default:dirt_with_rainforest_litter",
	},
	sidelen = 16,
	noise_params = {
		offset = 0,
		scale = 0.06,
		spread = {x = 100, y = 100, z = 100},
		seed = 420,
		octaves = 3,
		persist = 0.6
	},
	y_min = 5,
	y_max = 35,
	decoration = "farming:hemp_7",
	spawn_by = "group:tree",
	num_spawn_by = 1,
})

minetest.register_decoration({
	deco_type = "simple",
	place_on = {"default:dirt_with_grass", "default:dirt_with_rainforest_litter"},
	sidelen = 16,
	noise_params = {
		offset = 0,
		scale = 0.09,
		spread = {x = 100, y = 100, z = 100},
		seed = 760,
		octaves = 3,
		persist = 0.6
	},
	y_min = 5,
	y_max = 35,
	decoration = {"farming:chili_8", "farming:garlic_5", "farming:pepper_5", "farming:onion_5"},
	spawn_by = "group:tree",
	num_spawn_by = 1,
})

minetest.register_decoration({
	deco_type = "simple",
	place_on = {"default:dirt_with_dry_grass"},
	sidelen = 16,
	noise_params = {
		offset = 0,
		scale = 0.06,
		spread = {x = 100, y = 100, z = 100},
		seed = 917,
		octaves = 3,
		persist = 0.6
	},
	y_min = 18,
	y_max = 30,
	decoration = {"farming:pineapple_8"},
})
end

-- place waterlily in beach areas
local list = {
	{"desert_ocean", ethereal.desert},
	{"plains_ocean", ethereal.plains},
	{"sandclay", ethereal.sandclay},
	{"sandstone_ocean", ethereal.sandstone},
	{"mesa_ocean", ethereal.mesa},
	{"grove_ocean", ethereal.grove},
	{"grassy_ocean", ethereal.grassy},
	{"swamp_ocean", ethereal.swamp},
}

for _, row in pairs(list) do

	if row[2] == 1 then

	minetest.register_decoration({
		deco_type = "schematic",
		place_on = {"default:sand"},
		sidelen = 16,
		noise_params = {
			offset = -0.12,
			scale = 0.3,
			spread = {x = 200, y = 200, z = 200},
			seed = 33,
			octaves = 3,
			persist = 0.7
		},
		biomes = {row[1]},
		y_min = 0,
		y_max = 0,
		schematic = ethereal.waterlily,
		rotation = "random",
	})

	end

end

local random = math.random

-- Generate Illumishroom in caves next to coal
minetest.register_on_generated(function(minp, maxp)

	if minp.y > -30 or maxp.y < -3000 then
		return
	end

	local bpos
	local coal = minetest.find_nodes_in_area_under_air(
			minp, maxp, "default:stone_with_coal")

	for n = 1, #coal do

		if random(1, 2) == 1 then

			bpos = {x = coal[n].x, y = coal[n].y + 1, z = coal[n].z }

			if bpos.y > -3000 and bpos.y < -2000 then
				minetest.swap_node(bpos, {name = "ethereal:illumishroom3"})

			elseif bpos.y > -2000 and bpos.y < -1000 then
				minetest.swap_node(bpos, {name = "ethereal:illumishroom2"})

			elseif bpos.y > -1000 and bpos.y < -30 then
				minetest.swap_node(bpos, {name = "ethereal:illumishroom"})
			end
		end
	end
end)

-- coral reef (0.4.15 only)
if ethereal.reefs == 1 then

-- override corals so crystal shovel can pick them up intact
minetest.override_item("default:coral_skeleton", {groups = {crumbly = 3}})
minetest.override_item("default:coral_orange", {groups = {crumbly = 3}})
minetest.override_item("default:coral_brown", {groups = {crumbly = 3}})

	minetest.register_decoration({
		deco_type = "schematic",
		place_on = {"default:sand"},
		noise_params = {
			offset = -0.15,
			scale = 0.1,
			spread = {x = 100, y = 100, z = 100},
			seed = 7013,
			octaves = 3,
			persist = 1,
		},
		biomes = {
			"desert_ocean",
			"grove_ocean",
		},
		y_min = -8,
		y_max = -2,
		schematic = path .. "corals.mts",
		flags = "place_center_x, place_center_z",
		rotation = "random",
	})
end


-- is baked clay mod active? add new flowers if so
if minetest.get_modpath("bakedclay") then

minetest.register_decoration({
	deco_type = "simple",
	place_on = {
		"ethereal:prairie_grass", "default:dirt_with_grass",
		"ethereal:grove_dirt"
	},
	sidelen = 16,
	noise_params = {
		offset = 0,
		scale = 0.004,
		spread = {x = 100, y = 100, z = 100},
		seed = 7133,
		octaves = 3,
		persist = 0.6
	},
	y_min = 10,
	y_max = 90,
	decoration = "bakedclay:delphinium",
})

minetest.register_decoration({
	deco_type = "simple",
	place_on = {
		"ethereal:prairie_grass", "default:dirt_with_grass",
		"ethereal:grove_dirt", "ethereal:bamboo_dirt"
	},
	sidelen = 16,
	noise_params = {
		offset = 0,
		scale = 0.004,
		spread = {x = 100, y = 100, z = 100},
		seed = 7134,
		octaves = 3,
		persist = 0.6
	},
	y_min = 15,
	y_max = 90,
	decoration = "bakedclay:thistle",
})

minetest.register_decoration({
	deco_type = "simple",
	place_on = {"ethereal:jungle_dirt", "default:dirt_with_rainforest_litter"},
	sidelen = 16,
	noise_params = {
		offset = 0,
		scale = 0.01,
		spread = {x = 100, y = 100, z = 100},
		seed = 7135,
		octaves = 3,
		persist = 0.6
	},
	y_min = 1,
	y_max = 90,
	decoration = "bakedclay:lazarus",
	spawn_by = "default:jungletree",
	num_spawn_by = 1,
})

minetest.register_decoration({
	deco_type = "simple",
	place_on = {"default:dirt_with_grass", "default:sand"},
	sidelen = 16,
	noise_params = {
		offset = 0,
		scale = 0.009,
		spread = {x = 100, y = 100, z = 100},
		seed = 7136,
		octaves = 3,
		persist = 0.6
	},
	y_min = 1,
	y_max = 15,
	decoration = "bakedclay:mannagrass",
	spawn_by = "group:water",
	num_spawn_by = 1,
})

end

if ethereal.desert and minetest.get_modpath("wine") then
minetest.register_decoration({
	deco_type = "simple",
	place_on = {"default:desert_sand"},
	sidelen = 16,
	fill_ratio = 0.001,
	biomes = {"desert"},
	decoration = {"wine:blue_agave"},
})
end

if ethereal.snowy and minetest.registered_nodes["default:fern_1"] then
local function register_fern_decoration(seed, length)
	minetest.register_decoration({
		name = "default:fern_" .. length,
		deco_type = "simple",
		place_on = {
			"ethereal:cold_dirt", "default:dirt_with_coniferous_litter"},
		sidelen = 16,
		noise_params = {
			offset = 0,
			scale = 0.2,
			spread = {x = 100, y = 100, z = 100},
			seed = seed,
			octaves = 3,
			persist = 0.7
		},
		y_max = 31000,
		y_min = 6,
		decoration = "default:fern_" .. length,
	})
end

register_fern_decoration(14936, 3)
register_fern_decoration(801, 2)
register_fern_decoration(5, 1)
end

if ethereal.tundra and minetest.registered_nodes["default:permafrost"] then
	minetest.register_biome({
		name = "tundra_highland",
		node_dust = "default:snow",
		node_riverbed = "default:gravel",
		depth_riverbed = 2,
		y_max = 180,
		y_min = 47,
		heat_point = 0,
		humidity_point = 40,
	})

	minetest.register_biome({
		name = "tundra",
		node_top = "default:permafrost_with_stones",
		depth_top = 1,
		node_filler = "default:permafrost",
		depth_filler = 1,
		node_riverbed = "default:gravel",
		depth_riverbed = 2,
		vertical_blend = 4,
		y_max = 46,
		y_min = 2,
		heat_point = 0,
		humidity_point = 40,
	})

	minetest.register_biome({
		name = "tundra_beach",
		node_top = "default:gravel",
		depth_top = 1,
		node_filler = "default:gravel",
		depth_filler = 2,
		node_riverbed = "default:gravel",
		depth_riverbed = 2,
		vertical_blend = 1,
		y_max = 1,
		y_min = -3,
		heat_point = 0,
		humidity_point = 40,
	})

	minetest.register_biome({
		name = "tundra_ocean",
		node_top = "default:sand",
		depth_top = 1,
		node_filler = "default:sand",
		depth_filler = 3,
		node_riverbed = "default:gravel",
		depth_riverbed = 2,
		vertical_blend = 1,
		y_max = -4,
		y_min = -112,
		heat_point = 0,
		humidity_point = 40,
	})

	-- Tundra moss

	minetest.register_decoration({
		deco_type = "simple",
		place_on = {"default:permafrost_with_stones"},
		sidelen = 4,
		noise_params = {
			offset = -0.8,
			scale = 2.0,
			spread = {x = 100, y = 100, z = 100},
			seed = 53995,
			octaves = 3,
			persist = 1.0
		},
		biomes = {"tundra"},
		y_max = 50,
		y_min = 2,
		decoration = "default:permafrost_with_moss",
		place_offset_y = -1,
		flags = "force_placement",
	})

	-- Tundra patchy snow

	minetest.register_decoration({
		deco_type = "simple",
		place_on = {
			"default:permafrost_with_moss",
			"default:permafrost_with_stones",
			"default:stone",
			"default:gravel"
		},
		sidelen = 4,
		noise_params = {
			offset = 0,
			scale = 1.0,
			spread = {x = 100, y = 100, z = 100},
			seed = 172555,
			octaves = 3,
			persist = 1.0
		},
		biomes = {"tundra", "tundra_beach"},
		y_max = 50,
		y_min = 1,
		decoration = "default:snow",
	})
end

if minetest.get_modpath("butterflies") then
minetest.register_decoration({
	name = "butterflies:butterfly",
	deco_type = "simple",
	place_on = {"default:dirt_with_grass", "ethereal:prairie_dirt"},
	place_offset_y = 2,
	sidelen = 80,
	fill_ratio = 0.005,
	biomes = {"grassy", "grassytwo", "prairie", "jumble"},
	y_max = 31000,
	y_min = 1,
	decoration = {
		"butterflies:butterfly_white",
		"butterflies:butterfly_red",
		"butterflies:butterfly_violet"
	},
	spawn_by = "group:flower",
	num_spawn_by = 1
})
end

if minetest.get_modpath("fireflies") then
	minetest.register_decoration({
		name = "fireflies:firefly_low",
		deco_type = "simple",
		place_on = {
			"default:dirt_with_grass",
			"default:dirt_with_coniferous_litter",
			"default:dirt_with_rainforest_litter",
			"default:dirt",
			"ethereal:cold_dirt",
		},
		place_offset_y = 2,
		sidelen = 80,
		fill_ratio = 0.0005,
		biomes = {"grassy", "grassytwo", "snowy", "junglee", "swamp"},
		y_max = 31000,
		y_min = -1,
		decoration = "fireflies:hidden_firefly",
	})
end

-- Coral Reef (Minetest 5.0)
if minetest.registered_nodes["default:coral_green"] then
	minetest.register_decoration({
		name = "default:corals",
		deco_type = "simple",
		place_on = {"default:sand"},
		place_offset_y = -1,
		sidelen = 4,
		noise_params = {
			offset = -4,
			scale = 4,
			spread = {x = 50, y = 50, z = 50},
			seed = 7013,
			octaves = 3,
			persist = 0.7,
		},
		biomes = {
			"desert_ocean",
			"savanna_ocean",
			"junglee_ocean",
		},
		y_max = -2,
		y_min = -8,
		flags = "force_placement",
		decoration = {
			"default:coral_green", "default:coral_pink",
			"default:coral_cyan", "default:coral_brown",
			"default:coral_orange", "default:coral_skeleton",
		},
	})

	-- Kelp

	minetest.register_decoration({
		name = "default:kelp",
		deco_type = "simple",
		place_on = {"default:sand"},
		place_offset_y = -1,
		sidelen = 16,
		noise_params = {
			offset = -0.04,
			scale = 0.1,
			spread = {x = 200, y = 200, z = 200},
			seed = 87112,
			octaves = 3,
			persist = 0.7
		},
		biomes = {
			"frost_ocean", "grassy_ocean", "sandstone_ocean", "swamp_ocean"},
		y_max = -5,
		y_min = -10,
		flags = "force_placement",
		decoration = "default:sand_with_kelp",
		param2 = 48,
		param2_max = 96,
	})
end
