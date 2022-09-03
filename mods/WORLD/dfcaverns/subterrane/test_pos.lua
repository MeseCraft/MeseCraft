-- If pos is located inside a cavern volume, returns the list of cavern definitions that
-- are responsible for that cavern volume. If not inside a cavern volume returns an empty list.

-- This is a somewhat expensive function, take care not to use it more than necessary
subterrane.is_in_cavern = function(pos)
	local results = {}
	
	for _, cave_layer_def in pairs(subterrane.registered_layers) do
		local YMIN = cave_layer_def.y_min
		local YMAX = cave_layer_def.y_max
		local y = pos.y
		if y <= YMAX and y >= YMIN then
			local block_size = mapgen_helper.block_size
			local BLEND = math.min(cave_layer_def.boundary_blend_range, (YMAX-YMIN)/2)
			local TCAVE = cave_layer_def.cave_threshold
			local np_cave = cave_layer_def.perlin_cave
			local np_wave = cave_layer_def.perlin_wave
			local y_blend_min = YMIN + BLEND * 1.5
			local y_blend_max = YMAX - BLEND * 1.5	
			local nval_cave = minetest.get_perlin(np_cave):get_3d(pos) --cave noise for structure
			local nval_wave = minetest.get_perlin(np_wave):get_3d(pos) --wavy structure of cavern ceilings and floors
			nval_cave = (nval_cave + nval_wave)/2
			local cave_local_threshold
			if y < y_blend_min then
				cave_local_threshold = TCAVE + ((y_blend_min - y) / BLEND) ^ 2
			elseif y > y_blend_max then
				cave_local_threshold = TCAVE + ((y - y_blend_max) / BLEND) ^ 2
			else
				cave_local_threshold = TCAVE
			end
			if cave_layer_def.double_frequency and nval_cave < 0 then
				nval_cave = -nval_cave
			end
			if nval_cave > cave_local_threshold then
				table.insert(results, cave_layer_def)
			end
		end
	end
	
	return results
end

-- returns the value of the cavern field at a particular location for a particular cavern definition.
subterrane.get_cavern_value = function(name, pos)
	local cave_layer_def = subterrane.registered_layers[name]
	
	local YMIN = cave_layer_def.y_min
	local YMAX = cave_layer_def.y_max
	local y = pos.y
	if y > YMAX or y < YMIN then
		return nil
	end

	local block_size = mapgen_helper.block_size
	local BLEND = math.min(cave_layer_def.boundary_blend_range, (YMAX-YMIN)/2)
	local TCAVE = cave_layer_def.cave_threshold
	local np_cave = cave_layer_def.perlin_cave
	local np_wave = cave_layer_def.perlin_wave
	local y_blend_min = YMIN + BLEND * 1.5
	local y_blend_max = YMAX - BLEND * 1.5	
	local nval_cave = minetest.get_perlin(np_cave):get_3d(pos) --cave noise for structure
	local nval_wave = minetest.get_perlin(np_wave):get_3d(pos) --wavy structure of cavern ceilings and floors
	nval_cave = (nval_cave + nval_wave)/2
	return nval_cave
end