local perlin_buffers = {}

mapgen_helper.register_perlin = function(name, perlin_params)
	perlin_buffers[name] = perlin_buffers[name] or {}
	if perlin_buffers[name].perlin_params then
		minetest.log("error", "mapgen_helper.register_perlin3d called for " .. name .. " when perlin parameters were already registered.")
		return
	end
	perlin_buffers[name].perlin_params = perlin_params
end

local get_buffer = function(name, sidelen, perlin_params)
	perlin_buffers[name] = perlin_buffers[name] or {}
	local buffer = perlin_buffers[name]
	
	if buffer.sidelen ~= nil and buffer.sidelen ~= sidelen then
		buffer.nobj_perlin = nil -- parameter changed, force regenerate of object
	end
	buffer.sidelen = sidelen
	
	if perlin_params then
		if buffer.perlin_params then
			for k, v in pairs(buffer.perlin_params) do
				if perlin_params[k] ~= v then
					buffer.nobj_perlin = nil -- parameter changed, force regenerate of object
				end
			end
		end
		buffer.perlin_params = perlin_params -- record provided parameters
	elseif buffer.perlin_params == nil then
		minetest.log("error", "mapgen_helper.register_perlin3d called for " .. name .. " with no registered or provided perlin parameters.")
		return
	else
		perlin_params = buffer.perlin_params -- retrieve recorded parameters
	end
	
	buffer.last_used = minetest.get_gametime()
	return buffer, perlin_params
end

mapgen_helper.perlin3d = function(name, minp, maxp, perlin_params)
	local minx = minp.x
	local minz = minp.z
	local sidelen = maxp.x - minp.x + 1 --length of a mapblock
	local chunk_lengths = {x = sidelen, y = sidelen, z = sidelen} --table of chunk edges

	local buffer, perlin_params = get_buffer(name, sidelen, perlin_params)
	
	buffer.nvals_perlin_buffer = buffer.nvals_perlin_buffer or {}
	buffer.nobj_perlin = buffer.nobj_perlin or minetest.get_perlin_map(perlin_params, chunk_lengths)
	if buffer.nobj_perlin.get_3d_map_flat then
		return buffer.nobj_perlin:get_3d_map_flat(minp, buffer.nvals_perlin_buffer), VoxelArea:new{MinEdge=minp, MaxEdge=maxp}
	else
		return buffer.nobj_perlin:get3dMap_flat(minp, buffer.nvals_perlin_buffer), VoxelArea:new{MinEdge=minp, MaxEdge=maxp}
	end	
end

mapgen_helper.perlin2d = function(name, minp, maxp, perlin_params)
	local minx = minp.x
	local minz = minp.z
	local sidelen = maxp.x - minp.x + 1 --length of a mapblock
	local chunk_lengths = {x = sidelen, y = sidelen, z = sidelen} --table of chunk edges

	local buffer, perlin_params = get_buffer(name, sidelen, perlin_params)
	
	buffer.nvals_perlin_buffer = perlin_buffers[name].nvals_perlin_buffer or {}
	buffer.nobj_perlin = perlin_buffers[name].nobj_perlin or minetest.get_perlin_map(perlin_params, chunk_lengths)
	if buffer.nobj_perlin.get_2d_map_flat then
		return buffer.nobj_perlin:get_2d_map_flat({x=minp.x, y=minp.z}, perlin_buffers[name].nvals_perlin_buffer)
	else
		return buffer.nobj_perlin:get2dMap_flat({x=minp.x, y=minp.z}, perlin_buffers[name].nvals_perlin_buffer)
	end	
end

mapgen_helper.index2d = function(minp, maxp, x, z) 
	return x - minp.x +
		(maxp.x - minp.x + 1) -- sidelen
		*(z - minp.z)
		+ 1
end

mapgen_helper.index2dp = function(minp, maxp, pos)
	return mapgen_helper.index2d(minp, maxp, pos.x, pos.z)
end

-- Takes an index into a 3D area and returns the corresponding 2D index
-- assumes equal edge lengths
mapgen_helper.index2di = function(minp, maxp, area, vi)
	local MinEdge = area.MinEdge
	local zstride = area.zstride
	local minpx = minp.x
	local i = vi - 1
	local z = math.floor(i / zstride) + MinEdge.z
	local x = math.floor((i % zstride) % area.ystride) + MinEdge.x
	return x - minpx +
		(maxp.x - minpx + 1) -- sidelen
		*(z - minp.z)
		+ 1
end

-- If a noise buffer hasn't been used in 60 seconds, let garbage collection take it.
local time_elapsed = 0
minetest.register_globalstep(function(dtime)
	time_elapsed = time_elapsed + dtime
	if time_elapsed > 60 then
		local current_time = minetest.get_gametime()
		time_elapsed = 0
		for _, buffer in pairs(perlin_buffers) do
			if current_time - buffer.last_used > 60 then
				buffer.nvals_perlin_buffer = nil
			end
		end
	end
end)