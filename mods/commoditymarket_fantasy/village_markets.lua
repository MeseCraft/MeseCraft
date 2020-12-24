local S = commoditymarket_fantasy.S
local coins_per_ingot = commoditymarket_fantasy.coins_per_ingot
local default_items = commoditymarket_fantasy.default_items
local gold_ingot = commoditymarket_fantasy.gold_ingot
local gold_currency = commoditymarket_fantasy.gold_currency
local wood_sounds = commoditymarket_fantasy.wood_sounds
local usage_help = commoditymarket_fantasy.usage_help

commoditymarket_fantasy.register_gold_coins()

------------------------------------------------------------------------------
-- King's Market

if minetest.settings:get_bool("commoditymarket_enable_kings_market", true) then

local kings_def = {
	description = S("King's Market"),
	long_description = S("The largest and most accessible market for the common man, the King's Market uses gold coins as its medium of exchange (or the equivalent in gold ingots - @1 coins to the ingot). However, as a respectable institution of the surface world, the King's Market operates only during the hours of daylight. Gold coins are represented by a '☼' symbol.", coins_per_ingot),
	currency = gold_currency,
	currency_symbol = "☼", -- "\u{263C}" Alchemical symbol for gold
	inventory_limit = 100000,
	--sell_limit =, -- no sell limit for the King's Market
	initial_items = default_items,
}

commoditymarket_fantasy.register_gold_coins()

commoditymarket.register_market("kings", kings_def)

local kings_protect = minetest.settings:get_bool("commoditymarket_protect_kings_market", true)
local on_blast
if kings_protect then
	on_blast = function() end
end

minetest.register_node("commoditymarket_fantasy:kings_market", {
	description = kings_def.description,
	_doc_items_longdesc = kings_def.long_description,
	_doc_items_usagehelp = usage_help,
	tiles = {"commoditymarket_default_chest_top.png","commoditymarket_default_chest_top.png",
		"commoditymarket_default_chest_side.png","commoditymarket_default_chest_side.png",
		"commoditymarket_empty_shelf.png","commoditymarket_default_chest_side.png^commoditymarket_crown.png",},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {choppy = 2, oddly_breakable_by_hand = 1,},
	sounds = wood_sounds,
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		local timeofday =  minetest.get_timeofday()
		if timeofday > 0.2 and timeofday < 0.8 then
			commoditymarket.show_market("kings", clicker:get_player_name())
		else
			minetest.chat_send_player(clicker:get_player_name(), S("At this time of day the King's Market is closed."))
			minetest.sound_play({name = "commoditymarket_error", gain = 0.1}, {to_player=clicker:get_player_name()})
		end
	end,
	can_dig = function(pos, player)
		return not kings_protect or minetest.check_player_privs(player, "protection_bypass")
	end,
	on_blast = on_blast,
})
end
-------------------------------------------------------------------------------
-- Night Market

if minetest.settings:get_bool("commoditymarket_enable_night_market", true) then
local night_def = {
	description = S("Night Market"),
	long_description = S("When the sun sets and the stalls of the King's Market close, other vendors are just waking up to share their wares. The Night Market is not as voluminous as the King's Market but sometimes it's the only option. It accepts the same gold coinage of the realm, @1 coins to the gold ingot.", coins_per_ingot),
	currency = gold_currency,
	currency_symbol = "☼", --"\u{263C}"
	inventory_limit = 10000,
	--sell_limit =, -- no sell limit for the Night Market
	initial_items = default_items,
	anonymous = true,
}

commoditymarket_fantasy.register_gold_coins()

commoditymarket.register_market("night", night_def)

local night_protect = minetest.settings:get_bool("commoditymarket_protect_night_market", true)
local on_blast
if night_protect then
	on_blast = function() end
end

minetest.register_node("commoditymarket_fantasy:night_market", {
	description = night_def.description,
	_doc_items_longdesc = night_def.long_description,
	_doc_items_usagehelp = usage_help,
	tiles = {"commoditymarket_default_chest_top.png","commoditymarket_default_chest_top.png",
		"commoditymarket_default_chest_side.png","commoditymarket_default_chest_side.png",
		"commoditymarket_empty_shelf.png","commoditymarket_default_chest_side.png^commoditymarket_moon.png",},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {choppy = 2, oddly_breakable_by_hand = 1,},
	sounds = wood_sounds,
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		local timeofday =  minetest.get_timeofday()
		if timeofday < 0.2 or timeofday > 0.8 then
			commoditymarket.show_market("night", clicker:get_player_name())
		else
			minetest.chat_send_player(clicker:get_player_name(), S("At this time of day the Night Market is closed."))
			minetest.sound_play({name = "commoditymarket_error", gain = 0.1}, {to_player=clicker:get_player_name()})
		end
	end,
	can_dig = function(pos, player)
		return not night_protect or minetest.check_player_privs(player, "protection_bypass")
	end,
	on_blast = on_blast,
})
end