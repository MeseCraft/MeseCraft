--This file contains references to external dependencies, in hopes of making it easier to make those optional in the future

df_primordial_items.node_names = {}

df_primordial_items.node_names.dirt = "default:dirt"
df_primordial_items.node_names.dry_shrub = "default:dry_shrub"
df_primordial_items.node_names.dry_grass_3 = "default:dry_grass_3"
df_primordial_items.node_names.dry_grass_4 = "default:dry_grass_4"
df_primordial_items.node_names.junglewood = "default:junglewood"

df_primordial_items.sounds = {}

df_primordial_items.sounds.leaves = default.node_sound_leaves_defaults()
df_primordial_items.sounds.wood = default.node_sound_wood_defaults()
df_primordial_items.sounds.glass = default.node_sound_glass_defaults()
df_primordial_items.sounds.dirt = default.node_sound_dirt_defaults()

df_primordial_items.register_leafdecay = default.register_leafdecay
df_primordial_items.after_place_leaves = default.after_place_leaves

-- This stuff should only be used during initialization
minetest.after(0, function()
	df_primordial_items.node_names = nil
	df_primordial_items.sounds = nil
end)