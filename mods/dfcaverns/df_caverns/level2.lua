local c_water = minetest.get_content_id("default:water_source")
local c_air = minetest.get_content_id("air")
local c_dirt = minetest.get_content_id("default:dirt")
local c_dirt_moss = minetest.get_content_id("df_mapitems:dirt_with_cave_moss")

local c_wet_flowstone = minetest.get_content_id("df_mapitems:wet_flowstone")
local c_dry_flowstone = minetest.get_content_id("df_mapitems:dry_flowstone")

local c_veinstone = minetest.get_content_id("df_mapitems:veinstone")
local wall_vein_perlin_params = {
	offset = 0,
	scale = 1,
	spread = {x = 50, y = 50, z = 50},
	seed = 2199,
	octaves = 3,
	persist = 0.63,
	lacunarity = 2.0,
	flags = "eased",
}

local c_pearls = minetest.get_content_id("df_mapitems:cave_pearls")

local subsea_level = df_caverns.config.level2_min - (df_caverns.config.level2_min - df_caverns.config.level1_min) * 0.33 -- "sea level" for the flooded caverns.
local flooding_threshold = math.min(df_caverns.config.tunnel_flooding_threshold, df_caverns.config.cavern_threshold) -- cavern value out to which we're flooding tunnels and warrens

local get_biome = function(heat, humidity)
	if humidity < 23 then  -- about 20% of locations fall below this threshold
		return "barren"
	elseif heat < 40 then
		return "goblincap" -- about 33% are below this threshold
	elseif heat < 60 then
		return "sporetree" -- another 33%
	else
		return "tunneltube"
	end
end

local goblin_cap_shrublist
local tunnel_tube_shrublist
local spore_tree_shrublist

if minetest.get_modpath("df_farming") then
	goblin_cap_shrublist = {
		df_farming.spawn_plump_helmet_vm,
		df_farming.spawn_plump_helmet_vm,
		df_farming.spawn_dead_fungus_vm,
		df_farming.spawn_cavern_fungi_vm,
	}
	tunnel_tube_shrublist = {
		df_farming.spawn_sweet_pod_vm,
		df_farming.spawn_cave_wheat_vm,
		df_farming.spawn_cave_wheat_vm,
		df_farming.spawn_dead_fungus_vm,
		df_farming.spawn_cavern_fungi_vm,
	}	
	spore_tree_shrublist = {
		df_farming.spawn_pig_tail_vm,
		df_farming.spawn_pig_tail_vm,
		df_farming.spawn_cave_wheat_vm,
		df_farming.spawn_dead_fungus_vm,
		df_farming.spawn_cavern_fungi_vm,
	}
end

local c_red = minetest.get_content_id("df_trees:spindlestem_cap_red")

local goblin_cap_cavern_floor = function(abs_cracks, vert_rand, vi, area, data, data_param2)
	local ystride = area.ystride
	if abs_cracks < 0.1 then
		df_caverns.stalagmites(abs_cracks, vert_rand, vi, area, data, data_param2, true)
	elseif data[vi-ystride] ~= c_air then -- leave the ground as rock if it's only one node thick
		if math.random() < 0.25 then
			data[vi] = c_dirt
		else
			data[vi] = c_dirt_moss
		end
		if math.random() < 0.1 then
			df_caverns.place_shrub(vi+ystride, area, data, data_param2, goblin_cap_shrublist)
		elseif math.random() < 0.02 then
			df_trees.spawn_spindlestem_vm(vi+ystride, area, data, data_param2, c_red)
		elseif math.random() < 0.015 then
			df_trees.spawn_goblin_cap_vm(vi+ystride, area, data, data_param2)
		end
	end

end

local spore_tree_cavern_floor = function(abs_cracks, vert_rand, vi, area, data, data_param2)			
	local ystride = area.ystride
	if abs_cracks < 0.1 then
		df_caverns.stalagmites(abs_cracks, vert_rand, vi, area, data, data_param2, true)
	elseif data[vi-ystride] ~= c_air then -- leave the ground as rock if it's only one node thick
		if math.random() < 0.25 then
			data[vi] = c_dirt
		else
			data[vi] = c_dirt_moss
		end
		if math.random() < 0.1 then
			df_caverns.place_shrub(vi+ystride, area, data, data_param2, spore_tree_shrublist)
		elseif math.random() < 0.05 then
			df_trees.spawn_spore_tree_vm(vi+ystride, area, data, data_param2)
		end
	end
end


local tunnel_tube_cavern_floor = function(abs_cracks, vert_rand, vi, area, data, data_param2)
	local ystride = area.ystride
	if abs_cracks < 0.1 then
		df_caverns.stalagmites(abs_cracks, vert_rand, vi, area, data, data_param2, true)
	elseif data[vi-ystride] ~= c_air then -- leave the ground as rock if it's only one node thick
		if math.random() < 0.25 then
			data[vi] = c_dirt
		else
			data[vi] = c_dirt_moss
		end
		if math.random() < 0.1 then
			df_caverns.place_shrub(vi+ystride, area, data, data_param2, tunnel_tube_shrublist)
		elseif math.random() < 0.05 then
			df_trees.spawn_tunnel_tube_vm(vi+ystride, area, data, data_param2)
		end
	end
end

local decorate_level_2 = function(minp, maxp, seed, vm, node_arrays, area, data)
	math.randomseed(minp.x + minp.y*2^8 + minp.z*2^16 + seed) -- make decorations consistent between runs

	local heatmap = minetest.get_mapgen_object("heatmap")
	local humiditymap = minetest.get_mapgen_object("humiditymap")
	local data_param2 = df_caverns.data_param2
	vm:get_param2_data(data_param2)
	local nvals_cracks = mapgen_helper.perlin2d("df_cavern:cracks", minp, maxp, df_caverns.np_cracks)
	local nvals_cave = node_arrays.nvals_cave
	local cave_area = node_arrays.cave_area
	local cavern_def = node_arrays.cavern_def
	
	local vein_noise
	local vein_area
	
	-- Partly fill flooded caverns and warrens
	for vi, x, y, z in area:iterp_yxz(area.MinEdge, area.MaxEdge) do
		local cave_val = nvals_cave[vi]
		if cave_val < -flooding_threshold then
			if mapgen_helper.is_pos_within_box({x=x, y=y, z=z}, minp, maxp) then
				local index2d = mapgen_helper.index2di(minp, maxp, area, vi)
				local biome_name = get_biome(heatmap[index2d], humiditymap[index2d])
				local cave_threshold = cavern_def.cave_threshold
	
				--check if we're just inside the boundary of the (negazone) cavern threshold
				if biome_name == "barren" and cave_val < -cave_threshold and cave_val > -cave_threshold - 0.01 then
					-- add giant rooty structures to the flooded barren caverns
					if vein_noise == nil then
						vein_noise, vein_area = mapgen_helper.perlin3d("df_caverns:wall_veins", minp, maxp, wall_vein_perlin_params)
					end
					if data[vi] == c_air and math.abs(vein_noise[vein_area:transform(area, vi)]) < 0.02 then
						data[vi] = c_veinstone
					end
				end
			end
			if data[vi] == c_air and y <= subsea_level then
				data[vi] = c_water -- otherwise, fill air with water when below sea level
			end
		end
	end	
	
	---------------------------------------------------------
	-- Cavern floors
	
	for _, vi in ipairs(node_arrays.cavern_floor_nodes) do
		local vert_rand = mapgen_helper.xz_consistent_randomi(area, vi)
		local index2d = mapgen_helper.index2di(minp, maxp, area, vi)
		local biome_name = get_biome(heatmap[index2d], humiditymap[index2d])
		local abs_cracks = math.abs(nvals_cracks[index2d])
		local flooded_caverns = nvals_cave[vi] < 0 -- this indicates if we're in the "flooded" set of caves or not.
				
		if minp.y < subsea_level and area:get_y(vi) < subsea_level and flooded_caverns then
			-- underwater floor
			df_caverns.flooded_cavern_floor(abs_cracks, vert_rand, vi, area, data)
		elseif biome_name == "barren" then
			if flooded_caverns then
				df_caverns.wet_cavern_floor(abs_cracks, vert_rand, vi, area, data, data_param2)
			else
				df_caverns.dry_cavern_floor(abs_cracks, vert_rand, vi, area, data, data_param2)
			end
		elseif biome_name == "goblincap" then
			goblin_cap_cavern_floor(abs_cracks, vert_rand, vi, area, data, data_param2)			
		elseif biome_name == "sporetree" then
			spore_tree_cavern_floor(abs_cracks, vert_rand, vi, area, data, data_param2)			
		elseif biome_name == "tunneltube" then
			tunnel_tube_cavern_floor(abs_cracks, vert_rand, vi, area, data, data_param2)
		end
	end

	--------------------------------------
	-- Cavern ceilings
	
	for _, vi in ipairs(node_arrays.cavern_ceiling_nodes) do
		local vert_rand = mapgen_helper.xz_consistent_randomi(area, vi)
		local index2d = mapgen_helper.index2di(minp, maxp, area, vi)
		local biome_name = get_biome(heatmap[index2d], humiditymap[index2d])
		local abs_cracks = math.abs(nvals_cracks[index2d])
		local flooded_caverns = nvals_cave[vi] < 0 -- this indicates if we're in the "flooded" set of caves or not.

		if flooded_caverns and minp.y < subsea_level and area:get_y(vi) < subsea_level then
			-- underwater ceiling, do nothing
		elseif biome_name == "barren" then
			if flooded_caverns then
				-- wet barren
				if abs_cracks < 0.1 then
					df_caverns.stalactites(abs_cracks, vert_rand, vi, area, data, data_param2, true)
				end
			else
				-- dry barren
				if abs_cracks < 0.075 then
					df_caverns.stalactites(abs_cracks, vert_rand, vi, area, data, data_param2, false)
				end
				local y = area:get_y(vi)
				local y_proportional = (y - df_caverns.config.level1_min) / (df_caverns.config.level2_min - df_caverns.config.level1_min)
				if abs_cracks * y_proportional > 0.3 and math.random() < 0.005 * y_proportional then
					df_mapitems.place_big_crystal_cluster(area, data, data_param2, vi, math.random(0,1), true)
				end
			end			
		else -- all the other biomes
			df_caverns.glow_worm_cavern_ceiling(abs_cracks, vert_rand, vi, area, data, data_param2)
		end
	end
	
	----------------------------------------------
	-- Tunnel floors
	
	for _, vi in ipairs(node_arrays.tunnel_floor_nodes) do
		local index2d = mapgen_helper.index2di(minp, maxp, area, vi)
		local biome_name = get_biome(heatmap[index2d], humiditymap[index2d])
		local flooded_caverns = nvals_cave[vi] < 0 -- this indicates if we're in the "flooded" set of caves or not.

		if not (flooded_caverns and minp.y < subsea_level and area:get_y(vi) < subsea_level) then
			if flooded_caverns or biome_name ~= "barren" then		
				-- we're in flooded areas or are not barren
				df_caverns.tunnel_floor(minp, maxp, area, vi, nvals_cracks, data, data_param2, true)
			else
				df_caverns.tunnel_floor(minp, maxp, area, vi, nvals_cracks, data, data_param2, false)
			end
		end
	end
	
	------------------------------------------------------
	-- Tunnel ceiling
	
	for _, vi in ipairs(node_arrays.tunnel_ceiling_nodes) do
		local index2d = mapgen_helper.index2di(minp, maxp, area, vi)
		local biome_name = get_biome(heatmap[index2d], humiditymap[index2d])
		local flooded_caverns = nvals_cave[vi] < 0 -- this indicates if we're in the "flooded" set of caves or not.
		local ystride = area.ystride

		if not (flooded_caverns and minp.y < subsea_level and area:get_y(vi) < subsea_level) then
			if flooded_caverns or biome_name ~= "barren" then
				-- we're in flooded areas or are not barren
				df_caverns.tunnel_ceiling(minp, maxp, area, vi, nvals_cracks, data, data_param2, true)
			else
				df_caverns.tunnel_ceiling(minp, maxp, area, vi, nvals_cracks, data, data_param2, false)
			end
			if not flooded_caverns and (biome_name == "barren" or biome_name == "sporetree") and nvals_cracks[index2d] > 0.5 then
				for i= 1, 4 do
					if math.random() > 0.5 then
						local index = vi-i*ystride
						if data[index] == c_air then
							df_mapitems.place_against_surface_vm(c_pearls, index, area, data, data_param2)
						end
					end
				end
			end
		else
			-- air pockets
			local ystride = area.ystride
			local cracks = nvals_cracks[index2d]
			if cracks > 0.4 and data[vi-ystride] == c_water then
				data[vi-ystride] = c_air
				if cracks > 0.6 and data[vi-ystride*2] == c_water then
					data[vi-ystride*2] = c_air
				end
			end			
		end
	end

		----------------------------------------------
	-- Warren floors
	
	for _, vi in ipairs(node_arrays.warren_floor_nodes) do
		local index2d = mapgen_helper.index2di(minp, maxp, area, vi)
		local biome_name = get_biome(heatmap[index2d], humiditymap[index2d])
		local flooded_caverns = nvals_cave[vi] < 0 -- this indicates if we're in the "flooded" set of caves or not.

		if not (flooded_caverns and minp.y < subsea_level and area:get_y(vi) < subsea_level) then
			if flooded_caverns or biome_name ~= "barren" then		
				-- we're in flooded areas or are not barren
				df_caverns.tunnel_floor(minp, maxp, area, vi, nvals_cracks, data, data_param2, true)
			else
				df_caverns.tunnel_floor(minp, maxp, area, vi, nvals_cracks, data, data_param2, false)
			end
		end
	end
	
	------------------------------------------------------
	-- Warren ceiling

	for _, vi in ipairs(node_arrays.warren_ceiling_nodes) do
		local index2d = mapgen_helper.index2di(minp, maxp, area, vi)
		local biome_name = get_biome(heatmap[index2d], humiditymap[index2d])
		local flooded_caverns = nvals_cave[vi] < 0 -- this indicates if we're in the "flooded" set of caves or not.
		local ystride = area.ystride

		if not (flooded_caverns and minp.y < subsea_level and area:get_y(vi) < subsea_level) then
			if flooded_caverns or biome_name ~= "barren" then		
				-- we're in flooded areas or are not barren
				df_caverns.tunnel_ceiling(minp, maxp, area, vi, nvals_cracks, data, data_param2, true)
			else
				df_caverns.tunnel_ceiling(minp, maxp, area, vi, nvals_cracks, data, data_param2, false)
			end

			if not flooded_caverns and (biome_name == "barren" or biome_name == "sporetree") and nvals_cracks[index2d] > 0.5 then
				for i= 1, 4 do
					if math.random() > 0.5 then
						local index = vi-i*ystride
						if data[index] == c_air then
							df_mapitems.place_against_surface_vm(c_pearls, index, area, data, data_param2)
						end
					end
				end
			end
		else
			-- air pockets
			local cracks = nvals_cracks[index2d]
			if cracks > 0.4 and data[vi-ystride] == c_water then
				data[vi-ystride] = c_air
				if cracks > 0.6 and data[vi-ystride*2] == c_water then
					data[vi-ystride*2] = c_air
				end
			end			
		end

	end

	----------------------------------------------
	-- Column material override for dry biome
	
	for _, vi in ipairs(node_arrays.column_nodes) do
		local index2d = mapgen_helper.index2di(minp, maxp, area, vi)
		local biome_name = get_biome(heatmap[index2d], humiditymap[index2d])
		local dry = (biome_name == "barren") and (nvals_cave[vi] > 0)

		if dry and data[vi] == c_wet_flowstone then
			data[vi] = c_dry_flowstone
		end
	end

	vm:set_param2_data(data_param2)
end

subterrane.register_layer({
	name = "cavern layer 2",
	y_max = df_caverns.config.level1_min-1,
	y_min = df_caverns.config.level2_min,
	cave_threshold = df_caverns.config.cavern_threshold,
	boundary_blend_range = 64, -- range near ymin and ymax over which caves diminish to nothing
	perlin_cave = df_caverns.perlin_cave,
	perlin_wave = df_caverns.perlin_wave,
	solidify_lava = true,
	columns = {
		maximum_radius = 15,
		minimum_radius = 4,
		node = "df_mapitems:wet_flowstone",
		weight = 0.25,
		maximum_count = 50,
		minimum_count = 5,
	},
	decorate = decorate_level_2,
	warren_region_variability_threshold = 0.33,
	double_frequency = true,
	is_ground_content = df_caverns.is_ground_content,
})

