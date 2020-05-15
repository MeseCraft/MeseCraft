if not df_caverns.config.enable_primordial or not minetest.get_modpath("df_primordial_items") then
	return
end

local perlin_cave_primordial = {
	offset = 0,
	scale = 1,
	spread = {x=df_caverns.config.horizontal_cavern_scale, y=df_caverns.config.vertical_cavern_scale*0.5, z=df_caverns.config.horizontal_cavern_scale},
	seed = 14055553,
	octaves = 3,
	persist = 0.67
}

local perlin_wave_primordial = {
	offset = 0,
	scale = 1,
	spread = {x=df_caverns.config.horizontal_cavern_scale, y=df_caverns.config.vertical_cavern_scale*0.5, z=df_caverns.config.horizontal_cavern_scale},
	seed = 923444,
	octaves = 6,
	persist = 0.63
}

local c_air = minetest.get_content_id("air")

local giant_mycelium_timer_spread = tonumber(minetest.settings:get("dcaverns_giant_mycelium_timer_spread")) or 10

-----------------------------------------------------------------------------------------
-- Fungal biome

local c_orb = minetest.get_content_id("df_primordial_items:glow_orb_hanging")
local c_mycelial_dirt = minetest.get_content_id("df_primordial_items:dirt_with_mycelium")
local c_dirt = minetest.get_content_id("default:dirt")
local c_giant_mycelium = minetest.get_content_id("df_primordial_items:giant_hypha_apical_mapgen")

local fungal_plants = {
	minetest.get_content_id("df_primordial_items:fungal_grass_1"),
	minetest.get_content_id("df_primordial_items:fungal_grass_2"),
	minetest.get_content_id("df_primordial_items:glow_orb"),
	minetest.get_content_id("df_primordial_items:glow_orb_stalks"),
	minetest.get_content_id("df_primordial_items:glow_pods"),
}

local fungal_plant_names = {}
local fungal_plants = {}
for node_name, node_def in pairs(minetest.registered_nodes) do
	if minetest.get_item_group(node_name, "primordial_fungal_plant") > 0 then
		table.insert(fungal_plant_names, node_name)
		table.insert(fungal_plants, minetest.get_content_id(node_name))
	end
end

local mushroom_cavern_floor = function(abs_cracks, humidity, vi, area, data, data_param2)
	local ystride = area.ystride
	local humidityfactor = humidity/200 + 0.5
	abs_cracks = abs_cracks * humidityfactor

	if abs_cracks < 0.7 then
		data[vi] = c_mycelial_dirt
	elseif abs_cracks < 1 then
		data[vi] = c_dirt
	end

	local rand = math.random() * math.min(abs_cracks, 1) * humidityfactor
	if rand < 0.0005 then
		local mycelium_index = vi+ystride
		data[mycelium_index] = c_giant_mycelium
		minetest.get_node_timer(area:position(mycelium_index)):start(math.random(1,giant_mycelium_timer_spread))
	elseif rand < 0.003 then
		local schematic = df_primordial_items.get_primordial_mushroom()
		local rotation = (math.random(1,4)-1)*90
		mapgen_helper.place_schematic_on_data_if_it_fits(data, data_param2, area, area:position(vi+ystride), schematic, rotation)
	elseif rand < 0.05 then
		data[vi+ystride] = fungal_plants[math.random(1,5)]
	end
end

local mushroom_cavern_ceiling = function(abs_cracks, humidity, vi, area, data, data_param2)
	local ystride = area.ystride
	local humidityfactor = humidity/200 + 0.5
	abs_cracks = abs_cracks * humidityfactor

	if abs_cracks < 0.5 then
		data[vi] = c_mycelial_dirt
		if abs_cracks < 0.3 then
			local rand = math.random() * humidityfactor
			if rand < 0.002 then
				local mycelium_index = vi-ystride
				data[mycelium_index] = c_giant_mycelium
				minetest.get_node_timer(area:position(mycelium_index)):start(math.random(1,giant_mycelium_timer_spread))
			elseif rand < 0.03 then
				df_primordial_items.spawn_ceiling_spire_vm(vi, area, data)
			elseif rand < 0.2 then
				data[vi-ystride] = c_orb
				data_param2[vi-ystride] = math.random(0,179)
			end
		end
	end
end

local mushroom_warren_ceiling = function(abs_cracks, vi, area, data, data_param2)
	local ystride = area.ystride

	if abs_cracks < 0.3 then
		data[vi] = c_mycelial_dirt
		if abs_cracks < 0.2 then
			local rand = math.random()
			if rand < 0.001 then
				local mycelium_index = vi-ystride
				data[mycelium_index] = c_giant_mycelium
				minetest.get_node_timer(area:position(mycelium_index)):start(math.random(1,giant_mycelium_timer_spread))
			elseif rand < 0.2 then
				data[vi-ystride] = c_orb
				data_param2[vi-ystride] = math.random(0,179)
			end
		end
	end
end

local mushroom_warren_floor = function(abs_cracks, vi, area, data, data_param2)
	local ystride = area.ystride
	if abs_cracks < 0.7 then
		data[vi] = c_mycelial_dirt
	elseif abs_cracks < 1 then
		data[vi] = c_dirt
	end
	local rand = math.random() * math.min(abs_cracks, 1)
	if rand < 0.001 then
		local mycelium_index = vi+ystride
		data[mycelium_index] = c_giant_mycelium
		minetest.get_node_timer(area:position(mycelium_index)):start(math.random(1,giant_mycelium_timer_spread))
	elseif rand < 0.03 then
		data[vi+ystride] = fungal_plants[math.random(1,5)]
	end
end

--------------------------------------------------------------------------------------------------
-- Jungle biome

local jungle_plant_names = {}
local jungle_plants = {}
for node_name, node_def in pairs(minetest.registered_nodes) do
	if minetest.get_item_group(node_name, "primordial_jungle_plant") > 0 then
		table.insert(jungle_plant_names, node_name)
		table.insert(jungle_plants, minetest.get_content_id(node_name))
	end
end

local c_jungle_dirt = minetest.get_content_id("df_primordial_items:dirt_with_jungle_grass")
local c_plant_matter = minetest.get_content_id("df_primordial_items:plant_matter")
local c_packed_roots = minetest.get_content_id("df_primordial_items:packed_roots")
local c_glowstone = minetest.get_content_id("df_underworld_items:glowstone")
local c_ivy = minetest.get_content_id("df_primordial_items:jungle_ivy")
local c_root_2 = minetest.get_content_id("df_primordial_items:jungle_roots_2")
local c_root_1 = minetest.get_content_id("df_primordial_items:jungle_roots_1")

local c_fireflies
if minetest.get_modpath("fireflies") then
	c_fireflies = minetest.get_content_id("fireflies:firefly")
end

local jungle_cavern_floor = function(abs_cracks, humidity, vi, area, data, data_param2)
	local ystride = area.ystride
	local humidityfactor = humidity/100
	
	data[vi] = c_jungle_dirt

	local rand = math.random()
	if rand < 0.025 * humidityfactor then
		local fern_schematic = df_primordial_items.get_fern_schematic()
		local rotation = (math.random(1,4)-1)*90
		mapgen_helper.place_schematic_on_data_if_it_fits(data, data_param2, area, area:position(vi+ystride), fern_schematic, rotation)
	elseif rand < 0.025 * (1-humidityfactor) then
		df_primordial_items.spawn_jungle_mushroom_vm(vi+ystride, area, data)
	elseif rand < 0.05 * (1-humidityfactor) then
		df_primordial_items.spawn_jungle_tree_vm(math.random(8,14), vi+ystride, area, data)
	elseif rand < 0.3 then
		data[vi+ystride] = jungle_plants[math.random(1,#jungle_plants)]
	end
	
	if c_fireflies and math.random() < 0.01 then
		local firefly_vi = vi + ystride * math.random(1, 5)
		if data[firefly_vi] == c_air then
			data[firefly_vi] = c_fireflies
		end
	end
end

local jungle_cavern_ceiling = function(abs_cracks, vi, area, data, data_param2)
	if abs_cracks < 0.25 then
		data[vi] = c_glowstone
	elseif abs_cracks > 0.75 and math.random() < 0.1 then
		local ystride = area.ystride
		data[vi] = c_dirt
		local index = vi - ystride
		local hanging_node
		if math.random() < 0.5 then
			hanging_node = c_ivy
		else
			hanging_node = c_root_2
		end
		for i = 1, math.random(16) do
			if data[index] == c_air then
				data[index] = hanging_node
				index = index - ystride
			else
				break
			end
		end
	end
end

local jungle_warren_ceiling = function(abs_cracks, vi, area, data, data_param2)
	if abs_cracks < 0.1 then
		data[vi] = c_glowstone
	elseif abs_cracks > 0.75 and math.random() < 0.1 then
		local ystride = area.ystride
		data[vi] = c_dirt
		local index = vi - ystride
		local hanging_node
		if math.random() < 0.5 then
			hanging_node = c_root_1
		else
			hanging_node = c_root_2
		end
		for i = 1, math.random(8) do
			if data[index] == c_air then
				data[index] = hanging_node
				index = index - ystride
			else
				break
			end
		end
	end
end

local jungle_warren_floor = function(abs_cracks, vi, area, data, data_param2)
	local ystride = area.ystride
	if abs_cracks < 0.7 then
		data[vi] = c_jungle_dirt
		local rand = math.random() * abs_cracks
		if rand < 0.1 then
			data[vi+ystride] = jungle_plants[math.random(1,#jungle_plants)]
		end
	elseif abs_cracks < 1 then
		data[vi] = c_dirt
	end
	
	if c_fireflies and math.random() < 0.005 then
		local firefly_vi = vi + ystride * math.random(1, 5)
		if data[firefly_vi] == c_air then
			data[firefly_vi] = c_fireflies
		end
	end
end
---------------------------------------------------------------------------------------------------------

local decorate_primordial = function(minp, maxp, seed, vm, node_arrays, area, data)
	math.randomseed(minp.x + minp.y*2^8 + minp.z*2^16 + seed) -- make decorations consistent between runs

	local data_param2 = df_caverns.data_param2
	vm:get_param2_data(data_param2)
	local nvals_cracks = mapgen_helper.perlin2d("df_cavern:cracks", minp, maxp, df_caverns.np_cracks)
	local cave_area = node_arrays.cave_area
	local nvals_cave = node_arrays.nvals_cave
	
	local humiditymap = minetest.get_mapgen_object("humiditymap")

	
	---------------------------------------------------------
	-- Cavern floors
	
	for _, vi in ipairs(node_arrays.cavern_floor_nodes) do
		local index2d = mapgen_helper.index2di(minp, maxp, area, vi)
		local cracks = nvals_cracks[index2d]
		local abs_cracks = math.abs(cracks)
		local humidity = humiditymap[index2d]
		local jungle = nvals_cave[vi] < 0
		
		if jungle then
			jungle_cavern_floor(abs_cracks, humidity, vi, area, data, data_param2)
		else
			mushroom_cavern_floor(abs_cracks, humidity, vi, area, data, data_param2)
		end
	end
	
	--------------------------------------
	-- Cavern ceilings

	for _, vi in ipairs(node_arrays.cavern_ceiling_nodes) do
		local index2d = mapgen_helper.index2di(minp, maxp, area, vi)
		local cracks = nvals_cracks[index2d]
		local abs_cracks = math.abs(cracks)
		local jungle = nvals_cave[vi] < 0
		local humidity = humiditymap[index2d]
		if jungle then
			jungle_cavern_ceiling(abs_cracks, vi, area, data, data_param2)
		else
			mushroom_cavern_ceiling(abs_cracks, humidity, vi, area, data, data_param2)
		end
	end
	
		----------------------------------------------
	-- Tunnel floors
	
--	for _, vi in ipairs(node_arrays.tunnel_floor_nodes) do
--	end
	
	------------------------------------------------------
	-- Tunnel ceiling
	
--	for _, vi in ipairs(node_arrays.tunnel_ceiling_nodes) do
--	end
	
	------------------------------------------------------
	-- Warren ceiling

	for _, vi in ipairs(node_arrays.warren_ceiling_nodes) do
		local index2d = mapgen_helper.index2di(minp, maxp, area, vi)
		local cracks = nvals_cracks[index2d]
		local abs_cracks = math.abs(cracks)
		local jungle = nvals_cave[vi] < 0
		
		if jungle then
			jungle_warren_ceiling(abs_cracks, vi, area, data, data_param2)
		else
			mushroom_warren_ceiling(abs_cracks, vi, area, data, data_param2)
		end

	end

	----------------------------------------------
	-- Warren floors
	
	for _, vi in ipairs(node_arrays.warren_floor_nodes) do
		local index2d = mapgen_helper.index2di(minp, maxp, area, vi)
		local cracks = nvals_cracks[index2d]
		local abs_cracks = math.abs(cracks)
		local jungle = nvals_cave[vi] < 0
		
		if jungle then
			jungle_warren_floor(abs_cracks, vi, area, data, data_param2)
		else
			mushroom_warren_floor(abs_cracks, vi, area, data, data_param2)
		end
	end

	-- columns
	-- no flowstone below the Sunless Sea, replace with something else
	local random_dir = {1, -1, area.zstride, -area.zstride}
	for _, vi in ipairs(node_arrays.column_nodes) do
		local jungle = nvals_cave[vi] < 0
		if jungle then
			data[vi] = c_plant_matter
			minetest.get_node_timer(area:position(vi)):start(math.random(30, 120))
		else
			data[vi] = c_mycelial_dirt
			if math.random() < 0.05 then
				local rand_vi = vi + random_dir[math.random(1,4)]
				if data[rand_vi] == c_air then
					data[rand_vi] = c_giant_mycelium
					minetest.get_node_timer(area:position(rand_vi)):start(math.random(1,giant_mycelium_timer_spread))
				end				
			end
		end
	end

	vm:set_param2_data(data_param2)
end

--Primordial Caverns
subterrane.register_layer({
	name = "primordial",
	y_max = df_caverns.config.primordial_max,
	y_min = df_caverns.config.primordial_min,
	cave_threshold = df_caverns.config.sunless_sea_threshold, -- Make the caves a bit bigger than above
	perlin_cave = perlin_cave_primordial,
	perlin_wave = perlin_wave_primordial,
	solidify_lava = true,
	columns = {
		maximum_radius = 20,
		minimum_radius = 5,
		node = "default:stone", -- no flowstone below the Sunless Sea, replace with something else
		weight = 0.5,
		maximum_count = 60,
		minimum_count = 10,
	},
	decorate = decorate_primordial,
	double_frequency = true,
	is_ground_content = df_caverns.is_ground_content,
})

-- Rather than make plants farmable, have them randomly respawn in jungle soil. You can only get them down there.
minetest.register_abm({
	label = "Primordial plant growth",
	nodenames = {"df_primordial_items:dirt_with_jungle_grass"},
	neighbors = {"air"},
	interval = 60.0,
	chance = 50,
	action = function(pos, node, active_object_count, active_object_count_wider)
		if minetest.find_node_near(pos, 2, {"group:primordial_jungle_plant"}) == nil then
			local pos_above = {x=pos.x, y=pos.y+1, z=pos.z}
			local node_above = minetest.get_node(pos_above)
			if node_above.name == "air" then
				minetest.set_node(pos_above, {name = jungle_plant_names[math.random(1,#jungle_plant_names)]})
			end
		end
	end,
})

minetest.register_abm({
	label = "Primordial fungus growth",
	nodenames = {"df_primordial_items:dirt_with_mycelium"},
	neighbors = {"air"},
	interval = 60.0,
	chance = 50,
	action = function(pos, node, active_object_count, active_object_count_wider)
		if minetest.find_node_near(pos, 3, {"group:primordial_fungal_plant"}) == nil then
			local pos_above = {x=pos.x, y=pos.y+1, z=pos.z}
			local node_above = minetest.get_node(pos_above)
			if node_above.name == "air" then
				minetest.set_node(pos_above, {name = fungal_plant_names[math.random(1,#fungal_plant_names)]})
			end
		end
	end,
})
