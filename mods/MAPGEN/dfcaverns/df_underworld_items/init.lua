df_underworld_items = {}

local modname = minetest.get_current_modname()
df_underworld_items.S = minetest.get_translator(modname)
local modpath = minetest.get_modpath(modname)

dofile(modpath.."/config.lua")
dofile(modpath.."/doc.lua")

dofile(modpath.."/crystals_amethyst.lua")
dofile(modpath.."/glow_stone.lua")
dofile(modpath.."/slade.lua")
dofile(modpath.."/hunter_statue.lua")
dofile(modpath.."/glowing_pit_plasma.lua")

dofile(modpath.."/puzzle_seal.lua")