-- Nodes.

minetest.register_node("bees:honeycomb_block", {
        description = "Honeycomb Block",
        tiles = {"bees_honeycomb_block.png"},
        groups = {oddly_breakable_by_hand = 3, dig_immediate = 1},
        sounds = default.node_sound_dirt_defaults(),
})

