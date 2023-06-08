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

-- Set DEBUG_FLAGS to determine the behavior of nether.debug():
--   0 = off
--   1 = print(...)
--   2 = minetest.chat_send_all(...)
--   4 = minetest.log("info", ...)
local DEBUG_FLAGS = 0

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
nether.mapgen         = {} -- Shared Nether mapgen namespace, for mapgen files to expose functions and constants
nether.modname        = minetest.get_current_modname()
nether.path           = minetest.get_modpath(nether.modname)
nether.get_translator = S
                     -- nether.useBiomes allows other mods to know whether they can register ores etc. in the Nether.
                     -- See mapgen.lua for an explanation of why minetest.read_schematic is being checked
nether.useBiomes      = minetest.get_mapgen_setting("mg_name") ~= "v6" and minetest.read_schematic ~= nil
nether.fogColor = {	           -- only used if climate_api is installed
	netherCaverns = "#1D0504", -- Distance-fog colour for classic nether
	mantle        = "#070916", -- Distance-fog colour for the Mantle region
	geodes        = "#300530"  -- Distance-fog colour for secondary region
}


-- Settings
nether.DEPTH_CEILING              =  -5000 -- The y location of the Nether's celing
nether.DEPTH_FLOOR                = -11000 -- The y location of the Nether's floor
nether.FASTTRAVEL_FACTOR          =      8 -- 10 could be better value for Minetest, since there's no sprint
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


-- A debug-print function that understands vectors etc. and does not
-- evaluate when debugging is turned off.
-- Works like string.format(), treating the message as a format string.
-- nils, tables, and vectors passed as arguments to nether.debug() are
-- converted to strings and can be included inside the message with %s
function nether.debug(message, ...)

	local args = {...}
	local argCount = select("#", ...)

	for i = 1, argCount do
		local arg = args[i]
		if arg == nil then
			-- convert nils to strings
			args[i] = '<nil>'
		elseif type(arg) == "table" then
			local tableCount = 0
			for _,_ in pairs(arg) do tableCount = tableCount + 1 end
			if tableCount == 3 and arg.x ~= nil and arg.y ~= nil and arg.z ~= nil then
				-- convert vectors to strings
				args[i] = minetest.pos_to_string(arg)
			else
				-- convert tables to strings
				-- (calling function can use dump() if a multi-line listing is desired)
				args[i] = string.gsub(dump(arg, ""), "\n", " ")
			end
		end
	end

	local composed_message = "nether: " .. string.format(message, unpack(args))

	if math.floor(DEBUG_FLAGS / 1) % 2 == 1 then print(composed_message) end
	if math.floor(DEBUG_FLAGS / 2) % 2 == 1 then minetest.chat_send_all(composed_message) end
	if math.floor(DEBUG_FLAGS / 4) % 2 == 1 then minetest.log("info", composed_message) end
end
if DEBUG_FLAGS == 0 then
	-- do as little evaluation as possible
	nether.debug = function() end
end


-- Load files
dofile(nether.path .. "/portal_api.lua")
dofile(nether.path .. "/nodes.lua")
dofile(nether.path .. "/tools.lua")
dofile(nether.path .. "/crafts.lua")
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
			return pos.y < nether.DEPTH_CEILING and pos.y > nether.DEPTH_FLOOR
		end,

		find_realm_anchorPos = function(surface_anchorPos, player_name)
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
				destination_pos.y = nether.find_nether_ground_y(destination_pos.x, destination_pos.z, start_y, player_name)
				return destination_pos
			end
		end,

		find_surface_anchorPos = function(realm_anchorPos, player_name)
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
				destination_pos.y = nether.find_surface_target_y(destination_pos.x, destination_pos.z, "nether_portal", player_name)
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


	-- Set appropriate nether distance-fog if climate_api is available
	--
	-- Delegating to a mod like climate_api means nether won't unexpectedly stomp on the sky of
	-- any other mod.
	-- Skylayer is another mod which can perform this role, and skylayer support could be added
	-- here as well. However skylayer doesn't provide a position-based method of specifying sky
	-- colours out-of-the-box, so the nether mod will have to monitor when players enter and
	-- leave the nether.
	if minetest.get_modpath("climate_api") and minetest.global_exists("climate_api") and climate_api.register_weather ~= nil then

		climate_api.register_influence(
			"nether_biome",
			function(pos)
				local result = "surface"

				if pos.y <= nether.DEPTH_CEILING and pos.y >= nether.DEPTH_FLOOR then
					result = "nether"

					-- since mapgen_nobiomes.lua has no regions it doesn't implement getRegion(),
					-- so only use getRegion() if it exists
					if nether.mapgen.getRegion ~= nil then
						-- the biomes-based mapgen supports 2 extra regions
						local regions = nether.mapgen.RegionEnum
						local region  = nether.mapgen.getRegion(pos)
						if region == regions.CENTER or region == regions.CENTERSHELL then
							result = "mantle"
						elseif region == regions.NEGATIVE or region == regions.NEGATIVESHELL then
							result = "geode"
						end
					end
				end

				return result
			end
		)

		-- using sky type "plain" unfortunately means we don't get smooth fading transitions when
		-- the color of the sky changes, but it seems to be the only way to obtain a sky colour
		-- which doesn't brighten during the daytime.
		local undergroundSky = {
			sky_data = {
				base_color = nil,
				type = "plain",
				textures = nil,
				clouds = false,
			},
			sun_data = {
				visible = false,
				sunrise_visible = false
			},
			moon_data = {
				visible = false
			},
			star_data = {
				visible = false
			}
		}

		local netherSky, mantleSky, geodeSky = table.copy(undergroundSky), table.copy(undergroundSky), table.copy(undergroundSky)
		netherSky.sky_data.base_color = nether.fogColor.netherCaverns
		mantleSky.sky_data.base_color = nether.fogColor.mantle
		geodeSky.sky_data.base_color  = nether.fogColor.geodes

		climate_api.register_weather(
			"nether:nether",
			{ nether_biome = "nether" },
			{ ["climate_api:skybox"] = netherSky }
		)

		climate_api.register_weather(
			"nether:mantle",
			{ nether_biome = "mantle" },
			{ ["climate_api:skybox"] = mantleSky }
		)

		climate_api.register_weather(
			"nether:geode",
			{ nether_biome = "geode" },
			{ ["climate_api:skybox"] = geodeSky }
		)
	end

end -- end of "if nether.NETHER_REALM_ENABLED..."


-- Play bubbling lava sounds if player killed by lava
minetest.register_on_dieplayer(
	function(player, reason)
		if reason.node ~= nil and minetest.get_node_group(reason.node, "lava") > 0 or reason.node == "nether:lava_crust" then
			minetest.sound_play(
				"nether_lava_bubble",
				-- this sample was encoded at 3x speed to reduce .ogg file size
				-- at the expense of higher frequencies, so pitch it down ~3x
				{to_player = player:get_player_name(), pitch = 0.3, gain = 0.8}
			)
		end
	end
)