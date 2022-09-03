df_mapitems = {}

local modname = minetest.get_current_modname()
local modpath = minetest.get_modpath(modname)

--load companion lua files
dofile(modpath.."/config.lua")
dofile(modpath.."/doc.lua")
dofile(modpath.."/aliases.lua")
dofile(modpath.."/util.lua")

dofile(modpath.."/ground_cover.lua")
dofile(modpath.."/glow_worms.lua")
dofile(modpath.."/flowstone.lua")
dofile(modpath.."/snareweed.lua")
dofile(modpath.."/cave_coral.lua")

dofile(modpath.."/crystals_mese.lua")
dofile(modpath.."/crystals_ruby.lua")
dofile(modpath.."/crystals_salt.lua")

dofile(modpath.."/veinstone.lua")
dofile(modpath.."/cave_pearls.lua")
dofile(modpath.."/castle_coral.lua")