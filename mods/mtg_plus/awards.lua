local S = minetest.get_translator("mtg_plus")

if minetest.get_modpath("awards") then
	awards.register_achievement("mtg_plus_goldwood", {
		title = S("Rich Carpenter"),
		description = S("Craft 100 goldwood."),
		icon = "mtg_plus_goldwood.png",
		trigger = {
			type = "craft",
			item = "mtg_plus:goldwood",
			target = 100
		}
	})
	awards.register_achievement("mtg_plus_gravel_cobble", {
		title = S("Historic City"),
		description = S("Craft 400 cobbled gravel."),
		icon = "mtg_plus_gravel_cobble.png",
		trigger = {
			type = "craft",
			item = "mtg_plus:gravel_cobble",
			target = 400
		}
	})
	awards.register_achievement("mtg_plus_papyrus_block", {
		title = S("Papyrus Panic"),
		description = S("Build 100 papyrus blocks."),
		icon = "mtg_plus_papyrus_block_side.png",
		trigger = {
			type = "place",
			node = "mtg_plus:papyrus_block",
			target = 100
		}
	})
	awards.register_achievement("mtg_plus_harddiamondblock", {
		title = S("Can't dig me!"),
		description = S("Place a aggregated diamond block."),
		icon = "mtg_plus_hard_diamond_block.png",
		trigger = {
			type = "place",
			node = "mtg_plus:harddiamondblock",
			target = 1
		}
	})
	awards.register_achievement("mtg_plus_ice_tile16", {
		title = S("Ice Crazy"),
		description = S("Craft 128 dense ice tiles."),
		icon = "mtg_plus_ice_tile16.png",
		trigger = {
			type = "craft",
			item = "mtg_plus:ice_tile16",
			target = 128
		}
	})
	awards.register_achievement("mtg_plus_hard_snow_brick", {
		title = S("Let's build an igloo!"),
		description = S("Place 225 hard snow bricks."),
		icon = "mtg_plus_hard_snow_brick.png",
		trigger = {
			type = "place",
			node = "mtg_plus:hard_snow_brick",
			target = 225
		}
	})
	awards.register_achievement("mtg_plus_gold_bed", {
		title = S("Luxurious Adornment"),
		description = S("Craft 4 small gold-framed diamond blocks."),
		icon = "mtg_plus_gold_diamond_block.png",
		trigger = {
			type = "craft",
			item = "mtg_plus:gold_diamond_block",
			target = 4
		}
	})
	awards.register_achievement("mtg_plus_jungle_cobble", {
		title = S("Green Jungle"),
		description = S("Craft 512 jungle cobblestone."),
		icon = "mtg_plus_jungle_cobble.png",
		trigger = {
			type = "craft",
			item = "mtg_plus:jungle_cobble",
			target = 512
		}
	})
	awards.register_achievement("mtg_plus_sandstone_cobble", {
		title = S("Yellow Desert"),
		description = S("Craft 512 cobbled sandstone."),
		icon = "mtg_plus_sandstone_cobble.png",
		trigger = {
			type = "craft",
			item = "mtg_plus:sandstone_cobble",
			target = 512
		}
	})
end
