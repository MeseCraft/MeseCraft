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

local S
if minetest.get_translator ~= nil then
	S = minetest.get_translator("nether")
else
	-- mock the translator function for MT 0.4
	S = function(str, ...)
		local args={...}
		return str:gsub(
			"@%d+",
			function(match) return args[tonumber(match:sub(2))]	end
		)
	end
end

-- Global Nether namespace
nether                = {}
nether.modname        = minetest.get_current_modname()
nether.path           = minetest.get_modpath(nether.modname)
nether.get_translator = S
                     -- nether.useBiomes allows other mods to know whether they can register ores etc. in the Nether.
                     -- See mapgen.lua for an explanation of why minetest.read_schematic is being checked
nether.useBiomes      = minetest.get_mapgen_setting("mg_name") ~= "v6" and minetest.read_schematic ~= nil


-- Settings
nether.DEPTH_CEILING              =  -5000 -- The y location of the Nether's celing
nether.DEPTH_FLOOR                = -11000 -- The y location of the Nether's floor
nether.FASTTRAVEL_FACTOR          =      8 -- 10 could be better value for Minetest, since there's no sprint, but ex-Minecraft players will be mathing for 8
nether.PORTAL_BOOK_LOOT_WEIGHTING =    0.9 -- Likelyhood of finding the Book of Portals (guide) in dungeon chests. Set to 0 to disable.
nether.NETHER_REALM_ENABLED       =   true -- Setting to false disables the Nether and Nether portal


-- Override default settings with values from the .conf file, if any are present.
nether.FASTTRAVEL_FACTOR          = tonumber(minetest.settings:get("nether_fasttravel_factor") or nether.FASTTRAVEL_FACTOR)
nether.PORTAL_BOOK_LOOT_WEIGHTING = tonumber(minetest.settings:get("nether_portalBook_loot_weighting") or nether.PORTAL_BOOK_LOOT_WEIGHTING)
nether.NETHER_REALM_ENABLED       = minetest.settings:get_bool("nether_realm_enabled", nether.NETHER_REALM_ENABLED)
nether.DEPTH_CEILING              = tonumber(minetest.settings:get("nether_depth_ymax") or nether.DEPTH_CEILING)
nether.DEPTH_FLOOR                = tonumber(minetest.settings:get("nether_depth_ymin") or nether.DEPTH_FLOOR)

if nether.DEPTH_FLOOR + 1000 > nether.DEPTH_CEILING then 
	error("The lower limit of the Nether must be set at least 1000 lower than the upper limit, and more than 3000 is recommended. Set settingtypes.txt, or 'All Settings' -> 'Mods' -> 'nether' -> 'Nether depth'", 0)
end
nether.DEPTH = nether.DEPTH_CEILING -- Deprecated, use nether.DEPTH_CEILING instead.

-- Load files
dofile(nether.path .. "/portal_api.lua")
dofile(nether.path .. "/nodes.lua")
if nether.NETHER_REALM_ENABLED then
	if nether.useBiomes then
		dofile(nether.path .. "/mapgen.lua")
	else
		dofile(nether.path .. "/mapgen_nobiomes.lua")
	end
end
dofile(nether.path .. "/portal_examples.lua")


-- Portals are ignited by right-clicking with a mese crystal fragment
nether.register_portal_ignition_item(
	"default:mese_crystal_fragment",
	{name = "nether_portal_ignition_failure", gain = 0.3}
)


if nether.NETHER_REALM_ENABLED then
	-- Use the Portal API to add a portal type which goes to the Nether
	-- See portal_api.txt for documentation
	nether.register_portal("nether_portal", {
		shape               = nether.PortalShape_Traditional,
		frame_node_name     = "default:obsidian",
		wormhole_node_color = 0, -- 0 is magenta
		title = S("Nether Portal"),
		book_of_portals_pagetext = S([[Construction requires 14 blocks of obsidian, which we found deep underground where water had solidified molten rock. The finished frame is four blocks wide, five blocks high, and stands vertically, like a doorway.

This opens to a truly hellish place, though for small mercies the air there is still breathable. There is an intriguing dimensional mismatch happening between this realm and ours, as after opening the second portal into it we observed that 10 strides taken in the Nether appear to be an equivalent of @1 in the natural world.

The expedition parties have found no diamonds or gold, and after an experienced search party failed to return from the trail of a missing expedition party, I must conclude this is a dangerous place.]], 10 * nether.FASTTRAVEL_FACTOR),

		is_within_realm = function(pos) -- return true if pos is inside the Nether
			return pos.y < nether.DEPTH_CEILING
		end,

		find_realm_anchorPos = function(surface_anchorPos)
			-- divide x and z by a factor of 8 to implement Nether fast-travel
			local destination_pos = vector.divide(surface_anchorPos, nether.FASTTRAVEL_FACTOR)
			destination_pos.x = math.floor(0.5 + destination_pos.x) -- round to int
			destination_pos.z = math.floor(0.5 + destination_pos.z) -- round to int
			destination_pos.y = nether.DEPTH_CEILING - 1000 -- temp value so find_nearest_working_portal() returns nether portals

			-- a y_factor of 0 makes the search ignore the altitude of the portals (as long as they are in the Nether)
			local existing_portal_location, existing_portal_orientation =
				nether.find_nearest_working_portal("nether_portal", destination_pos, 8, 0)

			if existing_portal_location ~= nil then
				return existing_portal_location, existing_portal_orientation
			else
				local start_y = nether.DEPTH_CEILING - math.random(500, 1500) -- Search starting altitude
				destination_pos.y = nether.find_nether_ground_y(destination_pos.x, destination_pos.z, start_y)
				return destination_pos
			end
		end,

		find_surface_anchorPos = function(realm_anchorPos)
			-- A portal definition doesn't normally need to provide a find_surface_anchorPos() function,
			-- since find_surface_target_y() will be used by default, but Nether portals also scale position
			-- to create fast-travel.
			-- Defining a custom function also means we can look for existing nearby portals.

			-- Multiply x and z by a factor of 8 to implement Nether fast-travel
			local destination_pos = vector.multiply(realm_anchorPos, nether.FASTTRAVEL_FACTOR)
			destination_pos.x = math.min(30900, math.max(-30900, destination_pos.x)) -- clip to world boundary
			destination_pos.z = math.min(30900, math.max(-30900, destination_pos.z)) -- clip to world boundary
			destination_pos.y = 0 -- temp value so find_nearest_working_portal() doesn't return nether portals

			-- a y_factor of 0 makes the search ignore the altitude of the portals (as long as they are outside the Nether)
			local existing_portal_location, existing_portal_orientation =
				nether.find_nearest_working_portal("nether_portal", destination_pos, 8 * nether.FASTTRAVEL_FACTOR, 0)

			if existing_portal_location ~= nil then
				return existing_portal_location, existing_portal_orientation
			else
				destination_pos.y = nether.find_surface_target_y(destination_pos.x, destination_pos.z, "nether_portal")
				return destination_pos
			end
		end,

		on_ignite = function(portalDef, anchorPos, orientation)

			-- make some sparks fly
			local p1, p2 = portalDef.shape:get_p1_and_p2_from_anchorPos(anchorPos, orientation)
			local pos = vector.divide(vector.add(p1, p2), 2)

			local textureName = portalDef.particle_texture
			if type(textureName) == "table" then textureName = textureName.name end

			minetest.add_particlespawner({
				amount = 110,
				time   = 0.1,
				minpos = {x = pos.x - 0.5, y = pos.y - 1.2, z = pos.z - 0.5},
				maxpos = {x = pos.x + 0.5, y = pos.y + 1.2, z = pos.z + 0.5},
				minvel = {x = -5, y = -1, z = -5},
				maxvel = {x =  5, y =  1, z =  5},
				minacc = {x =  0, y =  0, z =  0},
				maxacc = {x =  0, y =  0, z =  0},
				minexptime = 0.1,
				maxexptime = 0.5,
				minsize = 0.2 * portalDef.particle_texture_scale,
				maxsize = 0.8 * portalDef.particle_texture_scale,
				collisiondetection = false,
				texture = textureName .. "^[colorize:#F4F:alpha",
				animation = portalDef.particle_texture_animation,
				glow = 8
			})

		end

	})
end
