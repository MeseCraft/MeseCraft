-- these methods should indicate whether a sapling placed at pos should bother attempting to grow.
-- check soil conditions and biome here, for example.

df_primordial_items.giant_fern_growth_permitted = function(pos)
	return minetest.get_item_group(minetest.get_node({x=pos.x, y=pos.y-1, z=pos.z}).name, "soil") > 0
end

df_primordial_items.giant_mycelium_growth_permitted = function(pos)
	return true
end

df_primordial_items.jungle_mushroom_growth_permitted = function(pos)
	return minetest.get_item_group(minetest.get_node({x=pos.x, y=pos.y-1, z=pos.z}).name, "soil") > 0
end

df_primordial_items.jungletree_growth_permitted = function(pos)
	return minetest.get_item_group(minetest.get_node({x=pos.x, y=pos.y-1, z=pos.z}).name, "soil") > 0
end

df_primordial_items.primordial_mushroom_growth_permitted = function(pos)
	return minetest.get_item_group(minetest.get_node({x=pos.x, y=pos.y-1, z=pos.z}).name, "soil") > 0
end