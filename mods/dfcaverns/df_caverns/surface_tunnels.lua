-- surface tunnels

local y_max = 200
local y_min = df_caverns.config.ymax

local c_stone = minetest.get_content_id("default:stone")
local c_air = minetest.get_content_id("air")

minetest.register_on_generated(function(minp, maxp, seed)
	--if out of range of cave definition limits, abort
	if minp.y > y_max or maxp.y < y_min then
		return
	end	
	
	local t_start = os.clock()

	local vm, data, data_param2, area = mapgen_helper.mapgen_vm_data_param2()

	local eminp = {x=minp.x, y=area.MinEdge.y, z=minp.z}
	local emaxp = {x=maxp.x, y=area.MaxEdge.y, z=maxp.z}
	local minp_y = minp.y
	local maxp_y = maxp.y
	
	local humiditymap = minetest.get_mapgen_object("humiditymap")
	local nvals_cracks = mapgen_helper.perlin2d("df_cavern:cracks", minp, maxp, df_caverns.np_cracks)

	local previous_y = eminp.y-1
	
	local previous_potential_floor_vi
	local previous_potential_floor_y
	local previous_node
	
	for vi, x, y, z in area:iterp_yxz(eminp, emaxp) do
		
		if y < previous_y then
			-- we've started a new column, initialize everything
			previous_potential_floor_vi = nil
			previous_potential_floor_y = nil
			previous_node = nil
		end
		previous_y = y
		
		local current_node = data[vi]
		if previous_node and y < y_max then
			if current_node == c_air and previous_node == c_stone then
				-- this may be a floor, but only if we eventually hit a ceiling in this column
				previous_potential_floor_vi = vi-area.ystride
				previous_potential_floor_y = y-1
			elseif current_node == c_stone and previous_node == c_air and previous_potential_floor_vi then
				-- we hit a ceiling after passing through a floor
				local index2d = mapgen_helper.index2d(minp, maxp, x, z)
				local humidity = humiditymap[index2d]
				if previous_potential_floor_y <= maxp_y and previous_potential_floor_y >= minp_y then
					df_caverns.tunnel_floor(minp, maxp, area, previous_potential_floor_vi, nvals_cracks, data, data_param2, humidity > 30)
				end
				if y <= maxp_y and y >= minp_y then
					df_caverns.tunnel_ceiling(minp, maxp, area, vi, nvals_cracks, data, data_param2, humidity > 30)
				end
				previous_potential_floor_vi = nil
			elseif not mapgen_helper.buildable_to(current_node) then
				-- we've entered a non-stone ceiling of some kind. Abort potential floor-ceiling pair detection.
				previous_potential_floor_vi = nil
			end
		end
		previous_node = current_node
		
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
	
	local time_taken = os.clock() - t_start -- how long this chunk took, in seconds
	mapgen_helper.record_time("df_caverns surface tunnels", time_taken)
end)
