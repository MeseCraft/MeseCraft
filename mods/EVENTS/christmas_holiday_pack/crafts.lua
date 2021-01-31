-- Nodes
	-- 9 Candy Canes into 3 Candy Cane Blocks.
        minetest.register_craft({
                output = "christmas_holiday_pack:candy_cane_block 3",
                recipe = {
                        {"christmas_holiday_pack:candy_cane", "christmas_holiday_pack:candy_cane", "christmas_holiday_pack:candy_cane"},
                        {"christmas_holiday_pack:candy_cane", "christmas_holiday_pack:candy_cane", "christmas_holiday_pack:candy_cane"},
                        {"christmas_holiday_pack:candy_cane", "christmas_holiday_pack:candy_cane", "christmas_holiday_pack:candy_cane"},
                },
        })

	-- 9 Green Candy Canes into 3 Green Candy Cane Blocks.
        minetest.register_craft({
                output = "christmas_holiday_pack:green_candy_cane_block 3",
                recipe = {
                        {"christmas_holiday_pack:green_candy_cane", "christmas_holiday_pack:green_candy_cane", "christmas_holiday_pack:green_candy_cane"},
                        {"christmas_holiday_pack:green_candy_cane", "christmas_holiday_pack:green_candy_cane", "christmas_holiday_pack:green_candy_cane"},
                        {"christmas_holiday_pack:green_candy_cane", "christmas_holiday_pack:green_candy_cane", "christmas_holiday_pack:green_candy_cane"},
                },
        })

	-- 9 Gingerbread Men into 3 Gingerbread Blocks.
        minetest.register_craft({
                output = "christmas_holiday_pack:gingerbread_block 3",
                recipe = {
                        {"christmas_holiday_pack:gingerbread_man", "christmas_holiday_pack:gingerbread_man", "christmas_holiday_pack:gingerbread_man"},
                        {"christmas_holiday_pack:gingerbread_man", "christmas_holiday_pack:gingerbread_man", "christmas_holiday_pack:gingerbread_man"},
                        {"christmas_holiday_pack:gingerbread_man", "christmas_holiday_pack:gingerbread_man", "christmas_holiday_pack:gingerbread_man"},
                },
        })

        -- 9 Gingerbread into 3 Gingerbread Blocks.
        minetest.register_craft({
                output = "christmas_holiday_pack:gingerbread_block 3",
                recipe = {
                        {"christmas_holiday_pack:gingerbread", "christmas_holiday_pack:gingerbread", "christmas_holiday_pack:gingerbread"},
                        {"christmas_holiday_pack:gingerbread", "christmas_holiday_pack:gingerbread", "christmas_holiday_pack:gingerbread"},
                        {"christmas_holiday_pack:gingerbread", "christmas_holiday_pack:gingerbread", "christmas_holiday_pack:gingerbread"},
                },
        })

	-- Frosting Block
        minetest.register_craft({
                output = "christmas_holiday_pack:frosting_block 3",
                recipe = {
                        {"group:food_sugar", "group:food_sugar", "group:food_sugar"},
                        {"group:food_sugar", "mobs_creatures:milk_bucket", "group:food_sugar"},
                        {"group:food_sugar", "group:food_sugar", "group:food_sugar"},
		},
		replacements = {{"mobs_creatures:milk_bucket", "bucket:bucket_empty"}},
        })


-- 3d_armor : Candy Cane Armor
	minetest.register_craft({
		output = "christmas_holiday_pack:helmet_cane",
		recipe = {
			{"christmas_holiday_pack:candy_cane_block", "christmas_holiday_pack:candy_cane_block", "christmas_holiday_pack:candy_cane_block"},
			{"christmas_holiday_pack:candy_cane_block", "", "christmas_holiday_pack:candy_cane_block"},
			{"", "", ""},
		},
	})
	minetest.register_craft({
		output = "christmas_holiday_pack:chestplate_cane",
		recipe = {
			{"christmas_holiday_pack:candy_cane_block", "", "christmas_holiday_pack:candy_cane_block"},
			{"christmas_holiday_pack:candy_cane_block", "christmas_holiday_pack:candy_cane_block", "christmas_holiday_pack:candy_cane_block"},
			{"christmas_holiday_pack:candy_cane_block", "christmas_holiday_pack:candy_cane_block", "christmas_holiday_pack:candy_cane_block"},
		},
	})
	minetest.register_craft({
		output = "christmas_holiday_pack:leggings_cane",
		recipe = {
			{"christmas_holiday_pack:candy_cane_block", "christmas_holiday_pack:candy_cane_block", "christmas_holiday_pack:candy_cane_block"},
			{"christmas_holiday_pack:candy_cane_block", "", "christmas_holiday_pack:candy_cane_block"},
			{"christmas_holiday_pack:candy_cane_block", "", "christmas_holiday_pack:candy_cane_block"},
		},
	})
	minetest.register_craft({
		output = "christmas_holiday_pack:boots_cane",
		recipe = {
			{"christmas_holiday_pack:candy_cane_block", "", "christmas_holiday_pack:candy_cane_block"},
			{"christmas_holiday_pack:candy_cane_block", "", "christmas_holiday_pack:candy_cane_block"},
		},
	})
	minetest.register_craft({
		output = "christmas_holiday_pack:shield_cane",
		recipe = {
			{"christmas_holiday_pack:candy_cane_block", "christmas_holiday_pack:candy_cane_block", "christmas_holiday_pack:candy_cane_block"},
			{"christmas_holiday_pack:candy_cane_block", "christmas_holiday_pack:candy_cane_block", "christmas_holiday_pack:candy_cane_block"},
			{"", "christmas_holiday_pack:candy_cane_block", ""},
		},
	})
-- Candy Cane Pickaxe
        minetest.register_craft({
                output = "christmas_holiday_pack:candy_cane_pickaxe",
                recipe = {
                        {"christmas_holiday_pack:candy_cane_block", "christmas_holiday_pack:candy_cane_block", "christmas_holiday_pack:candy_cane_block"},
                        {"", "christmas_holiday_pack:candy_cane", ""},
                        {"", "christmas_holiday_pack:candy_cane", ""},
                },
        })
-- Candy Cane Axe
        minetest.register_craft({
                output = "christmas_holiday_pack:candy_cane_axe",
                recipe = {
                        {"christmas_holiday_pack:candy_cane_block", "christmas_holiday_pack:candy_cane_block", ""},
                        {"", "christmas_holiday_pack:candy_cane", ""},
                        {"", "christmas_holiday_pack:candy_cane", ""},
                },
        })
-- Candy Cane Sword
        minetest.register_craft({
                output = "christmas_holiday_pack:candy_cane_sword",
                recipe = {
                        {"", "christmas_holiday_pack:candy_cane_block", ""},
                        {"", "christmas_holiday_pack:candy_cane_block", ""},
                        {"", "christmas_holiday_pack:candy_cane", ""},
                },
        })


-- Christmas Bell
-- Mistletoe
-- Christmas Reef
-- Icicles
-- Christmas Tree Star

-- Garland
minetest.register_craft({
        output = "christmas_holiday_pack:garland 3",
	type = "shapeless",
        recipe = {"default:pine_needles", "default:pine_needles", "default:pine_needles"},
})
-- Festive Garland
minetest.register_craft({
        output = "christmas_holiday_pack:festive_garland",
	type = "shapeless",
        recipe = {"christmas_holiday_pack:garland", "farming:raspberries"},
})
-- Festive Garland with Lights
minetest.register_craft({
        output = "christmas_holiday_pack:festive_garland_lights",
        type = "shapeless",
        recipe = {"christmas_holiday_pack:festive_garland", "holiday_lights:lights_white"},
})

-- Red Garland
minetest.register_craft({
        output = "christmas_holiday_pack:garland_red 3",
        type = "shapeless",
        recipe = {"christmas_holiday_pack:garland","christmas_holiday_pack:garland","christmas_holiday_pack:garland", "dye:red"},
})

-- Yellow Garland
minetest.register_craft({
        output = "christmas_holiday_pack:garland_yellow 3",
        type = "shapeless",
        recipe = {"christmas_holiday_pack:garland","christmas_holiday_pack:garland","christmas_holiday_pack:garland", "dye:yellow"},
})

-- White Garland
minetest.register_craft({
        output = "christmas_holiday_pack:garland_white 3",
        type = "shapeless",
        recipe = {"christmas_holiday_pack:garland","christmas_holiday_pack:garland","christmas_holiday_pack:garland", "dye:white"},
})

-- ORNAMENTS
-- SKIPPED

-- CRAFT ITEMS

-- Candy Cane
-- SKIPPED

-- Green Candy Cane
-- SKIPPED

-- Peppermint Candies
minetest.register_craft({
        output = "christmas_holiday_pack:peppermint_candies 8",
        type = "shapeless",
        recipe = {"christmas_holiday_pack:peppermint","christmas_holiday_pack:peppermint","group:food_sugar", "group:food_sugar", "dye:red", "farming:mortar_pestle"},
        replacements = {{"farming:mortar_pestle", "farming:mortar_pestle"}},
})

-- Green Peppermint Candies
minetest.register_craft({
        output = "christmas_holiday_pack:green_peppermint_candies 8",
        type = "shapeless",
        recipe = {"christmas_holiday_pack:peppermint","christmas_holiday_pack:peppermint","group:food_sugar", "group:food_sugar", "dye:green", "farming:mortar_pestle"},
        replacements = {{"farming:mortar_pestle", "farming:mortar_pestle"}},
})

-- Gingerbread Dough
minetest.register_craft({
        output = "christmas_holiday_pack:gingerbread_dough",
        type = "shapeless",
        recipe = {"christmas_holiday_pack:ginger","christmas_holiday_pack:ginger","group:food_flour", "group:food_flour", "group:food_sugar", "group:food_egg", "mobs_creatures:butter", "farming:mortar_pestle"},
        replacements = {{"farming:mortar_pestle", "farming:mortar_pestle"}},
})
-- Gingerbread Cooking Recipe
minetest.register_craft({
        type = "cooking",
        output = "christmas_holiday_pack:gingerbread",
        recipe = "christmas_holiday_pack:gingerbread_dough",
        cooktime = 10,
})
-- Gingerbread Cookie (Man)
-- SKIPPED

-- Sugar Cookie
minetest.register_craft({
        output = "christmas_holiday_pack:sugar_cookie 6",
        type = "shapeless",
        recipe = {"group:food_flour","group:food_flour", "group:food_sugar", "group:food_sugar", "group:food_egg", "mobs_creatures:butter"},
})
-- Bell Sugar Cookie
minetest.register_craft({
        output = "christmas_holiday_pack:sugar_cookie_bell 4",
        type = "shapeless",
        recipe = {"group:food_flour","group:food_flour", "group:food_sugar", "group:food_sugar", "group:food_egg", "mobs_creatures:butter", "dye:blue"},
})
-- Star Sugar Cookie
minetest.register_craft({
        output = "christmas_holiday_pack:sugar_cookie_star 4",
        type = "shapeless",
        recipe = {"group:food_flour","group:food_flour", "group:food_sugar", "group:food_sugar", "group:food_egg", "mobs_creatures:butter", "dye:red"},
})
-- Tree Sugar Cookie
minetest.register_craft({
        output = "christmas_holiday_pack:sugar_cookie_tree 4",
        type = "shapeless",
        recipe = {"group:food_flour","group:food_flour", "group:food_sugar", "group:food_sugar", "group:food_egg", "mobs_creatures:butter", "dye:green"},
})
-- Glass of Hot Chocolate
-- SKIPPED

-- Glass of Eggnog
-- SKIPPED, maybe use ginger


-- Stocking
--minetest.register_craft({
--      output = "christmas_holiday_pack:stocking",
--      recipe = {
--            {"farming:string", "wool:white", "wool:white"},
--              {"", "wool:red", "wool:red"},
--              {"wool:red", "wool:red", "wool:red"},
--      }
--})
-- Green Stockings
--minetest.register_craft({
--      output = "christmas_holiday_pack:green_stocking",
--      recipe = {
--              {"farming:string", "wool:white", "wool:white"},
--              {"", "wool:green", "wool:green"},
--             {"wool:green", "wool:green", "wool:green"},
--     }
--})

