pit_caves = {}

local modpath = minetest.get_modpath(minetest.get_current_modname())
local S = minetest.get_translator(minetest.get_current_modname())

local min_depth = tonumber(minetest.settings:get("pit_caves_min_bottom") or -2500)
local max_depth = tonumber(minetest.settings:get("pit_caves_max_bottom") or -500)
local min_top = tonumber(minetest.settings:get("pit_caves_min_top") or -100)
local max_top = tonumber(minetest.settings:get("pit_caves_max_top") or 100)

local seal_ocean = minetest.settings:get_bool("pit_caves_seal_ocean", true)

assert(min_depth < max_depth, "pit_caves_min_bottom is above pit_caves_max_bottom")
assert(min_top < max_top, "pit_caves_min_top is above pit_caves_max_top")
assert(max_depth < min_top, "pit_caves_max_bottom is above pit_caves_min_top")

local pit_radius = 3 -- approximate minimum radius of pit - noise adds a lot to this

local region_mapblocks = tonumber(minetest.settings:get("pit_caves_mapblock_spacing") or 16)
local mapgen_chunksize = tonumber(minetest.get_mapgen_setting("chunksize"))
local pit_region_size = region_mapblocks * mapgen_chunksize * 16

local c_air = minetest.get_content_id("air")
local c_gravel = c_air
local water_node
if minetest.get_modpath("default") then
	c_gravel = minetest.get_content_id("default:gravel")
	if seal_ocean then
		water_node = "default:water_source"
	end
end

local log_location
if minetest.get_modpath("mapgen_helper") and mapgen_helper.log_location_enabled then
	log_location = mapgen_helper.log_first_location
end

local ignore
if minetest.get_modpath("chasms") then
	-- the chasms mod already sets up a method to allow chasms to avoid overwriting stalactites and whatnot,
	-- hijack that.
	ignore = chasms.ignore_content_id
end

local water_level = tonumber(minetest.get_mapgen_setting("water_level"))
local mapgen_seed = tonumber(minetest.get_mapgen_setting("seed")) % 2^16

local scatter_2d = function(min_xz, gridscale, border_width)
	local bordered_scale = gridscale - 2 * border_width
	local point = {}
	point.x = math.floor(math.random() * bordered_scale + min_xz.x + border_width)
	point.y = 0
	point.z = math.floor(math.random() * bordered_scale + min_xz.z + border_width)
	return point
end

-- For some reason, map chunks generate with -32, -32, -32 as the "origin" minp. To make the large-scale grid align with map chunks it needs to be offset like this.
local get_corner = function(pos)
	return {x = math.floor((pos.x+32) / pit_region_size) * pit_region_size - 32, z = math.floor((pos.z+32) / pit_region_size) * pit_region_size - 32}
end

local get_pit = function(pos)
	local corner_xz = get_corner(pos)
	local next_seed = math.random(1, 1000000000)
	math.randomseed(corner_xz.x + corner_xz.z * 2 ^ 8 + mapgen_seed + 1)

	local location = scatter_2d(corner_xz, pit_region_size, 0)
	local depth = math.floor(math.random() * (max_depth - min_depth) + min_depth)
	local top = math.floor(math.random() * (max_top - min_top) + min_top)
	
	math.randomseed(next_seed)
	return {location = location, depth = depth, top = top}
end

pit_caves.get_nearest_pit = get_pit

local perlin_params = {
	offset = 0,
	scale = 1,
	spread = {x=30, y=30, z=30},
	seed = 45011,
	octaves = 3,
	persist = 0.67
}
local data = {}

minetest.register_on_generated(function(minp, maxp, seed)
	if minp.y > max_top or maxp.y < min_depth then
		return
	end

	local pit = get_pit(minp)
	
	if pit == nil then
		return -- no pit in this map region
	end
	
	local location_x = pit.location.x
	local location_z = pit.location.z
	
	-- early out if the pit is too far away to matter
	-- The plus 20 is because the noise being added will generally be in the 0-20 range, see the "distance" calculation below
	if	location_x - 20 > maxp.x or 
		location_x + 20 < minp.x or 
		location_z - 20 > maxp.z or
		location_z + 20 < minp.z
	then
		return
	end
	
	local top = pit.top
	local depth = pit.depth

	local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
	local area = VoxelArea:new{MinEdge=emin, MaxEdge=emax}
	vm:get_data(data)

	if water_node and minp.y <= water_level and maxp.y >= water_level-240 then
		local test_node = minetest.get_node(vector.new(location_x, water_level, location_z))
		if test_node.name == water_node then
			top = math.min(-32, top) -- we're coming up under the ocean, abort the pit.
			-- note that this does depend on the water-level map block having been generated already,
			-- which could lead to a sharp cutoff if that's not the case - if the player's coming
			-- up a pit from below into an unexplored ocean, for example. But it should still at least
			-- seal the hole before the ocean pours down into it, so that's acceptable. And I expect
			-- most of the time the surface world will be explored first before pits are discovered.
		end
	end

	local nvals_perlin = mapgen_helper.perlin3d("pit_caves:pit", emin, emax, perlin_params)
		
	for vi, x, y, z in area:iterp_xyz(emin, emax) do
		if not (ignore and ignore(data[vi])) then
			local distance_perturbation = (nvals_perlin[vi]+1)*10
			local distance = vector.distance({x=x, y=y, z=z}, {x=location_x, y=y, z=location_z}) - distance_perturbation
			local taper_min = top - 40

			if y < top and y > depth then
				if y > top - 40 then
					-- taper the top end
					distance = distance - ((taper_min - y)/2)
				end
			
				if distance < pit_radius then
					if y < depth + 20 and data[vi] ~= c_air then
						data[vi] = c_gravel
					else
						data[vi] = c_air
						if log_location then log_location("pit_cave", vector.new(x,y,z)) end
					end
				end
			end
		end
	end
	
	--send data back to voxelmanip
	vm:set_data(data)
	--calc lighting
	vm:set_lighting({day = 0, night = 0})
	vm:calc_lighting()
	vm:update_liquids()
	--write it to world
	vm:write_to_map()
end)

----------------------------------------------------------------------------------------------
-- Debugging and sightseeing commands

function round(val, decimal)
  if (decimal) then
    return math.floor( (val * 10^decimal) + 0.5) / (10^decimal)
  else
    return math.floor(val+0.5)
  end
end

local send_pit_state = function(pos, name)
	local pit = get_pit(pos)
	if pit == nil then
		return false
	end
	local location = {x=math.floor(pit.location.x), y=pit.top, z=math.floor(pit.location.z)}
	minetest.chat_send_player(name, S("Pit at @1, bottom @2", minetest.pos_to_string(location), pit.depth))
	return true
end

local send_nearby_states = function(pos, name)
	local retval = false
	retval = send_pit_state({x=pos.x-pit_region_size, y=0, z=pos.z+pit_region_size}, name) or retval
	retval = send_pit_state({x=pos.x, y=0, z=pos.z+pit_region_size}, name) or retval
	retval = send_pit_state({x=pos.x+pit_region_size, y=0, z=pos.z+pit_region_size}, name) or retval
	retval = send_pit_state({x=pos.x-pit_region_size, y=0, z=pos.z}, name) or retval
	retval = send_pit_state(pos, name) or retval
	retval = send_pit_state({x=pos.x+pit_region_size, y=0, z=pos.z}, name) or retval
	retval = send_pit_state({x=pos.x-pit_region_size, y=0, z=pos.z-pit_region_size}, name) or retval
	retval = send_pit_state({x=pos.x, y=0, z=pos.z-pit_region_size}, name) or retval
	retval = send_pit_state({x=pos.x+pit_region_size, y=0, z=pos.z-pit_region_size}, name) or retval
	return retval
end

minetest.register_chatcommand("find_pit_caves", {
    params = "pos", -- Short parameter description
    description = S("find the pits near the player's map region, or in the map region containing pos if provided"),
    func = function(name, param)
		if minetest.check_player_privs(name, {server = true}) then
			local pos = {}
			pos.x, pos.y, pos.z = string.match(param, "^([%d.-]+)[, ] *([%d.-]+)[, ] *([%d.-]+)$")
			pos.x = tonumber(pos.x)
			pos.y = tonumber(pos.y)
			pos.z = tonumber(pos.z)
			if pos.x and pos.y and pos.z then
				if not send_nearby_states(pos, name) then
					minetest.chat_send_player(name, S("No pits near @1", minetest.pos_to_string(pos)))
				end
				return true
			else
				local playerobj = minetest.get_player_by_name(name)
				pos = playerobj:get_pos()
				if not send_nearby_states(pos, name) then
					pos.x = math.floor(pos.x)
					pos.y = math.floor(pos.y)
					pos.z = math.floor(pos.z)
					minetest.chat_send_player(name, S("No pits near @1", minetest.pos_to_string(pos)))
				end
				return true
			end
		else
			return false, S("You need the server privilege to use this command.")
		end
	end,
})