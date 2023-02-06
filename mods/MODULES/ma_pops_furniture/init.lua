ma_pops_furniture = {}

local MP = minetest.get_modpath(minetest.get_current_modname())
local S, NS = dofile(MP.."/intllib.lua")
ma_pops_furniture.intllib = S

dofile(MP..'/sit.lua')
dofile(MP..'/kitchen_bath.lua')
dofile(MP..'/armchair.lua')
dofile(MP..'/fridge.lua')
dofile(MP..'/freezer.lua')
dofile(MP..'/mirror.lua')
dofile(MP..'/microwave.lua')
dofile(MP..'/oven.lua')
dofile(MP..'/toilet.lua')
dofile(MP..'/toaster.lua')

minetest.register_alias("furniture_mod:toilet_closed", "ma_pops_furniture:toilet_closed")
minetest.register_alias("furniture_mod:toilet_open", "ma_pops_furniture:toilet_open")
