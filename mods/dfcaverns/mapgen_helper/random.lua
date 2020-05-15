
-- Returns a consistent list of random points within a volume.
-- Each call to this method will give the same set of points if the same parameters are provided
mapgen_helper.get_random_points = function(minp, maxp, min_output_size, max_output_size)
	local next_seed = math.random(1, 2^21) -- should be 2^31, but I've had a report that this causes a crash in the Lua interpreter on some systems.
	math.randomseed(minetest.hash_node_position(minp) + mapgen_helper.mapgen_seed)
	
	local count = math.random(min_output_size, max_output_size)
	local result = {}
	while count > 0 do
		local point = {}
		point.x = math.random(minp.x, maxp.x)
		point.y = math.random(minp.y, maxp.y)
		point.z = math.random(minp.z, maxp.z)
		table.insert(result, point)
		count = count - 1
	end
	
	math.randomseed(next_seed)
	return result
end

-- Returns a random value based on the x and z coordinates of pos, always the same for the same x and z
mapgen_helper.xz_consistent_randomp = function(pos)
	local next_seed = math.random(1, 2^21) -- should be 2^31, but I've had a report that this causes a crash in the Lua interpreter on some systems.
	math.randomseed(pos.x + pos.z * 2 ^ 8)
	local output = math.random()
	math.randomseed(next_seed)
	return output
end

mapgen_helper.xz_consistent_randomi = function(area, vi)
	local pos = area:position(vi)
	return mapgen_helper.xz_consistent_randomp(pos)
end
