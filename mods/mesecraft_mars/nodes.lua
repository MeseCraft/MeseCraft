

minetest.register_node("mesecraft_mars:stone_with_coal", {
	description = "Coal Ore",
	tiles = {"default_desert_stone.png^default_mineral_coal.png"},
	groups = {cracky = 3},
	drop = 'default:coal_lump',
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("mesecraft_mars:stone_with_iron", {
	description = "Iron Ore",
	tiles = {"default_desert_stone.png^default_mineral_iron.png"},
	groups = {cracky = 2},
	drop = 'default:iron_lump',
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("mesecraft_mars:stone_with_copper", {
	description = "Copper Ore",
	tiles = {"default_desert_stone.png^default_mineral_copper.png"},
	groups = {cracky = 2},
	drop = 'default:copper_lump',
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("mesecraft_mars:stone_with_tin", {
	description = "Tin Ore",
	tiles = {"default_desert_stone.png^default_mineral_tin.png"},
	groups = {cracky = 2},
	drop = "default:tin_lump",
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("mesecraft_mars:stone_with_mese", {
	description = "Mese Ore",
	tiles = {"default_desert_stone.png^default_mineral_mese.png"},
	groups = {cracky = 1},
	drop = "default:mese_crystal",
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("mesecraft_mars:stone_with_gold", {
	description = "Gold Ore",
	tiles = {"default_desert_stone.png^default_mineral_gold.png"},
	groups = {cracky = 2},
	drop = "default:gold_lump",
	sounds = default.node_sound_stone_defaults(),
})


minetest.register_node("mesecraft_mars:stone_with_diamond", {
	description = "Diamond Ore",
	tiles = {"default_desert_stone.png^default_mineral_diamond.png"},
	groups = {cracky = 1},
	drop = "default:diamond",
	sounds = default.node_sound_stone_defaults(),
})
