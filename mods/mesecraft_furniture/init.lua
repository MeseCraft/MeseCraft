-- Initialization code for mesecraft_furniture.

-- Declare and initialize table.
mesecraft_furniture = {}

-- declare modpath variables and set to current path.
local MP = minetest.get_modpath(minetest.get_current_modname())

-- translation support
local S, NS = dofile(MP.."/intllib.lua")
mesecraft_furniture.intllib = S

-- run submodules.
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