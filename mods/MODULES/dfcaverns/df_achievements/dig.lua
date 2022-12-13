local S = minetest.get_translator(minetest.get_current_modname())

local steel_pick = df_dependencies.texture_tool_steelpick
local steel_shovel = df_dependencies.texture_tool_steelshovel

local crossed_pick_and_shovel = "((("..steel_shovel.."^[transformFX)^"..steel_pick..")^[resize:32x32)"

local gas_seep = "(("..df_dependencies.texture_stone.."^"..df_dependencies.texture_mineral_coal.."^[combine:16x80:0,-16=crack_anylength.png)^[resize:32x32)"

awards.register_achievement("dfcaverns_destroyed_gas_seep", {
	title = S("Destroy a Gas Seep"),
	description = S("Plug a crack that mine gas is seeping out of to make the caves just a little bit safer."),
	icon = "dfcaverns_awards_backgroundx32.png^" .. gas_seep .."^dfcaverns_awards_foregroundx32.png",
	difficulty = 2,
	trigger = {
		type = "dig",
		node = "mine_gas:gas_seep",
		target = 1
	},
})

awards.register_achievement("dfcaverns_giant_web", {
	title = S("Collect Giant Webbing"),
	description = S("Collect a piece of giant webbing found in a cave."),
	icon ="dfcaverns_awards_backgroundx32.png^big_webs_item.png^dfcaverns_awards_foregroundx32.png",
	difficulty = 1,
	trigger = {
		type = "dig",
		node = "big_webs:webbing",
		target = 1
	},
})

-- too common
--awards.register_achievement("dfcaverns_glow_worms", {
--	title = S("Collect Glow Worms"),
--	description = S(""),
--	icon =,
--	trigger = {
--		type = "dig",
--		node = "df_mapitems:glow_worm",
--		target = 1
--	},
--})

---------------------------------------------------------------

awards.register_achievement("dfcaverns_cave_pearls", {
	title = S("Collect Cave Pearls"),
	description = S("Collect some cave pearls from the wall of a cave."),
	icon = "dfcaverns_awards_backgroundx32.png^dfcaverns_cave_pearls_achievement.png^dfcaverns_awards_foregroundx32.png",
	difficulty = 1,
	trigger = {
		type = "dig",
		node = "df_mapitems:cave_pearls",
		target = 1
	},
	_dfcaverns_achievements = {"dfcaverns_prospector"},
})

awards.register_achievement("dfcaverns_castle_coral", {
	title = S("Collect Castle Coral"),
	description = S("Collect a piece of Castle Coral from the Sunless Sea."),
	icon ="dfcaverns_awards_backgroundx32.png^dfcaverns_castle_coral_achievement.png^dfcaverns_awards_foregroundx32.png",
	trigger = {
		type = "dig",
		node = "df_mapitems:castle_coral",
		target = 1
	},
	difficulty = 2,
	_dfcaverns_achievements = {"dfcaverns_prospector"},
})

awards.register_achievement("dfcaverns_ruby_crystals", {
	title = S("Collect Giant Red Crystal"),
	description = S("Collect one of the giant red crystals found in large barren caverns."),
	icon ="dfcaverns_awards_backgroundx32.png^dfcaverns_big_red_crystal_achievement.png^dfcaverns_awards_foregroundx32.png",
	trigger = {
		type = "dig",
		node = "group:dfcaverns_big_crystal",
		target = 1
	},
	difficulty = 1,
	_dfcaverns_achievements = {"dfcaverns_prospector"},
})

awards.register_achievement("dfcaverns_cave_coral", {
	title = S("Collect Cave Coral"),
	description = S("Collect a piece of Cave Coral from the Sunless Sea."),
	icon ="dfcaverns_awards_backgroundx32.png^dfcaverns_cave_coral_achievement.png^dfcaverns_awards_foregroundx32.png",
	trigger = {
		type = "dig",
		node = "group:dfcaverns_cave_coral",
		target = 1
	},
	difficulty = 1,
	_dfcaverns_achievements = {"dfcaverns_prospector"},
})

awards.register_achievement("dfcaverns_flawless_mese", {
	title = S("Collect Flawless Mese Crystal Block"),
	description = S("Collect a flawless Mese crystal block from the Magma Sea."),
	icon ="dfcaverns_awards_backgroundx32.png^dfcaverns_glowmese_achievement.png^dfcaverns_awards_foregroundx32.png",
	trigger = {
		type = "dig",
		node = "df_mapitems:glow_mese",
		target = 1
	},
	difficulty = 3,
	_dfcaverns_achievements = {"dfcaverns_prospector"},
})

awards.register_achievement("dfcaverns_luminous_salt", {
	title = S("Collect Luminous Salt Crystal"),
	description = S("Collect a luminous salt crystal from the dry caverns where Bloodthorns live."),
	icon ="dfcaverns_awards_backgroundx32.png^dfcaverns_salt_achievement.png^dfcaverns_awards_foregroundx32.png",
	trigger = {
		type = "dig",
		node = "df_mapitems:salt_crystal",
		target = 1
	},
	difficulty = 1,
	_dfcaverns_achievements = {"dfcaverns_prospector"},
})

awards.register_achievement("dfcaverns_glow_amethyst", {
	title = S("Collect Glowing Amethyst"),
	description = S("Collect a block of glowing amethyst crystal from the Underworld."),
	icon ="dfcaverns_awards_backgroundx32.png^dfcaverns_amethyst_achievement.png^dfcaverns_awards_foregroundx32.png",
	trigger = {
		type = "dig",
		node = "df_underworld_items:glow_amethyst",
		target = 1
	},
	difficulty = 2,
	_dfcaverns_achievements = {"dfcaverns_prospector"},
})

awards.register_achievement("dfcaverns_glow_stone", {
	title = S('"Collect" Lightseam Stone'),
	description = S("Attempt to collect a piece of Lightseam, a strange glowing mineral found deep underground."),
	icon ="dfcaverns_awards_backgroundx32.png^dfcaverns_glowstone_achievement.png^dfcaverns_awards_foregroundx32.png",
	trigger = {
		type = "dig",
		node = "df_underworld_items:glowstone",
		target = 1
	},
	difficulty = 2,
	_dfcaverns_achievements = {"dfcaverns_prospector"},
})

------------------------------------------------------------------

awards.register_achievement("dfcaverns_prospector", {
	title = S("Deep Prospector"),
	description = S("Collect various different exotic items from various caverns."),
	icon = "dfcaverns_awards_backgroundx32.png^"..crossed_pick_and_shovel.."^dfcaverns_awards_foregroundx32.png",
	difficulty = 3 / df_achievements.get_child_achievement_count("dfcaverns_prospector"),
	trigger = {
		type="dfcaverns_achievements",
		achievement_name="dfcaverns_prospector",
		target=df_achievements.get_child_achievement_count("dfcaverns_prospector"),
	},
})
