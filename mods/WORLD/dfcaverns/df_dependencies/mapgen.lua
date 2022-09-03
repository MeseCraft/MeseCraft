local S = minetest.get_translator(minetest.get_current_modname())

local function deep_copy(table_in)
	local table_out = {}
	for index, value in pairs(table_in) do
		if type(value) == "table" then
			table_out[index] = deep_copy(value)
		else
			table_out[index] = value
		end
	end
	return table_out
end

local config = df_dependencies.config

local lowest_elevation = config.sunless_sea_min
if config.enable_oil_sea then
	lowest_elevation = config.oil_sea_level
end
if config.enable_lava_sea then
	lowest_elevation = config.lava_sea_level
end
if config.enable_underworld then
	lowest_elevation = config.underworld_level
end
if config.enable_primordial then
	lowest_elevation = config.primordial_min
end
lowest_elevation = lowest_elevation - 193 -- add a little buffer space

df_dependencies.mods_required.mcl_init = true
df_dependencies.mods_required.mcl_worlds = true
df_dependencies.mods_required.mcl_strongholds = true
df_dependencies.mods_required.mcl_compatibility = true
df_dependencies.mods_required.mcl_mapgen = true

local old_overworld_min

local ores_extended = false
local extend_ores = function()
	if ores_extended then return end -- should only do this once.
	ores_extended = true
	local ores_registered = {}
	for key, val in pairs(minetest.registered_ores) do
		ores_registered[val.ore] = true
	end

	local wherein_stonelike = {"mcl_core:stone"}
	local localseed = 12345
	
	local stone_blobs = {
		wherein = wherein_stonelike,
		clust_scarcity = 1000,
		clust_size = 7,
		y_min = lowest_elevation,
		y_max = old_overworld_min,
		ore_type = "blob",
		clust_num_ores = 58,
		noise_params = {
			octaves = 3,
			seed = 12345,
			lacunarity = 2,
			spread = {
				y = 250,
				x = 250,
				z = 250
			},
			persist = 0.6,
			flags = "defaults",
			offset = 0,
			scale = 1
		},
	}
	
	local register_blob = function(ore, cluster_size, cluster_scarcity_cuberoot, ymin, ymax)
		localseed = localseed + 1 -- increment this every time it's called to ensure different distributions
		local blob_copy = deep_copy(stone_blobs)
		blob_copy.ore = ore
		blob_copy.clust_num_ores = cluster_size
		blob_copy.clust_size = math.ceil(math.sqrt(cluster_size))
		blob_copy.clust_scarcity = cluster_scarcity_cuberoot*cluster_scarcity_cuberoot*cluster_scarcity_cuberoot
		blob_copy.seed = localseed
		blob_copy.y_min = ymin or stone_blobs.y_min
		blob_copy.y_max = ymax or stone_blobs.y_max
		--minetest.debug(dump(blob_copy))
		minetest.register_ore(blob_copy)
	end

	local scattered_ore = {
		wherein        = wherein_stonelike,
		ore_type       = "scatter",
		--ore            = "mcl_core:stone_with_coal",
		clust_scarcity = 525*3,
		clust_num_ores = 5,
		clust_size     = 3,
		y_min = lowest_elevation,
		y_max = old_overworld_min,
		noise_params   = deep_copy(stone_blobs.noise_params), -- since there's so much volume to scatter ore in, using noise to make some regions "rich" and others "poor" for variety
		noise_threshold= 0,
	}

	local register_scattered_internal = function(ore, cluster_size, cluster_scarcity_cuberoot, threshold, ymin, ymax, wherein)
		local scattered_copy = deep_copy(scattered_ore)
		scattered_copy.ore = ore
		scattered_copy.clust_size = cluster_size*cluster_size*cluster_size
		scattered_copy.clust_scarcity = cluster_scarcity_cuberoot*cluster_scarcity_cuberoot*cluster_scarcity_cuberoot
		scattered_copy.clust_num_ores = math.ceil(scattered_copy.clust_size/3)
		scattered_copy.seed = localseed
		scattered_copy.threshold = threshold
		scattered_copy.y_min = ymin or scattered_ore.y_min
		scattered_copy.y_max = ymax or scattered_ore.y_max
		scattered_copy.wherein = wherein or scattered_ore.wherein
		--minetest.debug(dump(scattered_copy))
		minetest.register_ore(scattered_copy)
	end
	local register_scattered = function(ore, cluster_size, cluster_scarcity_cuberoot, ymin, ymax, wherein)
		assert(not (ymin and ymax) or ymin < ymax, "Elevation parameter error for register_scattered")
		localseed = localseed + 1 -- increment this every time it's called to ensure different distributions
		-- same seed makes the noise patterns overlap.
		-- one produces widespread smaller clusters, other produces larger clusters at the peaks of the noise in addition to the smaller ones
		register_scattered_internal(ore, cluster_size, cluster_scarcity_cuberoot, 0, ymin, ymax, wherein)
		register_scattered_internal(ore, cluster_size*2, cluster_scarcity_cuberoot, 0.25, ymin, ymax, wherein)
	end

	if ores_registered["mcl_core:diorite"] then
		register_blob("mcl_core:diorite", 58, 10)
		register_blob("mcl_core:diorite", 33, 15)
		table.insert(wherein_stonelike, "mcl_core:diorite")
	end
	if ores_registered["mcl_core:andesite"] then
		register_blob("mcl_core:andesite", 58, 10)
		register_blob("mcl_core:andesite", 33, 15)
		table.insert(wherein_stonelike, "mcl_core:andesite")
	end
	if ores_registered["mcl_core:granite"] then
		register_blob("mcl_core:granite", 58, 10)
		register_blob("mcl_core:granite", 33, 15)
		table.insert(wherein_stonelike, "mcl_core:granite")
	end
	if ores_registered["mcl_core:dirt"] then
		register_blob("mcl_core:dirt", 33, 15, config.sunless_sea_min)
		if config.enable_primordial then
			register_blob("mcl_core:dirt", 33, 15, config.primordial_min, config.primoridal_max)
		end
	end
	if ores_registered["mcl_core:gravel"] then
		register_blob("mcl_core:gravel", 33, 14)
	end

	if ores_registered["mcl_core:stone_with_iron"] then
		register_scattered("mcl_core:stone_with_iron", 3, 12)
	end
	if ores_registered["mcl_core:stone_with_coal"] then
		register_scattered("mcl_core:stone_with_coal", 3, 12)
		if config.enable_oil_sea then
			register_blob("mcl_core:stone_with_coal", 80, 10, config.oil_sea_level-200, config.oil_sea_level+200) -- tons of coal in the oil sea
		end
	end
	
	if ores_registered["mcl_core:stone_with_lapis"] then
		register_scattered("mcl_core:stone_with_lapis", 3, 25, config.sunless_sea_min, config.level3_min) -- Lapis is an ocean gem, I decided
		if config.enable_primordial then
			register_scattered("mcl_core:stone_with_lapis", 3, 25, config.primordial_min, config.primordial_max)
		end
	end
	
	if ores_registered["mcl_core:stone_with_redstone"] then
		register_scattered("mcl_core:stone_with_redstone", 3, 15, config.level3_min, config.level2_min) -- Level 3 is the most magical, scatter redstone there
		if config.enable_lava_sea then
			register_scattered("mcl_core:stone_with_redstone", 4, 15, config.lava_sea_level-200, config.lava_sea_level+100) -- and of course plenty of redstone in the lava sea
		end
	end
	
	if ores_registered["mcl_core:stone_with_diamond"] then
		register_scattered("mcl_core:stone_with_diamond", 2, 18, config.sunless_sea_min, config.level2_min)
		if config.enable_oil_sea then
			register_scattered("mcl_core:stone_with_diamond", 3, 18, config.oil_sea_level-200, config.oil_sea_level+200)
		end
		if config.enable_primordial then
			register_scattered("mcl_core:stone_with_diamond", 3, 15, config.primordial_min, config.primordial_max)
		end
	end
	
	if ores_registered["mcl_core:stone_with_gold"] then
		register_scattered("mcl_core:stone_with_gold", 2, 18)
		if config.enable_primordial then
			register_scattered("mcl_core:stone_with_gold", 3, 15, config.primordial_min, config.primordial_max)
		end
	end

	if ores_registered["mcl_core:stone_with_copper"] then
		register_scattered("mcl_core:stone_with_copper", 3, 18)
	end

	if ores_registered["mcl_deepslate:deepslate"] then
		register_blob("mcl_deepslate:deepslate", 33, 15, lowest_elevation, config.sunless_sea_min) -- it's called deepslate, so put it deep
	end
	if ores_registered["mcl_deepslate:tuff"] then
		register_blob("mcl_deepslate:tuff", 33, 15, lowest_elevation, config.sunless_sea_min)
	end

	if ores_registered["mcl_deepslate:deepslate_with_emerald"] then
		register_scattered("mcl_deepslate:deepslate_with_emerald", 1, 25, lowest_elevation, config.sunless_sea_min, "mcl_deepslate:deepslate")
	end
	if ores_registered["mcl_core:stone_with_emerald"] then
		register_scattered("mcl_core:stone_with_emerald", 1, 25, lowest_elevation, config.sunless_sea_min)
	end

end

if minetest.get_modpath("mcl_init") then -- Mineclone 2
	
	old_overworld_min = mcl_vars.mg_overworld_min -- remember this for weather control
	
	mcl_vars.mg_overworld_min = lowest_elevation
	mcl_vars.mg_bedrock_overworld_min = mcl_vars.mg_overworld_min
	mcl_vars.mg_lava_overworld_max = mcl_vars.mg_overworld_min + 10
	mcl_vars.mg_end_max = mcl_vars.mg_overworld_min - 2000

	-- shouldn't need to worry about the setting, extend_ores checks if the ores
	-- have already been registered.
	--if minetest.settings:get_bool("mcl_generate_ores", true) then
		extend_ores()
	--end

	df_dependencies.mods_required.mcl_structures = true
	-- never mind - add dependency on mcl_strongholds and these will get generated before overworld_min gets changed.
	--if minetest.get_modpath("mcl_structures") and minetest.get_modpath("mcl_strongholds") then
	--	local elevation_delta = old_overworld_min - lowest_elevation
	--	local strongholds = mcl_structures.get_structure_data("stronghold")
	--	mcl_structures.register_structure_data("stronghold", strongholds)	
	--end
end
if minetest.get_modpath("mcl_compatibility") then -- Mineclone 5
	old_overworld_min = mcl_vars.mg_overworld_min -- remember this for weather control

	mcl_vars.mg_overworld_min = lowest_elevation
	mcl_vars.mg_bedrock_overworld_min = mcl_vars.mg_overworld_min
	mcl_vars.mg_bedrock_overworld_max = mcl_vars.mg_overworld_min+4
	mcl_vars.mg_lava_overworld_max = mcl_vars.mg_overworld_min+6
	mcl_vars.mg_lava = false
	mcl_vars.mg_end_max = mcl_vars.mg_overworld_min - 2000
	mcl_vars.mg_realm_barrier_overworld_end_max = mcl_vars.mg_end_max
	mcl_vars.mg_realm_barrier_overworld_end_min = mcl_vars.mg_end_max-11
end
if minetest.get_modpath("mcl_mapgen") then -- Mineclone 5
	old_overworld_min = mcl_mapgen.overworld.min -- remember this for weather control

	mcl_mapgen.overworld.min = lowest_elevation
	mcl_mapgen.overworld.bedrock_min = mcl_mapgen.overworld.min
	mcl_mapgen.overworld.bedrock_max = mcl_mapgen.overworld.bedrock_min + (mcl_mapgen.bedrock_is_rough and 4 or 0)
	mcl_mapgen.overworld.lava_max = mcl_mapgen.overworld.min+6
	mcl_mapgen.overworld.railcorridors_height_min = -50
	mcl_mapgen.overworld.railcorridors_height_max = -2
	
	mcl_mapgen.end_.max = mcl_mapgen.overworld.min - 2000
	mcl_mapgen.realm_barrier_overworld_end_max = mcl_mapgen.end_.max
	mcl_mapgen.realm_barrier_overworld_end_min = mcl_mapgen.end_.max - 11

	if mcl_mapgen.on_settings_changed then
		mcl_mapgen.on_settings_changed()
	else
		minetest.log("error", "The installed version of the mcl_mapgen mod (part of Mineclone 5) "
		.."does not have an mcl_mapgen.on_settings_changed method. This will likely result in "
		.."altitudes below the original bedrock being inaccessible to players.")
	end
	
	extend_ores()
end
if minetest.get_modpath("mcl_worlds") then
	local old_has_weather = mcl_worlds.has_weather
	mcl_worlds.has_weather = function(pos)
		-- No weather in the deep caverns
		if pos.y >= lowest_elevation and pos.y <= old_overworld_min then
			return false
		end
		return old_has_weather(pos)
	end
end
