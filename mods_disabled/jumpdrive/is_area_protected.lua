local has_areas_mod = minetest.get_modpath("areas")
local has_protector_mod = minetest.get_modpath("protector")

local protector_radius = (tonumber(minetest.settings:get("protector_radius")) or 5)

jumpdrive.is_area_protected = function(pos1, pos2, playername)

	local radius_vector = {x=protector_radius, y=protector_radius, z=protector_radius}
	local check_pos1 = vector.subtract(pos1, radius_vector)
	local check_pos2 = vector.add(pos2, radius_vector)

	-- preload area with voxel manip
	minetest.get_voxel_manip(check_pos1, check_pos2)

	if minetest.is_area_protected then
		-- use area protection check
		if minetest.is_area_protected(pos1, pos2, playername, 8) then
			return true
		end

	elseif has_protector_mod then
		-- use improvised find_nodes check
		local protectors = minetest.find_nodes_in_area(
			check_pos1, check_pos2, {
				"protector:protect",
				"protector:protect2",
				"priv_protector:protector",
				"xp_redo:protector"
			}
		)

		if protectors then
			for _,pos in pairs(protectors) do
				if minetest.is_protected(pos, playername) then
					return true
				end
			end
		end
	end

	if has_areas_mod then
		if not areas:canInteractInArea(pos1, pos2, playername, true) then
			-- player can't interact
			return true
		end
	end

	-- no protection
	return false
end
