
jumpdrive = {
	config = {
		-- allowed radius
		max_radius = tonumber(minetest.settings:get("jumpdrive.max_radius")) or 15,
		max_area_radius = tonumber(minetest.settings:get("jumpdrive.max_area_radius")) or 25,

		-- max volume in nodes ( ((radius*2) + 1) ^ 3 )
		max_area_volume = tonumber(minetest.settings:get("jumpdrive.max_area_volume")) or 29791,

		-- base storage value
		powerstorage = tonumber(minetest.settings:get("jumpdrive.powerstorage")) or 1000000,

		-- base technic power requirement
		powerrequirement = tonumber(minetest.settings:get("jumpdrive.power_requirement")) or 2500,
	},

	-- blacklisted nodes
	blacklist = {}
}

local MP = minetest.get_modpath("jumpdrive")

if minetest.get_modpath("technic") then
	dofile(MP.."/technic_run.lua")
end

if minetest.get_modpath("pipeworks") then
	dofile(MP.."/override/teleport_tube.lua")
end

-- common functions
dofile(MP.."/fuel.lua")
dofile(MP.."/upgrade.lua")
dofile(MP.."/bookmark.lua")
dofile(MP.."/infotext.lua")
dofile(MP.."/migrate.lua")
dofile(MP.."/marker.lua")
dofile(MP.."/compat/compat.lua")
dofile(MP.."/is_area_empty.lua")
dofile(MP.."/is_area_protected.lua")

-- move logic
dofile(MP.."/move/move_objects.lua")
dofile(MP.."/move/move_metadata.lua")
dofile(MP.."/move/move_nodetimers.lua")
dofile(MP.."/move/move.lua")

dofile(MP.."/mapgen.lua")
dofile(MP.."/common.lua")
dofile(MP.."/digiline.lua")
dofile(MP.."/backbone.lua")
dofile(MP.."/crafts.lua")

-- engines
dofile(MP.."/engines/default.lua")
dofile(MP.."/engines/default_formspec.lua")
dofile(MP.."/engines/default_jump.lua")

--[[
-- WIP
if minetest.get_modpath("areas") then
	dofile(MP.."/engines/area.lua")
	dofile(MP.."/engines/area_formspec.lua")
end
--]]

-- fleet
dofile(MP.."/fleet/fleet_functions.lua")
dofile(MP.."/fleet/fleet_digiline.lua")
dofile(MP.."/fleet/fleet_controller.lua")
dofile(MP.."/fleet/fleet_formspec.lua")

-- blacklist nodes
dofile(MP.."/blacklist.lua")


if minetest.get_modpath("monitoring") then
	-- enable metrics
	dofile(MP.."/metrics.lua")
end

if minetest.settings:get_bool("enable_jumpdrive_integration_test") then
        dofile(MP.."/integration_test.lua")
end

print("[OK] Jumpdrive")
