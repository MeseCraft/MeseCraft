df_caverns = {}
df_caverns.config = df_dependencies.config

--grab a shorthand for the filepath of the mod
local modpath = minetest.get_modpath(minetest.get_current_modname())

--load companion lua files
dofile(modpath.."/node_ids.lua")

dofile(modpath.."/shared.lua")
dofile(modpath.."/surface_tunnels.lua")
dofile(modpath.."/level1.lua")
dofile(modpath.."/level2.lua")
dofile(modpath.."/level3.lua")
dofile(modpath.."/sunless_sea.lua")
dofile(modpath.."/oil_sea.lua")
dofile(modpath.."/lava_sea.lua")
dofile(modpath.."/underworld.lua")
dofile(modpath.."/primordial.lua")
dofile(modpath.."/dungeon_loot.lua")
dofile(modpath.."/growth_restrictions.lua")