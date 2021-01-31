local sidelen = mapgen_helper.block_size

local snap_to_minp = function(ydepth)
	return ydepth - (ydepth+32) % sidelen -- put ydepth at the minp.y of mapblocks
end

function subterrane:register_cave_spawn(cave_layer_def, start_depth)
	minetest.register_on_newplayer(function(player)
		local ydepth = snap_to_minp(start_depth or cave_layer_def.y_max)
		local spawned = false
		while spawned ~= true do
			spawned = spawnplayer(cave_layer_def, player, ydepth)
			ydepth = ydepth - sidelen
			if ydepth < cave_layer_def.y_min then
				ydepth = snap_to_minp(cave_layer_def.y_max)
			end
		end
	end)

	minetest.register_on_respawnplayer(function(player)
		local ydepth = snap_to_minp(start_depth or cave_layer_def.y_max)
		local spawned = false
		while spawned ~= true do
			spawned = spawnplayer(cave_layer_def, player, ydepth)
			ydepth = ydepth - sidelen
			if ydepth < cave_layer_def.y_min then
				ydepth = snap_to_minp(cave_layer_def.y_max)
			end
		end
		return true
	end)
end

local outside_region = 0
local inside_ground = 1
local inside_cavern = 2

-- Spawn player underground in a giant cavern
function spawnplayer(cave_layer_def, player, ydepth)
	subterrane.set_defaults(cave_layer_def)

	local YMIN = cave_layer_def.y_min
	local YMAX = cave_layer_def.y_max
	local BLEND = math.min(cave_layer_def.boundary_blend_range, (YMAX-YMIN)/2)

	local TCAVE = cave_layer_def.cave_threshold
	
	local np_cave = cave_layer_def.perlin_cave
	local np_wave = cave_layer_def.perlin_wave
	
	local y_blend_min = YMIN + BLEND * 1.5
	local y_blend_max = YMAX - BLEND * 1.5	
	
	local column_def = cave_layer_def.columns
	local double_frequency = cave_layer_def.double_frequency

	local options = {}

	for chunk = 1, 64 do
		minetest.log("info", "[subterrane] searching for spawn "..chunk)
				
		local minp = {x = sidelen * math.random(-32, 32) - 32, z = sidelen * math.random(-32, 32) - 32, y = ydepth}
		local maxp = {x = minp.x + sidelen - 1, z = minp.z + sidelen - 1, y = ydepth + sidelen - 1}

		local nvals_cave, cave_area = mapgen_helper.perlin3d("subterrane:cave", minp, maxp, np_cave) --cave noise for structure
		local nvals_wave = mapgen_helper.perlin3d("subterrane:wave", minp, maxp, np_wave) --wavy structure of cavern ceilings and floors

		-- pre-average everything
		for vi, value in ipairs(nvals_cave) do
			nvals_cave[vi] = (value + nvals_wave[vi])/2
		end
		local column_points = nil
		local column_weight = nil		
		
		local previous_y = minp.y
		local previous_node_state = outside_region
	
		for vi, x, y, z in cave_area:iterp_yxz(vector.add(minp, 2), vector.subtract(maxp, 2)) do
			
			if y < previous_y then
				previous_node_state = outside_region
			end
			previous_y = y
			
			local cave_local_threshold
			if y < y_blend_min then
				cave_local_threshold = TCAVE + ((y_blend_min - y) / BLEND) ^ 2
			elseif y > y_blend_max then
				cave_local_threshold = TCAVE + ((y - y_blend_max) / BLEND) ^ 2
			else
				cave_local_threshold = TCAVE
			end

			local cave_value = nvals_cave[vi]
			if double_frequency then
				cave_value = math.abs(cave_value)
			end			
		
			-- inside a giant cavern
			if cave_value > cave_local_threshold then
				local column_value = 0
				local inside_column = false
				if column_def then
					if column_points == nil then
						column_points = subterrane.get_column_points(minp, maxp, column_def)
						column_weight = column_def.weight
					end
					column_value = subterrane.get_column_value({x=x, y=y, z=z}, column_points)
				end
				inside_column =  column_value > 0 and cave_value - column_value * column_weight < cave_local_threshold
				if previous_node_state == inside_ground and not inside_column then
					-- we just entered the cavern from below. Do a quick check for head space.
					local val_above = nvals_cave[vi+cave_area.ystride]
					if double_frequency then
						val_above = math.abs(val_above)
					end
					if val_above > cave_local_threshold then
						table.insert(options, {x=x, y=y+1, z=z})
					end
				end
				if not inside_column then
					previous_node_state = inside_cavern
				else
					previous_node_state = inside_ground
				end

			else
				previous_node_state = inside_ground
			end
		end

		if table.getn(options) > 20 then -- minimum 20 to ensure the player is put in a place with a modicum of size
			local choice = math.random(1, table.getn(options))
			local spawnpoint = options[ choice ]
			minetest.log("action", "[subterrane] spawning player " .. minetest.pos_to_string(spawnpoint))
			player:setpos(spawnpoint)
			return true
		end
	end
	return false
end
