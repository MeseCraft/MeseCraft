local path = minetest.get_modpath("mesecraft_christmas")

-- Initialize our namespace.
mesecraft_christmas = {}

-- Do these submodules.
dofile(path .. "/bell.lua")
dofile(path .. "/crafts.lua")
dofile(path .. "/craftitems.lua")
dofile(path .. "/nodes.lua")
dofile(path .. "/paintings.lua")
dofile(path .. "/presents_functions.lua")
dofile(path .. "/presents_items.lua")
dofile(path .. "/stocking.lua")
dofile(path .. "/tools.lua")

-- If the "3d_armor" mod is present, Candy Cane armor is registered.
if minetest.get_modpath("3d_armor") then
        dofile(path .. "/armor.lua")
	dofile(path .. "/costumes.lua")
end

-- If the farming_redo mod is present, we add some crops.
if minetest.get_modpath("farming") then
        dofile(path .. "/crops.lua")
end


-- If the mobs_npc mod is present (assumes mobs_redo is installed) we run mobs.
if minetest.get_modpath("mobs_npc") then
	dofile(path .. "/mobs/candy_cane_man.lua")
	dofile(path .. "/mobs/christmas_tree_man.lua")
	dofile(path .. "/mobs/crampus_claus.lua")
	dofile(path .. "/mobs/gingerbread_man.lua")
	dofile(path .. "/mobs/mrs_claus.lua")
        dofile(path .. "/mobs/reindeer.lua")
        dofile(path .. "/mobs/santa_claus.lua")
        dofile(path .. "/mobs/zombie_elf.lua")
end


-- FINALIZE
-- lootchest item table
-- goodie bag item table
-- stocking item table

-- Christmas records had to be moved to the gramophone mod due to its global functions and modpath requirements.
