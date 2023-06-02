-- Christmas Tree Painting (64x48)
minetest.register_node("mesecraft_christmas:painting_01", {
                description = "Christmas Tree Painting",
                drawtype = "nodebox",
                tiles = {"mesecraft_christmas_painting_01.png"},
                inventory_image = "mesecraft_christmas_painting_01.png",
                wield_image = "mesecraft_christmas_painting_01.png",
                paramtype = "light",
                paramtype2 = "wallmounted",
                sunlight_propagates = true,
                walkable = false,
                node_box = {
                        type = "wallmounted",
			-- Ceiling
                        wall_top    = {-0.5, 0.4375, -0.375, 0.5, 0.5, 0.375},
			-- Floor
                        wall_bottom = {-0.5, -0.5, -0.375, 0.5, -0.4375, 0.375},
			-- Wall
                        wall_side   = {-0.5, -0.375, -0.5, -0.4375, 0.375, 0.5},
                },
                groups = {snappy = 2, choppy = 2, oddly_breakable_by_hand = 3, flammable = 3},
                sounds = default.node_sound_wood_defaults(),
        })

-- Santa Christmas Painting (64x64)
minetest.register_node("mesecraft_christmas:painting_02", {
                description = "Santa Claus Painting",
                drawtype = "nodebox",
                tiles = {"mesecraft_christmas_painting_02.png"},
                inventory_image = "mesecraft_christmas_painting_02.png",
                wield_image = "mesecraft_christmas_painting_02.png",
                paramtype = "light",
                paramtype2 = "wallmounted",
                sunlight_propagates = true,
                walkable = false,
                node_box = {
                        type = "wallmounted",
			-- Ceiling
                        wall_top    = {-0.5, 0.4375, -0.5, 0.5, 0.5, 0.5},
			-- Floor
                        wall_bottom = {-0.5, -0.5, -0.5, 0.5, -0.4375, 0.5},
			-- Wall
                        wall_side   = {-0.5, -0.5, -0.5, -0.4375, 0.5, 0.5},
                },
                groups = {snappy = 2, choppy = 2, oddly_breakable_by_hand = 3, flammable = 3},
                sounds = default.node_sound_wood_defaults(),
        })

-- Snowman Christmas Painting (64x64)
minetest.register_node("mesecraft_christmas:painting_03", {
                description = "Snowman Painting",
                drawtype = "nodebox",
                tiles = {"mesecraft_christmas_painting_03.png"},
                inventory_image = "mesecraft_christmas_painting_03.png",
                wield_image = "mesecraft_christmas_painting_03.png",
                paramtype = "light",
                paramtype2 = "wallmounted",
                sunlight_propagates = true,
                walkable = false,
                node_box = {
                        type = "wallmounted",
			-- Ceiling
                        wall_top    = {-0.5, 0.4375, -0.5, 0.5, 0.5, 0.5},
			-- Floor
                        wall_bottom = {-0.5, -0.5, -0.5, 0.5, -0.4375, 0.5},
			-- Wall
                        wall_side   = {-0.5, -0.5, -0.5, -0.4375, 0.5, 0.5},
                },
                groups = {snappy = 2, choppy = 2, oddly_breakable_by_hand = 3, flammable = 3},
                sounds = default.node_sound_wood_defaults(),
        })
-- Christmas Tree Painting (64x32)
minetest.register_node("mesecraft_christmas:painting_04", {
                description = "Christmas Cabin Landscape Painting",
                drawtype = "nodebox",
                tiles = {"mesecraft_christmas_painting_04.png"},
                inventory_image = "mesecraft_christmas_painting_04.png",
                wield_image = "mesecraft_christmas_painting_04.png",
                paramtype = "light",
                paramtype2 = "wallmounted",
                sunlight_propagates = true,
                walkable = false,
                node_box = {
                        type = "wallmounted",
                        -- Ceiling
                        wall_top    = {-0.5, 0.4375, -0.25, 0.5, 0.5, 0.25},
                        -- Floor
                        wall_bottom = {-0.5, -0.5, -0.25, 0.5, -0.4375, 0.25},
                        -- Wall
                        wall_side   = {-0.5, -0.25, -0.5, -0.4375, 0.25, 0.5},
                },
                groups = {snappy = 2, choppy = 2, oddly_breakable_by_hand = 3, flammable = 3},
                sounds = default.node_sound_wood_defaults(),
        })

-- Mountainous Winter Landscape Painting (64x32)
minetest.register_node("mesecraft_christmas:painting_05", {
                description = "Mountainous Winter Landscape Painting",
                drawtype = "nodebox",
                tiles = {"mesecraft_christmas_painting_05.png"},
                inventory_image = "mesecraft_christmas_painting_05.png",
                wield_image = "mesecraft_christmas_painting_05.png",
                paramtype = "light",
                paramtype2 = "wallmounted",
                sunlight_propagates = true,
                walkable = false,
                node_box = {
                        type = "wallmounted",
                        -- Ceiling
                        wall_top    = {-0.5, 0.4375, -0.25, 0.5, 0.5, 0.25},
                        -- Floor
                        wall_bottom = {-0.5, -0.5, -0.25, 0.5, -0.4375, 0.25},
                        -- Wall
                        wall_side   = {-0.5, -0.25, -0.5, -0.4375, 0.25, 0.5},
                },
                groups = {snappy = 2, choppy = 2, oddly_breakable_by_hand = 3, flammable = 3},
                sounds = default.node_sound_wood_defaults(),
        })

-- Winter Horseback Riding Painting (64x48)
minetest.register_node("mesecraft_christmas:painting_06", {
                description = "Winter Horseback Riding Painting",
                drawtype = "nodebox",
                tiles = {"mesecraft_christmas_painting_06.png"},
                inventory_image = "mesecraft_christmas_painting_06.png",
                wield_image = "mesecraft_christmas_painting_06.png",
                paramtype = "light",
                paramtype2 = "wallmounted",
                sunlight_propagates = true,
                walkable = false,
                node_box = {
                        type = "wallmounted",
                        -- Ceiling
                        wall_top    = {-0.5, 0.4375, -0.375, 0.5, 0.5, 0.375},
                        -- Floor
                        wall_bottom = {-0.5, -0.5, -0.375, 0.5, -0.4375, 0.375},
                        -- Wall
                        wall_side   = {-0.5, -0.375, -0.5, -0.4375, 0.375, 0.5},
                },
                groups = {snappy = 2, choppy = 2, oddly_breakable_by_hand = 3, flammable = 3},
                sounds = default.node_sound_wood_defaults(),
        })
