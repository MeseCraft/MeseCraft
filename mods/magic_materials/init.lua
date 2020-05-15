local path = minetest.get_modpath("magic_materials")
dofile(path .. "/nodes.lua")
dofile(path .. "/craftitems.lua")
dofile(path .. "/crafts.lua")
dofile(path .. "/mapgen.lua")
dofile(path .. "/tools.lua")

if minetest.get_modpath("technic") then
    dofile(path .. "/technic.lua")
end