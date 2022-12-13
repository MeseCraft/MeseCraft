--[[

  Nether mod for minetest

  "mapgen_nobiomes.lua" is the legacy version of the mapgen, only used
    in older versions of Minetest or in v6 worlds.
  "mapgen.lua" is the modern biomes-based Nether mapgen, which
    requires Minetest v5.1 or greater


  Copyright (C) 2013 PilzAdam

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


-- Parameters

local NETHER_CEILING = nether.DEPTH_CEILING
local NETHER_FLOOR   = nether.DEPTH_FLOOR
local TCAVE = 0.6
local BLEND = 128


-- 3D noise

local np_cave = {
	offset = 0,
	scale = 1,
	spread = {x = 384, y = 128, z = 384}, -- squashed 3:1
	seed = 59033,
	octaves = 5,
	persist = 0.7,
	lacunarity = 2.0,
	--flags = ""
}


-- Stuff

local yblmin = NETHER_FLOOR   + BLEND * 2
local yblmax = NETHER_CEILING - BLEND * 2



-- Mapgen

dofile(nether.path .. "/mapgen_decorations.lua")

-- Initialize noise object, localise noise and data buffers

local nobj_cave = nil
local nbuf_cave = {}
local dbuf = {}


-- Content ids

local c_air = minetest.get_content_id("air")

--local c_stone_with_coal = minetest.get_content_id("default:stone_with_coal")
--local c_stone_with_iron = minetest.get_content_id("default:stone_with_iron")
local c_stone_with_mese = minetest.get_content_id("default:stone_with_mese")
local c_stone_with_diamond = minetest.get_content_id("default:stone_with_diamond")
local c_stone_with_gold = minetest.get_content_id("default:stone_with_gold")
--local c_stone_with_copper = minetest.get_content_id("default:stone_with_copper")
local c_mese = minetest.get_content_id("default:mese")

local c_gravel = minetest.get_content_id("default:gravel")
local c_dirt = minetest.get_content_id("default:dirt")
local c_sand = minetest.get_content_id("default:sand")

local c_cobble = minetest.get_content_id("default:cobble")
local c_mossycobble = minetest.get_content_id("default:mossycobble")
local c_stair_cobble = minetest.get_content_id("stairs:stair_cobble")

local c_lava_source = minetest.get_content_id("default:lava_source")
local c_lava_flowing = minetest.get_content_id("default:lava_flowing")
local c_water_source = minetest.get_content_id("default:water_source")
local c_water_flowing = minetest.get_content_id("default:water_flowing")

local c_glowstone = minetest.get_content_id("nether:glowstone")
local c_nethersand = minetest.get_content_id("nether:sand")
local c_netherbrick = minetest.get_content_id("nether:brick")
local c_netherrack = minetest.get_content_id("nether:rack")


-- On-generated function

minetest.register_on_generated(function(minp, maxp, seed)
	if minp.y > NETHER_CEILING or maxp.y < NETHER_FLOOR then
		return
	end

	local x1 = maxp.x
	local y1 = math.min(maxp.y, NETHER_CEILING)
	local z1 = maxp.z
	local x0 = minp.x
	local y0 = math.max(minp.y, NETHER_FLOOR)
	local z0 = minp.z

	local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
	local area = VoxelArea:new{MinEdge = emin, MaxEdge = emax}
	local data = vm:get_data(dbuf)

	local x11 = emax.x -- Limits of mapchunk plus mapblock shell
	local y11 = emax.y
	local z11 = emax.z
	local x00 = emin.x
	local y00 = emin.y
	local z00 = emin.z

	local ystride = x1 - x0 + 1
	local zstride = ystride * ystride
	local chulens = {x = ystride, y = ystride, z = ystride}
	local minposxyz = {x = x0, y = y0, z = z0}

	nobj_cave = nobj_cave or minetest.get_perlin_map(np_cave, chulens)
	local nvals_cave = nobj_cave:get_3d_map_flat(minposxyz, nbuf_cave)

	for y = y00, y11 do -- Y loop first to minimise tcave calculations
		local tcave
		local in_chunk_y = false
		if y >= y0 and y <= y1 then
			tcave = TCAVE
			if y > yblmax then tcave = TCAVE + ((y - yblmax) / BLEND) ^ 2 end
			if y < yblmin then tcave = TCAVE + ((yblmin - y) / BLEND) ^ 2 end
			in_chunk_y = true
		end

		for z = z00, z11 do
			local vi = area:index(x00, y, z) -- Initial voxelmanip index
			local ni
			local in_chunk_yz = in_chunk_y and z >= z0 and z <= z1

			for x = x00, x11 do
				if in_chunk_yz and x == x0 then
					-- Initial noisemap index
					ni = (z - z0) * zstride + (y - y0) * ystride + 1
				end
				local in_chunk_yzx = in_chunk_yz and x >= x0 and x <= x1 -- In mapchunk

				local id = data[vi] -- Existing node
				-- Cave air, cave liquids and dungeons are overgenerated,
				-- convert these throughout mapchunk plus shell
				if id == c_air or -- Air and liquids to air
						id == c_lava_source or
						id == c_lava_flowing or
						id == c_water_source or
						id == c_water_flowing then
					data[vi] = c_air
				-- Dungeons are preserved so we don't need
				-- to check for cavern in the shell
				elseif id == c_cobble or -- Dungeons (preserved) to netherbrick
						id == c_mossycobble or
						id == c_stair_cobble then
					data[vi] = c_netherbrick
				end

				if in_chunk_yzx then -- In mapchunk
					if nvals_cave[ni] > tcave then -- Only excavate cavern in mapchunk
						data[vi] = c_air
					elseif id == c_mese then -- Mese block to lava
						data[vi] = c_lava_source
					elseif id == c_stone_with_gold or -- Precious ores to glowstone
							id == c_stone_with_mese or
							id == c_stone_with_diamond then
						data[vi] = c_glowstone
					elseif id == c_gravel or -- Blob ore to nethersand
							id == c_dirt or
							id == c_sand then
						data[vi] = c_nethersand
					else -- All else to netherstone
						data[vi] = c_netherrack
					end

					ni = ni + 1 -- Only increment noise index in mapchunk
				end

				vi = vi + 1
			end
		end
	end

	vm:set_data(data)

	minetest.generate_decorations(vm)

	vm:set_lighting({day = 0, night = 0}, minp, maxp)
	vm:calc_lighting()
	vm:update_liquids()
	vm:write_to_map()
end)


-- use knowledge of the nether mapgen algorithm to return a suitable ground level for placing a portal.
-- player_name is optional, allowing a player to spawn a remote portal in their own protected areas.
function nether.find_nether_ground_y(target_x, target_z, start_y, player_name)
	local nobj_cave_point = minetest.get_perlin(np_cave)
	local air = 0 -- Consecutive air nodes found

	local minp_schem, maxp_schem = nether.get_schematic_volume({x = target_x, y = 0, z = target_z}, nil, "nether_portal")
	local minp = {x = minp_schem.x, y = 0, z = minp_schem.z}
	local maxp = {x = maxp_schem.x, y = 0, z = maxp_schem.z}

	for y = start_y, math.max(NETHER_FLOOR + BLEND, start_y - 4096), -1 do
		local nval_cave = nobj_cave_point:get_3d({x = target_x, y = y, z = target_z})

		if nval_cave > TCAVE then -- Cavern
			air = air + 1
		else -- Not cavern, check if 4 nodes of space above
			if air >= 4 then
				local portal_y = y + 1
				-- Check volume for non-natural nodes
				minp.y = minp_schem.y + portal_y
				maxp.y = maxp_schem.y + portal_y
				if nether.volume_is_natural_and_unprotected(minp, maxp, player_name) then
					return portal_y
				else -- Restart search a little lower
					nether.find_nether_ground_y(target_x, target_z, y - 16, player_name)
				end
			else -- Not enough space, reset air to zero
				air = 0
			end
		end
	end

	return math.max(start_y, NETHER_FLOOR + BLEND) -- Fallback
end
