local path = minetest.get_modpath("mobs_npc")

-- NPC
dofile(path .. "/npc.lua") -- TenPlus1
dofile(path .. "/trader.lua")
dofile(path .. "/igor.lua")

-- Print mod status in log
print ("[MOD] Mobs Redo 'NPCs' loaded")
