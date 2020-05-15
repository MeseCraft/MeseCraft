-- These functions are a minor modification of the voxel area iterator defined in the built in voxelarea.lua lua code.
-- As such, this file is separately licened under the LGPL as follows:

-- License of Minetest source code
-------------------------------

--Minetest
--Copyright (C) 2010-2018 celeron55, Perttu Ahola <celeron55@gmail.com>

--This program is free software; you can redistribute it and/or modify
--it under the terms of the GNU Lesser General Public License as published by
--the Free Software Foundation; either version 2.1 of the License, or
--(at your option) any later version.

--This program is distributed in the hope that it will be useful,
--but WITHOUT ANY WARRANTY; without even the implied warranty of
--MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--GNU Lesser General Public License for more details.

--You should have received a copy of the GNU Lesser General Public License along
--with this program; if not, write to the Free Software Foundation, Inc.,
--51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

function VoxelArea:iter_xyz(minx, miny, minz, maxx, maxy, maxz)
	local i = self:index(minx, miny, minz) - 1
	
	local x = minx - 1 -- subtracting one because x gets incremented before it gets returned the first time.
	local xrange = maxx - minx + 1
	local nextaction = i + 1 + xrange

	local y = 0
	local yrange = maxy - miny + 1
	local yreqstride = self.ystride - xrange

	local z = 0
	local zrange = maxz - minz + 1
	local multistride = self.zstride - ((yrange - 1) * self.ystride + xrange)

	return function()
		-- continue i until it needs to jump
		i = i + 1
		x = x + 1
		if i ~= nextaction then
			return i, x, y+miny, z+minz
		end

		-- continue y until maxy is exceeded
		y = y + 1
		x = minx -- new line
		if y ~= yrange then
			-- set i to index(minx, miny + y, minz + z) - 1
			i = i + yreqstride
			nextaction = i + xrange
			return i, x, y+miny, z+minz
		end

		-- continue z until maxz is exceeded
		z = z + 1
		if z == zrange then
			-- cuboid finished, return nil
			return
		end

		-- set i to index(minx, miny, minz + z) - 1
		i = i + multistride

		y = 0
		nextaction = i + xrange
		return i, x, y+miny, z+minz
	end
end

function VoxelArea:iterp_xyz(minp, maxp)
	return self:iter_xyz(minp.x, minp.y, minp.z, maxp.x, maxp.y, maxp.z)
end
