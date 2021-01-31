-- These functions are a modification of the schematic placement code from src/mapgen/mg_schematic.cpp.
-- As such, this file is separately licened under the LGPL as follows:

-- License of Minetest source code
-------------------------------

--Minetest
--Copyright (C) 2010-2018 celeron55, Perttu Ahola <celeron55@gmail.com>

--This program is free software; you can redistribute it and/or modify
--it under the terms of the GNU Lesser General Public License as published by
--the Free Software Foundation; either version 2.1 of the License, or
--(at your option) any later version.

--This program is distributed in the hope that it will be useful,
--but WITHOUT ANY WARRANTY; without even the implied warranty of
--MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--GNU Lesser General Public License for more details.

--You should have received a copy of the GNU Lesser General Public License along
--with this program; if not, write to the Free Software Foundation, Inc.,
--51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

local c_air = minetest.get_content_id("air")
local c_ignore = minetest.get_content_id("ignore")

-- Table value = rotated facedir
-- Columns: 90, 180, 270 degrees rotation around vertical axis
-- Rotation is anticlockwise as seen from above (+Y)
local rotate_facedir_y =
{
	[0] = {1, 2, 3}     ,
	[1] = {2, 3, 0}     ,
	[2] = {3, 0, 1}     ,
	[3] = {0, 1, 2}     ,
	[4] = {13, 10, 19}  ,
	[5] = {14, 11, 16}  ,
	[6] = {15, 8, 17}   ,
	[7] = {12, 9, 18}   ,
	[8] = {17, 6, 15}   ,
	[9] = {18, 7, 12}   ,
	[10] = {19, 4, 13}  ,
	[11] = {16, 5, 14}  ,
	[12] = {9, 18, 7}   ,
	[13] = {10, 19, 4}  ,
	[14] = {11, 16, 5}  ,
	[15] = {8, 17, 6}   ,
	[16] = {5, 14, 11}  ,
	[17] = {6, 15, 8}   ,
	[18] = {7, 12, 9}   ,
	[19] = {4, 13, 10}  ,
	[20] = {23, 22, 21} ,
	[21] = {20, 23, 22} ,
	[22] = {21, 20, 23} ,
	[23] = {22, 21, 20} ,
}

local random_rotations = {0, 90, 180, 270}

local rotate_param2 = function(param2, paramtype2, rotation)
	param2 = param2 or 0
	if paramtype2 == "facedir" then
		if rotation == 90 then
			param2 = rotate_facedir_y[param2][1]
		elseif rotation == 180 then
			param2 = rotate_facedir_y[param2][2]
		elseif rotation == 270 then
			param2 = rotate_facedir_y[param2][3]
		end
	elseif paramtype2 == "wallmounted" then
		--TODO
	elseif paramtype2 == "colorfacedir" then
		--TODO
	elseif paramtype2 == "colorwallmounted" then
		--TODO
	end

	return param2
end


local swap = function(size_x, size_z)
	return size_z, size_x
end

-- Returns the minpos and maxpos of the bounding box that this schematic will be placed in given
-- the rotation and flag parameters. Useful for testing whether a schematic will fit in a place before actually
-- writing it to the data, so that you can abort and try something else instead.
mapgen_helper.get_schematic_bounding_box = function(pos, schematic, rotation, flags)
	flags = flags or {}
	local size = schematic.size
	local size_x = size.x
	local size_y = size.y
	local size_z = size.z
	local center_pos = schematic.center_pos
	
	if center_pos and rotation ~= nil and rotation ~= 0 then
		center_pos = vector.new(center_pos) -- make a copy so we can mess with it without damaging the schematic
		if rotation == 90 then
			center_pos.x, center_pos.z = swap(size_x - center_pos.x - 1, center_pos.z)
		elseif rotation == 180 then
			center_pos.z = size_z - center_pos.z - 1
			center_pos.x = size_x - center_pos.x - 1
		elseif rotation == 270 then
			center_pos.x, center_pos.z = swap(center_pos.x, size_z - center_pos.z - 1)
		end
	end

	if rotation == 90 or rotation == 270 then
		size_x, size_z = swap(size_x, size_z)
	end
	
	local minpos = vector.new(pos)
	
	if center_pos then
		if not flags.place_center_x then
			minpos.x = minpos.x - center_pos.x
		end
		if not flags.place_center_y then
			minpos.y = minpos.y - center_pos.y
		end
		if not flags.place_center_z then
			minpos.z = minpos.z - center_pos.z
		end
	end	
	if flags.place_center_x then
		minpos.x = math.floor(minpos.x - (size_x - 1) / 2)
	end
	if flags.place_center_y then
		minpos.y = math.floor(minpos.y - (size_y - 1) / 2)
	end
	if flags.place_center_z then
		minpos.z = math.floor(minpos.z - (size_z - 1) / 2)
	end
	
	local maxpos = vector.add(minpos, {x=size_x-1, y=size_y-1, z=size_z-1})

	return minpos, maxpos
end

-- Takes a lua-format schematic and applies it to the data and param2_data arrays produced by vmanip instead of being applied to the vmanip directly. Useful in a mapgen loop that's doing other things with the data before and after applying schematics. A VoxelArea for the data also needs to be provided.

-- Schematic enhancements beyond the basic Minetest API that work with this:
-- * node defs can have a "place_on_condition" property defined, which is a function that takes a node content ID parameter and returns true to indicate the schematic should replace it or false to indicate it should not. Useful for, for example, a schematic that should replace water but not stone (placing decorations on the bottom of the ocean), or a schematic that replaces all buildable_to nodes (to prevent tufts of grass from knocking holes in foundations). "data, area, vi" parameters are also provided if you want to get fancy and base the condition on surrounding nodes, but bear in mind that the schematic is in the process of being written already so some neighbors will already have been replaced with schematic nodes and some neighbors will be replaced in the future.
-- * schematic can have a "center_pos" position defined relative to the placement pos that will be treated as the rotation and placement origin, unless overridden by the flags parameter

-- returns true if the schematic was entirely contained within the voxelarea, false otherwise.

local empty_table = {}

mapgen_helper.place_schematic_on_data = function(data, data_param2, area, pos, schematic, rotation, replacements, force_placement, flags)
	pos = vector.new(pos)
	replacements = replacements or empty_table
	flags = flags or empty_table -- TODO: support all flags formats
	if flags.force_placement ~= nil then
		force_placement = flags.force_placement -- TODO: unclear which force_placement parameter should have prededence here
	end
	local center_pos = schematic.center_pos
	if rotation == "random" then rotation = random_rotations[math.random(1,4)] end
	
	local schemdata = schematic.data
	local slice_probs = schematic.yslice_prob or {}
	
	local size = schematic.size
	local size_x = size.x
	local size_y = size.y
	local size_z = size.z

	local xstride = 1
	local ystride = size_x
	local zstride = size_x * size_y

	if center_pos and rotation ~= nil and rotation ~= 0 then
		center_pos = vector.new(center_pos) -- make a copy so we can mess with it without damaging the schematic
		if rotation == 90 then
			center_pos.x, center_pos.z = swap(size_x - center_pos.x - 1, center_pos.z)
		elseif rotation == 180 then
			center_pos.z = size_z - center_pos.z - 1
			center_pos.x = size_x - center_pos.x - 1
		elseif rotation == 270 then
			center_pos.x, center_pos.z = swap(center_pos.x, size_z - center_pos.z - 1)
		end
	end
	
	local i_start, i_step_x, i_step_z
	if rotation == 90 then
		i_start  = size_x
		i_step_x = zstride
		i_step_z = -xstride
		size_x, size_z = swap(size_x, size_z)
	elseif rotation == 180 then
		i_start  = zstride * (size_z - 1) + size_x
		i_step_x = -xstride
		i_step_z = -zstride
	elseif rotation == 270 then
		i_start  = zstride * (size_z - 1) + 1
		i_step_x = -zstride
		i_step_z = xstride
		size_x, size_z = swap(size_x, size_z)
	else
		i_start = 1
		i_step_x = xstride
		i_step_z = zstride
	end

	--	Adjust placement position if necessary
	if center_pos then
		if not flags.place_center_x then
			pos.x = pos.x - center_pos.x
		end
		if not flags.place_center_y then
			pos.y = pos.y - center_pos.y
		end
		if not flags.place_center_z then
			pos.z = pos.z - center_pos.z
		end
	end	
	if flags.place_center_x then
		pos.x = math.floor(pos.x - (size_x - 1) / 2)
	end
	if flags.place_center_y then
		pos.y = math.floor(pos.y - (size_y - 1) / 2)
	end
	if flags.place_center_z then
		pos.z = math.floor(pos.z - (size_z - 1) / 2)
	end
	
	local maxpos = vector.add(pos, {x=size_x-1, y=size_y-1, z=size_z-1})
	local minEdge = area.MinEdge
	local maxEdge = area.MaxEdge
	if not (pos.x <= maxEdge.x and maxpos.x >= minEdge.x and
			pos.z <= maxEdge.z and maxpos.z >= minEdge.z and
			pos.y <= maxEdge.y and maxpos.y >= minEdge.y) then
		return false -- the bounding boxes of the area and the schematic don't overlap at all
	end	
	
	local contained_in_area = true
	local on_place_callbacks = {}
	
	local y_map = pos.y
	for y = 0, size_y-1 do
		if slice_probs[y] == nil or slice_probs[y] == 255 or slice_probs[y] <= math.random(1, 255) then
			for z = 0, size_z-1 do
				local i = z * i_step_z + y * ystride + i_start
				for x = 0, size_x-1 do
					local vi = area:index(pos.x + x, y_map, pos.z + z)
					if area:containsi(vi) then						
						local node_def = schemdata[i]
						local node_name = replacements[node_def.name] or node_def.name
						if node_name ~= "ignore" then
							local placement_prob = node_def.prob or 255
							if placement_prob ~= 0 then

								local force_place_node = node_def.force_place
								local place_on_condition = node_def.place_on_condition
								local on_place = node_def.on_place
								local old_node_id = data[vi]

								if (force_placement or force_place_node
									or (place_on_condition and place_on_condition(old_node_id, data, area, vi))
									or (not place_on_condition and (old_node_id == c_air or old_node_id == c_ignore)))
									and (placement_prob == 255 or math.random(1,255) <= placement_prob)
								then
									local registered_def = minetest.registered_nodes[node_name]
									if registered_def ~= nil then
										local paramtype2 = registered_def.paramtype2
										data[vi] = minetest.get_content_id(node_name)
										data_param2[vi] = rotate_param2(node_def.param2, paramtype2, rotation)
										
										if on_place then
											table.insert(on_place_callbacks, {on_place, vi})
										end
									else
										minetest.log("error", "mapgen_helper.place_schematic was given a schematic with unregistered node " .. tostring(node_name) .. " in it.")
									end
								end
							end
						end
					else
						contained_in_area = false -- schematic spilled over the edge of the area
					end
					i = i + i_step_x
				end
			end
		end
		y_map = y_map + 1
	end
	
	for k, callback in pairs(on_place_callbacks) do
		callback[1](callback[2], data, data_param2, area, pos, schematic, rotation, replacements, force_placement, flags)
	end
	
	return contained_in_area
end

-- aborts schematic placement if it won't fit into the provided data
mapgen_helper.place_schematic_on_data_if_it_fits = function(data, data_param2, area, pos, schematic, rotation, replacements, force_placement, flags)
	local minbound, maxbound = mapgen_helper.get_schematic_bounding_box(pos, schematic, rotation, flags)
	if mapgen_helper.is_box_within_box(minbound, maxbound, area.MinEdge, area.MaxEdge) then
		return mapgen_helper.place_schematic_on_data(data, data_param2, area, pos, schematic, rotation, replacements, force_placement, flags)
	end
	return false
end


-- wraps the above for convenience, so you can use this style of schematic in non-mapgen contexts as well
mapgen_helper.place_schematic = function(pos, schematic, rotation, replacements, force_placement, flags)
	local minpos, maxpos = mapgen_helper.get_schematic_bounding_box(pos, schematic, rotation, flags)
	local vmanip = minetest.get_voxel_manip(minpos, maxpos)
	local data = vmanip:get_data()
	local data_param2 = vmanip:get_param2_data()
	local emin, emax = vmanip:get_emerged_area()
	local area = VoxelArea:new{MinEdge=emin, MaxEdge=emax}
	local ret = mapgen_helper.place_schematic_on_data(data, data_param2, area, pos, schematic, rotation, replacements, force_placement, flags)
	vmanip:set_data(data)
	vmanip:set_param2_data(data_param2)
	vmanip:write_to_map()
	return ret -- should always be true since we created the voxelarea to fit the schematic
end
