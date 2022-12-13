--[[

  Nether mod for minetest

  This file contains helper functions for generating the Mantle
  (AKA center region), which are moved into a separate file to keep the
  size of mapgen.lua manageable.


  Copyright (C) 2021 Treer

  Permission to use, copy, modify, and/or distribute this software for
  any purpose with or without fee is hereby granted, provided that the
  above copyright notice and this permission notice appear in all copies.

  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL
  WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR
  BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES
  OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
  WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION,
  ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS
  SOFTWARE.

]]--


local debugf = nether.debug
local mapgen = nether.mapgen
local S      = nether.get_translator

local BASALT_COLUMN_UPPER_LIMIT = mapgen.BASALT_COLUMN_UPPER_LIMIT
local BASALT_COLUMN_LOWER_LIMIT = mapgen.BASALT_COLUMN_LOWER_LIMIT


-- 2D noise for basalt formations
local np_basalt = {
	offset      =-0.85,
	scale       = 1,
	spread      = {x = 46, y = 46, z = 46},
	seed        = 1000,
	octaves     = 5,
	persistence = 0.5,
	lacunarity  = 2.6,
	flags = "eased"
}


-- Buffers and objects we shouldn't recreate every on_generate

local nobj_basalt = nil
local nbuf_basalt = {}

-- Content ids

local c_air              = minetest.get_content_id("air")
local c_netherrack_deep  = minetest.get_content_id("nether:rack_deep")
local c_glowstone        = minetest.get_content_id("nether:glowstone")
local c_lavasea_source   = minetest.get_content_id("nether:lava_source") -- same as lava but with staggered animation to look better as an ocean
local c_lava_crust       = minetest.get_content_id("nether:lava_crust")
local c_basalt           = minetest.get_content_id("nether:basalt")


-- Math funcs
local math_max, math_min, math_abs, math_floor = math.max, math.min, math.abs, math.floor -- avoid needing table lookups each time a common math function is invoked

function random_unit_vector()
	return vector.normalize({
		x = math.random() - 0.5,
		y = math.random() - 0.5,
		z = math.random() - 0.5
	})
end

-- returns the smallest component in the vector
function vector_min(v)
	return math_min(v.x, math_min(v.y, v.z))
end


-- Mantle mapgen functions (AKA Center region)

-- Returns (absolute height, fractional distance from ceiling or sea floor)
-- the fractional distance from ceiling or sea floor is a value between 0 and 1 (inclusive)
-- Note it may find the most relevent sea-level - not necesssarily the one you are closest
-- to, since the space above the sea reaches much higher than the depth below the sea.
mapgen.find_nearest_lava_sealevel = function(y)
	-- todo: put oceans near the bottom of chunks to improve ability to generate tunnels to the center
	-- todo: constrain y to be not near the bounds of the nether
	-- todo: add some random adj at each level, seeded only by the level height
	local sealevel = math.floor((y + 100) / 200) * 200
	--local sealevel = math.floor((y + 80) / 160) * 160
	--local sealevel = math.floor((y + 120) / 240) * 240

	local cavern_limits_fraction
	local height_above_sea = y - sealevel
	if height_above_sea >= 0 then
		cavern_limits_fraction = math_min(1, height_above_sea / 95)
	else
		-- approaches 1 much faster as the lava sea is shallower than the cavern above it
		cavern_limits_fraction = math_min(1, -height_above_sea / 40)
	end

	return sealevel, cavern_limits_fraction
end




mapgen.add_basalt_columns = function(data, area, minp, maxp)
	-- Basalt columns are structures found in lava oceans, and the only way to obtain
	-- nether basalt.
	-- Their x, z position is determined by a 2d noise map and a 2d slice of the cave
	-- noise (taken at lava-sealevel).

	local x0, y0, z0 = minp.x, math_max(minp.y, nether.DEPTH_FLOOR),   minp.z
	local x1, y1, z1 = maxp.x, math_min(maxp.y, nether.DEPTH_CEILING), maxp.z

	local yStride = area.ystride
	local yCaveStride = x1 - x0 + 1

	local cavePerlin = mapgen.getCavePointPerlin()
	nobj_basalt = nobj_basalt or minetest.get_perlin_map(np_basalt, {x = yCaveStride, y = yCaveStride})
	local nvals_basalt = nobj_basalt:get_2d_map_flat({x=minp.x, y=minp.z}, {x=yCaveStride, y=yCaveStride}, nbuf_basalt)

	local nearest_sea_level, _ = mapgen.find_nearest_lava_sealevel(math_floor((y0 + y1) / 2))

	local leeway = mapgen.CENTER_CAVERN_LIMIT * 0.18

	for z = z0, z1 do
		local noise2di = 1 + (z - z0) * yCaveStride

		for x = x0, x1 do

			local basaltNoise = nvals_basalt[noise2di]
			if basaltNoise > 0 then
				-- a basalt column is here

				local abs_sealevel_cave_noise = math_abs(cavePerlin:get_3d({x = x, y = nearest_sea_level, z = z}))

				-- Add Some quick deterministic noise to the column heights
				-- This is probably not good noise, but it doesn't have to be.
				local fastNoise = 17
				fastNoise = 37 * fastNoise + y0
				fastNoise = 37 * fastNoise + z
				fastNoise = 37 * fastNoise + x
				fastNoise = 37 * fastNoise + math_floor(basaltNoise * 32)

				local columnHeight = basaltNoise * 18 + ((fastNoise % 3) - 1)

				-- columns should drop below sealevel where lava rivers are flowing
				-- i.e. anywhere abs_sealevel_cave_noise < BASALT_COLUMN_LOWER_LIMIT
				-- And we'll also have it drop off near the edges of the lava ocean so that
				-- basalt columns can only be found by the player reaching a lava ocean.
				local lowerClip = (math_min(math_max(abs_sealevel_cave_noise, BASALT_COLUMN_LOWER_LIMIT - leeway), BASALT_COLUMN_LOWER_LIMIT + leeway) - BASALT_COLUMN_LOWER_LIMIT) / leeway
				local upperClip = (math_min(math_max(abs_sealevel_cave_noise, BASALT_COLUMN_UPPER_LIMIT - leeway), BASALT_COLUMN_UPPER_LIMIT + leeway) - BASALT_COLUMN_UPPER_LIMIT) / leeway
				local columnHeightAdj = lowerClip * -upperClip -- all are values between 1 and -1

				columnHeight = columnHeight + math_floor(columnHeightAdj * 12 - 12)

				local vi = area:index(x, y0, z) -- Initial voxelmanip index

				for y = y0, y1 do -- Y loop first to minimise tcave & lava-sea calculations

					if y < nearest_sea_level + columnHeight  then

						local id = data[vi] -- Existing node
						if id == c_lava_crust or id == c_lavasea_source or (id == c_air and y > nearest_sea_level) then
							-- Avoid letting columns extend beyond the central region.
							-- (checking node ids saves having to calculate abs_cave_noise_adjusted here
							-- to test it against CENTER_CAVERN_LIMIT)
							data[vi] = c_basalt
						end
					end

					vi = vi + yStride
				end
			end

			noise2di = noise2di + 1
		end
	end
end


-- returns an array of points from pos1 and pos2 which deviate from a straight line
-- but which don't venture too close to a chunk boundary
function generate_waypoints(pos1, pos2, minp, maxp)

	local segSize = 10
	local maxDeviation = 7
	local minDistanceFromChunkWall = 5

	local pathVec     = vector.subtract(pos2, pos1)
	local pathVecNorm = vector.normalize(pathVec)
	local pathLength  = vector.distance(pos1, pos2)
	local minBound    = vector.add(minp, minDistanceFromChunkWall)
	local maxBound    = vector.subtract(maxp, minDistanceFromChunkWall)

	local result = {}
	result[1] = pos1

	local segmentCount = math_floor(pathLength / segSize)
	for i = 1, segmentCount do
		local waypoint = vector.add(pos1, vector.multiply(pathVec, i / (segmentCount + 1)))

		-- shift waypoint a few blocks in a random direction orthogonally to the pathVec, to make the path crooked.
		local crossProduct
		repeat
			crossProduct = vector.normalize(vector.cross(pathVecNorm, random_unit_vector()))
		until vector.length(crossProduct) > 0
		local deviation = vector.multiply(crossProduct, math.random(1, maxDeviation))
		waypoint = vector.add(waypoint, deviation)
		waypoint = {
			x = math_min(maxBound.x, math_max(minBound.x, waypoint.x)),
			y = math_min(maxBound.y, math_max(minBound.y, waypoint.y)),
			z = math_min(maxBound.z, math_max(minBound.z, waypoint.z))
		}

		result[#result + 1] = waypoint
	end

	result[#result + 1] = pos2
	return result
end


function excavate_pathway(data, area, nether_pos, center_pos, minp, maxp)

	local ystride = area.ystride
	local zstride = area.zstride

	math.randomseed(nether_pos.x + 10 * nether_pos.y + 100 * nether_pos.z) -- so each tunnel generates deterministically (this doesn't have to be a quality seed)
	local dist = math_floor(vector.distance(nether_pos, center_pos))
	local waypoints = generate_waypoints(nether_pos, center_pos, minp, maxp)

	-- First pass: record path details
	local linedata = {}
	local last_pos = {}
	local line_index = 1
	local first_filled_index, boundary_index, last_filled_index
	for i = 0, dist do
		-- Bresenham's line would be good here, but too much lua code
		local waypointProgress = (#waypoints - 1) * i / dist
		local segmentIndex = math_min(math_floor(waypointProgress) + 1, #waypoints - 1) -- from the integer portion of waypointProgress
		local segmentInterp = waypointProgress - (segmentIndex - 1)                     -- the remaining fractional portion
		local segmentStart = waypoints[segmentIndex]
		local segmentVector = vector.subtract(waypoints[segmentIndex + 1], segmentStart)
		local pos = vector.round(vector.add(segmentStart, vector.multiply(segmentVector, segmentInterp)))

		if not vector.equals(pos, last_pos) then
			local vi = area:indexp(pos)
			local node_id = data[vi]
			linedata[line_index] = {
				pos = pos,
				vi = vi,
				node_id = node_id
			}
			if boundary_index == nil and node_id == c_netherrack_deep then
				boundary_index = line_index
			end
			if node_id == c_air then
				if boundary_index ~= nil and last_filled_index == nil then
					last_filled_index = line_index
				end
			else
				if first_filled_index == nil then
					first_filled_index = line_index
				end
			end
			line_index = line_index + 1
			last_pos = pos
		end
	end
	first_filled_index = first_filled_index or 1
	last_filled_index  = last_filled_index  or #linedata
	boundary_index     = boundary_index     or last_filled_index


	-- limit tunnel radius to roughly the closest that startPos or stopPos comes to minp-maxp, so we
	-- don't end up exceeding minp-maxp and having excavation filled in when the next chunk is generated.
	local startPos, stopPos = linedata[first_filled_index].pos, linedata[last_filled_index].pos
	local radiusLimit = vector_min(vector.subtract(startPos, minp))
	radiusLimit = math_min(radiusLimit, vector_min(vector.subtract(stopPos, minp)))
	radiusLimit = math_min(radiusLimit, vector_min(vector.subtract(maxp, startPos)))
	radiusLimit = math_min(radiusLimit, vector_min(vector.subtract(maxp, stopPos)))

	if radiusLimit < 4 then -- This is a logic check, ignore it. It could be commented out
		-- 4 is (79 - 75), and values less than 4 shouldn't be possible if sampling-skip was 10
		-- i.e. if sampling-skip was 10 then {5, 15, 25, 35, 45, 55, 65, 75} should be sampled from possible positions 0 to 79
		debugf("Error: radiusLimit %s is smaller then half the sampling distance. min %s, max %s, start %s, stop %s", radiusLimit, minp, maxp, startPos, stopPos)
	end
	radiusLimit = radiusLimit + 1 -- chunk walls wont be visibly flat if the radius only exceeds it a little ;)

	-- Second pass: excavate
	local start_index, stop_index = math_max(1, first_filled_index - 2), math_min(#linedata, last_filled_index + 3)
	for i = start_index, stop_index, 3 do

		-- Adjust radius so that tunnels start wide but thin out in the middle
		local distFromEnds = 1 - math_abs(((start_index + stop_index) / 2) - i) / ((stop_index - start_index) / 2) -- from 0 to 1, with 0 at ends and 1 in the middle
		-- Have it more flaired at the ends, rather than linear.
		-- i.e. sizeAdj approaches 1 quickly as distFromEnds increases
		local distFromMiddle = 1 - distFromEnds
		local sizeAdj = 1 - (distFromMiddle * distFromMiddle * distFromMiddle)

		local radius = math_min(radiusLimit, math.random(50 - (25 * sizeAdj), 80 - (45 * sizeAdj)) / 10)
		local radiusSquared = radius * radius
		local radiusCeil = math_floor(radius + 0.5)

		linedata[i].radius = radius             -- Needed in third pass
		linedata[i].distFromEnds = distFromEnds -- Needed in third pass

		local vi = linedata[i].vi
		for z = -radiusCeil, radiusCeil do
			local vi_z = vi + z * zstride
			for y = -radiusCeil, radiusCeil do
				local vi_zy = vi_z + y * ystride
				local xSquaredLimit = radiusSquared - (z * z + y * y)
				for x = -radiusCeil, radiusCeil do
					if x * x < xSquaredLimit then
						data[vi_zy + x] = c_air
					end
				end
			end
		end

	end

	-- Third pass: decorate
	-- Add glowstones to make tunnels to the mantle easier to find
	-- https://i.imgur.com/sRA28x7.jpg
	for i = start_index, stop_index, 3 do
		if linedata[i].distFromEnds < 0.3 then
			local glowcount = 0
			local radius = linedata[i].radius
			for _ = 1, 20 do
				local testPos = vector.round(vector.add(linedata[i].pos, vector.multiply(random_unit_vector(), radius + 0.5)))
				local vi = area:indexp(testPos)
				if data[vi] ~= c_air then
					data[vi] = c_glowstone
					glowcount = glowcount + 1
				--else
				--	data[vi] = c_debug
				end
				if glowcount >= 2 then break end
			end
		end
	end

end


-- excavates a tunnel connecting the Primary or Secondary region with the mantle / central region
-- if a suitable path is found.
-- Returns true if successful
mapgen.excavate_tunnel_to_center_of_the_nether = function(data, area, nvals_cave, minp, maxp)

	local result = false
	local extent = vector.subtract(maxp, minp)
	local skip = 10 -- sampling rate of 1 in 10

	local highest = -1000
	local lowest  =  1000
	local lowest_vi
	local highest_vi

	local yCaveStride = maxp.x - minp.x + 1
	local zCaveStride = yCaveStride * yCaveStride

	local vi_offset = area:indexp(vector.add(minp, math_floor(skip / 2))) -- start half the sampling distance away from minp
	local vi, ni

	for y = 0, extent.y - 1, skip do
		local sealevel = mapgen.find_nearest_lava_sealevel(minp.y + y)

		if minp.y + y > sealevel then -- only create tunnels above sea level
			for z = 0, extent.z - 1, skip do

				vi = vi_offset + y * area.ystride + z * area.zstride
				ni = z * zCaveStride + y * yCaveStride + 1
				for x = 0, extent.x - 1, skip do

					local noise = math_abs(nvals_cave[ni])
					if noise < lowest then
						lowest = noise
						lowest_vi = vi
					end
					if noise > highest then
						highest = noise
						highest_vi = vi
					end
					ni = ni + skip
					vi = vi + skip
				end
			end
		end
	end

	if lowest < mapgen.CENTER_CAVERN_LIMIT and highest > mapgen.TCAVE + 0.03 then

		local mantle_y = area:position(lowest_vi).y
		local _, cavern_limit_distance = mapgen.find_nearest_lava_sealevel(mantle_y)
		local _, centerRegionLimit_adj = mapgen.get_mapgenblend_adjustments(mantle_y)

		 -- cavern_noise_adj gets added to noise value instead of added to the limit np_noise
		 -- is compared against, so subtract centerRegionLimit_adj instead of adding
		local cavern_noise_adj =
			mapgen.CENTER_REGION_LIMIT * (cavern_limit_distance * cavern_limit_distance * cavern_limit_distance) -
			centerRegionLimit_adj

		if lowest + cavern_noise_adj < mapgen.CENTER_CAVERN_LIMIT then
			excavate_pathway(data, area, area:position(highest_vi), area:position(lowest_vi), minp, maxp)
			result = true
		end
	end
	return result
end


-- an enumerated list of the different regions in the nether
mapgen.RegionEnum = {
	OVERWORLD     = {name = "overworld",      desc = S("The Overworld") },   -- Outside the Nether / none of the regions in the Nether
	POSITIVE      = {name = "positive",       desc = S("Positive nether") }, -- The classic nether caverns are here - where cavePerlin > 0.6
	POSITIVESHELL = {name = "positive shell", desc = S("Shell between positive nether and center region") }, -- the nether side of the wall/buffer area separating classic nether from the mantle
	CENTER        = {name = "center",         desc = S("Center/Mantle, inside cavern") },
	CENTERSHELL   = {name = "center shell",   desc = S("Center/Mantle, but outside the caverns") }, -- the mantle side of the wall/buffer area separating the positive and negative regions from the center region
	NEGATIVE      = {name = "negative",       desc = S("Negative nether") }, -- Secondary/spare region - where cavePerlin < -0.6
	NEGATIVESHELL = {name = "negative shell", desc = S("Shell between negative nether and center region") } -- the spare region side of the wall/buffer area separating the negative region from the mantle
}


-- Returns (region, noise) where region is a value from mapgen.RegionEnum
-- and noise is the unadjusted cave perlin value
mapgen.getRegion = function(pos)

	if pos.y > nether.DEPTH_CEILING or pos.y < nether.DEPTH_FLOOR then
		return mapgen.RegionEnum.OVERWORLD, nil
	end

	local caveNoise = mapgen.getCavePerlinAt(pos)
	local sealevel, cavern_limit_distance = mapgen.find_nearest_lava_sealevel(pos.y)
	local tcave_adj, centerRegionLimit_adj = mapgen.get_mapgenblend_adjustments(pos.y)
	local tcave   = mapgen.TCAVE + tcave_adj
	local tmantle = mapgen.CENTER_REGION_LIMIT + centerRegionLimit_adj

	-- cavern_noise_adj gets added to noise value instead of added to the limit np_noise
	-- is compared against, so subtract centerRegionLimit_adj instead of adding
	local cavern_noise_adj =
		mapgen.CENTER_REGION_LIMIT * (cavern_limit_distance * cavern_limit_distance * cavern_limit_distance) -
		centerRegionLimit_adj

	local region
	if caveNoise > tcave then
		region = mapgen.RegionEnum.POSITIVE
	elseif -caveNoise > tcave then
		region = mapgen.RegionEnum.NEGATIVE
	elseif math_abs(caveNoise) < tmantle then

		if math_abs(caveNoise) + cavern_noise_adj < mapgen.CENTER_CAVERN_LIMIT then
			region = mapgen.RegionEnum.CENTER
		else
			region = mapgen.RegionEnum.CENTERSHELL
		end

	elseif caveNoise > 0 then
		region = mapgen.RegionEnum.POSITIVESHELL
	else
		region = mapgen.RegionEnum.NEGATIVESHELL
	end

	return region, caveNoise
end


minetest.register_chatcommand("nether_whereami",
	{
		description = S("Describes which region of the nether the player is in"),
		privs = {debug = true},
		func = function(name, param)

			local player = minetest.get_player_by_name(name)
			if player == nil then return false, S("Unknown player position") end
			local playerPos = vector.round(player:get_pos())

			local region, caveNoise                = mapgen.getRegion(playerPos)
			local seaLevel, cavernLimitDistance    = mapgen.find_nearest_lava_sealevel(playerPos.y)
			local tcave_adj, centerRegionLimit_adj = mapgen.get_mapgenblend_adjustments(playerPos.y)

			local seaDesc = ""
			local boundaryDesc = ""
			local perlinDesc = ""

			if region ~= mapgen.RegionEnum.OVERWORLD then

				local seaPos = playerPos.y - seaLevel
				if seaPos > 0 then
					seaDesc = S(", @1m above lava-sea level", seaPos)
				else
					seaDesc = S(", @1m below lava-sea level", seaPos)
				end

				if tcave_adj > 0 then
					boundaryDesc = S(", approaching y boundary of Nether")
				end

				perlinDesc = S("[Perlin @1] ", (math_floor(caveNoise * 1000) / 1000))
			end

			return true, S("@1@2@3@4", perlinDesc, region.desc, seaDesc, boundaryDesc)
		end
	}
)
