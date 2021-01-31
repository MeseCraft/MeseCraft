-- similar to iter_xyz, but iterates first along the y axis. Useful in mapgens that want to detect a vertical transition (eg, finding ground level)
function VoxelArea:iter_yxz(minx, miny, minz, maxx, maxy, maxz)
	local i = self:index(minx, miny, minz) - self.ystride
	
	local x = minx
	local y = miny - 1
	local z = minz

	return function()
		y = y + 1

		if y <= maxy then
			i = i + self.ystride
			return i, x, y, z
		end
		
		y = miny
		x = x + 1
		
		if x <= maxx then
			i = self:index(x, y, z)
			return i, x, y, z
		end
		
		x = minx
		z = z + 1
		
		if z <= maxz then
			i = self:index(x, y, z)
			return i, x, y, z
		end
	end
end

function VoxelArea:iterp_yxz(minp, maxp)
	return self:iter_yxz(minp.x, minp.y, minp.z, maxp.x, maxp.y, maxp.z)
end

function VoxelArea:get_y(i)
	return math.floor(((i - 1) % self.zstride) / self.ystride) + self.MinEdge.y
end

-- Used to make transform more efficient by skipping a table creation
function VoxelArea:position_xyz(vi)
	local MinEdge = self.MinEdge
	local Zstride = self.zstride
	local Ystride = self.ystride
	vi = vi - 1
	local z = math.floor(vi / Zstride) + MinEdge.z
	vi = vi % Zstride
	local y = math.floor(vi / Ystride) + MinEdge.y
	vi = vi % Ystride
	local x = vi + MinEdge.x
	return x, y, z
end

-- Takes another voxelarea and an index in it and transforms it into an index into its own
-- voxelarea, or nil if it's not in the voxelarea. This is useful when you've got, for example,
-- a mapgen's voxelmanipulator and a perlin noise array covering the map block but not the entire
-- emerged volume.
function VoxelArea:transform(area, vi)
	local x,y,z = area:position_xyz(vi)
	if self:contains(x,y,z) then
		return self:index(x,y,z)
	end
	return nil
end