-- algorithms taken from https://gist.github.com/reciprocum/4e3599a9563ec83ba2a63f5a6cdd39eb

local dot = function(a, b)
	return a.x * b.x + a.y * b.y + a.z * b.z
end

local modulus = function(v)
	return math.sqrt(dot(v,v))
end

local cross = function(a, b)
	return {x= a.y * b.z - a.z * b.y,
		y= a.z * b.x - a.x * b.z,
		z= a.x * b.y - a.y * b.x}
end

-- TODO: add bounding box tests to early-out on distant segments

-- Calculates the distance from a point to a line segment.
-- v - the point
-- a - start of line segment
-- b - end of line segment

mapgen_helper.distance_to_segment = function(v, a, b)
	local ab = vector.subtract(b, a)
    local av = vector.subtract(v, a)

	if dot(av, ab) <= 0.0 then -- Point is lagging behind start of the segment, so perpendicular distance is not viable.
		return modulus(av) -- Use distance to start of segment instead.
	end

    local bv = vector.subtract(v, b)

    if dot(bv, ab) >= 0.0 then -- Point is advanced past the end of the segment, so perpendicular distance is not viable.
        return modulus(bv) -- Use distance to end of the segment instead.
	end
	
	return modulus( cross(ab, av )) / modulus(ab) -- Perpendicular distance of point to segment.
end

-- Calculates the euclidean distance from a point to a line segmented path.
-- v - the point from with the distance is measured
-- path - the array of points which, when sequentialy joined by line segments, form a path
-- returns the distance from v to the closest of the path forming line segments

mapgen_helper.distance_to_path = function(v, path)
	local minimum_distance = 2^32 -- Should be big enough for any practical minetest needs
	for i = 2, table.getn(path) do
		local distance = mapgen_helper.distance_to_segment(path[i-1], path[i])
        if (distance < minimum_distance) then
			minimum_distance = distance
		end
	end
	return minimum_distance
end


-- For digging out straight lines

local dist_sq = function(x1, y1, z1, x2, y2, z2)
	return (x2-x1)^2 + (y2-y1)^2 + (z2-z1)^2
end
local constrain = function(n, min_n, max_n)
	if n < min_n then return min_n
	elseif n > max_n then return max_n
	else return n end
end
local dist_to_segment_squared = function(px, py, pz, lx1, ly1, lz1, lx2, ly2, lz2)
	local line_dist = dist_sq(lx1, ly1, lz1, lx2, ly2, lz2)
	if (line_dist == 0) then 
		return dist_sq(px, py, pz, lx1, ly1, lz1)
	end
	local t = ((px - lx1) * (lx2 - lx1) + (py - ly1) * (ly2 - ly1) + (pz - lz1) * (lz2 - lz1)) / line_dist
	t = constrain(t, 0, 1)
	return dist_sq(px, py, pz, lx1 + t * (lx2 - lx1), ly1 + t * (ly2 - ly1), lz1 + t * (lz2 - lz1))
end