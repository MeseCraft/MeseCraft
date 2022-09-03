df_underworld_items = {}

local modname = minetest.get_current_modname()
local modpath = minetest.get_modpath(modname)

dofile(modpath.."/config.lua")
dofile(modpath.."/doc.lua")

dofile(modpath.."/crystals_amethyst.lua")
dofile(modpath.."/glow_stone.lua")
dofile(modpath.."/slade.lua")
dofile(modpath.."/hunter_statue.lua")
dofile(modpath.."/glowing_pit_plasma.lua")

dofile(modpath.."/puzzle_seal.lua")
dofile(modpath.."/puzzle_chest.lua")
dofile(modpath.."/ancient_lanterns.lua")
if df_underworld_items.config.enable_slade_drill then
	dofile(modpath.."/slade_drill.lua")
end
