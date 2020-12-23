df_primordial_items = {}
df_primordial_items.doc = {}

local modname = minetest.get_current_modname()
df_primordial_items.S = minetest.get_translator(modname)
local modpath = minetest.get_modpath(modname)

dofile(modpath.."/dependencies.lua")
dofile(modpath.."/doc.lua")
dofile(modpath.."/jungle_nodes.lua")
dofile(modpath.."/jungle_tree.lua")
dofile(modpath.."/jungle_mushroom.lua")
dofile(modpath.."/giant_fern.lua")
dofile(modpath.."/fungal_nodes.lua")
dofile(modpath.."/ceiling_fungus.lua")
dofile(modpath.."/primordial_mushroom.lua")
dofile(modpath.."/giant_mycelium.lua")
dofile(modpath.."/edibles.lua")