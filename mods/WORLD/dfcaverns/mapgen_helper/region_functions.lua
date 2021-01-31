local mapgen_chunksize = tonumber(minetest.get_mapgen_setting("chunksize"))

-- For getting large regions that don't cross mapgen block boundaries
-- For some reason, map chunks generate with -32, -32, -32 as the "origin" minp. To make the large-scale grid align with map chunks it needs to be offset like this.
mapgen_helper.get_region_minp_xz = function(pos_xz, mapblocks)
	local region_size = mapblocks * mapgen_chunksize * 16
	return {x = math.floor((pos.x+32) / region_size) * region_size - 32, y = 0, z = math.floor((pos.z+32) / region_size) * region_size - 32}
end

-- Given a position and a region scale, returns the minp corners of the four regions that the player is closest to.
-- For example, if we have a region scale of 6 and the parameter position is at "*", the four points marked "R" would be returned.

-- |-----|-----|-----|      |-----|-----|-----|      |-----|-----|-----|
-- |     |     |     |      |     |     |     |      |     |     |     |
-- |     |     |     |      |     |     |     |      |     |     |     |
-- |     |     |     |      |     |     |     |      |     |     |     |
-- |     |     |     |      |     |     |     |      |     |     |     |
-- |     |     |     |      |     |     |     |      |     |     |     |
-- |-----|-----|-----|      |-----|-----|-----|      |-----R-----R-----|
-- |     |     |     |      |     |     |     |      |     |     |     |
-- |     |     |     |      |     |     |     |      |     |    *|     |
-- |     |     |     |      |     |     |     |      |     |     |     |
-- |     | *   |     |      |     |    *|     |      |     |     |     |
-- |     |     |     |      |     |     |     |      |     |     |     |
-- R-----R-----|-----|      |-----R-----R-----|      |-----R-----R-----|
-- |     |     |     |      |     |     |     |      |     |     |     |
-- |     |     |     |      |     |     |     |      |     |     |     |
-- |     |     |     |      |     |     |     |      |     |     |     |
-- |     |     |     |      |     |     |     |      |     |     |     |
-- |     |     |     |      |     |     |     |      |     |     |     |
-- R-----R-----|-----|      |-----R-----R-----|      |-----|-----|-----|

-- In this way you can be sure you aren't near an area you haven't tested.

mapgen_helper.get_nearest_regions = function(pos_xz, gridscale)
	local half_scale = gridscale / 2
	local grid_cell = {x = math.floor(pos_xz.x / gridscale) * gridscale, z = math.floor(pos_xz.z / gridscale) * gridscale}
	local pos_internal = {x = pos_xz.x % gridscale, z = pos_xz.z % gridscale}
	local result = {grid_cell}
	local shift_x = gridscale
	local shift_z = gridscale
	if (pos_internal.x < half_scale) then
		shift_x = -gridscale
	end
	if (pos_internal.z < half_scale) then
		shift_z = -gridscale
	end

	table.insert(result, {x = grid_cell.x + shift_x, z = grid_cell.z + shift_z})
	table.insert(result, {x = grid_cell.x + shift_x, z = grid_cell.z})
	table.insert(result, {x = grid_cell.x, z = grid_cell.z + shift_z})

	return result
end


-- |---|---|---|
-- |   |   |   |
-- |   |   |   |
-- R---R---R---|
-- |   |   |   |
-- |   |  *|   |
-- R---R---R---|
-- |   |   |   |
-- |   |   |   |
-- R---R---R---|

mapgen_helper.get_adjacent_regions = function(pos_xz, gridscale)
	local grid_cell = {x = math.floor(pos_xz.x / gridscale) * gridscale, z = math.floor(pos_xz.z / gridscale) * gridscale}
	local result = {grid_cell}
	table.insert(result, {x = grid_cell.x + gridscale, z = grid_cell.y + gridscale})
	table.insert(result, {x = grid_cell.x + gridscale, z = grid_cell.y})
	table.insert(result, {x = grid_cell.x, z = grid_cell.y + gridscale})
	table.insert(result, {x = grid_cell.x - gridscale, z = grid_cell.y - gridscale})
	table.insert(result, {x = grid_cell.x - gridscale, z = grid_cell.y})
	table.insert(result, {x = grid_cell.x, z = grid_cell.y - gridscale})
	return result
end
