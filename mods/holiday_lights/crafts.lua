-- Base items.

	-- Wire
	minetest.register_craft({
		output = "holiday_lights:wire 16",
		recipe = {
			{"basic_materials:plastic_strip", "basic_materials:plastic_strip", "basic_materials:plastic_strip"},
			{"basic_materials:copper_strip", "basic_materials:copper_strip", "basic_materials:copper_strip"},
			{"basic_materials:plastic_strip", "basic_materials:plastic_strip", "basic_materials:plastic_strip"},
		},
	})

	-- White Bulbs
	minetest.register_craft({
	        output = "holiday_lights:bulbs_white 8",
	        recipe = {
	                {"", "default:glass", ""},
	                {"", "basic_materials:plastic_strip", ""},
	                {"", "default:mese_crystal_fragment", ""},
	        },
	})

-- Bulbs

	-- Yellow Bulbs
	minetest.register_craft({
	        output = "holiday_lights:bulbs_yellow 3",
		type = "shapeless",
	        recipe = {"holiday_lights:bulbs_white","holiday_lights:bulbs_white","holiday_lights:bulbs_white","dye:yellow"},
	})

	-- Red Bulbs
	minetest.register_craft({
	        output = "holiday_lights:bulbs_red 3",
	        type = "shapeless",
	        recipe = {"holiday_lights:bulbs_white","holiday_lights:bulbs_white","holiday_lights:bulbs_white","dye:red"},
	})

	-- Green Bulbs
	minetest.register_craft({
	        output = "holiday_lights:bulbs_green 3",
	        type = "shapeless",
	        recipe = {"holiday_lights:bulbs_white","holiday_lights:bulbs_white","holiday_lights:bulbs_white","dye:green"},
	})

	-- Blue Bulbs
	minetest.register_craft({
	        output = "holiday_lights:bulbs_blue 3",
	        type = "shapeless",
	        recipe = {"holiday_lights:bulbs_white","holiday_lights:bulbs_white","holiday_lights:bulbs_white","dye:blue"},
	})

	-- Purple Bulbs
	minetest.register_craft({
	        output = "holiday_lights:bulbs_purple 3",
	        type = "shapeless",
	        recipe = {"holiday_lights:bulbs_white","holiday_lights:bulbs_white","holiday_lights:bulbs_white","dye:violet"},
	})

	-- Pink Bulbs
	minetest.register_craft({
	        output = "holiday_lights:bulbs_pink 3",
	        type = "shapeless",
	        recipe = {"holiday_lights:bulbs_white","holiday_lights:bulbs_white","holiday_lights:bulbs_white","dye:pink"},
	})

	-- Orange Bulbs
	minetest.register_craft({
	        output = "holiday_lights:bulbs_orange 3",
	        type = "shapeless",
	        recipe = {"holiday_lights:bulbs_white","holiday_lights:bulbs_white","holiday_lights:bulbs_white","dye:orange"},
	})

-- String Lights

        -- White String Lights
        minetest.register_craft({
                output = "holiday_lights:lights_white",
                type = "shapeless",
                recipe = {"holiday_lights:bulbs_white","holiday_lights:bulbs_white","holiday_lights:bulbs_white","holiday_lights:wire"},
        })

        -- Yellow String Lights
        minetest.register_craft({
                output = "holiday_lights:lights_yellow",
                type = "shapeless",
                recipe = {"holiday_lights:bulbs_yellow","holiday_lights:bulbs_yellow","holiday_lights:bulbs_yellow","holiday_lights:wire"},
        })

        -- Red String Lights
        minetest.register_craft({
                output = "holiday_lights:lights_red",
                type = "shapeless",
                recipe = {"holiday_lights:bulbs_red","holiday_lights:bulbs_red","holiday_lights:bulbs_red","holiday_lights:wire"},
        })

        -- Green String Lights
        minetest.register_craft({
                output = "holiday_lights:lights_green",
                type = "shapeless",
                recipe = {"holiday_lights:bulbs_green","holiday_lights:bulbs_green","holiday_lights:bulbs_green","holiday_lights:wire"},
        })

        -- Blue String Lights
        minetest.register_craft({
                output = "holiday_lights:lights_blue",
                type = "shapeless",
                recipe = {"holiday_lights:bulbs_blue","holiday_lights:bulbs_blue","holiday_lights:bulbs_blue","holiday_lights:wire"},
        })

        -- Purple String Lights
        minetest.register_craft({
                output = "holiday_lights:lights_purple",
                type = "shapeless",
                recipe = {"holiday_lights:bulbs_purple","holiday_lights:bulbs_purple","holiday_lights:bulbs_purple","holiday_lights:wire"},
        })

        -- Pink String Lights
        minetest.register_craft({
                output = "holiday_lights:lights_pink",
                type = "shapeless",
                recipe = {"holiday_lights:bulbs_pink","holiday_lights:bulbs_pink","holiday_lights:bulbs_pink","holiday_lights:wire"},
        })

        -- Orange String Lights
        minetest.register_craft({
                output = "holiday_lights:lights_orange",
                type = "shapeless",
                recipe = {"holiday_lights:bulbs_orange","holiday_lights:bulbs_orange","holiday_lights:bulbs_orange","holiday_lights:wire"},
        })

-- Special Sets

        -- Rainbow String Lights
        minetest.register_craft({
                output = "holiday_lights:lights_rainbow 2",
                type = "shapeless",
                recipe = {"holiday_lights:bulbs_red","holiday_lights:bulbs_yellow","holiday_lights:bulbs_green","holiday_lights:bulbs_blue","holiday_lights:bulbs_purple", "holiday_lights:wire", "holiday_lights:wire"},
        })

        -- Festive String Lights
        minetest.register_craft({
                output = "holiday_lights:lights_festive",
                type = "shapeless",
                recipe = {"holiday_lights:bulbs_red","holiday_lights:bulbs_green","holiday_lights:bulbs_red","holiday_lights:bulbs_green", "holiday_lights:wire"},
        })

        -- Spooky String Lights
        minetest.register_craft({
                output = "holiday_lights:lights_spooky",
                type = "shapeless",
                recipe = {"holiday_lights:bulbs_orange","holiday_lights:bulbs_purple","holiday_lights:bulbs_orange","holiday_lights:bulbs_purple","holiday_lights:wire"},
        })

        -- Patriotic String Lights
        minetest.register_craft({
                output = "holiday_lights:lights_patriotic",
                type = "shapeless",
                recipe = {"holiday_lights:bulbs_red","holiday_lights:bulbs_white","holiday_lights:bulbs_blue","holiday_lights:wire"},
        })

        -- Icy String Lights
        minetest.register_craft({
                output = "holiday_lights:lights_icy",
                type = "shapeless",
                recipe = {"holiday_lights:bulbs_white","holiday_lights:bulbs_white","holiday_lights:bulbs_white","holiday_lights:wire", "default:ice"},
        })

