-- load the modpath
local modpath = minetest.get_modpath("mesecraft_announcements")

-- Check the game settings to get a value for the announcement settings.

	-- Setting to toggle announcement on/off.
	local mesecraft_announcements = minetest.settings:get_bool("mesecraft_announcements", true)
	
	-- Setting to control time interval between each announcement.
--	local mesecraft_announcements_interval = minetest.settings:get("mesecraft_announcements_interval") or 600

-- Initlize the module if annoucements are enabled or unspecified.
if mesecraft_announcements = true then
	dofile(modpath .. "/announce.lua")
end

minetest.log("info", "MeseCraft Announcements loaded successfully!")