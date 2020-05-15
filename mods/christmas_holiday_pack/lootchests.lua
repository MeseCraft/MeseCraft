-- Christmas Lootchests that look like presents to use with the "Lootchests" API by ClockGen.
-- Note: Initlize the lootchests_item_tables.lua first or they won't register.


-- Register the Christmas Lootchests.

	-- Check the date and set the spawn chance of lootchests. (Dec 15th - Dec 31st)
	local date = os.date("*t")
	local spawn_chance
	if (date.month == 12 and date.day >= 1) or (date.month == 12 and date.day <= 31) then
		spawn_chance = 8000
		elevationmax = 200
		elevationmin = -16000
	else
		spawn_chance = 999999
		elevationmax = 30912
		elevationmin = 30911
	end

	-- Red Christmas Chest
	lootchests.register_lootchest({
	    name = "christmas_holiday_pack:chest_red",
	    description = "Red Christmas Chest",
	    tiles = {
	        "christmas_holiday_pack_christmas_chest_red_top.png",
	        "christmas_holiday_pack_christmas_chest_red_bottom.png",
	        "christmas_holiday_pack_christmas_chest_red_side.png",
	        "christmas_holiday_pack_christmas_chest_red_side.png",
		"christmas_holiday_pack_christmas_chest_red_side.png",
	        "christmas_holiday_pack_christmas_chest_red_front.png",
	    },                           
	    spawn_on = {"group:cracky", "group:crumbly", "group:shovely", "group:pickaxey"},
	    sounds = default.node_sound_wood_defaults(),
	    groups = {choppy = 2, oddly_breakable_by_hand = 2},
	    ymax = elevationmax,
	    ymin = elevationmin,
	    spawn_on_rarity = spawn_chance,
	    slot_spawn_chance = 25,
	    slots = 32,
	})

        -- Green Christmas Chest
        lootchests.register_lootchest({
            name = "christmas_holiday_pack:chest_green",
            description = "Green Christmas Chest",
            tiles = {
                "christmas_holiday_pack_christmas_chest_green_top.png",
                "christmas_holiday_pack_christmas_chest_green_bottom.png",
                "christmas_holiday_pack_christmas_chest_green_side.png",
                "christmas_holiday_pack_christmas_chest_green_side.png",
                "christmas_holiday_pack_christmas_chest_green_side.png",
                "christmas_holiday_pack_christmas_chest_green_front.png",
            },
            spawn_on = {"default:stone",},
            sounds = default.node_sound_wood_defaults(),
            groups = {choppy = 2, oddly_breakable_by_hand = 2},
            ymax = elevationmax,
            ymin = elevationmin,
            spawn_on_rarity = spawn_chance,
            slot_spawn_chance = 50,
            slots = 32,
        })

        -- Blue Christmas Chest
        lootchests.register_lootchest({
            name = "christmas_holiday_pack:chest_blue",
            description = "Blue Christmas Chest",
            tiles = {
                "christmas_holiday_pack_christmas_chest_blue_top.png",
                "christmas_holiday_pack_christmas_chest_blue_bottom.png",
                "christmas_holiday_pack_christmas_chest_blue_side.png",
                "christmas_holiday_pack_christmas_chest_blue_side.png",
                "christmas_holiday_pack_christmas_chest_blue_side.png",
                "christmas_holiday_pack_christmas_chest_blue_front.png",
            },
            spawn_in = {"default:snow","default:dirt_with_snow","default:ice"},
            sounds = default.node_sound_wood_defaults(),
            groups = {choppy = 2, oddly_breakable_by_hand = 2},
            ymax = elevationmax,
            ymin = elevationmin,
            spawn_in_rarity = spawn_chance,
            slot_spawn_chance = 50,
            slots = 32,
        })

        -- Yellow Christmas Chest
        lootchests.register_lootchest({
            name = "christmas_holiday_pack:chest_yellow",
            description = "Yellow Christmas Chest",
            tiles = {
                "christmas_holiday_pack_christmas_chest_yellow_top.png",
                "christmas_holiday_pack_christmas_chest_yellow_bottom.png",
                "christmas_holiday_pack_christmas_chest_yellow_side.png",
                "christmas_holiday_pack_christmas_chest_yellow_side.png",
                "christmas_holiday_pack_christmas_chest_yellow_side.png",
                "christmas_holiday_pack_christmas_chest_yellow_front.png",
            },
            spawn_in = {"default:stone",},
            sounds = default.node_sound_wood_defaults(),
            groups = {choppy = 2, oddly_breakable_by_hand = 2},
            ymax = elevationmax,
            ymin = elevationmin,
            spawn_in_rarity = spawn_chance,
            slot_spawn_chance = 75,
            slots = 32,
        })
