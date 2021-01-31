local S = settlements.S

local c_air = minetest.get_content_id("air")

local default_path_material = "default:gravel"
local default_deep_platform = "default:stone"
local default_shallow_platform = "default:dirt"

local surface_mats = settlements.surface_materials

local settlement_waypoint_def = {
	default_name = S("a settlement"),
	default_color = 0xFFFFFF,
	discovery_volume_radius = tonumber(minetest.settings:get("settlements_discovery_range")) or 30,
}
if minetest.settings:get_bool("settlements_hud_requires_item", true) then
	local item_required = minetest.settings:get("settlements_hud_item_required")
	if item_required == nil or item_required == "" then
		item_required = "map:mapping_kit"
	end	
	settlement_waypoint_def.visibility_requires_item = item_required
end
if minetest.settings:get_bool("settlements_show_in_hud", true) then
	settlement_waypoint_def.visibility_volume_radius = tonumber(minetest.settings:get("settlements_visibility_range")) or 600
	settlement_waypoint_def.on_discovery = named_waypoints.default_discovery_popup
end
named_waypoints.register_named_waypoints("settlements", settlement_waypoint_def)

local buildable_to_set
local buildable_to = function(c_node)
	if buildable_to_set then return buildable_to_set[c_node] end
	buildable_to_set = {}
	for k, v in pairs(minetest.registered_nodes) do
		if v.buildable_to then
			buildable_to_set[minetest.get_content_id(k)] = true
		end
	end

	-- TODO: some way to discriminate between registered_settlements? For now, apply ignore_materials universally.
	for _, def in pairs(settlements.registered_settlements) do
		if def.ignore_surface_materials then
			for _, ignore_material in ipairs(def.ignore_surface_materials) do
				buildable_to_set[minetest.get_content_id(ignore_material)] = true
			end
		end
	end

	return buildable_to_set[c_node]
end

-- function to fill empty space below baseplate when building on a hill
local function ground(pos, data, va, c_shallow, c_deep) -- role model: Wendelsteinkircherl, Brannenburg
	local p2 = vector.new(pos)
	local cnt = 0
	local mat = c_shallow
	p2.y = p2.y-1
	local depth =  math.random(2,4)
	while true do
		cnt = cnt+1
		if cnt > 20 then break end
		if cnt > depth then mat = c_deep end
		local vi = va:index(p2.x, p2.y, p2.z)
		if not buildable_to(data[vi]) then break end -- stop when we hit solid ground
		data[vi] = mat
		p2.y = p2.y-1
	end
end

-- for displacing building schematic positions so that they're more centered
local function get_corner_pos(center_pos, schematic, rotation)
	local pos = center_pos
	local size = vector.new(schematic.size)
	size.y = 0
	if rotation == "90" or rotation == "270" then
		local tempz = size.z
		size.z = size.x
		size.x = tempz
	end
	local corner1 = vector.subtract(pos, vector.floor(vector.divide(size, 2)))
	local corner2 = vector.add(schematic.size, corner1)
	return corner1, corner2
end

local group_ids = {}
local is_in_group = function(c_id, groupname)
	local grouplist = group_ids[groupname]
	if grouplist then
		return grouplist[c_id]
	end
	grouplist = {}
	for name, def in pairs(minetest.registered_nodes) do
		if minetest.get_item_group(name, groupname) > 0 then
			grouplist[minetest.get_content_id(name)] = true
		end
	end
	group_ids[groupname] = grouplist
	return grouplist[c_id]
end

-- function clear space above baseplate
local function terraform(data, va, settlement_info)
	local c_air = minetest.get_content_id(settlement_info.def.platform_air or "air")
	local c_shallow = minetest.get_content_id(settlement_info.def.platform_shallow or default_shallow_platform)
	local c_deep = minetest.get_content_id(settlement_info.def.platform_deep or default_deep_platform)
	local fheight
	local fwidth
	local fdepth

	for _, built_house in ipairs(settlement_info) do
		local schematic_data = built_house.schematic_info

		local replace_air = schematic_data.platform_clear_above
		local build_platform = schematic_data.platform_build_below
		if replace_air == nil then
			replace_air = true
		end
		if build_platform == nil then
			build_platform = true
		end

		local skip_group_above = schematic_data.platform_ignore_group_above
		if skip_group_above then
			skip_group_above = skip_group_above:gsub("^group:", "")
		end

		local size = schematic_data.schematic.size
		local pos = built_house.build_pos_min
		if built_house.rotation == "0" or built_house.rotation == "180"
		then
			fwidth = size.x
			fdepth = size.z
		else
			fwidth = size.z
			fdepth = size.x
		end
		fheight = size.y
		if replace_air then-- remove trees and leaves above
			fheight = fheight * 3
		end
		--
		-- now that every info is available -> create platform and clear space above
		--
		for zi = 0,fdepth-1 do
			for yi = 0,fheight do
				for xi = 0,fwidth-1 do
					if yi == 0 and build_platform then
						local p = {x=pos.x+xi, y=pos.y, z=pos.z+zi}
						ground(p, data, va, c_shallow, c_deep)
					elseif replace_air then
						local p = vector.new(pos.x+xi, pos.y+yi, pos.z+zi)
						local vi = va:indexp(p)
						if not (skip_group_above and is_in_group(data[vi], skip_group_above)) then
							data[vi] = c_air
						end
					end
				end
			end
		end
	end
end

-------------------------------------------------------------------------------
-- function to find surface block y coordinate
-------------------------------------------------------------------------------
local function find_surface(pos, data, va, altitude_min, altitude_max)
	if not va:containsp(pos) then return nil end

	local y = pos.y

	-- starting point for looking for surface
	local previous_vi = va:indexp(pos)
	local previous_node = data[previous_vi]
	local itter -- count up or down
	if buildable_to(previous_node) then
		itter = -1 -- going down
	else
		itter = 1 -- going up
	end
	for cnt = 0, 100 do
		local next_vi = previous_vi + va.ystride * itter
		y = y + itter
		if (altitude_min and altitude_min > y) or (altitude_max and altitude_max < y) then
			-- an altitude range was specified and we're outside it
			return nil
		end
		if not va:containsi(next_vi) then return nil end
		local next_node = data[next_vi]
		if buildable_to(previous_node) ~= buildable_to(next_node) then
			--we transitioned through what may be a surface. Test if it was the right material.
			local above_node, below_node, above_vi, below_vi
			if itter > 0 then
				-- going up
				above_node, below_node = next_node, previous_node
				above_vi, below_vi = next_vi, previous_vi
			else
				above_node, below_node = previous_node, next_node
				above_vi, below_vi = previous_vi, next_vi
			end
			if surface_mats[below_node] then
				return va:position(below_vi), below_node
			else
				return nil
			end
		end
		previous_vi = next_vi
		previous_node = next_node
	end
	return nil
end

local function shallowCopy(original)
	local copy = {}
	for key, value in pairs(original) do
		copy[key] = value
	end
	return copy
end

-- randomize table
local function shuffle(tbl)
	local ret = shallowCopy(tbl)
	local size = #ret
	for i = size, 1, -1 do
		local rand = math.random(size)
		ret[i], ret[rand] = ret[rand], ret[i]
	end
	return ret
end

-- If the building fits into the areastore without overlapping existing buildings,
-- add it to the areastore and return true. Otherwise return false.
local function insert_into_area(building, areastore)
	local buffer = building.schematic_info.buffer or 0
	local edge1 = vector.new(building.build_pos_min)
	edge1 = vector.subtract(edge1, buffer)
	edge1.y = 0
	local edge2 = vector.new(building.build_pos_max)
	edge2 = vector.add(edge2, buffer)
	edge2.y = 1

	local result = areastore:get_areas_in_area(edge1, edge2, true)
	if next(result) then
		return false
	end
	areastore:insert_area(edge1, edge2, "")
	return true
end

local possible_rotations = {"0", "90", "180", "270"}

-------------------------------------------------------------------------------
-- everything necessary to pick a fitting next building
-------------------------------------------------------------------------------
local function pick_next_building(pos_surface, surface_material, count_buildings, settlement_info, settlement_def, areastore)
	local number_of_buildings = settlement_info.number_of_buildings
	local randomized_schematic_table = shuffle(settlement_def.schematics)
	-- pick schematic
	local size = #randomized_schematic_table
	for i = size, 1, -1 do
		-- already enough buildings of that type?
		local current_schematic = randomized_schematic_table[i]
		local current_schematic_name = current_schematic.name
		count_buildings[current_schematic_name] = count_buildings[current_schematic_name] or 0
		if count_buildings[current_schematic_name] < current_schematic.max_num*number_of_buildings then
			local rotation = possible_rotations[math.random(#possible_rotations)]
			local corner1, corner2 = get_corner_pos(pos_surface, current_schematic.schematic, rotation)
			local building_info = {
				center_pos = pos_surface,
				build_pos_min = corner1,
				build_pos_max = corner2,
				schematic_info = current_schematic,
				rotation = rotation,
				surface_mat = surface_material,
			}
			if insert_into_area(building_info, areastore) then
				count_buildings[current_schematic.name] = count_buildings[current_schematic.name] +1
				return building_info
			end
		end
	end
	return nil
end

local function select_replacements(source)
	local destination = {}
	if source then
		for original, replacement in pairs(source) do
			if type(replacement) == "table" then
				replacement = replacement[math.random(1, #replacement)]
			end
			destination[original] = replacement
		end
	end
	return destination
end

-------------------------------------------------------------------------------
-- fill settlement_info with LVM
--------------------------------------------------------------------------------
local function create_site_plan(minp, maxp, data, va, existing_settlement_name)
	-- find center of chunk
	local center = vector.floor({
		x=maxp.x-(maxp.x - minp.x)/2,
		y=maxp.y,
		z=maxp.z-(maxp.z - minp.z)/2,
	})
	-- find center_surface of chunk
	local center_surface_pos, surface_material = find_surface(center, data, va)
	if not center_surface_pos then
		return nil
	end

	-- get a list of all the settlement defs that can be made on this surface mat
	local material_defs = surface_mats[surface_material]
	local registered_settlements = {}
	-- cull out any that have altitude min/max set outside the range of the chunk
	for _, def in ipairs(material_defs) do
		if (not def.altitude_min or def.altitude_min < maxp.y) and
			(not def.altitude_max or def.altitude_max > minp.y) then
			table.insert(registered_settlements, def)
		end
	end
	-- Nothing to pick from
	if #registered_settlements == 0 then
		return nil
	end

	 -- pick one at random
	local settlement_def = registered_settlements[math.random(1, #registered_settlements)]

	-- Get a name for the settlement.
	local name = existing_settlement_name or settlement_def.generate_name(center)

	local min_number = settlement_def.building_count_min or 5
	local max_number = settlement_def.building_count_max or 25

	local settlement_info = {}
	settlement_info.def = settlement_def
	settlement_info.name = name
	local number_of_buildings = math.random(min_number, max_number)
	settlement_info.number_of_buildings = number_of_buildings
	local areastore = AreaStore() -- An efficient structure for storing building footprints and testing for overlaps
	settlement_info.areastore = areastore
	areastore:reserve(number_of_buildings)

	settlement_info.replacements = select_replacements(settlement_def.replacements)
	settlement_info.replacements_optional = select_replacements(settlement_def.replacements_optional)

	local count_buildings = {}

	-- first building is selected from the central_schematics list, or randomly from schematics if that isn't defined.
	local central_list = settlement_def.central_schematics or settlement_def.schematics

	local townhall = central_list[math.random(#central_list)]
	local rotation = possible_rotations[math.random(#possible_rotations)]
	-- add to settlement info table
	local number_built = 1
	local corner1, corner2 = get_corner_pos(center_surface_pos, townhall.schematic, rotation)
	local center_building = {
		center_pos = center_surface_pos,
		build_pos_min = corner1,
		build_pos_max = corner2,
		schematic_info = townhall,
		rotation = rotation,
		surface_mat = surface_material,
	}
	settlement_info[number_built] = center_building

	insert_into_area(center_building, areastore)

	-- now some buildings around in a circle, radius = size of town center
	local x, z = center_surface_pos.x, center_surface_pos.z
	local r = math.max(townhall.schematic.size.x, townhall.schematic.size.z) + (townhall.buffer or 0)
	-- draw circles around center and increase radius by math.random(2,5)
	for circle = 1,20 do
		if number_built < number_of_buildings	then
			-- set position on imaginary circle
			for angle_step = 0, 360, 15 do
				local angle = angle_step * math.pi / 180
				local ptx, ptz = x + r * math.cos( angle ), z + r * math.sin( angle )
				ptx = math.floor(ptx + 0.5) -- round
				ptz = math.floor(ptz + 0.5)
				local pos1 = { x=ptx, y=center_surface_pos.y, z=ptz}
				local pos_surface, surface_material = find_surface(pos1, data, va, settlement_def.altitude_min, settlement_def.altitude_max)
				if pos_surface then
					local building_info = pick_next_building(pos_surface, surface_material, count_buildings, settlement_info, settlement_def, areastore)
					if building_info then
						number_built = number_built + 1
						settlement_info[number_built] = building_info
						local name_built = building_info.schematic_info.name
						--building_counts[name_built] = (building_counts[name_built] or 0) + 1
						if number_of_buildings == number_built then
							break
						end
					end
				else
					break
				end
			end
			r = r + math.random(2,5)
		else
			break
		end
	end

	if number_built <= 1 then
		return nil
	end

	if not existing_settlement_name then
		local waypoint_pos = vector.add(center_surface_pos, {x=0,y=2,z=0})
		named_waypoints.add_waypoint("settlements", waypoint_pos, {name=name, settlement_type=settlement_def.name})
	end

	return settlement_info
end

local function initialize_nodes(settlement_info)
	for i, built_house in ipairs(settlement_info) do
		local pmin = built_house.build_pos_min
		local pmax = built_house.build_pos_max
		for yi = pmin.y, pmax.y do
			for xi = pmin.x, pmax.x do
				for zi = pmin.z, pmax.z do
					local pos = {x=xi, y=yi, z=zi}
					local node = minetest.get_node(pos)
					local node_def = minetest.registered_nodes[node.name]
					if node_def.on_construct then
						-- if the node has an on_construct defined, call it.
						node_def.on_construct(pos)
					end
					if built_house.schematic_info.initialize_node then
						-- Hook for specialized initialization.
						built_house.schematic_info.initialize_node(pos, node, node_def, settlement_info)
					end
				end
			end
		end
	end
end

-- generate paths between buildings
local function paths(data, va, settlement_info)
	local c_path_material = minetest.get_content_id(settlement_info.def.path_material or default_path_material)
	local starting_point
	local end_point
	local distance
	starting_point = settlement_info[1].center_pos
	for i,built_house in ipairs(settlement_info) do

		end_point = built_house.center_pos
		if starting_point ~= end_point
		then
			-- loop until end_point is reached (distance == 0)
			while true do

				-- define surrounding pos to starting_point
				local north_p = {x=starting_point.x+1, y=starting_point.y, z=starting_point.z}
				local south_p = {x=starting_point.x-1, y=starting_point.y, z=starting_point.z}
				local west_p = {x=starting_point.x, y=starting_point.y, z=starting_point.z+1}
				local east_p = {x=starting_point.x, y=starting_point.y, z=starting_point.z-1}
				-- measure distance to end_point
				local dist_north_p_to_end = math.sqrt(
					((north_p.x - end_point.x)*(north_p.x - end_point.x))+
					((north_p.z - end_point.z)*(north_p.z - end_point.z))
				)
				local dist_south_p_to_end = math.sqrt(
					((south_p.x - end_point.x)*(south_p.x - end_point.x))+
					((south_p.z - end_point.z)*(south_p.z - end_point.z))
				)
				local dist_west_p_to_end = math.sqrt(
					((west_p.x - end_point.x)*(west_p.x - end_point.x))+
					((west_p.z - end_point.z)*(west_p.z - end_point.z))
				)
				local dist_east_p_to_end = math.sqrt(
					((east_p.x - end_point.x)*(east_p.x - end_point.x))+
					((east_p.z - end_point.z)*(east_p.z - end_point.z))
				)
				-- evaluate which pos is closer to the end_point
				if dist_north_p_to_end <= dist_south_p_to_end and
				dist_north_p_to_end <= dist_west_p_to_end and
				dist_north_p_to_end <= dist_east_p_to_end
				then
					starting_point = north_p
					distance = dist_north_p_to_end

				elseif dist_south_p_to_end <= dist_north_p_to_end and
				dist_south_p_to_end <= dist_west_p_to_end and
				dist_south_p_to_end <= dist_east_p_to_end
				then
					starting_point = south_p
					distance = dist_south_p_to_end

				elseif dist_west_p_to_end <= dist_north_p_to_end and
				dist_west_p_to_end <= dist_south_p_to_end and
				dist_west_p_to_end <= dist_east_p_to_end
				then
					starting_point = west_p
					distance = dist_west_p_to_end

				elseif dist_east_p_to_end <= dist_north_p_to_end and
				dist_east_p_to_end <= dist_south_p_to_end and
				dist_east_p_to_end <= dist_west_p_to_end
				then
					starting_point = east_p
					distance = dist_east_p_to_end
				end
				-- find surface of new starting point
				local surface_point, surface_mat = find_surface(starting_point, data, va)
				-- replace surface node with path material
				if surface_point
				then
					local vi = va:index(surface_point.x, surface_point.y, surface_point.z)
					data[vi] = c_path_material

					-- don't set y coordinate, surface might be too low or high
					starting_point.x = surface_point.x
					starting_point.z = surface_point.z
				end
				if distance <= 1 or
				starting_point == end_point
				then
					break
				end
			end
		end
	end
end

function settlements.place_building(vm, built_house, settlement_info)
	local building_all_info = built_house.schematic_info

	local pos = built_house.build_pos_min
	pos.y = pos.y + (building_all_info.height_adjust or 0)
	local rotation = built_house.rotation
	-- get building node material for better integration to surrounding
	local platform_material = built_house.surface_mat
	local platform_material_name = minetest.get_name_from_content_id(platform_material)

	local building_schematic = building_all_info.schematic
	local replacements = {}
	if settlement_info.replacements then
		for target, repl in pairs(settlement_info.replacements) do
			replacements[target] = repl
		end
	end
	if building_all_info.replace_nodes_optional and settlement_info.replacements_optional then
		for target, repl in pairs(settlement_info.replacements_optional) do
			replacements[target] = repl
		end
	end
	if settlement_info.def.replace_with_surface_material then
		replacements[settlement_info.def.replace_with_surface_material] = platform_material_name
	end

	local force_place = building_all_info.force_place
	if force_place == nil then
		force_place = true
	end

	minetest.place_schematic_on_vmanip(
		vm,
		pos,
		building_schematic,
		rotation,
		replacements,
		force_place)
end

local trigger_timer_for_group = function(minp, maxp, nodenames)
	if not nodenames then
		return
	end
	local targets = minetest.find_nodes_in_area(minp, maxp, nodenames)
	for _, pos in ipairs(targets) do
		minetest.get_node_timer(pos):start(math.random(20, 120) / 10)
	end
end

settlements.generate_settlement_vm = function(vm, va, minp, maxp, existing_settlement_name)
	local data = {} -- normally this buffer would be outside the method to avoid
		-- garbage collecting it between calls and overwhelming LUA's memory management.
		-- But settlements should only need to generate on rare occasions so let's try letting
		-- LUA garbage-collect it to free up the memory in between times.
	vm:get_data(data)

	local settlement_info = create_site_plan(minp, maxp, data, va, existing_settlement_name)
	if not settlement_info
	then
		return false
	end

	-- prepare terrain
	terraform(data, va, settlement_info)

	--build paths between buildings
	if settlement_info.def.path_material then
		paths(data, va, settlement_info)
	end

	vm:set_data(data)
	
	-- place schematics
	for _, built_house in ipairs(settlement_info) do
		settlements.place_building(vm, built_house, settlement_info)
	end
	vm:calc_lighting()
	vm:update_liquids()
	vm:write_to_map()

	-- evaluate settlement_info and initialize furnaces and chests
	initialize_nodes(settlement_info)
	trigger_timer_for_group(minp, maxp, settlement_info.def.trigger_timers_for_nodes)
	return true
end

-- try to build a settlement outside of map generation
settlements.generate_settlement = function(minp, maxp)
	local vm = minetest.get_voxel_manip()
	local emin, emax = vm:read_from_map(minp, maxp) -- add borders to simulate mapgen overgeneration
	local va = VoxelArea:new{
		MinEdge = emin,
		MaxEdge = emax
	}

	return settlements.generate_settlement_vm(vm, va, minp, maxp)
end
