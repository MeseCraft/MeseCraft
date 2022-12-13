--[[

  Nether mod for minetest

  All the Dungeon related functions used by the biomes-based mapgen are here.


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


-- We don't need to be gen-notified of temples because only dungeons will be generated
-- if a biome defines the dungeon nodes
minetest.set_gen_notify({dungeon = true})


-- Content ids

local c_air              = minetest.get_content_id("air")
local c_netherrack       = minetest.get_content_id("nether:rack")
local c_netherrack_deep  = minetest.get_content_id("nether:rack_deep")
local c_dungeonbrick     = minetest.get_content_id("nether:brick")
local c_dungeonbrick_alt = minetest.get_content_id("nether:brick_cracked")
local c_netherbrick_slab = minetest.get_content_id("stairs:slab_nether_brick")
local c_netherfence      = minetest.get_content_id("nether:fence_nether_brick")
local c_glowstone        = minetest.get_content_id("nether:glowstone")
local c_glowstone_deep   = minetest.get_content_id("nether:glowstone_deep")
local c_lava_source      = minetest.get_content_id("default:lava_source")


-- Misc math functions

-- avoid needing table lookups each time a common math function is invoked
local math_max, math_min  = math.max, math.min


-- Dungeon excavation functions

function is_dungeon_brick(node_id)
	return node_id == c_dungeonbrick or node_id == c_dungeonbrick_alt
end



nether.mapgen.build_dungeon_room_list = function(data, area)

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
nether.mapgen.excavate_dungeons = function(data, area, rooms)

	local vi, node_id

	-- any air from the native mapgen has been replaced by netherrack, but
	-- we don't want this inside dungeons, so fill dungeon rooms with air
	for _, roomInfo in ipairs(rooms) do

		local room_min = roomInfo.minp
		local room_max = roomInfo.maxp

		for z = room_min.z, room_max.z do
			for y = room_min.y, room_max.y do
				vi = area:index(room_min.x, y, z)
				for x = room_min.x, room_max.x do
					node_id = data[vi]
					if node_id == c_netherrack or node_id == c_netherrack_deep then data[vi] = c_air end
					vi = vi + 1
				end
			end
		end
	end

	-- clear netherrack from dungeon stairways
	if #rooms > 0 then
		local stairPositions = minetest.find_nodes_in_area(area.MinEdge, area.MaxEdge, minetest.registered_biomes["nether_caverns"].node_dungeon_stair)
		for _, stairPos in ipairs(stairPositions) do
			vi = area:indexp(stairPos)
			for i = 1, 4 do
				if stairPos.y + i > area.MaxEdge.y then break end
				vi = vi + area.ystride
				node_id = data[vi]
				-- searching forward of the stairs could also be done
				if node_id == c_netherrack or node_id == c_netherrack_deep then data[vi] = c_air end
			end
		end
	end
end

-- Since we already know where all the rooms and their walls are, and have all the nodes stored
-- in a voxelmanip already, we may as well add a little Nether flair to the dungeons found here.
nether.mapgen.decorate_dungeons = function(data, area, rooms)

	local xStride, yStride, zStride = 1, area.ystride, area.zstride
	local minEdge, maxEdge = area.MinEdge, area.MaxEdge

	for _, roomInfo in ipairs(rooms) do

		local room_min, room_max = roomInfo.minp, roomInfo.maxp
		local room_size = vector.distance(room_min, room_max)

		if room_size > 10 then
			local room_seed = roomInfo.x + 3 * roomInfo.z + 13 * roomInfo.y
			local window_y  = roomInfo.y + math_min(2, room_max.y - roomInfo.y - 1)
			local roomWidth  = room_max.x - room_min.x + 1
			local roomLength = room_max.z - room_min.z + 1

			if room_seed % 3 == 0 and room_max.y < maxEdge.y then
				-- Glowstone chandelier (feel free to replace with a fancy schematic)
				local vi = area:index(roomInfo.x, room_max.y + 1, roomInfo.z)
				if is_dungeon_brick(data[vi]) then data[vi] = c_glowstone end

			elseif room_seed % 4 == 0 and room_min.y > minEdge.y
				   and room_min.x > minEdge.x and room_max.x < maxEdge.x
				   and room_min.z > minEdge.z and room_max.z < maxEdge.z then
				-- lava well (feel free to replace with a fancy schematic)
				local vi = area:index(roomInfo.x, room_min.y, roomInfo.z)
				if is_dungeon_brick(data[vi - yStride]) then
					data[vi - yStride] = c_lava_source
					if data[vi - zStride] == c_air then data[vi - zStride] = c_netherbrick_slab end
					if data[vi + zStride] == c_air then data[vi + zStride] = c_netherbrick_slab end
					if data[vi - xStride] == c_air then data[vi - xStride] = c_netherbrick_slab end
					if data[vi + xStride] == c_air then data[vi + xStride] = c_netherbrick_slab end
				end
			end

			-- Barred windows
			if room_seed % 7 < 5 and roomWidth >= 5 and roomLength >= 5
			   and window_y >= minEdge.y and window_y + 1 <= maxEdge.y
			   and room_min.x > minEdge.x and room_max.x < maxEdge.x
			   and room_min.z > minEdge.z and room_max.z < maxEdge.z then
				--data[area:indexp(roomInfo)] = minetest.get_content_id("default:mese_post_light") -- debug

				-- Can't use glass panes because they need the param data set.
				-- Until whisper glass is added, every window will be made of netherbrick fence (rather
				-- than material depending on room_seed)
				local window_node = c_netherfence
				--if c_netherglass ~= nil and room_seed % 20 >= 12 then window_node = c_crystallight end

				local function placeWindow(vi, viOutsideOffset, windowNo)
					if is_dungeon_brick(data[vi]) and is_dungeon_brick(data[vi + yStride]) then
						data[vi] = window_node

						if room_seed % 19 == windowNo then
							-- place a glowstone light behind the window
							local node_id = data[vi + viOutsideOffset]
							if node_id == c_netherrack then
								data[vi + viOutsideOffset] = c_glowstone
							elseif node_id == c_netherrack_deep then
								data[vi + viOutsideOffset] = c_glowstone_deep
							end
						end
					end
				end

				local vi_min = area:index(room_min.x - 1, window_y, roomInfo.z)
				local vi_max = area:index(room_max.x + 1, window_y, roomInfo.z)
				local locations = {-zStride, zStride, -zStride + yStride, zStride + yStride}
				for i, offset in ipairs(locations) do
					placeWindow(vi_min + offset, -1, i)
					placeWindow(vi_max + offset,  1, i + #locations)
				end
				vi_min = area:index(roomInfo.x, window_y, room_min.z - 1)
				vi_max = area:index(roomInfo.x, window_y, room_max.z + 1)
				locations = {-xStride, xStride, -xStride + yStride, xStride + yStride}
				for i, offset in ipairs(locations) do
					placeWindow(vi_min + offset, -zStride, i + #locations * 2)
					placeWindow(vi_max + offset,  zStride, i + #locations * 3)
				end
			end

			-- pillars or mezzanine floor
			if room_seed % 43 > 10 and roomWidth >= 6 and roomLength >= 6 then

				local pillar_vi    = {}
				local pillarHeight = 0
				local wallDist = 1 + math.floor((roomWidth + roomLength) / 14)

				local roomHeight = room_max.y - room_min.y
				if roomHeight >= 7 then
					-- mezzanine floor
					local mezzMax = {
						x = room_min.x + math.floor(roomWidth / 7 * 4),
						y = room_min.y + math.floor(roomHeight / 5 * 3),
						z = room_max.z
					}

					pillarHeight = mezzMax.y - room_min.y - 1
					pillar_vi = {
						area:index(mezzMax.x, room_min.y, room_min.z + wallDist),
						area:index(mezzMax.x, room_min.y, room_max.z - wallDist),
					}

					if is_dungeon_brick(data[pillar_vi[1] - yStride]) and is_dungeon_brick(data[pillar_vi[2] - yStride]) then
						-- The floor of the dungeon looks like it exists (i.e. not erased by nether
						-- cavern), so add the mezzanine floor
						for z = 0, roomLength - 1 do
							local vi = area:index(room_min.x, mezzMax.y, room_min.z + z)
							for x = room_min.x, mezzMax.x do
								if data[vi] == c_air then data[vi] = c_dungeonbrick end
								vi = vi + 1
							end
						end
					end

				elseif roomHeight >= 4 then
					-- 4 pillars
					pillarHeight = roomHeight
					pillar_vi = {
						area:index(room_min.x + wallDist, room_min.y, room_min.z + wallDist),
						area:index(room_min.x + wallDist, room_min.y, room_max.z - wallDist),
						area:index(room_max.x - wallDist, room_min.y, room_min.z + wallDist),
						area:index(room_max.x - wallDist, room_min.y, room_max.z - wallDist)
					}
				end

				for i = #pillar_vi, 1, -1 do
					if not is_dungeon_brick(data[pillar_vi[i] - yStride]) then
						-- there's no dungeon floor under this pillar so skip it, it's probably been cut away by nether cavern.
						table.remove(pillar_vi, i)
					end
				end
				for y = 0, pillarHeight do
					for _, vi in ipairs(pillar_vi) do
						if data[vi + y * yStride] == c_air then data[vi + y * yStride] = c_dungeonbrick end
					end
				end
			end

			-- Weeds on the floor once Nether weeds are added
		end
	end
end
