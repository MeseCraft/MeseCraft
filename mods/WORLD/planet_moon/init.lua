planet_moon = {
	miny = tonumber(minetest.settings:get("planet_moon.miny")) or 3000,
	maxy = tonumber(minetest.settings:get("planet_moon.maxy")) or 3300,
	maxsolidy = tonumber(minetest.settings:get("planet_moon.maxsolidy")) or 3200
}


local MP = minetest.get_modpath("planet_moon")

dofile(MP.."/stone.lua")
dofile(MP.."/ores.lua")
dofile(MP.."/mapgen.lua")

-- Nether mod check for portal API for moon portals.
local has_nether_mod = minetest.get_modpath("nether")
if has_nether_mod then
	dofile(MP.."/nether_portal.lua")
end
