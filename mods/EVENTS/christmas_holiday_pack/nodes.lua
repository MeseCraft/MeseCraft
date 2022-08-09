-- Christmas Holiday Pack by FreeGamers.org

-- MAIN NODES
	-- Candy Cane Block
	minetest.register_node("christmas_holiday_pack:candy_cane_block", {
		description = "Candy Cane Block",
		tiles = {"christmas_holiday_pack_candy_cane_block.png", "christmas_holiday_pack_candy_cane_block.png", "christmas_holiday_pack_candy_cane_block.png", "christmas_holiday_pack_candy_cane_block.png", "christmas_holiday_pack_candy_cane_block.png^[transformFX", "christmas_holiday_pack_candy_cane_block.png^[transformFX"},
		paramtype2 = "facedir",
		groups = {snappy = 3, oddly_breakable_by_hand = 3},
		sounds = default.node_sound_glass_defaults(),
	})

	-- Green Candy Cane Block
	minetest.register_node("christmas_holiday_pack:green_candy_cane_block", {
	        description = "Green Candy Cane Block",
	        tiles = {"christmas_holiday_pack_green_candy_cane_block.png", "christmas_holiday_pack_green_candy_cane_block.png", "christmas_holiday_pack_green_candy_cane_block.png", "christmas_holiday_pack_green_candy_cane_block.png", "christmas_holiday_pack_green_candy_cane_block.png^[transformFX", "christmas_holiday_pack_green_candy_cane_block.png^[transformFX"},
	        paramtype2 = "facedir",
	        groups = {snappy = 3, oddly_breakable_by_hand = 3},
	        sounds = default.node_sound_glass_defaults(),
	})

	-- Gingerbread Block
	minetest.register_node("christmas_holiday_pack:gingerbread_block", {
	        description = "Gingerbread Block",
	        tiles = {"christmas_holiday_pack_gingerbread_block.png", "christmas_holiday_pack_gingerbread_block.png", "christmas_holiday_pack_gingerbread_block.png", "christmas_holiday_pack_gingerbread_block.png", "christmas_holiday_pack_gingerbread_block.png^[transformFX", "christmas_holiday_pack_gingerbread_block.png^[transformFX"},
	        paramtype2 = "facedir",
	        groups = {snappy = 3, choppy = 2, oddly_breakable_by_hand = 2},
	        sounds = default.node_sound_wood_defaults(),
	})
	-- Frosting Block
	minetest.register_node("christmas_holiday_pack:frosting_block", {
		description = "Frosting Block",
		tiles = {"christmas_holiday_pack_frosting_block.png"},
		paramtype2 = "facedir",
		groups = {snappy = 3},
		sounds = default.node_sound_leaves_defaults(),
	})

-- StairsPlus Registrations for Candy Cane Block,  Green Candy Cane Block, Gingerbread Block, Frosting Block.
if minetest.get_modpath("moreblocks") then
        stairsplus:register_all(
	                "christmas_holiday_pack", "candy_cane_block", "christmas_holiday_pack:candy_cane_block", {
                        description = "Candy Cane Block",
                        groups = {snappy = 3, oddly_breakable_by_hand = 3},
                        tiles = {"christmas_holiday_pack_candy_cane_block.png"},
                        sounds = default.node_sound_glass_defaults(),
        })
	stairsplus:register_all(
	                "christmas_holiday_pack", "green_candy_cane_block", "christmas_holiday_pack:green_candy_cane_block", {
                        description = "Green Candy Cane Block",
                        groups = {snappy = 3, oddly_breakable_by_hand = 3},
                        tiles = {"christmas_holiday_pack_green_candy_cane_block.png"},
                        sounds = default.node_sound_glass_defaults(),
        })
	stairsplus:register_all(
                        "christmas_holiday_pack", "gingerbread_block", "christmas_holiday_pack:gingerbread_block", {
                        description = "Gingerbread Block",
                        groups = {snappy = 3, choppy = 2, oddly_breakable_by_hand = 2},
                        tiles = {"christmas_holiday_pack_gingerbread_block.png"},
                        sounds = default.node_sound_wood_defaults(),
        })
        stairsplus:register_all(
          		"christmas_holiday_pack", "frosting_block", "christmas_holiday_pack:frosting_block", {
                        description = "Frosting",
                        groups = {snappy = 3},
                        tiles = {"christmas_holiday_pack_frosting_block.png"},
                        sounds = default.node_sound_stone_defaults(),
        })
end

-- DECORATIVE NODES

	-- Mistletoe
	minetest.register_node("christmas_holiday_pack:mistletoe", {
	        description = "Mistletoe",
	        tiles = {"christmas_holiday_pack_mistletoe.png"},
	        drawtype = "plantlike",
	        walkable = false,
	        sunlight_propagates = true,
	        use_texture_alpha = "clip",
	        groups = {snappy = 3, oddly_breakable_by_hand = 3},
	        sounds = default.node_sound_leaves_defaults(),
	})

	-- Christmas Reef
	minetest.register_node("christmas_holiday_pack:reef", {
	        description = "Christmas Reef",
	        tiles = {"christmas_holiday_pack_christmas_reef.png"},
	        inventory_image = "christmas_holiday_pack_christmas_reef.png",
	        wield_image = "christmas_holiday_pack_christmas_reef.png",
	        sunlight_propagates = true,
	        walkable = false,
	        climbable = false,
	        is_ground_content = false,
	        selection_box = {
	                type = "wallmounted",
	        },
	        legacy_wallmounted = true,
	        use_texture_alpha = "clip",
	        drawtype = "signlike",
	        paramtype = "light",
	        paramtype2 = "wallmounted",
	        groups = {snappy = 3, oddly_breakable_by_hand = 3},
	        sounds = default.node_sound_leaves_defaults(),
	})

	-- Icicles
	minetest.register_node("christmas_holiday_pack:icicles", {
	        description = "Icicles",
	        tiles = {"christmas_holiday_pack_icicles.png"},
	        inventory_image = "christmas_holiday_pack_icicles.png",
	        wield_image = "christmas_holiday_pack_icicles.png",
	        sunlight_propagates = true,
	        walkable = false,
	        climbable = false,
	        is_ground_content = false,
	        selection_box = {
	                type = "wallmounted",
	        },
	        legacy_wallmounted = true,
	        use_texture_alpha = "clip",
	        drawtype = "signlike",
	        paramtype = "light",
	        paramtype2 = "wallmounted",
	        groups = {snappy = 3},
	        sounds = default.node_sound_glass_defaults(),
	})

	-- Christmas Tree Star
	minetest.register_node("christmas_holiday_pack:christmas_star", {
	        description = "Christmas Star",
	        tiles = {"christmas_holiday_pack_christmas_star.png"},
	        drawtype = "plantlike",
	        walkable = false,
	        sunlight_propagates = true,
	        use_texture_alpha = "clip",
	        groups = {snappy = 3, oddly_breakable_by_hand = 3},
	        light_source = 8,
	        sounds = default.node_sound_metal_defaults(),
	})
	-- Garland
	minetest.register_node("christmas_holiday_pack:garland", {
		description = "Garland",
		tiles = {"garland_green.png"},
		inventory_image = "garland_green.png",
		wield_image = "garland_green.png",
		sunlight_propagates = true,
		walkable = false,
		climbable = false,
		is_ground_content = false,
		selection_box = {
			type = "wallmounted",
		},
		legacy_wallmounted = true,
		use_texture_alpha = "clip",
		drawtype = "signlike",
		paramtype = "light",
		paramtype2 = "wallmounted",
		groups = {snappy = 3},
		sounds = default.node_sound_leaves_defaults(),
	})
	-- Festive Garland
	minetest.register_node("christmas_holiday_pack:festive_garland", {
		description = "Festive Garland",
		tiles = {"garland.png"},
		inventory_image = "garland.png",
		wield_image = "garland.png",
		sunlight_propagates = true,
		walkable = false,
		climbable = false,
		is_ground_content = false,
		selection_box = {
			type = "wallmounted",
		},
		legacy_wallmounted = true,
		use_texture_alpha = "clip",
		drawtype = "signlike",
		paramtype = "light",
		paramtype2 = "wallmounted",
		groups = {snappy = 3},
		sounds = default.node_sound_leaves_defaults(),
	})
	-- Festive Garland with Lights
	minetest.register_node("christmas_holiday_pack:festive_garland_lights", {
		description = "Festive Garland with Lights",
		tiles = {
			{
				image = "garland_lights.png",
				backface_culling = false,
				animation = {
					type = "vertical_frames",
					aspect_w = 64,
					aspect_h = 64,
					length = 16
				},
			}
		},
		inventory_image = "inv_garland_lights.png",
		wield_image = "inv_garland_lights.png",
		sunlight_propagates = true,
		walkable = false,
		climbable = false,
		is_ground_content = false,
		selection_box = {
			type = "wallmounted",
		},
		legacy_wallmounted = true,
		use_texture_alpha = "clip",
		drawtype = "signlike",
		paramtype = "light",
		light_source = 8,
		paramtype2 = "wallmounted",
		groups = {snappy = 3},
		sounds = default.node_sound_leaves_defaults(),
	})
        -- Red Garland
        minetest.register_node("christmas_holiday_pack:garland_red", {
                description = "Red Garland",
                tiles = {"garland_red.png"},
                inventory_image = "garland_red.png",
                wield_image = "garland_red.png",
                sunlight_propagates = true,
                walkable = false,
                climbable = false,
                is_ground_content = false,
                selection_box = {
                        type = "wallmounted",
                },
                legacy_wallmounted = true,
                use_texture_alpha = "clip",
                drawtype = "signlike",
                paramtype = "light",
                paramtype2 = "wallmounted",
                groups = {snappy = 3},
                sounds = default.node_sound_leaves_defaults(),
        })
        -- Yellow Garland
        minetest.register_node("christmas_holiday_pack:garland_yellow", {
                description = "Yellow Garland",
                tiles = {"garland_yellow.png"},
                inventory_image = "garland_yellow.png",
                wield_image = "garland_yellow.png",
                sunlight_propagates = true,
                walkable = false,
                climbable = false,
                is_ground_content = false,
                selection_box = {
                        type = "wallmounted",
                },
                legacy_wallmounted = true,
                use_texture_alpha = "clip",
                drawtype = "signlike",
                paramtype = "light",
                paramtype2 = "wallmounted",
                groups = {snappy = 3},
                sounds = default.node_sound_leaves_defaults(),
        })
        -- White Garland
        minetest.register_node("christmas_holiday_pack:garland_white", {
                description = "White Garland",
                tiles = {"garland_white.png"},
                inventory_image = "garland_white.png",
                wield_image = "garland_white.png",
                sunlight_propagates = true,
                walkable = false,
                climbable = false,
                is_ground_content = false,
                selection_box = {
                        type = "wallmounted",
                },
                legacy_wallmounted = true,
                use_texture_alpha = "clip",
                drawtype = "signlike",
                paramtype = "light",
                paramtype2 = "wallmounted",
                groups = {snappy = 3},
                sounds = default.node_sound_leaves_defaults(),
        })

	-- ORNAMENTS
	        -- 
	-- White Ornament
	minetest.register_node("christmas_holiday_pack:ornament_white", {
	        description = "White Christmas Ornament",
	        tiles = {"christmas_holiday_pack_ornament_white.png"},
	        inventory_image = "christmas_holiday_pack_ornament_white.png",
	        wield_image = "christmas_holiday_pack_ornament_white.png",
	        sunlight_propagates = true,
	        walkable = false,
	        climbable = false,
	        is_ground_content = false,
	        selection_box = {
	                type = "wallmounted",
	        },
	        legacy_wallmounted = true,
	        use_texture_alpha = "clip",
	        drawtype = "signlike",
	        paramtype = "light",
	        paramtype2 = "wallmounted",
	        groups = {snappy = 3, oddly_breakable_by_hand = 3},
	        sounds = default.node_sound_glass_defaults(),
	})
	-- Yellow Ornament
	minetest.register_node("christmas_holiday_pack:ornament_yellow", {
	        description = "Yellow Christmas Ornament",
	        tiles = {"christmas_holiday_pack_ornament_yellow.png"},
	        inventory_image = "christmas_holiday_pack_ornament_yellow.png",
	        wield_image = "christmas_holiday_pack_ornament_yellow.png",
	        sunlight_propagates = true,
	        walkable = false,
	        climbable = false,
	        is_ground_content = false,
	        selection_box = {
	                type = "wallmounted",
	        },
	        legacy_wallmounted = true,
	        use_texture_alpha = "clip",
	        drawtype = "signlike",
	        paramtype = "light",
	        paramtype2 = "wallmounted",
	        groups = {snappy = 3, oddly_breakable_by_hand = 3},
	        sounds = default.node_sound_glass_defaults(),
	})
	-- Red Ornament
	minetest.register_node("christmas_holiday_pack:ornament_red", {
	        description = "Red Christmas Ornament",
	        tiles = {"christmas_holiday_pack_ornament_red.png"},
	        inventory_image = "christmas_holiday_pack_ornament_red.png",
	        wield_image = "christmas_holiday_pack_ornament_red.png",
	        sunlight_propagates = true,
	        walkable = false,
	        climbable = false,
	        is_ground_content = false,
	        selection_box = {
	                type = "wallmounted",
	        },
	        legacy_wallmounted = true,
	        use_texture_alpha = "clip",
	        drawtype = "signlike",
	        paramtype = "light",
	        paramtype2 = "wallmounted",
	        groups = {snappy = 3, oddly_breakable_by_hand = 3},
	        sounds = default.node_sound_glass_defaults(),
	})
	-- Green Ornament
	minetest.register_node("christmas_holiday_pack:ornament_green", {
	        description = "Green Christmas Ornament",
	        tiles = {"christmas_holiday_pack_ornament_green.png"},
	        inventory_image = "christmas_holiday_pack_ornament_green.png",
	        wield_image = "christmas_holiday_pack_ornament_green.png",
	        sunlight_propagates = true,
	        walkable = false,
	        climbable = false,
	        is_ground_content = false,
	        selection_box = {
	                type = "wallmounted",
	        },
	        legacy_wallmounted = true,
	        use_texture_alpha = "clip",
	        drawtype = "signlike",
	        paramtype = "light",
	        paramtype2 = "wallmounted",
	        groups = {snappy = 3, oddly_breakable_by_hand = 3},
	        sounds = default.node_sound_glass_defaults(),
	})
	-- Blue Ornament
	minetest.register_node("christmas_holiday_pack:ornament_blue", {
	        description = "Blue Christmas Ornament",
	        tiles = {"christmas_holiday_pack_ornament_blue.png"},
	        inventory_image = "christmas_holiday_pack_ornament_blue.png",
	        wield_image = "christmas_holiday_pack_ornament_blue.png",
	        sunlight_propagates = true,
	        walkable = false,
	        climbable = false,
	        is_ground_content = false,
	        selection_box = {
	                type = "wallmounted",
	        },
	        legacy_wallmounted = true,
	        use_texture_alpha = "clip",
	        drawtype = "signlike",
	        paramtype = "light",
	        paramtype2 = "wallmounted",
	        groups = {snappy = 3, oddly_breakable_by_hand = 3},
	        sounds = default.node_sound_glass_defaults(),
	})
	-- Orange Ornament
	minetest.register_node("christmas_holiday_pack:ornament_orange", {
	        description = "Orange Christmas Ornament",
	        tiles = {"christmas_holiday_pack_ornament_orange.png"},
	        inventory_image = "christmas_holiday_pack_ornament_orange.png",
	        wield_image = "christmas_holiday_pack_ornament_orange.png",
	        sunlight_propagates = true,
	        walkable = false,
	        climbable = false,
	        is_ground_content = false,
	        selection_box = {
	                type = "wallmounted",
	        },
	        legacy_wallmounted = true,
	        use_texture_alpha = "clip",
	        drawtype = "signlike",
	        paramtype = "light",
	        paramtype2 = "wallmounted",
	        groups = {snappy = 3, oddly_breakable_by_hand = 3},
	        sounds = default.node_sound_glass_defaults(),
	})
	-- Purple Ornament
	minetest.register_node("christmas_holiday_pack:ornament_purple", {
	        description = "Purple Christmas Ornament",
	        tiles = {"christmas_holiday_pack_ornament_purple.png"},
	        inventory_image = "christmas_holiday_pack_ornament_purple.png",
	        wield_image = "christmas_holiday_pack_ornament_purple.png",
	        sunlight_propagates = true,
	        walkable = false,
	        climbable = false,
	        is_ground_content = false,
	        selection_box = {
	                type = "wallmounted",
	        },
	        legacy_wallmounted = true,
	        use_texture_alpha = "clip",
	        drawtype = "signlike",
	        paramtype = "light",
	        paramtype2 = "wallmounted",
	        groups = {snappy = 3, oddly_breakable_by_hand = 3},
	        sounds = default.node_sound_glass_defaults(),
	})
	-- Pink Ornament
	minetest.register_node("christmas_holiday_pack:ornament_pink", {
	        description = "Pink Christmas Ornament",
	        tiles = {"christmas_holiday_pack_ornament_pink.png"},
	        inventory_image = "christmas_holiday_pack_ornament_pink.png",
	        wield_image = "christmas_holiday_pack_ornament_pink.png",
	        sunlight_propagates = true,
	        walkable = false,
	        climbable = false,
	        is_ground_content = false,
	        selection_box = {
	                type = "wallmounted",
	        },
	        legacy_wallmounted = true,
	        use_texture_alpha = "clip",
	        drawtype = "signlike",
	        paramtype = "light",
	        paramtype2 = "wallmounted",
	        groups = {snappy = 3, oddly_breakable_by_hand = 3},
	        sounds = default.node_sound_glass_defaults(),
	})
