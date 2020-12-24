commoditymarket_fantasy = {}

local modpath = minetest.get_modpath(minetest.get_current_modname())
local default_modpath = minetest.get_modpath("default")
local mcl_modpath = minetest.get_modpath("mcl_core")
	and minetest.get_modpath("mcl_sounds")
	and minetest.get_modpath("mcl_chests")
	and minetest.get_modpath("mesecons_wires") -- confusingly, 'mesecons:wire_00000000_off' is defined in this mod

if not (default_modpath or mcl_modpath) then
	assert(false, "commoditymarket_fantasy must have either the default mod (eg from minetest_game) or the mineclone2 core mods enabled.")
end

minetest.register_alias("commoditymarket:kings_market",              "commoditymarket_fantasy:kings_market")
minetest.register_alias("commoditymarket:gold_coins",                "commoditymarket_fantasy:gold_coins")
minetest.register_alias("commoditymarket:night_market",				 "commoditymarket_fantasy:night_market")
minetest.register_alias("commoditymarket:goblin_market",             "commoditymarket_fantasy:goblin_market")
minetest.register_alias("commoditymarket:under_market",              "commoditymarket_fantasy:under_market")
minetest.register_alias("commoditymarket:caravan_post",              "commoditymarket_fantasy:caravan_post")
minetest.register_alias("commoditymarket:caravan_market_1",          "commoditymarket_fantasy:caravan_market_1")
minetest.register_alias("commoditymarket:caravan_market_2",          "commoditymarket_fantasy:caravan_market_2")
minetest.register_alias("commoditymarket:caravan_market_3",          "commoditymarket_fantasy:caravan_market_3")
minetest.register_alias("commoditymarket:caravan_market_4",          "commoditymarket_fantasy:caravan_market_4")
minetest.register_alias("commoditymarket:caravan_market_5",          "commoditymarket_fantasy:caravan_market_5")
minetest.register_alias("commoditymarket:caravan_market_permanent",  "commoditymarket_fantasy:caravan_market_permanent")

local S = minetest.get_translator(minetest.get_current_modname())
commoditymarket_fantasy.S = S

if default_modpath then
	commoditymarket_fantasy.default_items = {"default:axe_bronze","default:axe_diamond","default:axe_mese","default:axe_steel","default:axe_steel","default:axe_stone","default:axe_wood","default:pick_bronze","default:pick_diamond","default:pick_mese","default:pick_steel","default:pick_stone","default:pick_wood","default:shovel_bronze","default:shovel_diamond","default:shovel_mese","default:shovel_steel","default:shovel_stone","default:shovel_wood","default:sword_bronze","default:sword_diamond","default:sword_mese","default:sword_steel","default:sword_stone","default:sword_wood", "default:blueberries", "default:book", "default:bronze_ingot", "default:clay_brick", "default:clay_lump", "default:coal_lump", "default:copper_ingot", "default:copper_lump", "default:diamond", "default:flint", "default:gold_ingot", "default:gold_lump", "default:iron_lump", "default:mese_crystal", "default:mese_crystal_fragment", "default:obsidian_shard", "default:paper", "default:steel_ingot", "default:stick", "default:tin_ingot", "default:tin_lump", "default:acacia_tree", "default:acacia_wood", "default:apple", "default:aspen_tree", "default:aspen_wood", "default:blueberry_bush_sapling", "default:bookshelf", "default:brick", "default:bronzeblock", "default:bush_sapling", "default:cactus", "default:clay", "default:coalblock", "default:cobble", "default:copperblock", "default:desert_cobble", "default:desert_sand", "default:desert_sandstone", "default:desert_sandstone_block", "default:desert_sandstone_brick", "default:desert_stone", "default:desert_stone_block", "default:desert_stonebrick", "default:diamondblock", "default:dirt", "default:glass", "default:goldblock", "default:gravel", "default:ice", "default:junglegrass", "default:junglesapling", "default:jungletree", "default:junglewood", "default:ladder_steel", "default:ladder_wood", "default:large_cactus_seedling", "default:mese", "default:mese_post_light", "default:meselamp", "default:mossycobble", "default:obsidian", "default:obsidian_block", "default:obsidian_glass", "default:obsidianbrick", "default:papyrus", "default:pine_sapling", "default:pine_tree", "default:pine_wood", "default:sand", "default:sandstone", "default:sandstone_block", "default:sandstonebrick", "default:sapling", "default:silver_sand", "default:silver_sandstone", "default:silver_sandstone_block", "default:silver_sandstone_brick", "default:snow", "default:snowblock", "default:steelblock", "default:stone", "default:stone_block", "default:stonebrick", "default:tinblock", "default:tree", "default:wood",}
	commoditymarket_fantasy.wood_sounds = default.node_sound_wood_defaults()
	commoditymarket_fantasy.chest_locked = "default:chest_locked" -- used in the trader's caravan post recipe
	commoditymarket_fantasy.gold_ingot = "default:gold_ingot"
	commoditymarket_fantasy.coal_lump = "default:coal_lump" -- used by the goblin market

	commoditymarket_fantasy.undermarket_currency = {
		["default:mese"] = 9*9*20,
		["default:mese_crystal"] = 9*20,
		["default:mese_crystal_fragment"] = 20
	}
	commoditymarket_fantasy.undermarket_desc = S("Deep in the bowels of the world, below even the goblin-infested warrens and ancient delvings of the dwarves, dark and mysterious beings once dwelt. A few still linger to this day, and facilitate barter for those brave souls willing to travel in their lost realms. The Undermarket uses Mese chips ('₥') as a currency - twenty chips to the Mese fragment. Though traders are loathe to physically break Mese crystals up into units that small, as it renders it useless for other purposes.")
	commoditymarket_fantasy.undermarket_symbol = "₥" --"\u{20A5}" mill sign
	commoditymarket_fantasy.stone_sounds = default.node_sound_stone_defaults()

elseif mcl_modpath then
	commoditymarket_fantasy.default_items = {}
	commoditymarket_fantasy.wood_sounds = mcl_sounds.node_sound_wood_defaults()
	commoditymarket_fantasy.chest_locked = "mcl_chests:chest" -- used in the trader's caravan post recipe
	commoditymarket_fantasy.gold_ingot = "mcl_core:gold_ingot"
	commoditymarket_fantasy.coal_lump = "mcl_core:coal_lump" -- used by the goblin market
	
	commoditymarket_fantasy.undermarket_currency = {
		["mesecons:wire_00000000_off"] = 1
	}
	commoditymarket_fantasy.undermarket_desc = S("Deep in the bowels of the world, below even the goblin-infested warrens and ancient delvings of the dwarves, dark and mysterious beings once dwelt. A few still linger to this day, and facilitate barter for those brave souls willing to travel in their lost realms. The Undermarket uses Redstone ('₨') as a currency.")
	commoditymarket_fantasy.undermarket_symbol = "₨" --"\u{20A8}" rupee sign
	commoditymarket_fantasy.stone_sounds = mcl_sounds.node_sound_stone_defaults()
end


local coins_per_ingot = math.floor(tonumber(minetest.settings:get("commoditymarket_coins_per_ingot")) or 1000)
commoditymarket_fantasy.coins_per_ingot = coins_per_ingot

-- Only register gold coins once, if required.
-- If coins_per_ingot is 1 or less, don't register coins at all - users can use fractional ingots
local gold_coins_registered = false
commoditymarket_fantasy.register_gold_coins = function()
	if not gold_coins_registered and coins_per_ingot > 1 then
		minetest.register_craftitem("commoditymarket_fantasy:gold_coins", {
			description = S("Gold Coins"),
			_doc_items_longdesc = S("A gold ingot is far too valuable to use as a basic unit of value, so it has become common practice to divide the standard gold bar into @1 small disks to make trade easier.", coins_per_ingot),
			_doc_items_usagehelp = S("Gold coins can be deposited and withdrawn from markets that accept them as currency. These markets can make change if you have @1 coins and would like them back in ingot form again.", coins_per_ingot),
			inventory_image = "commoditymarket_gold_coins.png",
			stack_max = coins_per_ingot,
		})
		gold_coins_registered = true		
	end
end

-- used by both village markets and the caravan market
if coins_per_ingot > 1 then
	commoditymarket_fantasy.gold_currency = {
		[commoditymarket_fantasy.gold_ingot] = coins_per_ingot,
		["commoditymarket_fantasy:gold_coins"] = 1
	}
else
	commoditymarket_fantasy.gold_currency = {
		[commoditymarket_fantasy.gold_ingot] = 1,
	}
end	

commoditymarket_fantasy.usage_help = S("Right-click on this to open the market interface.")

dofile(modpath.."/caravan_markets.lua")
dofile(modpath.."/dungeon_markets.lua")
dofile(modpath.."/village_markets.lua")

-- These globals were only needed during initialization, dispose of them afterward
commoditymarket_fantasy = nil