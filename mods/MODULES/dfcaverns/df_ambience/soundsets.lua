if minetest.get_modpath("chasms") then
df_ambience.add_set({
	frequency = 0.03,
	sounds = {
		{name = "dfcaverns_long_bird_song_slow", gain = 0.5},
		{name = "dfcaverns_crow_slow", gain = 0.5},
		{name = "dfcaverns_bird_noise", gain = 0.5},
	},
	sound_check = function(def)
		if chasms.is_in_chasm(def.pos) then return true end
	end,
})
end

-- Level 1

df_ambience.add_set({
	frequency = 0.075,
	nodes = {"df_mapitems:dirt_with_cave_moss", "df_trees:fungiwood", "df_trees:fungiwood_shelf"},
	sounds = {
		{name = "dfcaverns_bird_budgie_song", gain = 0.5},
	},
	sound_check = function(def)
		return def.biome == "fungiwood" or def.biome == "fungispore"
	end,
})

df_ambience.add_set({
	frequency = 0.050,
	nodes = {"df_mapitems:dirt_with_cave_moss", "df_trees:tower_cap_stem", "df_trees:tower_cap_gills", "df_trees:tower_cap"},
	sounds = {
		{name = "dfcaverns_exotic_creature_song", gain = 0.5},
	},
	sound_check = function(def)
		return def.biome == "towercap" or def.biome == "towergoblin"
	end,
})

-- Level 2

df_ambience.add_set({
	frequency = 0.050,
	nodes = {"df_mapitems:dirt_with_cave_moss", "df_trees:goblin_cap_stem", "df_trees:goblin_cap", "df_trees:goblin_cap_gills"},
	sounds = {
		{name = "dfcaverns_pig_grunting_grumbling", gain = 0.25},
	},
	sound_check = function(def)
		return def.biome == "goblincap" or def.biome == "towergoblin"
	end,
})

df_ambience.add_set({
	frequency = 0.025,
	nodes = {"df_mapitems:dirt_with_stillworm", "df_trees:tunnel_tube", "df_trees:tunnel_tube_slant_bottom", "df_trees:tunnel_tube_slant_top", "df_trees:tunnel_tube_slant_full", "df_trees:tunnel_tube_fruiting_body"},
	sounds = {
		{name = "dfcaverns_solitary_bird_song", gain = 0.25},
	},
	sound_check = function(def)
		return def.biome == "tunneltube"
	end,
})

df_ambience.add_set({
	frequency = 0.035,
	nodes = {"df_mapitems:dirt_with_pebble_fungus", "df_trees:spore_tree", "df_trees:spore_tree_hyphae", "df_trees:spore_tree_fruiting_body"},
	sounds = {
		{name = "dfcaverns_horse_neigh", gain = 0.25},
	},
	sound_check = function(def)
		return def.biome == "sporetree" or def.biome == "fungispore"
	end,
})

-- Level 3

local ice = df_dependencies.node_name_ice
local snow = df_dependencies.node_name_snow
df_ambience.add_set({
	frequency = 0.050,
	nodes = {"df_mapitems:icicle_1", "df_mapitems:icicle_2", "df_mapitems:icicle_3", "df_mapitems:icicle_4", "ice_sprites:ice_sprite", "ice_sprites:hidden_ice_sprite", "df_trees:nether_cap", "df_trees:nether_cap_gills", "df_trees:nether_cap_stem", ice, snow},
	sounds = {
		{name = "dfcaverns_howling", gain = 0.5},
	},
	sound_check = function(def)
		return def.biome == "nethercap"
	end,
})

df_ambience.add_set({
	frequency = 0.075,
	nodes = {"df_trees:blood_thorn", "df_trees:blood_thorn_spike"},
	sounds = {
		{name = "dfcaverns_flies", gain = 0.5},
	},
	sound_check = function(def)
		return def.biome == "bloodthorn"
	end,
})

-- blackcap left silent, torchspines make their own noise

-- Sunless sea

local water_source = df_dependencies.node_name_water_source
df_ambience.add_set({
	frequency = 0.050,
	sounds = {
		{name = "dfcaverns_whale", gain = 0.5},
	},
	sound_check = function(def)
		return def.head_node == water_source and df_caverns.get_biome(def.pos) == "sunless undersea"
	end,
})


-- Oil sea
-- No soundset here

-- Lava sea

if minetest.get_modpath("df_underworld_items") then
local lava_source = df_dependencies.node_name_lava_source
df_ambience.add_set({
	frequency = 0.0750,
	nodes = {lava_source},
	sounds = {
		{name = "dfcaverns_massive_digging", gain = 1.0},
		{name = "dfcaverns_avalanche", gain = 1.0},
	},	
	sound_check = function(def)
		return df_caverns.get_biome(def.pos) == "lava_sea"
	end,
})
end

-- Underworld

df_ambience.add_set({
	frequency = 0.025,
	nodes = {"df_underworld_items:slade"},
	sounds = {
		{name = "dfcaverns_whispers", gain = 0.15},
	},
	sound_check = function(def)
		return def.biome == "underworld"
	end,
})

-- Primordial

local jungle_bird = {name = "dfcaverns_jungle_bird", gain = 0.4}
df_ambience.add_set({
	frequency = 0.075,
	nodes = {"df_primordial_items:dirt_with_jungle_grass", "df_primordial_items:fern_1", "df_primordial_items:fern_2", "df_primordial_items:giant_fern_leaves", "df_primordial_items:giant_fern_tree", "df_primordial_items:giant_fern_tree_slant_bottom", "df_primordial_items:giant_fern_tree_slant_full", "df_primordial_items:giant_fern_tree_slant_top", "df_primordial_items:glow_plant_1", "df_primordial_items:glow_plant_2", "df_primordial_items:glow_plant_3", "df_primordial_items:jungle_grass_1", "df_primordial_items:jungle_grass_2", "df_primordial_items:jungle_grass_3", "df_primordial_items:jungle_ivy", "df_primordial_items:jungle_leaves", "df_primordial_items:jungle_leaves_glowing", "df_primordial_items:jungle_mushroom_1", "df_primordial_items:jungle_mushroom_2", "df_primordial_items:jungle_mushroom_cap_1", "df_primordial_items:jungle_mushroom_cap_2", "df_primordial_items:jungle_mushroom_trunk", "df_primordial_items:jungle_roots_1", "df_primordial_items:jungle_roots_2", "df_primordial_items:jungle_thorns", "df_primordial_items:jungle_tree", "df_primordial_items:jungle_tree_glowing", "df_primordial_items:jungle_tree_mossy", "df_primordial_items:packed_roots", "df_primordial_items:plant_matter", },
	sounds = {
		{name = "dfcaverns_drums", gain = 0.3},
		{name = "dfcaverns_frog", gain = 0.5},
		jungle_bird, jungle_bird, -- double up the birds to make them more common
	},
	sound_check = function(def)
		return def.biome == "primordial jungle"
	end,
})

df_ambience.add_set({
	frequency = 0.05,
	nodes = {"df_primordial_items:dirt_with_mycelium", "df_primordial_items:fungal_grass_1", "df_primordial_items:fungal_grass_2", "df_primordial_items:glow_orb", "df_primordial_items:glow_orb_stalks", "df_primordial_items:glow_pods", "df_primordial_items:giant_hypha_root", "df_primordial_items:giant_hypha", "df_primordial_items:mushroom_cap", "df_primordial_items:mushroom_gills", "df_primordial_items:mushroom_gills_glowing", "df_primordial_items:mushroom_trunk", "df_primordial_items:glow_orb_hanging", "df_primordial_items:glownode", "df_primordial_items:glownode_stalk",},
	sounds = {
		{name = "dfcaverns_howler_monkey", gain = 0.3},
	},
	sound_check = function(def)
		return def.biome == "primordial fungus"
	end,
})