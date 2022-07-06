if minetest.get_modpath("dungeon_loot") then

if df_caverns.config.enable_underworld then
	dungeon_loot.register({
		{name = "df_underworld_items:glow_amethyst", chance = 0.3, count = {1, 12}, y = {-32768, df_caverns.config.lava_sea_level}},
	})
end

if df_caverns.config.enable_oil_sea and minetest.get_modpath("mesecraft_bucket") then
	dungeon_loot.register({
		{name = "oil:oil_bucket", chance = 0.5, count = {1, 3}, y = {-32768, df_caverns.config.ymax}},
	})
end

if df_caverns.config.enable_lava_sea then
	dungeon_loot.register({
		{name = "df_mapitems:mese_crystal", chance = 0.25, count = {1, 5}, y = {-32768, df_caverns.config.sunless_sea_min}},
		{name = "df_mapitems:glow_mese", chance = 0.1, count = {1, 3}, y = {-32768, df_caverns.config.sunless_sea_min}},
	})
end

dungeon_loot.register({
	{name = "df_farming:cave_wheat_seed", chance = 0.5, count = {1, 10}, y = {-32768, df_caverns.config.ymax}},
	{name = "df_farming:cave_bread", chance = 0.8, count = {1, 10}, y = {-32768, df_caverns.config.ymax}},
	{name = "df_farming:pig_tail_thread", chance = 0.7, count = {1, 10}, y = {-32768, df_caverns.config.ymax}},
	{name = "df_farming:plump_helmet_spawn", chance = 0.4, count = {1, 8}, y = {-32768, df_caverns.config.ymax}},
	{name = "df_farming:plump_helmet_4_picked", chance = 0.8, count = {1, 15}, y = {-32768, df_caverns.config.ymax}},
	{name = "df_trees:glowing_bottle_red", chance = 0.6, count = {1, 20}, y = {-32768, df_caverns.config.ymax}},
	{name = "df_trees:glowing_bottle_green", chance = 0.5, count = {1, 20}, y = {-32768, df_caverns.config.ymax}},
	{name = "df_trees:glowing_bottle_cyan", chance = 0.4, count = {1, 15}, y = {-32768, df_caverns.config.ymax}},
	{name = "df_trees:glowing_bottle_golden", chance = 0.3, count = {1, 5}, y = {-32768, df_caverns.config.ymax}},

	{name = "df_farming:pig_tail_seed", chance = 0.5, count = {1, 10}, y = {-32768, df_caverns.config.level1_min}},
	{name = "df_mapitems:med_crystal", chance = 0.2, count = {1, 2}, y = {-32768, df_caverns.config.level1_min}},

	{name = "df_farming:dimple_cup_seed", chance = 0.3, count = {1, 10}, y = {-32768, df_caverns.config.level2_min}},
	{name = "df_farming:quarry_bush_seed", chance = 0.3, count = {1, 5}, y = {-32768, df_caverns.config.level2_min}},
	{name = "df_farming:sweet_pod_seed", chance = 0.3, count = {1, 5}, y = {-32768, df_caverns.config.level2_min}},
	{name = "df_mapitems:big_crystal", chance = 0.1, count = {1, 1}, y = {-32768, df_caverns.config.level2_min}},
	{name = "df_trees:torchspine_ember", chance = 0.3, count = {1, 3}, y = {-32768, df_caverns.config.level2_min}},
	{name = "ice_sprites:ice_sprite_bottle", chance = 0.1, count = {1, 1}, y = {-32768, df_caverns.config.level2_min}},
})

end

if minetest.get_modpath("bones_loot") and df_caverns.config.enable_underworld then

bones_loot.register_loot({
	{name = "binoculars:binoculars", chance = 0.05, count = {1,1}, types = {"underworld_warrior"}},
	{name = "boats:boat", chance = 0.05, count = {1,1}, types = {"underworld_warrior"}},
	{name = "mesecraft_bucket:bucket_empty", chance = 0.3, count = {1,1}, types = {"underworld_warrior"}},
	{name = "fire:flint_and_steel", chance = 0.3, count = {1,1}, types = {"underworld_warrior"}},
	{name = "flowers:tulip_black", chance = 0.05, count = {1,1}, types = {"underworld_warrior"}},
	{name = "flowers:dandelion_white", chance = 0.05, count = {1,1}, types = {"underworld_warrior"}},
	{name = "flowers:dandelion_yellow", chance = 0.05, count = {1,1}, types = {"underworld_warrior"}},
	{name = "flowers:rose", chance = 0.05, count = {1,1}, types = {"underworld_warrior"}},
	{name = "flowers:tulip", chance = 0.05, count = {1,1}, types = {"underworld_warrior"}},
	{name = "flowers:chrysanthemum_green", chance = 0.05, count = {1,1}, types = {"underworld_warrior"}},
	{name = "flowers:geranium", chance = 0.05, count = {1,1}, types = {"underworld_warrior"}},
	{name = "map:mapping_kit", chance = 0.1, count = {1,1}, types = {"underworld_warrior"}},
	{name = "screwdriver:screwdriver", chance = 0.05, count = {1,1}, types = {"underworld_warrior"}},
	-- don't give the player tnt:tnt, they can craft that from this if tnt is enabled for them
	{name = "tnt:gunpowder", chance = 0.4, count = {1,10}, types = {"underworld_warrior"}},
	{name = "tnt:tnt_stick", chance = 0.3, count = {1,6}, types = {"underworld_warrior"}},

	{name = "vessels:steel_bottle", chance = 0.4, count = {1,3}, types = {"underworld_warrior"}},
	{name = "vessels:glass_bottle", chance = 0.2, count = {1,2}, types = {"underworld_warrior"}},
	{name = "vessels:glass_fragments", chance = 0.1, count = {1,4}, types = {"underworld_warrior"}},
	
	{name = "default:book", chance = 0.05, count = {1,1}, types = {"underworld_warrior"}},
	{name = "default:paper", chance = 0.1, count = {1,6}, types = {"underworld_warrior"}},
	{name = "default:skeleton_key", chance = 0.05, count = {1,1}, types = {"underworld_warrior"}},
	{name = "default:torch", chance = 0.75, count = {1,10}, types = {"underworld_warrior"}},
	
	{name = "default:pick_bronze",    chance = 0.15, count = {1,1}, types = {"underworld_warrior"}},
	{name = "default:pick_steel",     chance = 0.1, count = {1,1}, types = {"underworld_warrior"}},
	{name = "default:pick_mese",      chance = 0.05, count = {1,1}, types = {"underworld_warrior"}},
	{name = "default:pick_diamond",   chance = 0.05, count = {1,1}, types = {"underworld_warrior"}},
	{name = "default:shovel_bronze",  chance = 0.1, count = {1,1}, types = {"underworld_warrior"}},
	{name = "default:shovel_steel",   chance = 0.05, count = {1,1}, types = {"underworld_warrior"}},
	{name = "default:shovel_mese",    chance = 0.025, count = {1,1}, types = {"underworld_warrior"}},
	{name = "default:shovel_diamond", chance = 0.025, count = {1,1}, types = {"underworld_warrior"}},
	{name = "default:axe_bronze",     chance = 0.3, count = {1,1}, types = {"underworld_warrior"}},
	{name = "default:axe_steel",      chance = 0.5, count = {1,1}, types = {"underworld_warrior"}},
	{name = "default:axe_mese",       chance = 0.15, count = {1,1}, types = {"underworld_warrior"}},
	{name = "default:axe_diamond",    chance = 0.15, count = {1,1}, types = {"underworld_warrior"}},
	{name = "default:sword_bronze",   chance = 0.5, count = {1,1}, types = {"underworld_warrior"}},
	{name = "default:sword_steel",    chance = 0.75, count = {1,1}, types = {"underworld_warrior"}},
	{name = "default:sword_mese",     chance = 0.35, count = {1,1}, types = {"underworld_warrior"}},
	{name = "default:sword_diamond",  chance = 0.35, count = {1,1}, types = {"underworld_warrior"}},
	
	{name = "default:coal_lump",             chance = 0.5, count = {1,5}, types = {"underworld_warrior"}},
	{name = "default:mese_crystal",          chance = 0.1, count = {1,1}, types = {"underworld_warrior"}},
	{name = "default:diamond",               chance = 0.1, count = {1,1}, types = {"underworld_warrior"}},
	{name = "default:steel_ingot",           chance = 0.2, count = {1,3}, types = {"underworld_warrior"}},
	{name = "default:copper_ingot",          chance = 0.1, count = {1,2}, types = {"underworld_warrior"}},
	{name = "default:bronze_ingot",          chance = 0.2, count = {1,5}, types = {"underworld_warrior"}},
	{name = "default:gold_ingot",            chance = 0.3, count = {1,3}, types = {"underworld_warrior"}},
	{name = "default:mese_crystal_fragment", chance = 0.4, count = {1,5}, types = {"underworld_warrior"}}, 
	{name = "default:obsidian_shard",        chance = 0.4, count = {1,3}, types = {"underworld_warrior"}},
	{name = "default:flint",                 chance = 0.3, count = {1,1}, types = {"underworld_warrior"}},
	{name = "default:sign_wall_wood",  chance = 0.1, count = {1,4}, types = {"underworld_warrior"}},
	{name = "default:sign_wall_steel", chance = 0.1, count = {1,2}, types = {"underworld_warrior"}},
	{name = "default:ladder_wood",     chance = 0.5, count = {1,10}, types = {"underworld_warrior"}},
	{name = "default:ladder_steel",    chance = 0.2, count = {1,5}, types = {"underworld_warrior"}},
	{name = "default:meselamp",        chance = 0.1, count = {1,2}, types = {"underworld_warrior"}},
	{name = "default:mese_post_light", chance = 0.25, count = {1,5}, types = {"underworld_warrior"}},

	{name = "ice_sprites:ice_sprite_bottle", chance = 0.025, count = {1, 1}, types = {"underworld_warrior"}},
	{name = "df_underworld_items:glow_amethyst", chance = 0.25, count = {1, 2}, types = {"underworld_warrior"}},
})  

if df_caverns.config.enable_lava_sea then
	bones_loot.register_loot({name = "df_mapitems:mese_crystal", chance = 0.25, count = {1, 2}, types = {"underworld_warrior"}})
end

end 
