ma_pops_furniture = {}

dofile(minetest.get_modpath('ma_pops_furniture')..'/sit.lua')
dofile(minetest.get_modpath('ma_pops_furniture')..'/crafts.lua')
dofile(minetest.get_modpath('ma_pops_furniture')..'/nodes.lua')
dofile(minetest.get_modpath('ma_pops_furniture')..'/fridge.lua')
dofile(minetest.get_modpath('ma_pops_furniture')..'/freezer.lua')
dofile(minetest.get_modpath('ma_pops_furniture')..'/mirror.lua')
dofile(minetest.get_modpath('ma_pops_furniture')..'/microwave.lua')
dofile(minetest.get_modpath('ma_pops_furniture')..'/oven.lua')


--GreenDimond's code from waffle mod
local MP = minetest.get_modpath(minetest.get_current_modname())
local S, NS = dofile(MP.."/intllib.lua")

ma_pops_furniture.intllib = S
dofile(minetest.get_modpath('ma_pops_furniture')..'/toaster.lua')
dofile(minetest.get_modpath('ma_pops_furniture')..'/intllib.lua')

minetest.register_alias("furniture_mod:toilet_closed", "ma_pops_furniture:toilet_closed")
minetest.register_alias("furniture_mod:toilet_open", "ma_pops_furniture:toilet_open")
minetest.register_alias("furniture_mod:tv", "ma_pops_furniture:tv")
minetest.register_alias("furniture_mod:lamp", "ma_pops_furniture:lamp")
minetest.register_alias("furniture_mod:lamp_off", "ma_pops_furniture:lamp_off")
minetest.register_alias("furniture_mod:ceiling_light", "ma_pops_furniture:ceiling_lamp")
minetest.register_alias("furniture_mod:ceiling_light_off", "ma_pops_furniture:ceiling_lamp_off")
