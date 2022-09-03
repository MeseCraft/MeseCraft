df_trees = {}

local modname = minetest.get_current_modname()
local modpath = minetest.get_modpath(modname)

-- This is used by other mods, leave it exposed
df_trees.node_sound_tree_soft_fungus_defaults = function(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "dfcaverns_fungus_footstep", gain = 0.3}
	df_dependencies.sound_wood(table)
	return table
end

--load companion lua files
dofile(modpath.."/config.lua")
dofile(modpath.."/doc.lua")
dofile(modpath.."/aliases.lua")

dofile(modpath.."/blood_thorn.lua")
dofile(modpath.."/fungiwood.lua")
dofile(modpath.."/tunnel_tube.lua")
dofile(modpath.."/spore_tree.lua")
dofile(modpath.."/black_cap.lua")
dofile(modpath.."/nether_cap.lua")
dofile(modpath.."/goblin_cap.lua")
dofile(modpath.."/tower_cap.lua")

dofile(modpath.."/torchspine.lua")
dofile(modpath.."/spindlestem.lua")

dofile(modpath.."/sapling_growth_conditions.lua")