-- these methods should indicate whether a sapling placed at pos should bother attempting to grow.
-- check soil conditions and biome here, for example.

local stone_with_coal = df_dependencies.node_name_stone_with_coal
local coalblock = df_dependencies.node_name_coalblock
local is_coal = function(name)
	return name == stone_with_coal or name == coalblock
end

df_trees.black_cap_growth_permitted = function(pos)
	local below_name = minetest.get_node({x=pos.x, y=pos.y-1, z=pos.z}).name
	return minetest.get_item_group(below_name, "soil") > 0 or is_coal(below_name)
end

df_trees.blood_thorn_growth_permitted = function(pos)
	return minetest.get_item_group(minetest.get_node({x=pos.x, y=pos.y-1, z=pos.z}).name, "sand") > 0
end

df_trees.fungiwood_growth_permitted = function(pos)
	return minetest.get_item_group(minetest.get_node({x=pos.x, y=pos.y-1, z=pos.z}).name, "soil") > 0
end

df_trees.goblin_cap_growth_permitted = function(pos)
	return minetest.get_item_group(minetest.get_node({x=pos.x, y=pos.y-1, z=pos.z}).name, "soil") > 0
end

df_trees.nether_cap_growth_permitted = function(pos)
	local below_name = minetest.get_node({x=pos.x, y=pos.y-1, z=pos.z}).name
	return (minetest.get_item_group(below_name, "cools_lava") > 0 or minetest.get_item_group(below_name, "ice") > 0)
		and minetest.get_item_group(below_name, "nether_cap") == 0
end

df_trees.spindlestem_growth_permitted = function(pos)
	return minetest.get_item_group(minetest.get_node({x=pos.x, y=pos.y-1, z=pos.z}).name, "soil") > 0
end

df_trees.spore_tree_growth_permitted = function(pos)
	return minetest.get_item_group(minetest.get_node({x=pos.x, y=pos.y-1, z=pos.z}).name, "soil") > 0
end

df_trees.torchspine_growth_permitted = function(pos)
	local below_name = minetest.get_node({x=pos.x, y=pos.y-1, z=pos.z}).name
	return minetest.get_item_group(below_name, "flammable") > 0 or is_coal(below_name)
end

df_trees.tower_cap_growth_permitted = function(pos)
	return minetest.get_item_group(minetest.get_node({x=pos.x, y=pos.y-1, z=pos.z}).name, "soil") > 0
end

df_trees.tunnel_tube_growth_permitted = function(pos)
	return minetest.get_item_group(minetest.get_node({x=pos.x, y=pos.y-1, z=pos.z}).name, "soil") > 0
end