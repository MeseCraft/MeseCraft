-- A cheap nearness test, using Manhattan distance.
mapgen_helper.is_within_distance_box = function(pos1, pos2, distance)
	return math.abs(pos1.x-pos2.x) <= distance and
		math.abs(pos1.y-pos2.y) <= distance and
		math.abs(pos1.z-pos2.z) <= distance
end

-- Finds an intersection between two axis-aligned bounding boxes (AABB)s, or nil if there's no overlap
mapgen_helper.intersect = function(minpos1, maxpos1, minpos2, maxpos2)
	--checking x and z first since they're more likely to fail to overlap
	if minpos1.x <= maxpos2.x and maxpos1.x >= minpos2.x and
		minpos1.z <= maxpos2.z and maxpos1.z >= minpos2.z and
		minpos1.y <= maxpos2.y and maxpos1.y >= minpos2.y then
		
		return {
				x = math.max(minpos1.x, minpos2.x),
				y = math.max(minpos1.y, minpos2.y),
				z = math.max(minpos1.z, minpos2.z)
			},
			{
				x = math.min(maxpos1.x, maxpos2.x),
				y = math.min(maxpos1.y, maxpos2.y),
				z = math.min(maxpos1.z, maxpos2.z)
			}
	end
	return nil, nil
end

-- a simpler version of the above if all you care about is whether an intersection exists
mapgen_helper.intersect_exists = function(minpos1, maxpos1, minpos2, maxpos2)
	--checking x and z first since they're more likely to fail to overlap
	return (minpos1.x <= maxpos2.x and maxpos1.x >= minpos2.x and
		minpos1.z <= maxpos2.z and maxpos1.z >= minpos2.z and
		minpos1.y <= maxpos2.y and maxpos1.y >= minpos2.y)
end

-- A version of the above that only cares about the x and z parameters, useful for example to lay out non-overlapping trees or buildings
mapgen_helper.intersect_exists_xz = function(minpos1, maxpos1, minpos2, maxpos2)
	return (minpos1.x <= maxpos2.x and maxpos1.x >= minpos2.x and
		minpos1.z <= maxpos2.z and maxpos1.z >= minpos2.z)
end

-- Simply tests whether pos is within the bounding box defined by minpos and maxpos
local intersect_exists = mapgen_helper.intersect_exists
mapgen_helper.is_pos_within_box = function(pos, minpos, maxpos)
	return intersect_exists(pos, pos, minpos, maxpos)
end

-- Tests whether box 1 is entirely contained within box 2
mapgen_helper.is_box_within_box = function(minpos1, maxpos1, minpos2, maxpos2)
	return (minpos1.x >= minpos2.x and maxpos1.x <= maxpos2.x and
		minpos1.z >= minpos2.z and maxpos1.z <= maxpos2.z and
		minpos1.y >= minpos2.y and maxpos1.y <= maxpos2.y)
end