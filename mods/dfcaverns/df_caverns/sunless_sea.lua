local c_water = minetest.get_content_id("default:water_source")
local c_air = minetest.get_content_id("air")
local c_dirt = minetest.get_content_id("default:dirt")
local c_dirt_moss = minetest.get_content_id("df_mapitems:dirt_with_cave_moss")
local c_sand = minetest.get_content_id("default:sand")
local c_gravel = minetest.get_content_id("default:gravel")
local c_wet_flowstone = minetest.get_content_id("df_mapitems:wet_flowstone")
local c_dry_flowstone = minetest.get_content_id("df_mapitems:dry_flowstone")
local c_lava = minetest.get_content_id("default:lava_source")
local c_obsidian = minetest.get_content_id("default:obsidian")

local c_coral_table = {
	minetest.get_content_id("df_mapitems:cave_coral_1"),
	minetest.get_content_id("df_mapitems:cave_coral_2"),
	minetest.get_content_id("df_mapitems:cave_coral_3")
}

local mushroom_shrublist
local fungispore_shrublist

if minetest.get_modpath("df_farming") then
	mushroom_shrublist = {
		df_farming.spawn_plump_helmet_vm,
		df_farming.spawn_plump_helmet_vm,
		df_farming.spawn_dimple_cup_vm,
		df_farming.spawn_dead_fungus_vm,
		df_farming.spawn_cavern_fungi_vm,
	}
	fungispore_shrublist = 	{
		df_farming.spawn_pig_tail_vm,
		df_farming.spawn_sweet_pod_vm,
		df_farming.spawn_cave_wheat_vm,
		df_farming.spawn_cave_wheat_vm,
		df_farming.spawn_dead_fungus_vm,
		df_farming.spawn_cavern_fungi_vm,
	}
end

------------------------------------------------------------------------------------------

local perlin_cave_sunless_sea = {
	offset = 0,
	scale = 1,
	spread = {x=df_caverns.config.horizontal_cavern_scale * 2, y=df_caverns.config.vertical_cavern_scale * 0.5, z=df_caverns.config.horizontal_cavern_scale * 2},
	seed = -400000000089,
	octaves = 3,
	persist = 0.67
}

local perlin_wave_sunless_sea = {
	offset = 0,
	scale = 1,
	spread = {x=df_caverns.config.horizontal_cavern_scale * 4, y=df_caverns.config.vertical_cavern_scale * 0.5, z=df_caverns.config.horizontal_cavern_scale * 4}, -- squashed 2:1
	seed = 59033,
	octaves = 6,
	persist = 0.63
}

local perlin_cave_rivers = {
	offset = 0,
	scale = 1,
	spread = {x=400, y=400, z=400},
	seed = -400000000089,
	octaves = 3,
	persist = 0.67,
	flags = "", -- remove "eased" flag, makes the paths of rivers a bit jaggedier and more interesting that curvy smooth paths
}

-- large-scale rise and fall to make the seam between roof and floor less razor-flat and make the rivers shallower and deeper in various places
local perlin_wave_rivers = {
	offset = 0,
	scale = 1,
	spread = {x=800, y=800, z=800},
	seed = -4000089,
	octaves = 3,
	persist = 0.67,
}

local sea_level = df_caverns.config.level3_min - (df_caverns.config.level3_min - df_caverns.config.sunless_sea_min) * 0.5

local floor_mult = 100
local floor_displace = -10
local ceiling_mult = -200
local ceiling_displace = 20
local wave_mult = 7
local ripple_mult = 15
local y_max_river = sea_level + 2*wave_mult + ceiling_displace + ripple_mult
local y_min_river = sea_level - 2*wave_mult + floor_displace

local hot_zone_boundary = 70
local middle_zone_boundary = 50
local cool_zone_boundary = 30

local mushroom_cavern_floor = function(abs_cracks, vert_rand, vi, area, data, data_param2)
	local ystride = area.ystride
	if abs_cracks < 0.1 then
		df_caverns.stalagmites(abs_cracks, vert_rand, vi, area, data, data_param2, true)
	elseif data[vi-ystride] ~= c_air and data[vi-ystride] ~= c_water then -- leave the ground as rock if it's only one node thick
		if math.random() < 0.25 then
			data[vi] = c_dirt
		else
			data[vi] = c_dirt_moss
		end
		if math.random() < 0.1 then
			df_caverns.place_shrub(vi+ystride, area, data, data_param2, mushroom_shrublist)
		elseif abs_cracks > 0.25 then
			if math.random() < 0.01 then
				df_trees.spawn_tower_cap_vm(vi+ystride, area, data)
			elseif math.random() < 0.01 then
				df_trees.spawn_goblin_cap_vm(vi+ystride, area, data, data_param2)
			elseif math.random() < 0.02 then
				df_trees.spawn_spindlestem_vm(vi+ystride, area, data, data_param2)
			end
		end
	end
end

local fungispore_cavern_floor = function(abs_cracks, vert_rand, vi, area, data, data_param2)
	local ystride = area.ystride
	if abs_cracks < 0.1 then
		df_caverns.stalagmites(abs_cracks, vert_rand, vi, area, data, data_param2, true)
	elseif data[vi-ystride] ~= c_air and data[vi-ystride] ~= c_water then -- leave the ground as rock if it's only one node thick
		if math.random() < 0.25 then
			data[vi] = c_dirt
		else
			data[vi] = c_dirt_moss
		end
		if math.random() < 0.1 then
			df_caverns.place_shrub(vi+ystride, area, data, data_param2, fungispore_shrublist)
		elseif abs_cracks > 0.35 then
			if math.random() < 0.025 then
				df_trees.spawn_fungiwood_vm(vi+ystride, area, data)
			elseif math.random() < 0.025 then
				df_trees.spawn_spore_tree_vm(vi+ystride, area, data, data_param2)
			end
		end
	end
end

local cool_zone_ceiling = function(abs_cracks, vert_rand, vi, area, data, data_param2)
	if abs_cracks < 0.1 then
		df_caverns.stalactites(abs_cracks, vert_rand, vi, area, data, data_param2, false)
	end
end

local hot_zone_ceiling = function(abs_cracks, vert_rand, vi, area, data, data_param2)
	-- dry zone ceiling, add crystals
	if abs_cracks < 0.1 then
		df_caverns.stalactites(abs_cracks, vert_rand, vi, area, data, data_param2, false)
	end
	if abs_cracks > 0.3 and math.random() < 0.005 then
		df_mapitems.place_big_crystal_cluster(area, data, data_param2, vi, math.random(0,3), true)
	end
end

local cool_zone_floor = df_caverns.dry_cavern_floor

local hot_zone_floor = function(abs_cracks, vert_rand, vi, area, data, data_param2)
	if abs_cracks < 0.075 then
		df_caverns.stalagmites(abs_cracks, vert_rand, vi, area, data, data_param2, false)
	elseif abs_cracks > 0.3 and math.random() < 0.005 then
		df_mapitems.place_big_crystal_cluster(area, data, data_param2, vi+area.ystride,  math.random(0,2), false)
	end
end


local decorate_sunless_sea = function(minp, maxp, seed, vm, node_arrays, area, data)
	math.randomseed(minp.x + minp.y*2^8 + minp.z*2^16 + seed) -- make decorations consistent between runs

	local heatmap = minetest.get_mapgen_object("heatmap")
	local data_param2 = df_caverns.data_param2
	vm:get_param2_data(data_param2)
	local nvals_cracks = mapgen_helper.perlin2d("df_cavern:cracks", minp, maxp, df_caverns.np_cracks)

	local minp_below = minp.y <= sea_level
	local maxp_above = maxp.y > sea_level
	
	local nvals_cave = mapgen_helper.perlin2d("df_caverns:sunless_sea", minp, maxp, perlin_cave_rivers) --cave noise for structure
	local nvals_wave = mapgen_helper.perlin2d("df_caverns:sunless_sea_wave", minp, maxp, perlin_wave_rivers) --cave noise for structure
	
	local skip_next = false -- mapgen is proceeding upward on the y axis,
		--if this is true it skips a step to allow for things to be placed above the floor
	
	-- creates "river" caverns
	for vi, x, y, z in area:iterp_yxz(minp, maxp) do
		if not skip_next then		
			if y < y_max_river and y > y_min_river then
				local index2d = mapgen_helper.index2d(minp, maxp, x, z)
				local abs_cave = math.abs(nvals_cave[index2d])
				local wave = nvals_wave[index2d] * wave_mult
				local cracks = nvals_cracks[index2d]
				
				local ripple = cracks * ((y - y_min_river) / (y_max_river - y_min_river)) * ripple_mult

				-- above floor and below ceiling
				local floor_height = math.floor(abs_cave * floor_mult + sea_level + floor_displace + wave)
				local ceiling_height = math.floor(abs_cave * ceiling_mult + sea_level + ceiling_displace + wave + ripple)

				-- deal with lava
				if y <= floor_height and y > floor_height - 3 and y < sea_level + 5 and data[vi] == c_lava then
					data[vi] = c_obsidian
				end
				
				if y == floor_height and y < sea_level and not mapgen_helper.buildable_to(data[vi]) then
					if cracks > 0.2 then
						data[vi] = c_sand
						if cracks > 0.5 then
							data[vi+area.ystride] = c_sand
							skip_next = true
						end
					else
						data[vi] = c_gravel
					end
				elseif y > floor_height and y < ceiling_height and data[vi] ~= c_wet_flowstone then
					data[vi] = c_air
				elseif y == ceiling_height and not mapgen_helper.buildable_to(data[vi]) then
					df_caverns.glow_worm_cavern_ceiling(math.abs(cracks),
						mapgen_helper.xz_consistent_randomi(area, vi), vi, area, data, data_param2)
				end
				
				-- Deal with lava
				if y >= ceiling_height and y < ceiling_height + 5 and y > sea_level - 5 and data[vi] == c_lava then
					data[vi] = c_obsidian
				end
			end
		else
			skip_next = false
		end
	end
	
	if minp.y <= sea_level then
		for vi, x, y, z in area:iterp_yxz(area.MinEdge, area.MaxEdge) do
			-- convert all air below sea level into water
			if y <= sea_level and data[vi] == c_air then
				data[vi] = c_water
			end
		end
	end

	
	---------------------------------------------------------
	-- Cavern floors
	
	for _, vi in ipairs(node_arrays.cavern_floor_nodes) do
		local index2d = mapgen_helper.index2di(minp, maxp, area, vi)
		local heat = heatmap[index2d]
		local cracks = nvals_cracks[index2d]
		local abs_cracks = math.abs(cracks)
		local vert_rand = mapgen_helper.xz_consistent_randomi(area, vi)
		local y = area:get_y(vi)
		
		-- The vertically squished aspect of these caverns produces too many very thin shelves, this blunts them
		if mapgen_helper.buildable_to(data[vi-area.ystride]) then
			if y <= sea_level then
				data[vi] = c_water
			else
				data[vi] = c_air
			end
		end	
		
		-- extra test is needed because the rivers can remove nodes that Subterrane marked as floor.
		if not mapgen_helper.buildable_to(data[vi]) then
			if y >= sea_level  then
				if heat > hot_zone_boundary then
					hot_zone_floor(abs_cracks, vert_rand, vi, area, data, data_param2)
				elseif heat > middle_zone_boundary then
					fungispore_cavern_floor(abs_cracks, vert_rand, vi, area, data, data_param2)
				elseif heat > cool_zone_boundary then
					mushroom_cavern_floor(abs_cracks, vert_rand, vi, area, data, data_param2)
				else
					cool_zone_floor(abs_cracks, vert_rand, vi, area, data, data_param2)
				end
			elseif y >= sea_level - 30 then
				if math.random() < 0.005 then
					df_mapitems.place_snareweed_patch(area, data, vi, data_param2, 6)
				else
					data[vi] = c_dirt
				end
			else
				data[vi] = c_sand
				if math.random() < 0.001 then
					local iterations = math.random(1, 6)
					df_mapitems.spawn_coral_pile(area, data, vi, iterations)
					df_mapitems.spawn_castle_coral(area, data, vi+area.ystride, iterations)
				end
			end
		end
	end
	
	--------------------------------------
	-- Cavern ceilings

	for _, vi in ipairs(node_arrays.cavern_ceiling_nodes) do
		local index2d = mapgen_helper.index2di(minp, maxp, area, vi)
		local heat = heatmap[index2d]
		local cracks = nvals_cracks[index2d]
		local abs_cracks = math.abs(cracks)
		local vert_rand = mapgen_helper.xz_consistent_randomi(area, vi)
		local y = area:get_y(vi)
		
		if y > sea_level and not mapgen_helper.buildable_to(data[vi]) then
			if heat > hot_zone_boundary then
				hot_zone_ceiling(abs_cracks, vert_rand, vi, area, data, data_param2)
			elseif heat > cool_zone_boundary then
				df_caverns.glow_worm_cavern_ceiling(abs_cracks, vert_rand, vi, area, data, data_param2)
			else
				cool_zone_ceiling(abs_cracks, vert_rand, vi, area, data, data_param2)
			end
		end

	end
	
		----------------------------------------------
	-- Tunnel floors
	
	for _, vi in ipairs(node_arrays.tunnel_floor_nodes) do
		if area:get_y(vi) >= sea_level and not mapgen_helper.buildable_to(data[vi]) then
			df_caverns.tunnel_floor(minp, maxp, area, vi, nvals_cracks, data, data_param2, true)
		end
	end
	
	------------------------------------------------------
	-- Tunnel ceiling
	
	for _, vi in ipairs(node_arrays.tunnel_ceiling_nodes) do
		if area:get_y(vi) > sea_level and not mapgen_helper.buildable_to(data[vi]) then
			df_caverns.tunnel_ceiling(minp, maxp, area, vi, nvals_cracks, data, data_param2, true)
		else
			-- air pockets
			local index2d = mapgen_helper.index2di(minp, maxp, area, vi)
			local cracks = nvals_cracks[index2d]
			local ystride = area.ystride
			if cracks > 0.6 and data[vi-ystride] == c_water then
				data[vi-ystride] = c_air
				if cracks > 0.8 and data[vi-ystride*2] == c_water then
					data[vi-ystride*2] = c_air
				end
			end	
		end
	end
	
	------------------------------------------------------
	-- Warren ceiling

	for _, vi in ipairs(node_arrays.warren_ceiling_nodes) do
		if area:get_y(vi) > sea_level and not mapgen_helper.buildable_to(data[vi]) then
			df_caverns.tunnel_ceiling(minp, maxp, area, vi, nvals_cracks, data, data_param2, true)
		else
			-- air pockets
			local index2d = mapgen_helper.index2di(minp, maxp, area, vi)
			local cracks = nvals_cracks[index2d]
			local ystride = area.ystride
			if cracks > 0.6 and data[vi-ystride] == c_water then
				data[vi-ystride] = c_air
				if cracks > 0.8 and data[vi-ystride*2] == c_water then
					data[vi-ystride*2] = c_air
				end
			end	
		end
	end

	----------------------------------------------
	-- Warren floors
	
	for _, vi in ipairs(node_arrays.warren_floor_nodes) do
		if area:get_y(vi) >= sea_level and not mapgen_helper.buildable_to(data[vi]) then
			df_caverns.tunnel_floor(minp, maxp, area, vi, nvals_cracks, data, data_param2, true)
		end
	end

	-- columns
	for _, vi in ipairs(node_arrays.column_nodes) do
		if data[vi] == c_wet_flowstone then
			if area:get_y(vi) > sea_level then
				local index2d = mapgen_helper.index2di(minp, maxp, area, vi)
				local heat = heatmap[index2d]
				if heat > hot_zone_boundary then
					data[vi] = c_dry_flowstone
				end
			else
				data[vi] = c_coral_table[math.random(1,3)]
				data_param2[vi] = math.random(1,4)-1
				minetest.get_node_timer(area:position(vi)):start(math.random(10, 60))
			end
		end
	end

	vm:set_param2_data(data_param2)
end

--Sunless Sea
subterrane.register_layer({
	name = "sunless sea",
	y_max = df_caverns.config.level3_min-1,
	y_min = df_caverns.config.sunless_sea_min,
	cave_threshold = df_caverns.config.sunless_sea_threshold,
	perlin_cave = perlin_cave_sunless_sea,
	perlin_wave = perlin_wave_sunless_sea,
	solidify_lava = true,
	columns = {
		maximum_radius = 20,
		minimum_radius = 5,
		node = "df_mapitems:wet_flowstone",
		weight = 0.5,
		maximum_count = 60,
		minimum_count = 10,
	},
	decorate = decorate_sunless_sea,
	double_frequency = false,
	is_ground_content = df_caverns.is_ground_content,
})
