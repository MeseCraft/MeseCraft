--------------------------------------------------------
-- Minetest :: Extra Doors v2.0 (extra_doors)
--
-- See README.txt for licensing and release notes.
-- Copyright (c) 2018, Leslie E. Krause
--------------------------------------------------------

-- One of the most essential but often overlooked elements of building design is door selection.
-- Doors set the tone and character, and having the wrong style of door can make or break a build.

minetest.register_craftitem( ":default:steel_rod", {
        description = "Steel Rod",
        inventory_image = "default_steel_rod.png",
} )

minetest.register_craft( {
        output = "default:steel_rod 4",
        recipe = {
                { "default:steel_ingot" },
        }
} )

doors.register( "door_woodpanel1", {
	-- Colonial Style (6 panel)
	tiles = { { name = "doors_door_woodpanel1.png", backface_culling = true } },
	description = "Wooden Colonial Door",
	inventory_image = "doors_item_woodpanel1.png",
	groups = { choppy = 2, oddly_breakable_by_hand = 2, flammable = 2 },
	recipe = {
		{ "group:wood", "group:wood", "default:stick" },
		{ "group:wood", "group:wood", "default:stick" },
		{ "group:wood", "group:wood", "default:stick" },
	}
} )

doors.register( "door_woodglass1", {
	-- Cambridge Style (2 panel)
	tiles = { { name = "doors_door_woodglass1.png", backface_culling = true } },
	description = "Wooden Single-Lite Door",
	inventory_image = "doors_item_woodglass1.png",
	groups = { choppy = 2, oddly_breakable_by_hand = 2, flammable = 2 },
	recipe = {
		{ "default:glass", "default:glass", "default:stick" },
		{ "group:wood", "group:wood", "" },
		{ "group:wood", "group:wood", "" },
	}
} )

doors.register( "door_woodglass2", {
	-- Atherton Style (4 panel)
	tiles = { { name = "doors_door_woodglass2.png", backface_culling = true } },
	description = "Wooden Double-Lite Door",
	inventory_image = "doors_item_woodglass2.png",
	groups = { choppy = 2, oddly_breakable_by_hand = 2, flammable = 2 },
	recipe = {
		{ "default:glass", "default:glass", "default:stick" },
		{ "group:wood", "group:wood", "default:stick" },
		{ "group:wood", "group:wood", "" },
	}
} )

doors.register( "door_japanese", {
	tiles = { { name = "doors_door_japanese.png", backface_culling = true } },
	description = "Japanese Door",
	inventory_image = "doors_item_japanese.png",
	groups = { choppy = 2, oddly_breakable_by_hand = 2, flammable = 2 },
	recipe = {
		{ "default:paper", "group:wood", "default:stick" },
		{ "default:paper", "group:wood", "default:stick" },
		{ "default:paper", "group:wood", "default:stick" },
	}
} )

doors.register( "door_french", {
	tiles = { { name = "doors_door_french.png", backface_culling = true } },
	description = "French Door",
	inventory_image = "doors_item_french.png",
	groups = { choppy = 2, oddly_breakable_by_hand = 2, flammable = 2 },
	recipe = {
		{ "default:glass", "group:wood", "default:stick" },
		{ "default:glass", "group:wood", "default:stick" },
		{ "default:glass", "group:wood", "default:stick" },
	}
} )

doors.register( "door_cottage1", {
	tiles = { { name = "doors_door_cottage1.png", backface_culling = true } },
	description = "Cottage Interior Door",
	inventory_image = "doors_item_cottage1.png",
	groups = { choppy = 2, oddly_breakable_by_hand = 2, flammable = 2 },
	recipe = {
		{ "group:wood", "group:wood" },
		{ "default:stick", "default:stick" },
		{ "group:wood", "group:wood" },
	}
} )

doors.register( "door_cottage2", {
	tiles = { { name = "doors_door_cottage2.png", backface_culling = true } },
	description = "Cottage Exterior Door",
	inventory_image = "doors_item_cottage2.png",
	groups = { choppy = 2, oddly_breakable_by_hand = 2, flammable = 2 },
	recipe = {
		{ "default:glass", "default:glass" },
		{ "default:stick", "default:stick" },
		{ "group:wood", "group:wood" },
	}
} )

doors.register( "door_barn1", {
	tiles = { { name = "doors_door_barn1.png", backface_culling = true } },
	description = "Barn Interior Door",
	inventory_image = "doors_item_barn1.png",
	groups = { choppy = 2, oddly_breakable_by_hand = 2, flammable = 2 },
	recipe = {
		{ "group:wood", "group:wood", "group:wood" },
		{ "default:stick", "default:stick", "default:stick" },
		{ "group:wood", "group:wood", "group:wood" },
	}
} )

doors.register( "door_barn2", {
	tiles = { { name = "doors_door_barn2.png", backface_culling = true } },
	description = "Barn Exterior Door",
	inventory_image = "doors_item_barn2.png",
	groups = { choppy = 2, oddly_breakable_by_hand = 2, flammable = 2 },
	recipe = {
		{ "group:wood", "group:wood", "group:wood" },
		{ "default:steel_rod", "default:steel_rod", "default:steel_rod" },
		{ "group:wood", "group:wood", "group:wood" },
	}
} )

doors.register( "door_castle1", {
	tiles = { { name = "doors_door_castle1.png", backface_culling = true } },
	description = "Castle Interior Door",
	inventory_image = "doors_item_castle1.png",
	groups = { choppy = 2, oddly_breakable_by_hand = 2, flammable = 2 },
	recipe = {
		{ "default:stick", "group:wood", "group:wood" },
		{ "", "group:wood", "group:wood" },
		{ "default:stick", "group:wood", "group:wood" },
	}
} )

doors.register( "door_castle2", {
	tiles = { { name = "doors_door_castle2.png", backface_culling = true } },
	description = "Castle Exterior Door",
	inventory_image = "doors_item_castle2.png",
	groups = { choppy = 2, oddly_breakable_by_hand = 2, flammable = 2 },
	recipe = {
		{ "default:steel_rod", "group:wood", "group:wood" },
		{ "", "group:wood", "group:wood" },
		{ "default:steel_rod", "group:wood", "group:wood" },
	}
} )

doors.register( "door_mansion1", {
	tiles = { { name = "doors_door_mansion1.png", backface_culling = true } },
	description = "Mansion Interior Door",
	inventory_image = "doors_item_mansion1.png",
	groups = { choppy = 2, oddly_breakable_by_hand = 2, flammable = 2 },
	recipe = {
		{ "group:wood", "group:wood", "dye:white" },
		{ "group:wood", "group:wood", "dye:yellow" },
		{ "group:wood", "group:wood", "dye:white" },
	}
} )

doors.register( "door_mansion2", {
	tiles = { { name = "doors_door_mansion2.png", backface_culling = true } },
	description = "Mansion Exterior Door ",
	inventory_image = "doors_item_mansion2.png",
	groups = { choppy = 2, oddly_breakable_by_hand = 2, flammable = 2 },
	recipe = {
		{ "group:wood", "group:wood", "dye:black" },
		{ "group:wood", "group:wood", "dye:yellow" },
		{ "group:wood", "group:wood", "dye:black" },
	}
} )

doors.register("door_dungeon1", {
	tiles = { { name = "doors_door_dungeon1.png", backface_culling = true } },
	description = "Dungeon Interior Door",
	inventory_image = "doors_item_dungeon1.png",
	protected = true,
	groups = { cracky = 1, level = 2 },
	sounds = default.node_sound_metal_defaults( ),
	sound_open = "doors_steel_door_open",
	sound_close = "doors_steel_door_close",
	recipe = {
		{ "default:steel_ingot", "default:steel_rod", "default:steel_ingot" },
		{ "default:steel_rod", "default:steel_rod", "default:steel_rod" },
		{ "default:steel_ingot", "default:steel_rod", "default:steel_ingot" },
	}
} )

doors.register( "door_dungeon2", {
	tiles = { { name = "doors_door_dungeon2.png", backface_culling = true } },
	description = "Dungeon Exterior Door",
	inventory_image = "doors_item_dungeon2.png",
	protected = true,
	groups = { cracky = 1, level = 2 },
	sounds = default.node_sound_metal_defaults( ),
	sound_open = "doors_steel_door_open",
	sound_close = "doors_steel_door_close",
	recipe = {
		{ "default:steel_rod", "default:steel_rod", "default:steel_rod" },
		{ "default:steel_ingot", "default:steel_ingot", "default:steel_ingot" },
		{ "default:steel_ingot", "default:steel_ingot", "default:steel_ingot" },
	}
} )

doors.register( "door_steelpanel1", {
	tiles = { { name = "doors_door_steelpanel1.png", backface_culling = true } },
	description = "Steel Colonial Door",
	inventory_image = "doors_item_steelpanel1.png",
	protected = true,
	groups = { cracky = 1, level = 2 },
	sounds = default.node_sound_metal_defaults( ),
	sound_open = "doors_steel_door_open",
	sound_close = "doors_steel_door_close",
	recipe = {
		{ "default:steel_ingot", "default:steel_ingot", "default:steel_rod" },
		{ "default:steel_ingot", "default:steel_ingot", "default:steel_rod" },
		{ "default:steel_ingot", "default:steel_ingot", "default:steel_rod" },
	}
} )

doors.register( "door_steelglass1", {
	tiles = { { name = "doors_door_steelglass1.png", backface_culling = true } },
	description = "Steel Single-Lite Door",
	inventory_image = "doors_item_steelglass1.png",
	protected = true,
	groups = { cracky = 1, level = 2 },
	sounds = default.node_sound_metal_defaults( ),
	sound_open = "doors_steel_door_open",
	sound_close = "doors_steel_door_close",
	recipe = {
		{ "default:glass", "default:glass", "default:steel_rod" },
		{ "default:steel_ingot", "default:steel_ingot", "" },
		{ "default:steel_ingot", "default:steel_ingot", "" },
	}
} )

doors.register( "door_steelglass2", {
	tiles = { { name = "doors_door_steelglass2.png", backface_culling = true } },
	description = "Steel Double-Lite Door",
	inventory_image = "doors_item_steelglass2.png",
	protected = true,
	groups = { cracky = 1, level = 2 },
	sounds = default.node_sound_metal_defaults( ),
	sound_open = "doors_steel_door_open",
	sound_close = "doors_steel_door_close",
	recipe = {
		{ "default:glass", "default:glass", "default:steel_rod" },
		{ "default:steel_ingot", "default:steel_ingot", "default:steel_rod" },
		{ "default:steel_ingot", "default:steel_ingot", "" },
	}
} )

minetest.register_craft( {
	type = "fuel",
	recipe = "doors:door_barn1",
	burntime = 14,
} )

minetest.register_craft( {
	type = "fuel",
	recipe = "doors:door_barn2",
	burntime = 16,
} )

minetest.register_craft( {
	type = "fuel",
	recipe = "doors:door_castle1",
	burntime = 8,
} )

minetest.register_craft( {
	type = "fuel",
	recipe = "doors:door_castle2",
	burntime = 12,
} )
