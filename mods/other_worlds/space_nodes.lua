-- Nodes
minetest.register_node(":asteroid:stone", {
	description = "Asteroid Stone",
	tiles = {"default_stone.png"},
	is_ground_content = false,
	drop = 'asteroid:cobble',
	groups = {cracky = 3, not_in_creative_inventory=1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node(":asteroid:redstone", {
	description = "Asteroid Stone",
	tiles = {"asteroid_redstone.png"},
	is_ground_content = false,
	drop = 'asteroid:redcobble',
	groups = {cracky = 3},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node(":asteroid:cobble", {
	description = "Asteroid Cobble",
	tiles = {"asteroid_cobble.png"},
	is_ground_content = false,
	groups = {cracky = 3},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node(":asteroid:redcobble", {
	description = "Asteroid Cobble",
	tiles = {"asteroid_redcobble.png"},
	is_ground_content = false,
	groups = {cracky = 3},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node(":asteroid:gravel", {
	description = "Asteroid Gravel",
	tiles = {"asteroid_gravel.png"},
	is_ground_content = false,
	groups = {crumbly = 2},
	sounds = default.node_sound_dirt_defaults({
		footstep = {name = "default_gravel_footstep", gain = 0.2},
	}),
})

minetest.register_node(":asteroid:redgravel", {
	description = "Asteroid Gravel",
	tiles = {"asteroid_redgravel.png"},
	is_ground_content = false,
	groups = {crumbly = 2},
	sounds = default.node_sound_dirt_defaults({
		footstep = {name = "default_gravel_footstep", gain = 0.2},
	}),
})

minetest.register_node(":asteroid:dust", {
	description = "Asteroid Dust",
	tiles = {"asteroid_dust.png"},
	is_ground_content = false,
	groups = {crumbly = 3},
	sounds = default.node_sound_dirt_defaults({
		footstep = {name = "default_gravel_footstep", gain = 0.1},
	}),
})

minetest.register_node(":asteroid:reddust", {
	description = "Asteroid Dust",
	tiles = {"asteroid_reddust.png"},
	is_ground_content = false,
	groups = {crumbly = 3},
	sounds = default.node_sound_dirt_defaults({
		footstep = {name = "default_gravel_footstep", gain = 0.1},
	}),
})

minetest.register_node(":asteroid:ironore", {
	description = "Asteroid Iron Ore",
	tiles = {"asteroid_redstone.png^default_mineral_iron.png"},
	is_ground_content = false,
	groups = {cracky = 2},
	drop = "default:iron_lump",
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node(":asteroid:copperore", {
	description = "Asteroid Copper Ore",
	tiles = {"asteroid_redstone.png^default_mineral_copper.png"},
	is_ground_content = false,
	groups = {cracky = 2},
	drop = "default:copper_lump",
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node(":asteroid:goldore", {
	description = "Asteroid Gold Ore",
	tiles = {"asteroid_redstone.png^default_mineral_gold.png"},
	is_ground_content = false,
	groups = {cracky = 2},
	drop = "default:gold_lump",
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node(":asteroid:diamondore", {
	description = "Asteroid Diamond Ore",
	tiles = {"asteroid_redstone.png^default_mineral_diamond.png"},
	is_ground_content = false,
	groups = {cracky = 1},
	drop = "default:diamond",
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node(":asteroid:meseore", {
	description = "Asteroid Mese Ore",
	tiles = {"asteroid_redstone.png^default_mineral_mese.png"},
	is_ground_content = false,
	groups = {cracky = 1},
	drop = "default:mese_crystal",
	sounds = default.node_sound_stone_defaults(),
})
