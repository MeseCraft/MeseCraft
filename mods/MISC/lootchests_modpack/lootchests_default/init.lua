local path = minetest.get_modpath("lootchests_default")
dofile(path .. "/item_tables.lua")
dofile(path .. "/chests.lua")

if minetest.get_modpath("3d_armor") then
    dofile(path .. "/mod_support/3d_armor.lua")
end

if minetest.get_modpath("shields") then
    dofile(path .. "/mod_support/3d_armor_shields.lua")
end

if minetest.get_modpath("bonemeal") then
    dofile(path .. "/mod_support/bonemeal.lua")
end

if minetest.get_modpath("farming") and farming and farming.mod == "redo" then
    dofile(path .. "/mod_support/farming_redo.lua")
end

if minetest.get_modpath("gadgets_consumables") then
    dofile(path .. "/mod_support/gadgets_modpack.lua")
end

if minetest.get_modpath("moreores") then
    dofile(path .. "/mod_support/moreores.lua")
end

if minetest.get_modpath("moretrees") then
    dofile(path .. "/mod_support/moretrees.lua")
end