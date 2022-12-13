local registered_nodes = minetest.registered_nodes
local get_node_or_nil = minetest.get_node_or_nil

-- water flow functions by QwertyMine3, edited by TenPlus1
-- Copied from https://notabug.org/TenPlus1/builtin_item
local inv_roots = {
	[0] = 1,
	[1] = 1,
	[2] = 0.70710678118655,
	[4] = 0.5,
	[5] = 0.44721359549996,
	[8] = 0.35355339059327
}

function tnt.to_unit_vector(dir_vector)
	local x = dir_vector.x
	local z = dir_vector.z
	local sum = x * x + z * z

	return {
		x = x * inv_roots[sum],
		y = dir_vector.y,
		z = z * inv_roots[sum]
	}
end

function tnt.quick_flow_logic(node, pos_testing, direction)
	local node_testing = get_node_or_nil(pos_testing)

	if node_testing and registered_nodes[node_testing.name].liquidtype == "none" then
		return 0
	end

	local param2_testing = node_testing.param2

	if param2_testing < node.param2 then

		if (node.param2 - param2_testing) > 6 then
			return -direction
		else
			return direction
		end

	elseif param2_testing > node.param2 then

		if (param2_testing - node.param2) > 6 then
			return direction
		else
			return -direction
		end
	end

	return 0
end

local to_unit_vector = tnt.to_unit_vector
local quick_flow_logic = tnt.quick_flow_logic

function tnt.quick_flow(pos, node)
	if registered_nodes[node.name].liquidtype == "none" then
		return {x = 0, y = 0, z = 0}
	end

	local pos_x = pos.x
	local pos_y = pos.y
	local pos_z = pos.z
	local x, z = 0, 0

	x = x + quick_flow_logic(node, {x = pos_x - 1, y = pos_y, z = pos_z},-1)
	x = x + quick_flow_logic(node, {x = pos_x + 1, y = pos_y, z = pos_z}, 1)
	z = z + quick_flow_logic(node, {x = pos_x, y = pos_y, z = pos_z - 1},-1)
	z = z + quick_flow_logic(node, {x = pos_x, y = pos_y, z = pos_z + 1}, 1)

	return to_unit_vector({x = x, y = 0, z = z})
end
