local S = minetest.get_translator("mtg_plus")

local metal_sounds
if default.node_sound_metal_defaults then
	metal_sounds = default.node_sound_metal_defaults()
else
	metal_sounds = default.node_sound_stone_defaults()
end


-- Papyrus Block
minetest.register_node("mtg_plus:papyrus_block", {
	description = S("Papyrus Block"),
	tiles = {"mtg_plus_papyrus_block_y.png","mtg_plus_papyrus_block_y.png","mtg_plus_papyrus_block_side2.png","mtg_plus_papyrus_block_side2.png","mtg_plus_papyrus_block_side.png","mtg_plus_papyrus_block_side.png"},
	groups = {snappy = 2, choppy = 2, flammable = 3},
	is_ground_content = false,
	sounds = default.node_sound_leaves_defaults(),
})

minetest.register_craft({
	output = "mtg_plus:papyrus_block",
	recipe = { { "default:papyrus", "default:papyrus", "default:papyrus", },
	{ "default:papyrus", "default:papyrus", "default:papyrus", },
	{ "default:papyrus", "default:papyrus", "default:papyrus", } }
})

minetest.register_craft({
	output = "default:papyrus 9",
	recipe = { { "mtg_plus:papyrus_block" } }
})

minetest.register_craft({
	type = "fuel",
	recipe = "mtg_plus:papyrus_block",
	burntime = 9,
})
