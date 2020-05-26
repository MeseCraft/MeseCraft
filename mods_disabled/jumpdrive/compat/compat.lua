local MP = minetest.get_modpath("jumpdrive")

local has_travelnet_mod = minetest.get_modpath("travelnet")
local has_technic_mod = minetest.get_modpath("technic")
local has_locator_mod = minetest.get_modpath("locator")
local has_elevator_mod = minetest.get_modpath("elevator")
local has_display_mod = minetest.get_modpath("display_api")
local has_pipeworks_mod = minetest.get_modpath("pipeworks")
local has_beds_mod = minetest.get_modpath("beds")

-- rope removal crashes with minetest >= 5.2 (get_content_id)
-- isse: https://github.com/minetest-mods/ropes/issues/19
-- local has_ropes_mod = minetest.get_modpath("ropes")
local has_sethome_mod = minetest.get_modpath("sethome")
local has_areas_mod = minetest.get_modpath("areas")
local has_drawers_mod = minetest.get_modpath("drawers")
local has_textline_mod = minetest.get_modpath("textline")

dofile(MP.."/compat/travelnet.lua")
dofile(MP.."/compat/locator.lua")
dofile(MP.."/compat/elevator.lua")
dofile(MP.."/compat/signs.lua")
dofile(MP.."/compat/itemframes.lua")
dofile(MP.."/compat/anchor.lua")
dofile(MP.."/compat/telemosaic.lua")
dofile(MP.."/compat/beds.lua")
dofile(MP.."/compat/ropes.lua")
dofile(MP.."/compat/sethome.lua")
dofile(MP.."/compat/areas.lua")
dofile(MP.."/compat/drawers.lua")
dofile(MP.."/compat/textline.lua")

if has_pipeworks_mod then
	dofile(MP.."/compat/teleporttube.lua")
end


jumpdrive.node_compat = function(name, source_pos, target_pos)
	if (name == "locator:beacon_1" or name == "locator:beacon_2" or name == "locator:beacon_3") and has_locator_mod then
		jumpdrive.locator_compat(source_pos, target_pos)

	elseif has_technic_mod and name == "technic:admin_anchor" then
		jumpdrive.anchor_compat(source_pos, target_pos)

	elseif has_pipeworks_mod and string.find(name, "^pipeworks:teleport_tube") then
		jumpdrive.teleporttube_compat(source_pos, target_pos)

	elseif name == "telemosaic:beacon" or name == "telemosaic:beacon_protected" then
		jumpdrive.telemosaic_compat(source_pos, target_pos)

	end
end

jumpdrive.commit_node_compat = function()
	if has_pipeworks_mod then
		jumpdrive.teleporttube_compat_commit()
	end
end


jumpdrive.target_region_compat = function(source_pos1, source_pos2, target_pos1, target_pos2, delta_vector)
	-- sync compat functions

	if has_travelnet_mod then
		jumpdrive.travelnet_compat(target_pos1, target_pos2)
	end

	if has_elevator_mod then
		jumpdrive.elevator_compat(target_pos1, target_pos2)
	end

	if has_sethome_mod then
		jumpdrive.sethome_compat(source_pos1, source_pos2, delta_vector)
	end

	if has_beds_mod then
		jumpdrive.beds_compat(target_pos1, target_pos2, delta_vector)
	end

	--[[
	if has_ropes_mod then
		jumpdrive.ropes_compat(target_pos1, target_pos2, delta_vector)
	end
	--]]

	if has_areas_mod then
		jumpdrive.areas_compat(source_pos1, source_pos2, delta_vector)
	end

	-- async compat functions below here
	minetest.after(1.0, function()

		if has_drawers_mod then
			jumpdrive.drawers_compat(target_pos1, target_pos2)
		end

		if has_display_mod then
			jumpdrive.signs_compat(target_pos1, target_pos2)
		end

		if has_textline_mod then
			jumpdrive.textline_compat(target_pos1, target_pos2)
		end

	end)

end
