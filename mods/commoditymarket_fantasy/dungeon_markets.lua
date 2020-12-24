local modpath = minetest.get_modpath(minetest.get_current_modname())
dofile(modpath.."/mapgen_dungeon_markets.lua")

local S = commoditymarket_fantasy.S
local coal_lump = commoditymarket_fantasy.coal_lump
local wood_sounds = commoditymarket_fantasy.wood_sounds
local usage_help = commoditymarket_fantasy.usage_help
local default_modpath = commoditymarket_fantasy.default_modpath

local undermarket_currency = commoditymarket_fantasy.undermarket_currency
local undermarket_desc = commoditymarket_fantasy.undermarket_desc
local undermarket_symbol = commoditymarket_fantasy.undermarket_symbol
local stone_sounds = commoditymarket_fantasy.stone_sounds


-------------------------------------------------------------------------------
-- "Goblin Exchange"
if minetest.settings:get_bool("commoditymarket_enable_goblin_market", true) then

local goblin_def = {
	description = S("Goblin Exchange"),
	long_description = S("One does not usually associate Goblins with the sort of sophistication that running a market requires. Usually one just associates Goblins with savagery and violence. But they understand the principle of tit-for-tat exchange, and if approached correctly they actually respect the concepts of ownership and debt. However, for some peculiar reason they understand this concept in the context of coal lumps. Goblins deal in the standard coal lump as their form of currency, conceptually divided into 100 coal centilumps (though Goblin brokers prefer to \"keep the change\" when giving back actual coal lumps)."),
	currency = {
		[coal_lump] = 100
	},
	currency_symbol = "¢", --"\u{00A2}" cent symbol
	inventory_limit = 1000,
	--sell_limit =, -- no sell limit
}

commoditymarket.register_market("goblin", goblin_def)

local goblin_protect = minetest.settings:get_bool("commoditymarket_protect_goblin_market", true)
local on_blast
if goblin_protect then
	on_blast = function() end
end

minetest.register_node("commoditymarket_fantasy:goblin_market", {
	description = goblin_def.description,
	_doc_items_longdesc = goblin_def.long_description,
	_doc_items_usagehelp = usage_help,
	tiles = {"commoditymarket_default_chest_top.png^(default_coal_block.png^[opacity:128)","commoditymarket_default_chest_top.png^(default_coal_block.png^[opacity:128)",
		"commoditymarket_default_chest_side.png^(default_coal_block.png^[opacity:128)","commoditymarket_default_chest_side.png^(default_coal_block.png^[opacity:128)",
		"commoditymarket_empty_shelf.png^(default_coal_block.png^[opacity:128)","commoditymarket_default_chest_side.png^(default_coal_block.png^[opacity:128)^commoditymarket_goblin.png",},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {choppy = 2, oddly_breakable_by_hand = 1,},
	sounds = wood_sounds,
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		commoditymarket.show_market("goblin", clicker:get_player_name())	
	end,
	can_dig = function(pos, player)
		return not goblin_protect or minetest.check_player_privs(player, "protection_bypass")
	end,
	on_blast = on_blast,
})
end

--------------------------------------------------------------------------------
-- Undermarket

if minetest.settings:get_bool("commoditymarket_enable_under_market", true) then

local undermarket_def = {
	description = S("Undermarket"),
	long_description = undermarket_desc,
	currency = undermarket_currency,
	currency_symbol = undermarket_symbol,
	inventory_limit = 10000,
	--sell_limit =, -- no sell limit
}

commoditymarket.register_market("under", undermarket_def)

local under_protect = minetest.settings:get_bool("commoditymarket_protect_under_market", true)
local on_blast
if under_protect then
	on_blast = function() end
end

minetest.register_node("commoditymarket_fantasy:under_market", {
	description = undermarket_def.description,
	_doc_items_longdesc = undermarket_def.long_description,
	_doc_items_usagehelp = usage_help,
	tiles = {"commoditymarket_under_top.png","commoditymarket_under_top.png",
		"commoditymarket_under.png","commoditymarket_under.png","commoditymarket_under.png","commoditymarket_under.png"},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {choppy = 2, oddly_breakable_by_hand = 1,},
	sounds = stone_sounds,
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		commoditymarket.show_market("under", clicker:get_player_name())	
	end,
	can_dig = function(pos, player)
		return not under_protect or minetest.check_player_privs(player, "protection_bypass")
	end,
	on_blast = on_blast,
})
end
------------------------------------------------------------------
