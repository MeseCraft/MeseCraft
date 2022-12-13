-- Christmas Presents by FreeGamers.org
-- Description: Adds Christmas presents that give random items.
-- Note: Make sure this runs after presents_functions.lua
-- Instructions: Uses item tables to determine what is common, rare, and special.
-- farming, pie, dye, default, mobs_creatures, holiday lights, 

christmas_holiday_pack.christmas_common_item_pool = {}
christmas_holiday_pack.christmas_uncommon_item_pool = {}
christmas_holiday_pack.christmas_special_item_pool = {}

-- Common Item Pool
	table.insert(christmas_holiday_pack.christmas_common_item_pool, "default:coal_lump")
	table.insert(christmas_holiday_pack.christmas_common_item_pool, "default:pine_needles")
	table.insert(christmas_holiday_pack.christmas_common_item_pool, "default:pine_sapling")
	table.insert(christmas_holiday_pack.christmas_common_item_pool, "default:pine_wood")
	table.insert(christmas_holiday_pack.christmas_common_item_pool, "dye:red")
	table.insert(christmas_holiday_pack.christmas_common_item_pool, "dye:green")
	table.insert(christmas_holiday_pack.christmas_common_item_pool, "christmas_holiday_pack:candy_cane")
	table.insert(christmas_holiday_pack.christmas_common_item_pool, "christmas_holiday_pack:peppermint_candies")
	table.insert(christmas_holiday_pack.christmas_common_item_pool, "christmas_holiday_pack:green_peppermint_candies")
	table.insert(christmas_holiday_pack.christmas_common_item_pool, "christmas_holiday_pack:sugar_cookie")
	table.insert(christmas_holiday_pack.christmas_common_item_pool, "christmas_holiday_pack:eggnog_glass")
	table.insert(christmas_holiday_pack.christmas_common_item_pool, "christmas_holiday_pack:hot_chocolate_glass")
	table.insert(christmas_holiday_pack.christmas_common_item_pool, "mobs_creatures:milk_glass")
	table.insert(christmas_holiday_pack.christmas_common_item_pool, "christmas_holiday_pack:candy_cane_block")
	table.insert(christmas_holiday_pack.christmas_common_item_pool, "christmas_holiday_pack:gingerbread_block")
	table.insert(christmas_holiday_pack.christmas_common_item_pool, "christmas_holiday_pack:icicles")
	table.insert(christmas_holiday_pack.christmas_common_item_pool, "christmas_holiday_pack:festive_garland")
	table.insert(christmas_holiday_pack.christmas_common_item_pool, "christmas_holiday_pack:festive_garland_lights")
	table.insert(christmas_holiday_pack.christmas_common_item_pool, "christmas_holiday_pack:garland_red")
	table.insert(christmas_holiday_pack.christmas_common_item_pool, "christmas_holiday_pack:garland_yellow")
	table.insert(christmas_holiday_pack.christmas_common_item_pool, "christmas_holiday_pack:garland_white")
	table.insert(christmas_holiday_pack.christmas_common_item_pool, "christmas_holiday_pack:ornament_white")
	table.insert(christmas_holiday_pack.christmas_common_item_pool, "christmas_holiday_pack:ornament_yellow")
	table.insert(christmas_holiday_pack.christmas_common_item_pool, "christmas_holiday_pack:ornament_red")
	table.insert(christmas_holiday_pack.christmas_common_item_pool, "christmas_holiday_pack:ornament_green")
	table.insert(christmas_holiday_pack.christmas_common_item_pool, "christmas_holiday_pack:ornament_blue")
	table.insert(christmas_holiday_pack.christmas_common_item_pool, "christmas_holiday_pack:ornament_orange")
	table.insert(christmas_holiday_pack.christmas_common_item_pool, "christmas_holiday_pack:ornament_purple")
	table.insert(christmas_holiday_pack.christmas_common_item_pool, "christmas_holiday_pack:ornament_pink")
	table.insert(christmas_holiday_pack.christmas_common_item_pool, "default:gold_ingot")
	table.insert(christmas_holiday_pack.christmas_common_item_pool, "default:blueberries")
	table.insert(christmas_holiday_pack.christmas_common_item_pool, "default:ice")
	table.insert(christmas_holiday_pack.christmas_common_item_pool, "default:snow")
	table.insert(christmas_holiday_pack.christmas_common_item_pool, "holiday_lights:lights_icy")
	table.insert(christmas_holiday_pack.christmas_common_item_pool, "holiday_lights:lights_festive")
	table.insert(christmas_holiday_pack.christmas_common_item_pool, "holiday_lights:lights_rainbow")


-- Uncommon Item Pool
        table.insert(christmas_holiday_pack.christmas_uncommon_item_pool, "default:coal")
        table.insert(christmas_holiday_pack.christmas_uncommon_item_pool, "default:pine_tree")
        table.insert(christmas_holiday_pack.christmas_uncommon_item_pool, "farming:chocolate_dark")
        table.insert(christmas_holiday_pack.christmas_uncommon_item_pool, "pie:pie_0")
        table.insert(christmas_holiday_pack.christmas_uncommon_item_pool, "farming:porridge")
        table.insert(christmas_holiday_pack.christmas_uncommon_item_pool, "christmas_holiday_pack:green_candy_cane")
        table.insert(christmas_holiday_pack.christmas_uncommon_item_pool, "christmas_holiday_pack:gingerbread")
        table.insert(christmas_holiday_pack.christmas_uncommon_item_pool, "christmas_holiday_pack:gingerbread_cookie")
        table.insert(christmas_holiday_pack.christmas_uncommon_item_pool, "christmas_holiday_pack:sugar_cookie_star")
        table.insert(christmas_holiday_pack.christmas_uncommon_item_pool, "christmas_holiday_pack:sugar_cookie_tree")
        table.insert(christmas_holiday_pack.christmas_uncommon_item_pool, "christmas_holiday_pack:sugar_cookie_bell")
        table.insert(christmas_holiday_pack.christmas_uncommon_item_pool, "mobs_creatures:milk_bucket")
        table.insert(christmas_holiday_pack.christmas_uncommon_item_pool, "christmas_holiday_pack:peppermint_seeds")
        table.insert(christmas_holiday_pack.christmas_uncommon_item_pool, "christmas_holiday_pack:ginger")
        table.insert(christmas_holiday_pack.christmas_uncommon_item_pool, "christmas_holiday_pack:green_candy_cane_block")
        table.insert(christmas_holiday_pack.christmas_uncommon_item_pool, "christmas_holiday_pack:frosting_block")
        table.insert(christmas_holiday_pack.christmas_uncommon_item_pool, "christmas_holiday_pack:mistletoe")
        table.insert(christmas_holiday_pack.christmas_uncommon_item_pool, "christmas_holiday_pack:reef")
        table.insert(christmas_holiday_pack.christmas_uncommon_item_pool, "christmas_holiday_pack:christmas_star")
        table.insert(christmas_holiday_pack.christmas_uncommon_item_pool, "christmas_holiday_pack:painting_03")
        table.insert(christmas_holiday_pack.christmas_uncommon_item_pool, "christmas_holiday_pack:painting_05")
        table.insert(christmas_holiday_pack.christmas_uncommon_item_pool, "farming:blueberry_pie")
        table.insert(christmas_holiday_pack.christmas_uncommon_item_pool, "gramophone:vinyl_disc10")
        table.insert(christmas_holiday_pack.christmas_uncommon_item_pool, "gramophone:vinyl_disc11")
        table.insert(christmas_holiday_pack.christmas_uncommon_item_pool, "gnu:moognu_rainbow")

-- Special Item Pool
        table.insert(christmas_holiday_pack.christmas_special_item_pool, "christmas_holiday_pack:christmas_bell")
        table.insert(christmas_holiday_pack.christmas_special_item_pool, "christmas_holiday_pack:helmet_cane")
        table.insert(christmas_holiday_pack.christmas_special_item_pool, "christmas_holiday_pack:chestplate_cane")
        table.insert(christmas_holiday_pack.christmas_special_item_pool, "christmas_holiday_pack:leggings_cane")
        table.insert(christmas_holiday_pack.christmas_special_item_pool, "christmas_holiday_pack:boots_cane")
        table.insert(christmas_holiday_pack.christmas_special_item_pool, "christmas_holiday_pack:shield_cane")
        table.insert(christmas_holiday_pack.christmas_special_item_pool, "christmas_holiday_pack:mask_green_santa_hat")
        table.insert(christmas_holiday_pack.christmas_special_item_pool, "christmas_holiday_pack:mask_santa_hat")
        table.insert(christmas_holiday_pack.christmas_special_item_pool, "christmas_holiday_pack:mask_red_poof_ball_hat")
        table.insert(christmas_holiday_pack.christmas_special_item_pool, "christmas_holiday_pack:suit_elf")
        table.insert(christmas_holiday_pack.christmas_special_item_pool, "christmas_holiday_pack:suit_orange_parka")
        table.insert(christmas_holiday_pack.christmas_special_item_pool, "christmas_holiday_pack:suit_santa")
        table.insert(christmas_holiday_pack.christmas_special_item_pool, "christmas_holiday_pack:suit_tree")
        table.insert(christmas_holiday_pack.christmas_special_item_pool, "christmas_holiday_pack:shirt_ugly_sweater")
        table.insert(christmas_holiday_pack.christmas_special_item_pool, "christmas_holiday_pack:painting_01")
        table.insert(christmas_holiday_pack.christmas_special_item_pool, "christmas_holiday_pack:painting_02")
        table.insert(christmas_holiday_pack.christmas_special_item_pool, "christmas_holiday_pack:painting_04")
        table.insert(christmas_holiday_pack.christmas_special_item_pool, "christmas_holiday_pack:painting_06")
        table.insert(christmas_holiday_pack.christmas_special_item_pool, "christmas_holiday_pack:stocking")
        table.insert(christmas_holiday_pack.christmas_special_item_pool, "christmas_holiday_pack:green_stocking")
        table.insert(christmas_holiday_pack.christmas_special_item_pool, "christmas_holiday_pack:candy_cane_pickaxe")
        table.insert(christmas_holiday_pack.christmas_special_item_pool, "christmas_holiday_pack:candy_cane_axe")
        table.insert(christmas_holiday_pack.christmas_special_item_pool, "christmas_holiday_pack:candy_cane_sword")
        table.insert(christmas_holiday_pack.christmas_special_item_pool, "gramophone:vinyl_disc12")
        table.insert(christmas_holiday_pack.christmas_special_item_pool, "gramophone:vinyl_disc13")


-- Register Presents (3 tiers: 3 commons, 2 uncommon, 2 special)

	-- Common Tier
	minetest.register_craftitem("christmas_holiday_pack:present_01", {
		description = "" ..core.colorize("#35cdff","Christmas Present\n") ..core.colorize("#FFFFFF", "Wonder what's inside?"),
		inventory_image = "christmas_holiday_pack_present_01.png",
		on_use = christmas_holiday_pack.open_present("christmas_common"),
	})

	minetest.register_craftitem("christmas_holiday_pack:present_02", {
		description = "" ..core.colorize("#35cdff","Christmas Present\n") ..core.colorize("#FFFFFF", "Wonder what's inside?"),
	        inventory_image = "christmas_holiday_pack_present_02.png",
	        on_use = christmas_holiday_pack.open_present("christmas_common"),
	})

	minetest.register_craftitem("christmas_holiday_pack:present_03", {
		description = "" ..core.colorize("#35cdff","Christmas Present\n") ..core.colorize("#FFFFFF", "Wonder what's inside?"),
	        inventory_image = "christmas_holiday_pack_present_03.png",
	        on_use = christmas_holiday_pack.open_present("christmas_common"),
	})

	-- Uncommon Tier

	minetest.register_craftitem("christmas_holiday_pack:present_04", {
                description = "" ..core.colorize("#146b3a","Christmas Present\n") ..core.colorize("#FFFFFF", "Wonder what's inside?"),
	        inventory_image = "christmas_holiday_pack_present_04.png",
	        on_use = christmas_holiday_pack.open_present("christmas_uncommon"),
	})

        minetest.register_craftitem("christmas_holiday_pack:present_05", {
                description = "" ..core.colorize("#146b3a","Christmas Present\n") ..core.colorize("#FFFFFF", "Wonder what's inside?"),
                inventory_image = "christmas_holiday_pack_present_05.png",
                on_use = christmas_holiday_pack.open_present("christmas_uncommon"),
        })

	-- Special Tier

        minetest.register_craftitem("christmas_holiday_pack:present_06", {
                description = "" ..core.colorize("#bb2528","Christmas Present\n") ..core.colorize("#FFFFFF", "Wonder what's inside?"),
                inventory_image = "christmas_holiday_pack_present_06.png",
                on_use = christmas_holiday_pack.open_present("christmas_special"),
        })

        minetest.register_craftitem("christmas_holiday_pack:present_07", {
                description = "" ..core.colorize("#bb2528","Christmas Present\n") ..core.colorize("#FFFFFF", "Wonder what's inside?"),
                inventory_image = "christmas_holiday_pack_present_07.png",
                on_use = christmas_holiday_pack.open_present("christmas_special"),
        })
