hopper.containers = {}
hopper.groups = {}
hopper.neighbors = {}

-- global function to add new containers
function hopper:add_container(list)
	for _, entry in pairs(list) do
	
		local target_node = entry[2]
		local neighbor_node
		
		if string.sub(target_node, 1, 6) == "group:" then
			local group_identifier, group_number
			local equals_index = string.find(target_node, "=")
			if equals_index ~= nil then
				group_identifier = string.sub(target_node, 7, equals_index-1)
				-- it's possible that the string was of the form "group:blah = 1", in which case we want to trim spaces off the end of the group identifier
				local space_index = string.find(group_identifier, " ") 
				if space_index ~= nil then
					group_identifier = string.sub(group_identifier, 1, space_index-1)
				end
				group_number = tonumber(string.sub(target_node, equals_index+1, -1))
			else
				group_identifier = string.sub(target_node, 7, -1)
				group_number = "all" -- special value to indicate no number was provided
			end
			
			local group_info = hopper.groups[group_identifier]
			if group_info == nil then
				group_info = {}
			end
			if group_info[group_number] == nil then
				group_info[group_number] = {}
			end
			group_info[group_number][entry[1]] = entry[3]
			hopper.groups[group_identifier] = group_info
			neighbor_node = "group:"..group_identifier
			-- result is a table of the form groups[group_identifier][group_number][relative_position][inventory_name]
		else
			local node_info = hopper.containers[target_node]
			if node_info == nil then
				node_info = {}
			end
			node_info[entry[1]] = entry[3]
			hopper.containers[target_node] = node_info
			neighbor_node = target_node
			-- result is a table of the form containers[target_node_name][relative_position][inventory_name]
		end
		
		local already_in_neighbors = false
		for _, value in pairs(hopper.neighbors) do
			if value == neighbor_node then
				already_in_neighbors = true
				break
			end
		end
		if not already_in_neighbors then
			table.insert(hopper.neighbors, neighbor_node)
		end
	end
end

-- "top" indicates what inventory the hopper will take items from if this node is located at the hopper's wide end
-- "side" indicates what inventory the hopper will put items into if this node is located at the hopper's narrow end and at the same height as the hopper
-- "bottom" indicates what inventory the hopper will put items into if this node is located at the hopper's narrow end and either above or below the hopper.

hopper:add_container({
	{"top", "hopper:hopper", "main"},
	{"bottom", "hopper:hopper", "main"},
	{"side", "hopper:hopper", "main"},
	{"side", "hopper:hopper_side", "main"},
	
	{"bottom", "hopper:chute", "main"},
	{"side", "hopper:chute", "main"},
	
	{"bottom", "hopper:sorter", "main"},
	{"side", "hopper:sorter", "main"},
})

if minetest.get_modpath("default") then
	hopper:add_container({
		{"top", "default:chest", "main"},
		{"bottom", "default:chest", "main"},
		{"side", "default:chest", "main"},
	
		{"top", "default:furnace", "dst"},
		{"bottom", "default:furnace", "src"},
		{"side", "default:furnace", "fuel"},
	
		{"top", "default:furnace_active", "dst"},
		{"bottom", "default:furnace_active", "src"},
		{"side", "default:furnace_active", "fuel"},
	
		{"top", "default:chest_locked", "main"},
		{"bottom", "default:chest_locked", "main"},
		{"side", "default:chest_locked", "main"},
	})
end

-- protector redo mod support
if minetest.get_modpath("protector") then
	hopper:add_container({
		{"top", "protector:chest", "main"},
		{"bottom", "protector:chest", "main"},
		{"side", "protector:chest", "main"},
	})
end

-- wine mod support
if minetest.get_modpath("wine") then
	hopper:add_container({
		{"top", "wine:wine_barrel", "dst"},
		{"bottom", "wine:wine_barrel", "src"},
		{"side", "wine:wine_barrel", "src"},
	})
end

