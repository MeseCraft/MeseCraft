df_mapitems.sounds = {}

df_mapitems.sounds.stone = default.node_sound_stone_defaults()
df_mapitems.sounds.floor_fungus = default.node_sound_stone_defaults({footstep = {name = "dfcaverns_squish", gain = 0.25},})
df_mapitems.sounds.sandscum = default.node_sound_sand_defaults({footstep = {name = "dfcaverns_squish", gain = 0.25},})
df_mapitems.sounds.glass = default.node_sound_glass_defaults()
df_mapitems.sounds.dirt = default.node_sound_dirt_defaults()
df_mapitems.sounds.dirt_mossy = default.node_sound_dirt_defaults({footstep = {name = "default_grass_footstep", gain = 0.25},})

df_mapitems.node_id = {}

df_mapitems.node_id.stone = minetest.get_content_id("default:stone")
df_mapitems.node_id.water = minetest.get_content_id("default:water_source")
df_mapitems.node_id.dirt = minetest.get_content_id("default:dirt")

df_mapitems.texture = {}

df_mapitems.texture.coral_skeleton = "default_coral_skeleton.png"
df_mapitems.texture.cobble = "default_cobble.png"
df_mapitems.texture.stone = "default_stone.png"
df_mapitems.texture.ice = "default_ice.png"
df_mapitems.texture.sand = "default_sand.png"
df_mapitems.texture.dirt = "default_dirt.png"

df_mapitems.node_name = {}

df_mapitems.node_name.coral_skeleton = 	"default:coral_skeleton"
df_mapitems.node_name.water = "default:water_source"
df_mapitems.node_name.mese_crystal = "default:mese_crystal"
df_mapitems.node_name.cobble = "default:cobble"
df_mapitems.node_name.sand = "default:sand"
df_mapitems.node_name.dirt = "default:dirt"
df_mapitems.node_name.stone = "default:stone"
df_mapitems.node_name.ice = "default:ice"

df_mapitems.node_name.farming_soil = "farming:soil"
df_mapitems.node_name.farming_soil_wet = "farming:soil_wet"

-- This stuff should only be used during initialization
minetest.after(0, function()
	df_mapitems.node_name = nil
	df_mapitems.sounds = nil
	df_mapitems.texture = nil
	df_mapitems.node_id = nil
end)