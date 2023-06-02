local path = minetest.get_modpath("halloween_holiday_pack")

-- Halloween Creatures
-- Register mobs if mobs_redo is enabled
if minetest.get_modpath("mobs") then
	dofile(path .. "/mobs/frankenstein.lua")
	dofile(path .. "/mobs/ghost_halloween.lua")
	dofile(path .. "/mobs/grim_reaper.lua")
	dofile(path .. "/mobs/pumpboom.lua")
	dofile(path .. "/mobs/scarecrow.lua")
	dofile(path .. "/mobs/werewolf.lua")
	dofile(path .. "/mobs/witch.lua")
	dofile(path .. "/mobs/vampire.lua") --(dies into mesecraft_mobs:bat)
	dofile(path .. "/mobs/zombie_halloween.lua")
end


-- Register Halloween Candy.
if minetest.get_modpath("farming") then
	dofile(path .. "/halloween_candy.lua")
end


-- Register costumes if 3d_armor is enabled
if minetest.get_modpath("armor") then
	dofile(minetest.get_modpath("halloween").."/costumes.lua")
end