--[[

	Ignore

	A Minetest mod to manage ignore lists
	Code by: Mg

	Version: 00.01.18
	License: WTFPL
	Last Modification: 01/18/16 @ 9:31PM UTC+1

]]--


-- Da namespace
ignore = {}

ignore.config = {}
ignore.config.save_dir = minetest.get_worldpath() .. "/ignore"
ignore.config.enabled = not(minetest.settings:get_bool("disable_ignore") or false)
ignore.config.queue_interval = tonumber(minetest.settings:get("ignore_queue_interval")) or 30

dofile(minetest.get_modpath("ignore") .. "/lists.lua")
dofile(minetest.get_modpath("ignore") .. "/queues.lua")
dofile(minetest.get_modpath("ignore") .. "/chatcommand.lua")

minetest.mkdir(ignore.config.save_dir)

if ignore.config.enabled then
	minetest.log("action", "[Ignore] This session is loaded with the ignore callback")
	dofile(minetest.get_modpath("ignore") .. "/callback.lua")
else
	minetest.log("action", "[Ignore] This session is loaded without the ignore callback")
end

minetest.register_on_leaveplayer(function(player)
	ignore.del_list(player:get_player_name())
end)
