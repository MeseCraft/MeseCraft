df_farming.sounds = {}

df_farming.sounds.leaves = default.node_sound_leaves_defaults()
df_farming.sounds.water = default.node_sound_water_defaults()

df_farming.node_names = {}

df_farming.node_names.dirt = "default:dirt"
df_farming.node_names.dirt_moss = "df_farming:dirt_with_cave_moss"
df_farming.node_names.floor_fungus = "df_farming:cobble_with_floor_fungus"
df_farming.node_names.dirt_wet = "farming:soil_wet"
df_farming.node_names.mortar_pestle = "farming:mortar_pestle"
df_farming.node_names.bucket = "mesecraft_bucket:bucket_empty"
df_farming.node_names.wool_white = "wool:white"


-- these are only for initialization
minetest.after(0, function()
	df_farming.sounds = nil
	df_farming.node_names = nil
end)
