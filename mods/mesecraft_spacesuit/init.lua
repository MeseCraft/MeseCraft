
mesecraft_spacesuit = {
	armor_use = tonumber(minetest.settings:get("mesecraft_spacesuit.armor_use")) or 70,
}


local MP = minetest.get_modpath("mesecraft_spacesuit")

dofile(MP.."/suit.lua")
dofile(MP.."/crafts.lua")
dofile(MP.."/hud.lua")
dofile(MP.."/drowning.lua")
dofile(MP.."/repair.lua")

print("[OK] Spacesuit")
