local S = minetest.get_translator(minetest.get_current_modname())

local select_required = df_dependencies.select_required
local select_optional = df_dependencies.select_optional

df_dependencies.mods_required.mcl_sounds = true

if minetest.get_modpath("default") then
	df_dependencies.sound_dirt = default.node_sound_dirt_defaults
	df_dependencies.sound_glass = default.node_sound_glass_defaults
	df_dependencies.sound_gravel = default.node_sound_gravel_defaults
	df_dependencies.sound_leaves = default.node_sound_leaves_defaults
	df_dependencies.sound_sand = default.node_sound_sand_defaults
	df_dependencies.sound_stone = default.node_sound_stone_defaults
	df_dependencies.sound_water = default.node_sound_water_defaults
	df_dependencies.sound_wood = default.node_sound_wood_defaults
elseif minetest.get_modpath("mcl_sounds") then
	df_dependencies.sound_dirt = mcl_sounds.node_sound_dirt_defaults
	df_dependencies.sound_glass = mcl_sounds.node_sound_glass_defaults
	df_dependencies.sound_gravel = function(table)
		table = table or {}
		table.footstep = table.footstep or {name="default_gravel_footstep", gain=0.45}
		return mcl_sounds.node_sound_dirt_defaults(table)
	end
	df_dependencies.sound_leaves = mcl_sounds.node_sound_leaves_defaults
	df_dependencies.sound_sand = mcl_sounds.node_sound_sand_defaults
	df_dependencies.sound_stone = mcl_sounds.node_sound_stone_defaults
	df_dependencies.sound_water = mcl_sounds.node_sound_water_defaults
	df_dependencies.sound_wood = mcl_sounds.node_sound_wood_defaults
else
	assert(false, "One of [default] or [mcl_sounds] must be active")
end

df_dependencies.soundfile_grass_footstep = select_required({{"default", "default_grass_footstep"}, {"mcl_sounds", "default_grass_footstep"}})
df_dependencies.soundfile_snow_footstep = select_required({{"default", "default_snow_footstep"}, {"mcl_sounds", "pedology_snow_soft_footstep"}})
df_dependencies.soundfile_gravel_footstep = select_required({{"default", "default_gravel_footstep"}, {"mcl_sounds", "default_gravel_footstep"}})
df_dependencies.soundfile_cool_lava = select_required({{"default", "default_cool_lava"}, {"mcl_sounds", "default_cool_lava"}})
df_dependencies.soundfile_tnt_ignite = select_required({{"default", "tnt_ignite"}, {"mcl_tnt", "tnt_ignite"}})