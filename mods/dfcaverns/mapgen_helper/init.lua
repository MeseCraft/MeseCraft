mapgen_helper = {}

mapgen_helper.mapgen_seed = tonumber(minetest.get_mapgen_setting("seed"))

-- The "sidelen" used in almost every mapgen
mapgen_helper.block_size = tonumber(minetest.get_mapgen_setting("chunksize")) * 16

local MP = minetest.get_modpath(minetest.get_current_modname())
dofile(MP.."/bounding_boxes.lua")
dofile(MP.."/random.lua")
dofile(MP.."/voxelarea_iterator.lua")
dofile(MP.."/voxeldata.lua")
dofile(MP.."/region_functions.lua")
dofile(MP.."/lines.lua")
dofile(MP.."/place_schematic.lua")
dofile(MP.."/noise_manager.lua")
dofile(MP.."/metrics.lua")


local map_data = {}
local map_param2_data = {}

mapgen_helper.mapgen_vm_data = function()
	local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
	vm:get_data(map_data)
	return vm, map_data, VoxelArea:new{MinEdge=emin, MaxEdge=emax}
end

mapgen_helper.mapgen_vm_data_param2 = function()
	local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
	vm:get_data(map_data)
	vm:get_param2_data(map_param2_data)
	return vm, map_data, map_param2_data, VoxelArea:new{MinEdge=emin, MaxEdge=emax}
end

mapgen_helper.biome_defs = nil
mapgen_helper.get_biome_def = function(biome_id) -- given an id from the biome map, returns a biome definition.
	if mapgen_helper.biome_defs == nil then
		-- First time this was asked for, populate the table.
		-- Biome registration is only done at load time so we don't have to worry about new biomes invalidating this table
		mapgen_helper.biome_defs = {}
		for name, desc in pairs(minetest.registered_biomes) do
			local i = minetest.get_biome_id(desc.name)
			mapgen_helper.biome_defs[i] = desc
		end
	end
	return mapgen_helper.biome_defs[biome_id]
end

mapgen_helper.get_biome_def_i = function(biomemap, minp, maxp, area, vi)
	if biomemap == nil then
		return nil
	end
	local index2d = mapgen_helper.index2di(minp, maxp, area, vi)
	return mapgen_helper.get_biome_def(biomemap[index2d])
end


-- returns whether a content ID is "buildable to"
local buildable_to
mapgen_helper.buildable_to = function(c_node)
	if buildable_to then return buildable_to[c_node] end
	buildable_to = {}
	for k, v in pairs(minetest.registered_nodes) do
		if v.buildable_to then
			buildable_to[minetest.get_content_id(k)] = true
		end
	end
	return buildable_to[c_node]
end

local is_ground_content = nil
mapgen_helper.is_ground_content = function(c_node) -- If false, the cave generator will not carve through this node
	if is_ground_content ~= nil then
		return is_ground_content[c_node]
	end
	is_ground_content = {}
	for k, v in pairs(minetest.registered_nodes) do
		if v.is_ground_content == true then
			is_ground_content[minetest.get_content_id(k)] = true
		end
	end
	return is_ground_content[c_node]
end