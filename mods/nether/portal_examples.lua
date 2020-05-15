--[[

  Nether mod portal examples for Minetest

  These portal API examples work independently of the Nether realm
  and Nether portal. To try these examples, enable them in:
	  Minetest -> Settings -> All settings -> Mods -> nether
  Once enabled, details on how to build them can be found in dungeon
  chests in the book of portals.

  --

  Copyright (C) 2020 Treer

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
local S = nether.get_translator


local ENABLE_PORTAL_EXAMPLE_FLOATLANDS    = false
local ENABLE_PORTAL_EXAMPLE_SURFACETRAVEL = false

-- Sets how far a Surface Portal will travel, measured in cells along the Moore curve,
-- which are about 117 nodes square each. Larger numbers will generally mean further distance
-- as-the-crow-flies, but this will not always be true due to the how the Moore curve
-- frequently doubles back upon itself.
-- This doubling-back prevents the surface portal from taking players easily accross the
-- map - the curve is 262144 cells long!
local SURFACE_TRAVEL_DISTANCE = 26


--=================================================--
-- Portal to the Floatlands, playable code example --
--==================================================--
local FLOATLANDS_ENABLED
local FLOATLAND_LEVEL    = 1280

if minetest.settings:get_bool("nether_enable_portal_example_floatlands", ENABLE_PORTAL_EXAMPLE_FLOATLANDS) or ENABLE_PORTAL_EXAMPLE_FLOATLANDS then

	local floatlands_flavortext = ""
	if minetest.get_mapgen_setting("mg_name") == "v7" then
		local mgv7_spflags = minetest.get_mapgen_setting("mgv7_spflags")
		FLOATLANDS_ENABLED = mgv7_spflags ~= nil and mgv7_spflags:find("floatlands") ~= nil and mgv7_spflags:find("nofloatlands") == nil
		FLOATLAND_LEVEL = minetest.get_mapgen_setting("mgv7_floatland_level") or 1280

		if FLOATLANDS_ENABLED then
			floatlands_flavortext = "\n\n	" .. S("There is a floating land of hills and forests up there, over the edges of which is a perilous drop all the way back down to sea level. We have not found how far these pristine lands extend. I have half a mind to retire there one day.")
		end
	end


	nether.register_portal("floatlands_portal", {
		shape               = nether.PortalShape_Platform,
		frame_node_name     = "default:ice",
		wormhole_node_color = 7, -- 7 is white
		particle_texture    = {
			name      = "nether_particle_anim1.png",
			animation = {
				type = "vertical_frames",
				aspect_w = 7,
				aspect_h = 7,
				length = 1,
			},
			scale = 1.5
		},
		title = S("Floatlands Portal"),
		book_of_portals_pagetext = S([[Requiring 21 blocks of ice, and constructed in the shape of a 3 × 3 platform with walls, or like a bowl. A finished platform is 2 blocks high, and 5 blocks wide at the widest in both directions.

This portal is different to the others, rather than acting akin to a doorway it appears to the eye more like a small pool of water which can be stepped into. Upon setting foot in the portal we found ourselves at a tremendous altitude.@1]],
		floatlands_flavortext),

		is_within_realm = function(pos) -- return true if pos is inside the Nether
			return pos.y > FLOATLAND_LEVEL - 200
		end,

		find_realm_anchorPos = function(surface_anchorPos)
			-- TODO: Once paramat finishes adjusting the floatlands, implement a surface algorithm that finds land
			local destination_pos = {x = surface_anchorPos.x ,y = FLOATLAND_LEVEL + 2, z = surface_anchorPos.z}

			-- a y_factor of 0 makes the search ignore the altitude of the portals (as long as they are in the Floatlands)
			local existing_portal_location, existing_portal_orientation = nether.find_nearest_working_portal("floatlands_portal", destination_pos, 10, 0)
			if existing_portal_location ~= nil then
				return existing_portal_location, existing_portal_orientation
			else
				return destination_pos
			end
		end
	})

end


--==============================================--
-- Surface-travel portal, playable code example --
--==============================================--

-- These Moore Curve functions requred by surface_portal's find_surface_anchorPos() will
-- be assigned later in this file.
local get_moore_distance -- will be function get_moore_distance(cell_count, x, y): integer
local get_moore_coords   -- will be function get_moore_coords(cell_count, distance): pos2d

if minetest.settings:get_bool("nether_enable_portal_example_surfacetravel", ENABLE_PORTAL_EXAMPLE_SURFACETRAVEL) or ENABLE_PORTAL_EXAMPLE_SURFACETRAVEL then

	nether.register_portal("surface_portal", {
		shape               = nether.PortalShape_Circular,
		frame_node_name     = "default:tinblock",
		wormhole_node_color = 4, -- 4 is cyan
		title = S("Surface Portal"),
		book_of_portals_pagetext = S([[Requiring 16 blocks of tin and constructed in a circular fashion, a finished frame is seven blocks wide, seven blocks high, and stands vertically like a doorway.

These travel a distance along the ground, and even when constructed deep underground will link back up to the surface. They appear to favor a strange direction, with the exit portal linking back only for as long as the portal stays open — attempting to reopen a portal from the exit doorway leads to a new destination along this favored direction. It has stymied our ability to study the behavior of these portals because without constructing dual portals and keeping both open it's hard to step through more than one and still be able to return home.

Due to such difficulties, we never learned what determines the direction and distance where the matching twin portal will appear, and I have lost my friend and protégé. In cavalier youth and with little more than a rucksack, Coudreau has decided to follow the chain as far as it goes, and has not been seen since. Coudreau believes it works in epicycles, but I am not convinced. Still, I cling to the hope that one day the portal will open and Coudreau will step out from whichever place leads to this one, perhaps with an epic tale to tell.]]),

		is_within_realm = function(pos)
			-- Always return true, because these portals always just take you around the surface
			-- rather than taking you to a different realm
			return true
		end,

		find_realm_anchorPos = function(surface_anchorPos)
			-- This function isn't needed, since this type of portal always goes to the surface
			minetest.log("error" , "find_realm_anchorPos called for surface portal")
			return {x=0, y=0, z=0}
		end,

		find_surface_anchorPos = function(realm_anchorPos)
			-- A portal definition doesn't normally need to provide a find_surface_anchorPos() function,
			-- since find_surface_target_y() will be used by default, but these portals travel around the
			-- surface (following a Moore curve) so will be calculating a different x and z to realm_anchorPos.

			local cellCount = 512
			local maxDistFromOrigin = 30000 -- the world edges are at X=30927, X=−30912, Z=30927 and Z=−30912

			-- clip realm_anchorPos to maxDistFromOrigin, and move the origin so that all values are positive
			local x = math.min(maxDistFromOrigin, math.max(-maxDistFromOrigin, realm_anchorPos.x)) + maxDistFromOrigin
			local z = math.min(maxDistFromOrigin, math.max(-maxDistFromOrigin, realm_anchorPos.z)) + maxDistFromOrigin

			local divisor = math.ceil(maxDistFromOrigin * 2 / cellCount)
			local distance = get_moore_distance(cellCount, math.floor(x / divisor + 0.5), math.floor(z / divisor + 0.5))
			local destination_distance = (distance + SURFACE_TRAVEL_DISTANCE) % (cellCount * cellCount)
			local moore_pos = get_moore_coords(cellCount, destination_distance)
			local target_x = moore_pos.x * divisor - maxDistFromOrigin
			local target_z = moore_pos.y * divisor - maxDistFromOrigin

			local search_radius = divisor / 2 - 5 -- any portal within this area will do

			-- a y_factor of 0 makes the search ignore the altitude of the portals
			local existing_portal_location, existing_portal_orientation =
				nether.find_nearest_working_portal("surface_portal", {x = target_x, y = 0, z = target_z}, search_radius, 0)

			if existing_portal_location ~= nil then
				-- use the existing portal that was found near target_x, target_z
				return existing_portal_location, existing_portal_orientation
			else
				-- find a good location for the new portal, or if that isn't possible then at
				-- least adjust the coords a little so portals don't line up in a grid
				local adj_x, adj_z = 0, 0

				-- Deterministically look for a location in the cell where get_spawn_level() can give
				-- us a surface height, since nether.find_surface_target_y() works *much* better when
				-- it can use get_spawn_level()
				local prng = PcgRandom( -- seed the prng so that all portals for these Moore Curve coords will use the same random location
					moore_pos.x * 65732 +
					moore_pos.y * 729   +
					minetest.get_mapgen_setting("seed") * 3
				)

				local attemptLimit = 15 -- how many attempts we'll make at finding a good location
				for attempt = 1, attemptLimit do
					adj_x = math.floor(prng:rand_normal_dist(-search_radius, search_radius, 2) + 0.5)
					adj_z = math.floor(prng:rand_normal_dist(-search_radius, search_radius, 2) + 0.5)
					if minetest.get_spawn_level == nil or minetest.get_spawn_level(target_x + adj_x, target_z + adj_z)	~= nil then
						-- Found a location which will be at ground level - unless a player has built there.
						-- Or this is MT 0.4 which does not have get_spawn_level(), so there's no point looking
						-- at any further further random locations.
						break
					end
				end

				local destination_pos = {x = target_x + adj_x, y = 0, z = target_z + adj_z}
				destination_pos.y = nether.find_surface_target_y(destination_pos.x, destination_pos.z, "surface_portal")

				return destination_pos
			end
		end
	})

end

--=========================================--
-- Hilbert curve and Moore curve functions --
--=========================================--

-- These are space-filling curves, used by the surface_portal example as a way to determine where
-- to place portals. https://en.wikipedia.org/wiki/Moore_curve


-- Flip a quadrant on a diagonal axis
-- cell_count is the number of cells across the square is split into, and must be a power of 2
-- if flip_twice is true then pos does not change (even numbers of flips cancel out)
-- if flip_direction is true then the position is flipped along the \ diagonal
-- if flip_direction is false then the position is flipped along the / diagonal
local function hilbert_flip(cell_count, pos, flip_direction, flip_twice)
	if not flip_twice then
		if flip_direction then
			pos.x = (cell_count - 1) - pos.x;
			pos.y = (cell_count - 1) - pos.y;
		end

		local temp_x = pos.x;
		pos.x = pos.y;
		pos.y = temp_x;
	end
end

local function test_bit(cell_count, value, flag)
	local bit_value = cell_count / 2
	while bit_value > flag and bit_value >= 1  do
		if value >= bit_value then value = value - bit_value end
		bit_value = bit_value / 2
	end
	return value >= bit_value
end

-- Converts (x,y) to distance
-- starts at bottom left corner, i.e. (0, 0)
-- ends at bottom right corner, i.e. (cell_count - 1, 0)
local function get_hilbert_distance (cell_count, x, y)
	local distance = 0
	local pos = {x=x, y=y}
	local rx, ry

	local s = cell_count / 2
	while s > 0 do

		if test_bit(cell_count, pos.x, s) then rx = 1 else rx = 0 end
		if test_bit(cell_count, pos.y, s) then ry = 1 else ry = 0 end

		local rx_XOR_ry = rx
		if ry == 1 then rx_XOR_ry = 1 - rx_XOR_ry end -- XOR'd ry against rx

		distance = distance + s * s * (2 * rx + rx_XOR_ry)
		hilbert_flip(cell_count, pos, rx > 0, ry > 0);

		s = math.floor(s / 2)
	end
	return distance;
end

-- Converts distance to (x,y)
local function get_hilbert_coords(cell_count, distance)
	local pos = {x=0, y=0}
	local rx, ry

	local s = 1
	while s < cell_count do
		rx = math.floor(distance / 2) % 2
		ry = distance % 2
		if rx == 1 then ry = 1 - ry end -- XOR ry with rx

		hilbert_flip(s, pos, rx > 0, ry > 0);
		pos.x = pos.x + s * rx
		pos.y = pos.y + s * ry
		distance = math.floor(distance / 4)

		s = s * 2
	end
	return pos
end


-- Converts (x,y) to distance
-- A Moore curve is a variation of the Hilbert curve that has the start and
-- end next to each other.
-- Top middle point is the start/end location
get_moore_distance = function(cell_count, x, y)

	local quadLength = cell_count / 2
	local quadrant = 1 - math.floor(y / quadLength)
	if math.floor(x / quadLength) == 1 then quadrant = 3 - quadrant end
	local flipDirection = x < quadLength

	local pos = {x = x % quadLength, y = y % quadLength}
	hilbert_flip(quadLength, pos, flipDirection, false)

	return (quadrant * quadLength * quadLength) + get_hilbert_distance(quadLength, pos.x, pos.y)
end


-- Converts distance to (x,y)
-- A Moore curve is a variation of the Hilbert curve that has the start and
-- end next to each other.
-- Top middle point is the start/end location
get_moore_coords = function(cell_count, distance)
	local quadLength = cell_count / 2
	local quadDistance = quadLength * quadLength
	local quadrant = math.floor(distance / quadDistance)
	local flipDirection = distance * 2 < cell_count * cell_count
	local pos = get_hilbert_coords(quadLength, distance % quadDistance)
	hilbert_flip(quadLength, pos, flipDirection, false)

	if quadrant >= 2     then pos.x = pos.x + quadLength end
	if quadrant % 3 == 0 then pos.y = pos.y + quadLength end

	return pos
end
