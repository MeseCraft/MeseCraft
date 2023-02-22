

local has_bedrock_mod = minetest.get_modpath("mesecraft_bedrock")

-- http://dev.minetest.net/PerlinNoiseMap

-- basic planet material noise
local base_params = {
   offset = 0,
   scale = 1,
   spread = {x=1024, y=512, z=1024},
   seed = 3468584,
   octaves = 5,
   persist = 0.6
}


local c_base = minetest.get_content_id("default:stone")
local c_bedrock


if has_bedrock_mod then
	c_bedrock = minetest.get_content_id("mesecraft_bedrock:bedrock")
end


local base_perlin
local base_perlin_map = {}

minetest.register_on_generated(function(minp, maxp, seed)

	if minp.y < planet_moon.miny or minp.y > planet_moon.maxy then
		return
	end

	-- solid layer
	local is_solid = minp.y < planet_moon.maxsolidy

	local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
	local area = VoxelArea:new{MinEdge=emin, MaxEdge=emax}
	local data = vm:get_data()

	local side_length = maxp.x - minp.x + 1 -- 80
	local map_lengths_xyz = {x=side_length, y=side_length, z=side_length}

	base_perlin = base_perlin or minetest.get_perlin_map(base_params, map_lengths_xyz)
	base_perlin:get3dMap_flat(minp, base_perlin_map)

	local i = 1
	for z=minp.z,maxp.z do
	for y=minp.y,maxp.y do
	for x=minp.x,maxp.x do

		local index = area:index(x,y,z)

		if y >= planet_moon.miny and y < (planet_moon.miny + 10) and has_bedrock_mod then
			data[index] = c_bedrock

		else
			-- unpopulated node

			-- higher elevation = lower chance
			local chance = (y-minp.y) / side_length

			local base_n = base_perlin_map[i]

			if is_solid or base_n > chance then
				data[index] = c_base
			end
		end

		i = i + 1

	end --x
	end --y
	end --z

	vm:set_data(data)
-- 	Uncommenting below line to remove ores from moon. They need to be rebalanced manually.
--	minetest.generate_ores(vm, minp, maxp)
	vm:write_to_map()
end)
