-- Override the attributes for beds:fancy_bed_bottom.
minetest.override_item("beds:fancy_bed_bottom", {
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 3, bed = 1, fall_damage_add_percent=-40, bouncy=85},
	sounds = {
		footstep = { name = "bouncy", gain = 0.8 },
		dig = { name = "default_dig_oddly_breakable_by_hand", gain = 1.0 },
		dug = { name = "default_dug_node", gain = 1.0 },
	}
})
-- Override the attributes for beds:fancy_bed_top.
minetest.override_item("beds:fancy_bed_top", {
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 3, bed = 2, fall_damage_add_percent=-40, bouncy=85},
        sounds = { 
		footstep = { name = "bouncy", gain = 0.8 },
                dig = { name = "default_dig_oddly_breakable_by_hand", gain = 1.0 },
                dug = { name = "default_dug_node", gain = 1.0 },
        }
})

-- Override the attributes for beds:bed_bottom.
minetest.override_item("beds:bed_bottom", {
        groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 3, bed = 1, fall_damage_add_percent=-40, bouncy=85},
        sounds = {
                footstep = { name = "bouncy", gain = 0.8 },
                dig = { name = "default_dig_oddly_breakable_by_hand", gain = 1.0 },
                dug = { name = "default_dug_node", gain = 1.0 },
        }
})
-- Override the attributes for beds:bed_top.
minetest.override_item("beds:bed_top", {
        groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 3, bed = 2, fall_damage_add_percent=-40, bouncy=85},
        sounds = {
                footstep = { name = "bouncy", gain = 0.8 },
                dig = { name = "default_dig_oddly_breakable_by_hand", gain = 1.0 },
                dug = { name = "default_dug_node", gain = 1.0 },
        }
})
