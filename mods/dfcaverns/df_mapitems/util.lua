-- Used by cave pearls and crystal clusters
-- These methods simulate "wallmounted" nodes using regular facedir, randomizing the rotation around the wallmounted direction.
-- Useful for naturalistic objects you want to have look irregular

df_mapitems.place_against_surface = function(itemstack, placer, pointed_thing)
	-- check if pointing at a node
	if not pointed_thing then
		return itemstack
	end
	if pointed_thing.type ~= "node" then
		return itemstack
	end
	
	local under_pos = pointed_thing.under
	local above_pos = pointed_thing.above

	local under_node = minetest.get_node(under_pos)
	local above_node = minetest.get_node(above_pos)

	if minetest.is_protected(above_pos, placer:get_player_name()) then
		minetest.record_protection_violation(above_pos, placer:get_player_name())
		return
	end

	local under_name = under_node.name
	local above_name = above_node.name
	local under_def = minetest.registered_nodes[under_name]
	local above_def = minetest.registered_nodes[above_name]
	
	-- return if any of the nodes is not registered
	if not under_def or not above_def then
		return itemstack
	end
	-- check if you can replace the node above the pointed node
	if not above_def.buildable_to then
		return itemstack
	end

	local dir = vector.subtract(under_pos, above_pos)
	local param2
	if dir.x > 0 then
		--facing +x: 16, 17, 18, 19,
		param2 = 15 + math.random(1,4)
	elseif dir.x < 0 then
		--facing -x: 12, 13, 14, 15
		param2 = 11 + math.random(1,4)
	elseif dir.z > 0 then
		--facing +z: 8, 9, 10, 11
		param2 = 7 + math.random(1,4)
	elseif dir.z < 0 then
		--facing -z: 4, 5, 6, 7
		param2 = 3 + math.random(1,4)
	elseif dir.y > 0 then
		--facing -y: 20, 21, 22, 23 (ceiling)
		param2 = 19 + math.random(1,4)
	else
		--facing +y: 0, 1, 2, 3 (floor)
		param2 = math.random(1,4) - 1
	end
	-- add the node and remove 1 item from the itemstack
	minetest.add_node(above_pos, {name = itemstack:get_name(), param2 = param2})
	if not minetest.settings:get_bool("creative_mode", false) and not minetest.check_player_privs(placer, "creative") then
		itemstack:take_item()
	end
	return itemstack
end

-- Mapgen version of the above

local add_to_table = function(dest, source)
	for _, val in ipairs(source) do
		table.insert(dest, val)
	end
end

local valid_nodes = {} -- cache values
local is_valid_mounting_node = function(c_node)
	if valid_nodes[c_node] ~= nil then
		return valid_nodes[c_node]
	end
	local def = minetest.registered_nodes[minetest.get_name_from_content_id(c_node)]
	if def ~= nil
		and (def.drawtype == "normal" or def.drawtype == nil)
		and not def.buildable_to
		and not (def.groups and def.groups.falling_node) then
			valid_nodes[c_node] = true
			return true
	end
	valid_nodes[c_node] = false
	return false
end

--facing +x: 16, 17, 18, 19, 
--facing -x: 12, 13, 14, 15
--facing +z: 8, 9, 10, 11
--facing -z: 4, 5, 6, 7
--facing -y: 20, 21, 22, 23, (ceiling)
--facing +y: 0, 1, 2, 3

local get_valid_facedirs_vm = function(vi, area, data)
	local dirs = {}
	local ystride = area.ystride
	local zstride = area.zstride
	if is_valid_mounting_node(data[vi+1]) then
		add_to_table(dirs, {16, 17, 18, 19})
	end
	if is_valid_mounting_node(data[vi-1]) then
		add_to_table(dirs, {12, 13, 14, 15})
	end
	if is_valid_mounting_node(data[vi-ystride]) then
		add_to_table(dirs, {0, 1, 2, 3})
	end
	if is_valid_mounting_node(data[vi+ystride]) then
		add_to_table(dirs, {20, 21, 22, 23})
	end
	if is_valid_mounting_node(data[vi+zstride]) then
		add_to_table(dirs, {8, 9, 10, 11})
	end
	if is_valid_mounting_node(data[vi-zstride]) then
		add_to_table(dirs, {4, 5, 6, 7})
	end
	return dirs
end

df_mapitems.place_against_surface_vm = function(c_node, vi, area, data, data_param2)
	local facedirs = get_valid_facedirs_vm(vi, area, data)
	local count = #facedirs
	if count > 0 then
		data[vi] = c_node
		data_param2[vi] = facedirs[math.random(1, count)]
	end
end