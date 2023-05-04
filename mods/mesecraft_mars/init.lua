mesecraft_mars = {
	-- starting height of mars terrain
	y_start = tonumber(minetest.settings:get("mesecraft_mars.y_start")) or 11000,

	-- end height of terrain (relative to start)
	y_height = tonumber(minetest.settings:get("mesecraft_mars.y_height")) or 5000,

	-- height of clouds (relative to start)
	y_cloud_height = tonumber(minetest.settings:get("mesecraft_mars.y_skybox_height")) or 5300,

	-- end height of skybox (relative to start)
	y_skybox_height = tonumber(minetest.settings:get("mesecraft_mars.y_skybox_height")) or 6000,

}

local MP = minetest.get_modpath("mesecraft_mars")
dofile(MP.."/decorations.lua")
dofile(MP.."/airlight.lua")
dofile(MP.."/nodes.lua")
dofile(MP.."/ores.lua")
dofile(MP.."/mapgen.lua")
dofile(MP.."/skybox.lua")
dofile(MP.."/vacuum.lua")

local has_nether_mod = minetest.get_modpath("nether")
if has_nether_mod then
	dofile(MP.."/nether_portal.lua")
end

print("[OK] Planet: mars (start: " .. mesecraft_mars.y_start .. ", height:" .. mesecraft_mars.y_height .. ")")
