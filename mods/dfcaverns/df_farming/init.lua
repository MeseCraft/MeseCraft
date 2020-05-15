df_farming = {}

--grab a shorthand for the filepath of the mod
local modpath = minetest.get_modpath(minetest.get_current_modname())

--load companion lua files
dofile(modpath.."/config.lua")
dofile(modpath.."/doc.lua")
dofile(modpath.."/aliases.lua")

dofile(modpath.."/plants.lua") -- general functions
dofile(modpath.."/cave_wheat.lua")
dofile(modpath.."/dimple_cup.lua")
dofile(modpath.."/pig_tail.lua")
dofile(modpath.."/plump_helmet.lua")
dofile(modpath.."/quarry_bush.lua")
dofile(modpath.."/sweet_pod.lua")
dofile(modpath.."/cooking.lua")
