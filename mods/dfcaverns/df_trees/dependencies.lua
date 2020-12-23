df_trees.sounds = {}

df_trees.sounds.wood = default.node_sound_wood_defaults()
df_trees.sounds.leaves = default.node_sound_leaves_defaults()
df_trees.sounds.nethercap_wood = default.node_sound_wood_defaults({
	footstep = {name = "default_snow_footstep", gain = 0.2},
})
df_trees.sounds.glass = default.node_sound_glass_defaults()

df_trees.node_names = {}

df_trees.node_names.torch = "default:torch"
df_trees.node_names.chest = "default:chest"
df_trees.node_names.furnace = "default:furnace"
df_trees.node_names.apple = "default:apple"
df_trees.node_names.gold_ingot = "default:gold_ingot"
df_trees.node_names.water_source = "default:water_source"
df_trees.node_names.river_water_source = "default:river_water_source"
df_trees.node_names.ice = "default:ice"
df_trees.node_names.water_flowing = "default:water_flowing"
df_trees.node_names.river_water_flowing = "default:river_water_flowing"
df_trees.node_names.snow = "default:snow"
df_trees.node_names.torch_wall = "default:torch_wall"
df_trees.node_names.stone_with_coal = "default:stone_with_coal"
df_trees.node_names.coalblock = "default:coalblock"
df_trees.node_names.paper = "default:paper"


df_trees.textures = {}
df_trees.textures.gold_block = "default_gold_block.png"

-- this stuff is only for during initialization
minetest.after(0, function()
	df_trees.sounds = nil
	df_trees.node_names = nil
	df_trees.textures = nil
end)


df_trees.iron_containing_nodes = {"default:stone_with_iron", "default:steelblock"}
df_trees.copper_containing_nodes = {"default:stone_with_copper", "default:copperblock"}
df_trees.mese_containing_nodes = {"default:stone_with_mese", "default:mese"}


df_trees.after_place_leaves = default.after_place_leaves
df_trees.register_leafdecay = default.register_leafdecay

-- This is used by other mods, leave it exposed
df_trees.node_sound_tree_soft_fungus_defaults = function(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "dfcaverns_fungus_footstep", gain = 0.3}
	default.node_sound_wood_defaults(table)
	return table
end
