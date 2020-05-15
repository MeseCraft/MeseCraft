--------------------
---- BOUNCY BED ---- 
--------------------
-- Code by FreeGamers.org
-- Idea by kiopy7
-- LICENSE: GPLv3 (included in parent directory)
-- bouncy.ogg, Blender Foundation, CC-BY-3.0 (https://creativecommons.org/licenses/by/3.0/legalcode)


-- Override Fancy Bed
minetest.override_item("beds:fancy_bed_bottom", {
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 3, bed = 1, fall_damage_add_percent=-40, bouncy=85},
	sounds = {
		footstep = {
			name = "bouncy",
			gain = 0.8
		}
	}
})
minetest.override_item("beds:fancy_bed_top", {
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 3, bed = 2, fall_damage_add_percent=-40, bouncy=85},
        sounds = {
                footstep = {
                        name = "bouncy",
                        gain = 0.8
                }
        }
})

-- Override Simple Bed
minetest.override_item("beds:bed_bottom", {
        groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 3, bed = 1, fall_damage_add_percent=-40, bouncy=85},
        sounds = {
                footstep = {
                        name = "bouncy",
                        gain = 0.8
                }
        }
})
minetest.override_item("beds:bed_top", {
        groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 3, bed = 2, fall_damage_add_percent=-40, bouncy=85},
        sounds = {
                footstep = {
                        name = "bouncy",
                        gain = 0.8
                }
        }
})
