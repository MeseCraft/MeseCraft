--[[
=====================================================================
Minetest mod: Bedrock

Copyright (c) 2013-2017 Hugo Locurcio and contributors.
Licensed under the zlib license. See LICENSE.md for more information.
=====================================================================
--]]

minetest.register_ore({
	ore_type = "scatter",
	ore = "bedrock:bedrock",
	wherein = "default:stone",
	clust_scarcity = 1 * 1 * 1,
	clust_num_ores = 5,
	clust_size = 2,
	y_min = -30912,

	-- 256 layers of bedrock (caves will still cut through it)
	y_max = -30000,
})

minetest.register_ore({
	ore_type = "scatter",
	ore = "bedrock:deepstone",
	wherein = "default:stone",
	clust_scarcity = 1 * 1 * 1,
	clust_num_ores = 5,
	clust_size = 2,
	y_min = -30656,
	y_max = -30000,
})

minetest.register_node("bedrock:bedrock", {
	description = "Bedrock",
	tiles = {"bedrock_bedrock.png"},
	drop = "",
	-- Set `unbreakable` for Map Tools' admin pickaxe
	groups = {unbreakable = 1, not_in_creative_inventory = 1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("bedrock:deepstone", {
	description = "Deepstone",
	tiles = {"bedrock_deepstone.png"},
	drop = "default:stone", -- Intended
	groups = {cracky = 1},
	sounds = default.node_sound_stone_defaults(),
})
