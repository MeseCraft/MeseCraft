--[[

  Nether mod for minetest

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


-- Stuff

local math_max, math_min = math.max, math.min -- avoid needing table lookups each time a common math function is invoked

if minetest.read_schematic == nil then
	-- Using biomes to create the Nether requires the ability for biomes to set "node_cave_liquid = air".
	-- This feature was introduced by paramat in b1b40fef1 on 2019-05-19, but we can't test for
	-- it directly. However b2065756c was merged a few months later (in 2019-08-14) and it is easy
	-- to directly test for - it adds minetest.read_schematic() - so we use this as a proxy-test
	-- for whether the Minetest engine is recent enough to have implemented node_cave_liquid=air
	error("This " .. nether.modname .. " mapgen requires Minetest v5.1 or greater, use mapgen_nobiomes.lua instead.", 0)
end

local function override_underground_biomes()
	-- https://forum.minetest.net/viewtopic.php?p=257522#p257522
	-- Q: Is there a way to override an already-registered biome so I can get it out of the
	--    way of my own underground biomes without disturbing the other biomes registered by
	--    default?
	-- A: No, all you can do is use a mod to clear all biomes then re-register the complete
	--    set but with your changes. It has been described as hacky but this is actually the
	--    official way to alter biomes, most mods and subgames would want to completely change
	--    all biomes anyway.
	--    To avoid the engine side of mapgen becoming overcomplex the approach is to require mods
	--    to do slightly more complex stuff in Lua.

	-- take a copy of all biomes, decorations, and ores. Regregistering a biome changes its ID, so
	-- any decorations or ores using the 'biomes' field must afterwards be cleared and re-registered.
	-- https://github.com/minetest/minetest/issues/9288
	local registered_biomes_copy      = {}
	local registered_decorations_copy = {}
	local registered_ores_copy        = {}

	for old_biome_key, old_biome_def in pairs(minetest.registered_biomes) do
	   registered_biomes_copy[old_biome_key] = old_biome_def
	end
	for old_decoration_key, old_decoration_def in pairs(minetest.registered_decorations) do
	   registered_decorations_copy[old_decoration_key] = old_decoration_def
	end
	for old_ore_key, old_ore_def in pairs(minetest.registered_ores) do
		registered_ores_copy[old_ore_key] = old_ore_def
	 end

	-- clear biomes, decorations, and ores
	minetest.clear_registered_decorations()
	minetest.clear_registered_ores()
	minetest.clear_registered_biomes()

	-- Restore biomes, adjusted to not overlap the Nether
	for biome_key, new_biome_def in pairs(registered_biomes_copy) do
		local biome_y_max, biome_y_min = tonumber(new_biome_def.y_max), tonumber(new_biome_def.y_min)

		if biome_y_max > NETHER_FLOOR and biome_y_min < NETHER_CEILING then
			-- This biome occupies some or all of the depth of the Nether, shift/crop it.
			local spaceOccupiedAbove = biome_y_max - NETHER_CEILING
			local spaceOccupiedBelow = NETHER_FLOOR - biome_y_min
			if spaceOccupiedAbove >= spaceOccupiedBelow or biome_y_min <= -30000 then
				-- place the biome above the Nether
				-- We also shift biomes which extend to the bottom of the map above the Nether, since they
				-- likely only extend that deep as a catch-all, and probably have a role nearer the surface.
				new_biome_def.y_min = NETHER_CEILING + 1
				new_biome_def.y_max = math_max(biome_y_max, NETHER_CEILING + 2)
			else
				-- shift the biome to below the Nether
				new_biome_def.y_max = NETHER_FLOOR - 1
				new_biome_def.y_min = math_min(biome_y_min, NETHER_CEILING - 2)
			end
		end
		minetest.register_biome(new_biome_def)
	end

	-- Restore biome decorations
	for decoration_key, new_decoration_def in pairs(registered_decorations_copy) do
	   minetest.register_decoration(new_decoration_def)
	end
	-- Restore biome ores
	for ore_key, new_ore_def in pairs(registered_ores_copy) do
		minetest.register_ore(new_ore_def)
	 end
 end

-- Shift any overlapping biomes out of the way before we create the Nether biomes
override_underground_biomes()

-- nether:native_mapgen is used to prevent ores and decorations being generated according
-- to landforms created by the native mapgen.
-- Ores and decorations can be registered against "nether:rack" instead, and the lua
-- on_generate() callback will carve the Nether with nether:rack before invoking
-- generate_decorations and generate_ores.
minetest.register_node("nether:native_mapgen", {})

minetest.register_biome({
	name = "nether_caverns",
	node_stone  = "nether:native_mapgen", -- nether:native_mapgen is used here to prevent the native mapgen from placing ores and decorations.
	node_filler = "nether:native_mapgen", -- The lua on_generate will transform nether:rack_native into nether:rack then decorate and add ores.
	node_dungeon = "nether:brick",
	--node_dungeon_alt = "default:mossycobble",
	node_dungeon_stair = "stairs:stair_nether_brick",
	-- Setting node_cave_liquid to "air" avoids the need to filter lava and water out of the mapchunk and
	-- surrounding shell (overdraw nodes beyond the mapchunk).
	-- This feature was introduced by paramat in b1b40fef1 on 2019-05-19, and this mapgen.lua file should only
	-- be run if the Minetest version includes it. The earliest tag made after 2019-05-19 is 5.1.0 on 2019-10-13,
	-- however we shouldn't test version numbers. minetest.read_schematic() was added by b2065756c and merged in
	-- 2019-08-14 and is easy to test for, we don't use it but it should make a good proxy-test for whether the
	-- Minetest version is recent enough to have implemented node_cave_liquid=air
	node_cave_liquid = "air",
	y_max = NETHER_CEILING,
	y_min = NETHER_FLOOR,
	vertical_blend = 0,
	heat_point = 50,
	humidity_point = 50,
})


-- Ores and decorations

dofile(nether.path .. "/mapgen_decorations.lua")

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "nether:glowstone",
	wherein        = "nether:rack",
	clust_scarcity = 11 * 11 * 11,
	clust_num_ores = 3,
	clust_size     = 2,
	y_max = NETHER_CEILING,
	y_min = NETHER_FLOOR,
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "default:lava_source",
	wherein        = "nether:rack",
	clust_scarcity = 36 * 36 * 36,
	clust_num_ores = 4,
	clust_size     = 2,
	y_max = NETHER_CEILING,
	y_min = NETHER_FLOOR,
})

minetest.register_ore({
	ore_type        = "blob",
	ore             = "nether:sand",
	wherein         = "nether:rack",
	clust_scarcity  = 14 * 14 * 14,
	clust_size      = 8,
	y_max = NETHER_CEILING,
	y_min = NETHER_FLOOR
})


-- Mapgen

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

-- Buffers and objects we shouldn't recreate every on_generate

local nobj_cave = nil
local nbuf_cave = {}
local dbuf = {}

local yblmin = NETHER_FLOOR   + BLEND * 2
local yblmax = NETHER_CEILING - BLEND * 2

-- Content ids

local c_air              = minetest.get_content_id("air")
local c_netherrack       = minetest.get_content_id("nether:rack")
local c_netherbrick      = minetest.get_content_id("nether:brick")
local c_netherbrick_slab = minetest.get_content_id("stairs:slab_nether_brick")
local c_netherfence      = minetest.get_content_id("nether:fence_nether_brick")
local c_glowstone        = minetest.get_content_id("nether:glowstone")
local c_lava_source      = minetest.get_content_id("default:lava_source")
local c_native_mapgen    = minetest.get_content_id("nether:native_mapgen")


-- Dungeon excavation functions

function build_dungeon_room_list(data, area)

	local result = {}

	-- Unfortunately gennotify only returns dungeon rooms, not corridors.
	-- We don't need to check for temples because only dungeons are generated in biomes
	-- that define their own dungeon nodes.
	local gennotify = minetest.get_mapgen_object("gennotify")
	local roomLocations = gennotify["dungeon"] or {}

	-- Excavation should still know to stop if a cave or corridor has removed the dungeon wall.
	-- See MapgenBasic::generateDungeons in mapgen.cpp for max room sizes.
	local maxRoomSize = 18
	local maxRoomRadius = math.ceil(maxRoomSize / 2)

	local xStride, yStride, zStride = 1, area.ystride, area.zstride
	local minEdge, maxEdge = area.MinEdge, area.MaxEdge

	for _, roomPos in ipairs(roomLocations) do

		if area:containsp(roomPos) then -- this safety check does not appear to be necessary, but lets make it explicit

			local room_vi = area:indexp(roomPos)
			--data[room_vi] = minetest.get_content_id("default:torch") -- debug

			local startPos = vector.new(roomPos)
			if roomPos.y + 1 <= maxEdge.y and data[room_vi + yStride] == c_air then
				-- The roomPos coords given by gennotify are at floor level, but whenever possible we
				-- want to be performing searches a node higher than floor level to avoids dungeon chests.
				startPos.y = startPos.y + 1
				room_vi = area:indexp(startPos)
			end

			local bound_min_x = math_max(minEdge.x, roomPos.x - maxRoomRadius)
			local bound_min_y = math_max(minEdge.y, roomPos.y - 1) -- room coords given by gennotify are on the floor
			local bound_min_z = math_max(minEdge.z, roomPos.z - maxRoomRadius)

			local bound_max_x = math_min(maxEdge.x, roomPos.x + maxRoomRadius)
			local bound_max_y = math_min(maxEdge.y, roomPos.y + maxRoomSize) -- room coords given by gennotify are on the floor
			local bound_max_z = math_min(maxEdge.z, roomPos.z + maxRoomRadius)

			local room_min = vector.new(startPos)
			local room_max = vector.new(startPos)

			local vi = room_vi
			while room_max.y < bound_max_y and data[vi + yStride] == c_air do
				room_max.y = room_max.y + 1
				vi = vi + yStride
			end

			vi = room_vi
			while room_min.y > bound_min_y and data[vi - yStride] == c_air do
				room_min.y = room_min.y - 1
				vi = vi - yStride
			end

			vi = room_vi
			while room_max.z < bound_max_z and data[vi + zStride] == c_air do
				room_max.z = room_max.z + 1
				vi = vi + zStride
			end

			vi = room_vi
			while room_min.z > bound_min_z and data[vi - zStride] == c_air do
				room_min.z = room_min.z - 1
				vi = vi - zStride
			end

			vi = room_vi
			while room_max.x < bound_max_x and data[vi + xStride] == c_air do
				room_max.x = room_max.x + 1
				vi = vi + xStride
			end

			vi = room_vi
			while room_min.x > bound_min_x and data[vi - xStride] == c_air do
				room_min.x = room_min.x - 1
				vi = vi - xStride
			end

			local roomInfo = vector.new(roomPos)
			roomInfo.minp = room_min
			roomInfo.maxp = room_max
			result[#result + 1] = roomInfo
		end
	end

	return result;
end

-- Only partially excavates dungeons, the rest is left as an exercise for the player ;)
-- (Corridors and the parts of rooms which extend beyond the emerge boundary will remain filled)
function excavate_dungeons(data, area, rooms)

	-- any air from the native mapgen has been replaced by netherrack, but
	-- we don't want this inside dungeons, so fill dungeon rooms with air
	for _, roomInfo in ipairs(rooms) do

		local room_min = roomInfo.minp
		local room_max = roomInfo.maxp

		for z = room_min.z, room_max.z do
			for y = room_min.y, room_max.y do
				local vi = area:index(room_min.x, y, z)
				for x = room_min.x, room_max.x do
					if data[vi] == c_netherrack then data[vi] = c_air end
					vi = vi + 1
				end
			end
		end
	end
end

-- Since we already know where all the rooms and their walls are, and have all the nodes stored
-- in a voxelmanip already, we may as well add a little Nether flair to the dungeons found here.
function decorate_dungeons(data, area, rooms)

	local xStride, yStride, zStride = 1, area.ystride, area.zstride
	local minEdge, maxEdge = area.MinEdge, area.MaxEdge

	for _, roomInfo in ipairs(rooms) do

		local room_min, room_max = roomInfo.minp, roomInfo.maxp
		local room_size = vector.distance(room_min, room_max)

		if room_size > 10 then
			local room_seed = roomInfo.x + 3 * roomInfo.z + 13 * roomInfo.y
			local window_y  = roomInfo.y + math_min(2, room_max.y - roomInfo.y - 1)

			if room_seed % 3 == 0 and room_max.y < maxEdge.y then
				-- Glowstone chandelier
				local vi = area:index(roomInfo.x, room_max.y + 1, roomInfo.z)
				if data[vi] == c_netherbrick then data[vi] = c_glowstone end

			elseif room_seed % 4 == 0 and room_min.y > minEdge.y
				   and room_min.x > minEdge.x and room_max.x < maxEdge.x
				   and room_min.z > minEdge.z and room_max.z < maxEdge.z then
				-- lava well (feel free to replace with a fancy schematic)
				local vi = area:index(roomInfo.x, room_min.y, roomInfo.z)
				if data[vi - yStride] == c_netherbrick then data[vi - yStride] = c_lava_source end
				if data[vi - zStride] == c_air then data[vi - zStride] = c_netherbrick_slab end
				if data[vi + zStride] == c_air then data[vi + zStride] = c_netherbrick_slab end
				if data[vi - xStride] == c_air then data[vi - xStride] = c_netherbrick_slab end
				if data[vi + xStride] == c_air then data[vi + xStride] = c_netherbrick_slab end
			end

			-- Barred windows
			if room_seed % 7 < 5 and room_max.x - room_min.x >= 4 and room_max.z - room_min.z >= 4
			   and window_y >= minEdge.y and window_y + 1 <= maxEdge.y
			   and room_min.x > minEdge.x and room_max.x < maxEdge.x
			   and room_min.z > minEdge.z and room_max.z < maxEdge.z then
				--data[area:indexp(roomInfo)] = minetest.get_content_id("default:mese_post_light") -- debug

				-- Until whisper glass is added, every window will be made of netherbrick fence (rather
				-- than material depending on room_seed)
				local window_node = c_netherfence

				local vi_min = area:index(room_min.x - 1, window_y, roomInfo.z)
				local vi_max = area:index(room_max.x + 1, window_y, roomInfo.z)
				local locations = {-zStride, zStride, -zStride + yStride, zStride + yStride}
				for _, offset in ipairs(locations) do
					if data[vi_min + offset] == c_netherbrick then data[vi_min + offset] = window_node end
					if data[vi_max + offset] == c_netherbrick then data[vi_max + offset] = window_node end
				end
				vi_min = area:index(roomInfo.x, window_y, room_min.z - 1)
				vi_max = area:index(roomInfo.x, window_y, room_max.z + 1)
				locations = {-xStride, xStride, -xStride + yStride, xStride + yStride}
				for _, offset in ipairs(locations) do
					if data[vi_min + offset] == c_netherbrick then data[vi_min + offset] = window_node end
					if data[vi_max + offset] == c_netherbrick then data[vi_max + offset] = window_node end
				end
			end

			-- Weeds on the floor once Nether weeds are added
		end
	end
end


-- On-generated function

local function on_generated(minp, maxp, seed)

	if minp.y > NETHER_CEILING or maxp.y < NETHER_FLOOR then
		return
	end

	local vm, emerge_min, emerge_max = minetest.get_mapgen_object("voxelmanip")
	local area = VoxelArea:new{MinEdge=emerge_min, MaxEdge=emerge_max}
	local data = vm:get_data(dbuf)

	local x0, y0, z0 = minp.x, math_max(minp.y, NETHER_FLOOR),   minp.z
	local x1, y1, z1 = maxp.x, math_min(maxp.y, NETHER_CEILING), maxp.z

	local yCaveStride = x1 - x0 + 1
	local zCaveStride = yCaveStride * yCaveStride
	local chulens = {x = yCaveStride, y = yCaveStride, z = yCaveStride}

	nobj_cave = nobj_cave or minetest.get_perlin_map(np_cave, chulens)
	local nvals_cave = nobj_cave:get_3d_map_flat(minp, nbuf_cave)


	local dungeonRooms = build_dungeon_room_list(data, area)

	for y = y0, y1 do -- Y loop first to minimise tcave calculations

		local tcave = TCAVE
		if y > yblmax then tcave = TCAVE + ((y - yblmax) / BLEND) ^ 2 end
		if y < yblmin then tcave = TCAVE + ((yblmin - y) / BLEND) ^ 2 end

		for z = z0, z1 do
			local vi = area:index(x0, y, z) -- Initial voxelmanip index
			local ni = (z - z0) * zCaveStride + (y - y0) * yCaveStride + 1

			for x = x0, x1 do

				local id = data[vi] -- Existing node

				if nvals_cave[ni] > tcave then
					data[vi] = c_air
				elseif id == c_air or id == c_native_mapgen then
					data[vi] = c_netherrack -- excavate_dungeons() will mostly reverse this inside dungeons
				end

				ni = ni + 1
				vi = vi + 1
			end
		end
	end

	-- any air from the native mapgen has been replaced by netherrack, but we
	-- don't want netherrack inside dungeons, so fill known dungeon rooms with air.
	excavate_dungeons(data, area, dungeonRooms)
	decorate_dungeons(data, area, dungeonRooms)

	vm:set_data(data)

	-- avoid generating decorations on the underside of the bottom of the nether
	if minp.y > NETHER_FLOOR and maxp.y < NETHER_CEILING then minetest.generate_decorations(vm) end

	minetest.generate_ores(vm)
	vm:set_lighting({day = 0, night = 0}, minp, maxp)
	vm:calc_lighting()
	vm:update_liquids()
	vm:write_to_map()
end


-- use knowledge of the nether mapgen algorithm to return a suitable ground level for placing a portal.
function nether.find_nether_ground_y(target_x, target_z, start_y)
	local nobj_cave_point = minetest.get_perlin(np_cave)
	local air = 0 -- Consecutive air nodes found

	for y = start_y, math_max(NETHER_FLOOR + BLEND, start_y - 4096), -1 do
		local nval_cave = nobj_cave_point:get3d({x = target_x, y = y, z = target_z})

		if nval_cave > TCAVE then -- Cavern
			air = air + 1
		else -- Not cavern, check if 4 nodes of space above
			if air >= 4 then
				-- Check volume for non-natural nodes
				local minp = {x = target_x - 1, y = y    , z = target_z - 2}
				local maxp = {x = target_x + 2, y = y + 4, z = target_z + 2}
				if nether.volume_is_natural(minp, maxp) then
					return y + 1
				else -- Restart search a little lower
					nether.find_nether_ground_y(target_x, target_z, y - 16)
				end
			else -- Not enough space, reset air to zero
				air = 0
			end
		end
	end

	return math_max(start_y, NETHER_FLOOR + BLEND) -- Fallback
end

-- We don't need to be gen-notified of temples because only dungeons will be generated
-- if a biome defines the dungeon nodes
minetest.set_gen_notify({dungeon = true})

minetest.register_on_generated(on_generated)