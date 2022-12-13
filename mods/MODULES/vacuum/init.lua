
vacuum = {
	space_height = tonumber(minetest.settings:get("vacuum.space_height")) or 1000,
	air_pump_range = tonumber(minetest.settings:get("vacuum.air_pump_range")) or 5,
	profile_mapgen = minetest.settings:get("vacuum.profile_mapgen"),
	debug = minetest.settings:get("vacuum.debug")
}


local MP = minetest.get_modpath("vacuum")

dofile(MP.."/common.lua")
dofile(MP.."/vacuum.lua")
dofile(MP.."/compat.lua")
dofile(MP.."/airbottle.lua")
dofile(MP.."/airpump.lua")
dofile(MP.."/mapgen.lua")
dofile(MP.."/physics.lua")
dofile(MP.."/dignode.lua")

print("[OK] Vacuum")
