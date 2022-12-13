-------------------------------------------------------------------------------------------------------
-- For upgrading old worlds to the new format. Do this before registering named_waypoints

local worldpath = minetest.get_worldpath()

local v1filename = worldpath.."/settlements.txt"
local v2filename = worldpath.."/settlements_areastore.txt"
local v3filename = worldpath.."/named_waypoints_settlements.txt"

-- delayed to account for circular dependency on medieval settlement (for namegen)
-- and to allow settlements to be registered
local function upgrade(settlement_list)
	local medieval_def = settlements.registered_settlements["medieval"]
	for id, data in pairs(settlement_list) do
		local pos = data.min
		local dat = minetest.deserialize(data.data)
		if not dat.name then
			dat.settlement_type = dat.settlement_type or "medieval"
			if medieval_def then
				dat.name = medieval_def.generate_name(pos)
			end
		end
		named_waypoints.add_waypoint("settlements", pos, dat)
	end
end

local v3file = io.open(v3filename, "r")
if not v3file then -- if the v3 file exists, no upgrade should be done
	local v2file = io.open(v2filename, "r")
	if v2file then
		minetest.log("action", "[settlements] found v2 settlements file but no v3 settlements file, upgrading")
		-- v2 file exists but not v3, upgrade v2 to v3
		local v2area = AreaStore()
		v2area:from_file(v2filename)
		local v2settlements = v2area:get_areas_in_area({x=-32000, y=-32000, z=-32000}, {x=32000, y=32000, z=32000}, true, true, true)
		minetest.after(5, upgrade, v2settlements)
	else
		local v1file = io.open(v1filename, "r")
		if v1file then
			minetest.log("action", "[settlements] found v1 settlements file but no v2 or v3 settlements file, upgrading")
			local settlements = minetest.deserialize(v1file:read("*all"))
			local v1settlements = {}
			for _, pos in ipairs(settlements) do
				table.insert(v1settlements, {min = pos, data = minetest.serialize({})})
			end
			minetest.after(5, upgrade, v1settlements)			
		end
	end
end

