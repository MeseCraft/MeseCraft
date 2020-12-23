if not df_caverns.config.enable_underworld or not minetest.get_modpath("df_underworld_items") then
	return
end
local modname = minetest.get_current_modname()
local modpath = minetest.get_modpath(modname)
local S = minetest.get_translator(modname)

local bones_loot_path = minetest.get_modpath("bones_loot")
local named_waypoints_path = minetest.get_modpath("named_waypoints")
local name_generator_path = minetest.get_modpath("name_generator")

-- TEMP backwards compatibility for the change of name of the name_generator mod. Once it's updated in the contentDB, remove this and also the optional_depends
local namegenerator = nil
if not name_generator_path and minetest.get_modpath("namegen") and namegen and namegen.parse_lines and namegen.generate then
	namegenerator = namegen
elseif name_generator_path then
	namegenerator = name_generator
end

local hunters_enabled = minetest.get_modpath("hunter_statue") and df_underworld_items.config.underworld_hunter_statues

local name_pit = function() end
local name_ruin = function() end

if named_waypoints_path then

	local item_required = nil
	if minetest.settings:get_bool("dfcaverns_underworld_hud_requires_item", true) then
		local setting_item_required = minetest.settings:get("dfcaverns_underworld_hud_item_required")
		if setting_item_required == nil or setting_item_required == "" then
			setting_item_required = "map:mapping_kit"
		end	
		item_required = setting_item_required
	end

	local pit_waypoint_def = {
		default_name = S("A glowing pit"),
		default_color = 0xFF88FF,
		discovery_volume_radius = tonumber(minetest.settings:get("dfcaverns_pit_discovery_range")) or 60,
		visibility_requires_item = item_required,
	}	
	
	if minetest.settings:get_bool("dfcaverns_show_pits_in_hud", true) then
		pit_waypoint_def.visibility_volume_radius = tonumber(minetest.settings:get("dfcaverns_pit_visibility_range")) or 500
		pit_waypoint_def.on_discovery = named_waypoints.default_discovery_popup
	end
	named_waypoints.register_named_waypoints("glowing_pits", pit_waypoint_def)

	local seal_waypoint_def = {
		default_name = S("Mysterious seal"),
		default_color = 0x9C2233,
		discovery_volume_radius = tonumber(minetest.settings:get("dfcaverns_seal_discovery_range")) or 10,
		visibility_requires_item = item_required,
	}

	if minetest.settings:get_bool("dfcaverns_show_seals_in_hud", true) then
		seal_waypoint_def.visibility_volume_radius = tonumber(minetest.settings:get("dfcaverns_seal_visibility_range")) or 200
		seal_waypoint_def.on_discovery = named_waypoints.default_discovery_popup
	end
	named_waypoints.register_named_waypoints("puzzle_seals", seal_waypoint_def)

	if namegenerator then
		namegenerator.parse_lines(io.lines(modpath.."/underworld_names.cfg"))
		
		name_pit = function()
			return namegenerator.generate("glowing_pits")
		end
		name_ruin = function()
			return namegenerator.generate("underworld_ruins")
		end
		
		local underworld_ruin_def = {
			default_name = S("Ancient ruin"),
			discovery_volume_radius = tonumber(minetest.settings:get("dfcaverns_ruin_discovery_range")) or 40,
			visibility_requires_item = item_required,
		}
		if minetest.settings:get_bool("dfcaverns_show_ruins_in_hud", true) then
			underworld_ruin_def.visibility_volume_radius = tonumber(minetest.settings:get("dfcaverns_ruin_visibility_range")) or 250
			underworld_ruin_def.on_discovery = named_waypoints.default_discovery_popup
		end

		named_waypoints.register_named_waypoints("underworld_ruins", underworld_ruin_def)
	end
end



local c_slade = df_caverns.node_id.slade
local c_slade_block = df_caverns.node_id.slade_block
local c_air = df_caverns.node_id.air
local c_water = df_caverns.node_id.water

local c_glowstone = df_caverns.node_id.glowstone
local c_amethyst = df_caverns.node_id.amethyst
local c_pit_plasma = df_caverns.node_id.pit_plasma

local MP = minetest.get_modpath(minetest.get_current_modname())
local oubliette_schematic = dofile(MP.."/schematics/oubliette.lua")
local lamppost_schematic = dofile(MP.."/schematics/lamppost.lua")
local small_slab_schematic = dofile(MP.."/schematics/small_slab.lua")
local small_building_schematic = dofile(MP.."/schematics/small_building.lua")
local medium_building_schematic = dofile(MP.."/schematics/medium_building.lua")

local perlin_cave = {
	offset = 0,
	scale = 1,
	spread = {x=200, y=200, z=200},
	seed = 88233498,
	octaves = 6,
	persist = 0.67
}

-- large-scale rise and fall to make the seam between stone and slade less razor-flat
local perlin_wave = {
	offset = 0,
	scale = 1,
	spread = {x=1000, y=1000, z=1000},
	seed = 993455,
	octaves = 3,
	persist = 0.67
}

-- building zones
local perlin_zone = {
	offset = 0,
	scale = 1,
	spread = {x=500, y=500, z=500},
	seed = 199422,
	octaves = 3,
	persist = 0.67
}

local median = df_caverns.config.underworld_level
local floor_mult = 20
local floor_displace = -10
local ceiling_mult = -40
local ceiling_displace = 20
local wave_mult = 50

local y_max = median + 2*wave_mult + ceiling_displace + -2*ceiling_mult
local y_min = median - 2*wave_mult + floor_displace - 2*floor_mult

--df_caverns.config.underworld_min = y_min

--local poisson = mapgen_helper.get_poisson_points({x=-32000, z=-32000}, {x=32000, z=32000}, 1000)
--minetest.debug(dump(poisson.objects))

---------------------------------------------------------
-- Buildings

local oubliette_threshold = 0.8
local town_threshold = 1.1

local local_random = function(x, z)
	local next_seed = math.floor(math.random()*2^21)
	math.randomseed(x + z*2^16)
	local ret = math.random()
	math.randomseed(next_seed)
	return ret
end

-- create a deterministic list of buildings
local get_buildings = function(emin, emax, nvals_zone)
	local buildings = {}
	for x = emin.x, emax.x do
		for z = emin.z, emax.z do
		
			local index2d = mapgen_helper.index2d(emin, emax, x, z)
			local zone = math.abs(nvals_zone[index2d])
			
			if zone > oubliette_threshold and zone < town_threshold then
				-- oubliette zone
				--zone = (zone - oubliette_threshold)/(town_threshold-oubliette_threshold) -- turn this into a 0-1 spread
				local building_val = local_random(x, z)
				if building_val > 0.98 then
					building_val = (building_val - 0.98)/0.02
					local building_type
					if building_val < 0.8 then
						building_type = "oubliette"
					elseif building_val < 0.9 then
						building_type = "open oubliette"
					else
						building_type = "lamppost"
					end
					table.insert(buildings,
						{
							pos = {x=x, y=0, z=z}, -- y to be determined later
							building_type = building_type,
							bounding_box = {minpos={x=x-2, z=z-2}, maxpos={x=x+2, z=z+2}},
							priority = math.floor(building_val * 10000000) % 1000, -- indended to allow for deterministic removal of overlapping buildings
						}						
					)
				end
			elseif zone > town_threshold then
				-- town zone
				local building_val = local_random(x, z)
				if building_val > 0.9925 then
					building_val = (building_val - 0.9925)/0.0075
	
					local building_type
					local bounding_box
					local priority = math.floor(building_val * 10000000) % 1000
					local rotation = (priority % 4) * 90
	
					if building_val < 0.75 then
						building_type = "small building"
						local boundmin, boundmax = mapgen_helper.get_schematic_bounding_box({x=x, y=0, z=z}, small_building_schematic, rotation)
						bounding_box = {minpos=boundmin, maxpos=boundmax}
					elseif building_val < 0.85 then
						building_type = "medium building"
						local boundmin, boundmax = mapgen_helper.get_schematic_bounding_box({x=x, y=0, z=z}, medium_building_schematic, rotation)
						bounding_box = {minpos=boundmin, maxpos=boundmax}					
					else
						building_type = "small slab"
						local boundmin, boundmax = mapgen_helper.get_schematic_bounding_box({x=x, y=0, z=z}, small_slab_schematic, rotation)
						bounding_box = {minpos=boundmin, maxpos=boundmax}						
					end
					
					table.insert(buildings,
						{
							pos = {x=x, y=0, z=z}, -- y to be determined later
							building_type = building_type,
							bounding_box = bounding_box,
							rotation = rotation,
							priority = priority, -- indended to allow for deterministic removal of overlapping buildings
						}
					)
				end
			end
		end
	end
	
	-- eliminate overlapping buildings
	local building_count = table.getn(buildings)
	local overlap_count = 0
	for i = 1, building_count-1 do
		local curr_building = buildings[i]
		for j = i+1, building_count do
			local test_building = buildings[j]
			if test_building ~= nil and curr_building ~= nil and mapgen_helper.intersect_exists_xz(
				curr_building.bounding_box.minpos,
				curr_building.bounding_box.maxpos,
				test_building.bounding_box.minpos,
				test_building.bounding_box.maxpos) then
				
				if curr_building.priority < test_building.priority then -- this makes elimination of overlapping buildings deterministic
					buildings[i] = nil
					j=building_count+1
				else
					buildings[j] = nil
				end
				overlap_count = overlap_count + 1
			end
		end
	end
	
	if building_count > 50 and overlap_count > building_count * 2/3 then
		minetest.log("warning", "[df_caverns] underworld mapgen generated " ..
			tostring(building_count) .. " buildings and " .. tostring(overlap_count) ..
			" were eliminated as overlapping, if this happens a lot consider reducing building" ..
			" generation probability to improve efficiency.")
	end
	
	local compacted_buildings = {}
	for _, building in pairs(buildings) do
		compacted_buildings[minetest.hash_node_position(building.pos)] = building
	end
	
	return compacted_buildings
end

-----------------------------------------------------------
-- Pits

local radius_pit_max = 40 -- won't actually be this wide, there'll be crystal spires around it
local radius_pit_variance = 10
local plasma_depth_min = 5
local plasma_depth_max = 75

local region_mapblocks = df_caverns.config.underworld_glowing_pit_mapblocks -- One glowing pit in each region this size
local mapgen_chunksize = tonumber(minetest.get_mapgen_setting("chunksize"))
local pit_region_size = region_mapblocks * mapgen_chunksize * 16

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

local mapgen_seed = tonumber(minetest.get_mapgen_setting("seed")) % 2^21

local get_pit = function(pos)
	if region_mapblocks < 1 then return nil end

	local corner_xz = get_corner(pos)
	local next_seed = math.floor(math.random() * 2^21)
	math.randomseed(corner_xz.x + corner_xz.z * 2 ^ 8 + mapgen_seed)
	local location = scatter_2d(corner_xz, pit_region_size, radius_pit_max + radius_pit_variance)
	local variance_multiplier = math.random()
	local radius = variance_multiplier * (radius_pit_max - 15) + 15
	local variance = radius_pit_variance/2 + radius_pit_variance*variance_multiplier/2
	local depth = math.random(plasma_depth_min, plasma_depth_max)	
	math.randomseed(next_seed)
	return {location = location, radius = radius, variance = variance, depth = depth}
end

local perlin_pit = {
	offset = 0,
	scale = 1,
	spread = {x=30, y=30, z=30},
	seed = 901,
	octaves = 3,
	persist = 0.67
}

-------------------------------------

minetest.register_chatcommand("find_pit", {
	params = "",
	privs = {server=true},
	decription = "find a nearby glowing pit",
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		local pit = get_pit(player:get_pos())
		if pit then
			minetest.chat_send_player(name, "Pit location: x=" .. math.floor(pit.location.x) .. " z=" .. math.floor(pit.location.z))
		end
	end,
})

minetest.register_on_generated(function(minp, maxp, seed)

	--if out of range of cave definition limits, abort
	if minp.y > y_max or maxp.y < y_min then
		return
	end

	local t_start = os.clock()

	local vm, data, data_param2, area = mapgen_helper.mapgen_vm_data_param2()
	local emin = area.MinEdge
	local emax = area.MaxEdge
	
	local nvals_cave = mapgen_helper.perlin2d("df_caverns:underworld_cave", emin, emax, perlin_cave) --cave noise for structure
	local nvals_wave = mapgen_helper.perlin2d("df_caverns:underworld_wave", emin, emax, perlin_wave) --cave noise for structure
	local nvals_zone = mapgen_helper.perlin2d("df_caverns:underworld_zone", emin, emax, perlin_zone) --building zones
	
	local pit = get_pit(minp)
	--minetest.chat_send_all(minetest.pos_to_string(pit.location))

	local buildings = get_buildings(emin, emax, nvals_zone)
	
	local pit_uninitialized = true
	local nvals_pit, area_pit
	
	for vi, x, y, z in area:iterp_yxz(minp, maxp) do
		if y > y_min then
			local index2d = mapgen_helper.index2d(emin, emax, x, z)
			local abs_cave = math.abs(nvals_cave[index2d]) -- range is from 0 to approximately 2, with 0 being connected and 2s being islands
			local wave = nvals_wave[index2d] * wave_mult
			
			local floor_height =  math.floor(abs_cave * floor_mult + median + floor_displace + wave)
			
			if named_waypoints_path and floor_height == y and pit and pit.location.x == x and pit.location.z == z then
				named_waypoints.add_waypoint("glowing_pits", {x=x, y=y, z=z}, {name=name_pit()})
			end

			local underside_height = math.floor(y_min + math.abs(wave) / 5)+2 -- divide wave by five to smooth out the underside of the slade, we only want the interface to ripple a little down here
			local ceiling_height =  math.floor(abs_cave * ceiling_mult + median + ceiling_displace + wave)
			if (y == underside_height or y == underside_height - 1) and (x % 8 == 0 or z % 8 == 0) then
				data[vi] = c_air
			elseif y < floor_height and y > underside_height then 
				data[vi] = c_slade
				if	pit and
					pit.location.x - radius_pit_max - radius_pit_variance < maxp.x and
					pit.location.x + radius_pit_max + radius_pit_variance > minp.x and
					pit.location.z - radius_pit_max - radius_pit_variance < maxp.z and
					pit.location.z + radius_pit_max + radius_pit_variance > minp.z
				then
					-- there's a pit nearby
					if pit_uninitialized then
						nvals_pit, area_pit = mapgen_helper.perlin3d("df_cavern:perlin_cave", minp, maxp, perlin_pit)
						pit_uninitialized = false
					end
					local pit_value = nvals_pit[area_pit:index(x,y,z)] * pit.variance
					local distance = vector.distance({x=x, y=y, z=z}, {x=pit.location.x, y=y, z=pit.location.z}) + pit_value
					if distance < pit.radius -2.5 then
						if y < median + floor_displace + wave - pit.depth or y < underside_height + plasma_depth_min then
							data[vi] = c_pit_plasma
						else
							data[vi] = c_air
						end
					elseif distance < pit.radius then
						data[vi] = c_amethyst
					elseif distance < radius_pit_max and y == floor_height - 4 then
						if math.random() > 0.95 then
							df_underworld_items.underworld_shard(data, area, vi)
						end
					end
				end
			elseif y >= floor_height and y < ceiling_height and data[vi] ~= c_amethyst then
				data[vi] = c_air
			elseif data[vi] == c_water then
				data[vi] = c_air -- no water down here
			end
		end
	end

	-- Ceiling decoration
	for x = minp.x + 1, maxp.x-1 do
		for z = minp.z + 1, maxp.z -1 do
			local index2d = mapgen_helper.index2d(emin, emax, x, z)
			local abs_cave = math.abs(nvals_cave[index2d]) -- range is from 0 to approximately 2, with 0 being connected and 2s being islands
			local wave = nvals_wave[index2d] * wave_mult
			local floor_height = math.floor(abs_cave * floor_mult + median + floor_displace + wave)
			local ceiling_height = math.floor(abs_cave * ceiling_mult + median + ceiling_displace + wave)
	
			if ceiling_height > floor_height + 5 and ceiling_height < maxp.y and ceiling_height > minp.y then
				local vi = area:index(x, ceiling_height, z)
				if (
					--test if we're nestled in a crevice
					(not mapgen_helper.buildable_to(data[vi-area.ystride + 1]) and not mapgen_helper.buildable_to(data[vi-area.ystride - 1])) or
					(not mapgen_helper.buildable_to(data[vi-area.ystride + area.zstride]) and not mapgen_helper.buildable_to(data[vi-area.ystride - area.zstride]))
				)
				then
					data[vi] = c_glowstone
				end
			end
		end
	end

	-- buildings
	for x = emin.x + 5, emax.x - 5 do
		for z = emin.z + 5, emax.z - 5 do
		
			local skip = false
			if	pit and
				pit.location.x - radius_pit_max - radius_pit_variance < x and
				pit.location.x + radius_pit_max + radius_pit_variance > x and
				pit.location.z - radius_pit_max - radius_pit_variance < z and
				pit.location.z + radius_pit_max + radius_pit_variance > z
			then
				if vector.distance(pit.location, {x=x, y=0, z=z}) < radius_pit_max + radius_pit_variance then
					-- there's a pit nearby
					skip = true
				end
			end
			if not skip then
				local index2d = mapgen_helper.index2d(emin, emax, x, z)
				local abs_cave = math.abs(nvals_cave[index2d]) -- range is from 0 to approximately 2, with 0 being connected and 2s being islands
				local wave = nvals_wave[index2d] * wave_mult
				local floor_height = math.floor(abs_cave * floor_mult + median + floor_displace + wave)
				local ceiling_height = math.floor(abs_cave * ceiling_mult + median + ceiling_displace + wave)
				
				if ceiling_height > floor_height and floor_height <= maxp.y and floor_height >= minp.y  then
					local building = buildings[minetest.hash_node_position({x=x,y=0,z=z})]
					if building ~= nil then
						building.pos.y = floor_height
						--minetest.chat_send_all("placing " .. building.building_type .. " at " .. minetest.pos_to_string(building.pos))
						if building.building_type == "oubliette" then
							mapgen_helper.place_schematic_on_data(data, data_param2, area, building.pos, oubliette_schematic)
						elseif building.building_type == "open oubliette" then
							mapgen_helper.place_schematic_on_data(data, data_param2, area, building.pos, oubliette_schematic, 0, {["df_underworld_items:slade_seal"] = "air"})
						elseif building.building_type == "lamppost" then
							mapgen_helper.place_schematic_on_data(data, data_param2, area, building.pos, lamppost_schematic)
						elseif building.building_type == "small building" then
							mapgen_helper.place_schematic_on_data(data, data_param2, area, building.pos, small_building_schematic, building.rotation)
						elseif building.building_type == "medium building" then
							mapgen_helper.place_schematic_on_data(data, data_param2, area, building.pos, medium_building_schematic, building.rotation)
							if named_waypoints_path and namegenerator then
								if not next(named_waypoints.get_waypoints_in_area("underworld_ruins", vector.subtract(building.pos, 250), vector.add(building.pos, 250))) then
									named_waypoints.add_waypoint("underworld_ruins", {x=building.pos.x, y=floor_height+1, z=building.pos.z}, {name=name_ruin()})
								end
							end							
						elseif building.building_type == "small slab" then
							mapgen_helper.place_schematic_on_data(data, data_param2, area, building.pos, small_slab_schematic, building.rotation)
						else
							minetest.log("error", "unrecognized underworld building type: " .. tostring(building.building_type))
						end
					end
				end	
			end
		end
	end
	
	-- puzzle seal
	local puzzle_seal = nil	
	if pit_uninitialized and math.random() < 0.05 then
		local index2d = mapgen_helper.index2d(emin, emax, minp.x + 3, minp.z + 3)
		local abs_cave = math.abs(nvals_cave[index2d]) -- range is from 0 to approximately 2, with 0 being connected and 2s being islands
		local wave = nvals_wave[index2d] * wave_mult
			
		local floor_height =  math.floor(abs_cave * floor_mult + median + floor_displace + wave)
		local underside_height = math.floor(y_min + math.abs(wave) / 5)

		if floor_height < maxp.y and floor_height > minp.y then
			for plat_vi in area:iter(minp.x, floor_height-6, minp.z, minp.x+6, floor_height, minp.z+6) do
				data[plat_vi] = c_slade_block
			end
			puzzle_seal = {x=minp.x+3, y=floor_height+1, z=minp.z+3}
			minetest.log("info", "Puzzle seal generated at " .. minetest.pos_to_string(puzzle_seal))
		end
	end

	--send data back to voxelmanip
	vm:set_data(data)
	vm:set_param2_data(data_param2)
	--calc lighting
	vm:set_lighting({day = 0, night = 0})
	vm:calc_lighting()
	vm:update_liquids()
	--write it to world
	vm:write_to_map()
	
	if puzzle_seal ~= nil then
		if named_waypoints_path then
			named_waypoints.add_waypoint("puzzle_seals", puzzle_seal)
		end

		minetest.place_schematic({x=puzzle_seal.x-3, y=puzzle_seal.y, z=puzzle_seal.z-3}, df_underworld_items.seal_temple_schem, 0, {}, true)
		local node_name = minetest.get_node(puzzle_seal).name
		local node_def = minetest.registered_nodes[node_name]
		node_def.on_construct(puzzle_seal)
	end
	
	if bones_loot_path then
		for i = 1, 30 do
			local x = math.random(minp.x, maxp.x)
			local z = math.random(minp.z, maxp.z)
			local index2d = mapgen_helper.index2d(emin, emax, x, z)
			local abs_cave = math.abs(nvals_cave[index2d]) -- range is from 0 to approximately 2, with 0 being connected and 2s being islands
			local wave = nvals_wave[index2d] * wave_mult
			local floor_height =  math.floor(abs_cave * floor_mult + median + floor_displace + wave)-1
			local ceiling_height =  math.floor(abs_cave * ceiling_mult + median + ceiling_displace + wave)
			if floor_height < ceiling_height then
				local zone = math.abs(nvals_zone[index2d])
				if math.random() < zone then -- bones are more common in the built-up areas
					local floor_node = minetest.get_node({x=x, y=floor_height, z=z})
					local floor_node_def = minetest.registered_nodes[floor_node.name]
					if floor_node_def and not floor_node_def.buildable_to then
						local y = floor_height + 1
						while y < ceiling_height do
							local target_pos = {x=x, y=y, z=z}
							local target_node = minetest.get_node(target_pos)
							if target_node.name == "air" then
								bones_loot.place_bones(target_pos, "underworld_warrior", math.random(3, 10), nil, true)
								break
							elseif target_node.name == "bones:bones" then
								-- don't stack bones on bones, it looks silly
								break
							end
							y = y + 1
						end
					end
				end
			end
		end
	end
	
	if hunters_enabled then
		local x = math.random(minp.x, maxp.x)
		local z = math.random(minp.z, maxp.z)
		local index2d = mapgen_helper.index2d(emin, emax, x, z)
		local abs_cave = math.abs(nvals_cave[index2d]) -- range is from 0 to approximately 2, with 0 being connected and 2s being islands
		local wave = nvals_wave[index2d] * wave_mult
		local floor_height =  math.floor(abs_cave * floor_mult + median + floor_displace + wave)-1
		local zone = math.abs(nvals_zone[index2d])
		if math.random() < zone / 4 then -- hunters are more common in the built-up areas. zone/4 gives ~ 400 hunters per square kilometer.
			for y = floor_height, floor_height+20 do
				local target_pos = {x=x, y=y, z=z}
				local target_node = minetest.get_node(target_pos)
				if minetest.get_item_group(target_node.name, "slade") == 0 then
					minetest.set_node(target_pos, {name="df_underworld_items:hunter_statue"})
					break
				end
			end
		end
		
	end
	
	local time_taken = os.clock() - t_start -- how long this chunk took, in seconds
	mapgen_helper.record_time("df_caverns underworld", time_taken)
end)
