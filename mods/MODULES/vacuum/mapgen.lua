
local c_vacuum = minetest.get_content_id("vacuum:vacuum")
local c_ignore = minetest.get_content_id("ignore")
local c_air = minetest.get_content_id("air")


local get_corners = function(minp, maxp)
	return {
		minp,
		maxp,
		{ x=maxp.x, y=minp.y, z=minp.z },
		{ x=minp.x, y=maxp.y, z=minp.z },
		{ x=minp.x, y=minp.y, z=maxp.z },
		{ x=maxp.x, y=maxp.y, z=minp.z },
		{ x=minp.x, y=maxp.y, z=maxp.z },
		{ x=maxp.x, y=minp.y, z=maxp.z },
	}
end

local check_corners_in_space = function(minp, maxp)
	for _, pos in ipairs(get_corners(minp, maxp)) do
		if vacuum.is_pos_in_space(pos) then
			return true
		end
	end

	return false
end

minetest.register_on_generated(function(minp, maxp, seed)
	local t0 = minetest.get_us_time()

	if not check_corners_in_space(minp, maxp) then
		return
	end

	local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
	local data = vm:get_data()
	local area = VoxelArea:new({MinEdge=emin, MaxEdge=emax})

	for i in area:iter(
		minp.x, minp.y, minp.z,
		maxp.x, maxp.y, maxp.z
	) do
		if data[i] == c_air or data[i] == c_ignore then
			data[i] = c_vacuum
		end
	end

	vm:set_data(data)
	vm:set_lighting({day=15, night=0})
	vm:write_to_map()

	local t1 = minetest.get_us_time()
	local micros = t1 -t0

	if vacuum.profile_mapgen then
		print("[vacuum] mapgen for " .. minetest.pos_to_string(minp) .. " took " .. micros .. " us")
	end
end)
