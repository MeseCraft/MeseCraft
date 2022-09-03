local add_biome_restrictions = function(root_table, function_name, biome_set)
	local old_function = root_table[function_name]
	root_table[function_name] = function(pos)
		local biome = df_caverns.get_biome(pos)
		return old_function(pos) and biome_set[biome]
	end
end

if df_caverns.config.restrict_trees_to_biomes then

	if minetest.get_modpath("df_trees") then
		add_biome_restrictions(df_trees, "black_cap_growth_permitted", {blackcap = true})
		add_biome_restrictions(df_trees, "blood_thorn_growth_permitted", {bloodthorn = true})
		add_biome_restrictions(df_trees, "fungiwood_growth_permitted", {fungiwood = true, fungispore = true})
		add_biome_restrictions(df_trees, "goblin_cap_growth_permitted", {goblincap = true, towergoblin = true})
		add_biome_restrictions(df_trees, "nether_cap_growth_permitted", {nethercap = true})
		add_biome_restrictions(df_trees, "spore_tree_growth_permitted", {sporetree = true, fungispore = true})
		add_biome_restrictions(df_trees, "tower_cap_growth_permitted", {towercap = true, towergoblin = true})
		add_biome_restrictions(df_trees, "tunnel_tube_growth_permitted", {tunneltube = true})
		-- Deliberately not biome-restricted
		--add_biome_restrictions(df_trees, "torchspine_growth_permitted", {})
		--add_biome_restrictions(df_trees, "spindlestem_growth_permitted", {})
	end

	if minetest.get_modpath("df_primordial_items") then
		add_biome_restrictions(df_primordial_items, "primordial_mushroom_growth_permitted", {["primordial fungus"] = true})
		add_biome_restrictions(df_primordial_items, "giant_mycelium_growth_permitted", {["primordial fungus"] = true})
		add_biome_restrictions(df_primordial_items, "giant_fern_growth_permitted", {["primordial jungle"] = true})
		add_biome_restrictions(df_primordial_items, "jungle_mushroom_growth_permitted", {["primordial jungle"] = true})
		add_biome_restrictions(df_primordial_items, "jungletree_growth_permitted", {["primordial jungle"] = true})
	end

end

if df_caverns.config.restrict_farmables_to_biomes and minetest.get_modpath("df_farming") then
	add_biome_restrictions(df_farming.growth_permitted, "df_farming:cave_wheat_seed",
		{fungiwood = true, tunneltube = true, sporetree = true, fungispore = true})
	add_biome_restrictions(df_farming.growth_permitted, "df_farming:dimple_cup_seed",
		{towergoblin = true})
	add_biome_restrictions(df_farming.growth_permitted, "df_farming:pig_tail_seed",
		{sporetree = true, fungispore = true})
	add_biome_restrictions(df_farming.growth_permitted, "df_farming:quarry_bush_seed",
		{bloodthorn = true})
	add_biome_restrictions(df_farming.growth_permitted, "df_farming:sweet_pod_seed",
		{tunneltube = true, fungispore = true})
	add_biome_restrictions(df_farming.growth_permitted, "df_farming:plump_helmet_spawn",
		{fungiwood = true, towercap = true, goblincap = true, towergoblin = true})
end