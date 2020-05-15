local modpath = minetest.get_modpath(minetest.get_current_modname())

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

dofile(modpath.."/mapgen_dungeon_markets.lua")

local coins_per_ingot = math.floor(tonumber(minetest.settings:get("commoditymarket_coins_per_ingot")) or 1000)

-- Only register gold coins once, if required
local gold_coins_registered = false
local register_gold_coins = function()
	if not gold_coins_registered then
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

local default_items = {"default:axe_bronze","default:axe_diamond","default:axe_mese","default:axe_steel","default:axe_steel","default:axe_stone","default:axe_wood","default:pick_bronze","default:pick_diamond","default:pick_mese","default:pick_steel","default:pick_stone","default:pick_wood","default:shovel_bronze","default:shovel_diamond","default:shovel_mese","default:shovel_steel","default:shovel_stone","default:shovel_wood","default:sword_bronze","default:sword_diamond","default:sword_mese","default:sword_steel","default:sword_stone","default:sword_wood", "default:blueberries", "default:book", "default:bronze_ingot", "default:clay_brick", "default:clay_lump", "default:coal_lump", "default:copper_ingot", "default:copper_lump", "default:diamond", "default:flint", "default:gold_ingot", "default:gold_lump", "default:iron_lump", "default:mese_crystal", "default:mese_crystal_fragment", "default:obsidian_shard", "default:paper", "default:steel_ingot", "default:stick", "default:tin_ingot", "default:tin_lump", "default:acacia_tree", "default:acacia_wood", "default:apple", "default:aspen_tree", "default:aspen_wood", "default:blueberry_bush_sapling", "default:bookshelf", "default:brick", "default:bronzeblock", "default:bush_sapling", "default:cactus", "default:clay", "default:coalblock", "default:cobble", "default:copperblock", "default:desert_cobble", "default:desert_sand", "default:desert_sandstone", "default:desert_sandstone_block", "default:desert_sandstone_brick", "default:desert_stone", "default:desert_stone_block", "default:desert_stonebrick", "default:diamondblock", "default:dirt", "default:glass", "default:goldblock", "default:gravel", "default:ice", "default:junglegrass", "default:junglesapling", "default:jungletree", "default:junglewood", "default:ladder_steel", "default:ladder_wood", "default:large_cactus_seedling", "default:mese", "default:mese_post_light", "default:meselamp", "default:mossycobble", "default:obsidian", "default:obsidian_block", "default:obsidian_glass", "default:obsidianbrick", "default:papyrus", "default:pine_sapling", "default:pine_tree", "default:pine_wood", "default:sand", "default:sandstone", "default:sandstone_block", "default:sandstonebrick", "default:sapling", "default:silver_sand", "default:silver_sandstone", "default:silver_sandstone_block", "default:silver_sandstone_brick", "default:snow", "default:snowblock", "default:steelblock", "default:stone", "default:stone_block", "default:stonebrick", "default:tinblock", "default:tree", "default:wood",}

local usage_help = S("Right-click on this to open the market interface.")

------------------------------------------------------------------------------
-- King's Market

if minetest.settings:get_bool("commoditymarket_enable_kings_market", true) then

local kings_def = {
	description = S("King's Market"),
	long_description = S("The largest and most accessible market for the common man, the King's Market uses gold coins as its medium of exchange (or the equivalent in gold ingots - @1 coins to the ingot). However, as a respectable institution of the surface world, the King's Market operates only during the hours of daylight. The purchase and sale of swords and explosives is prohibited in the King's Market. Gold coins are represented by a '☼' symbol.", coins_per_ingot),
	currency = {
		["default:gold_ingot"] = coins_per_ingot,
		["commoditymarket_fantasy:gold_coins"] = 1
	},
	currency_symbol = "☼", -- "\u{263C}" Alchemical symbol for gold
	allow_item = function(item)
		if item:sub(1,13) == "default:sword" or item:sub(1,4) == "tnt:" then
			return false
		end
		return true
	end,
	inventory_limit = 100000,
	--sell_limit =, -- no sell limit for the King's Market
	initial_items = default_items,
}

register_gold_coins()

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
	tiles = {"default_chest_top.png","default_chest_top.png",
		"default_chest_side.png","default_chest_side.png",
		"commoditymarket_empty_shelf.png","default_chest_side.png^commoditymarket_crown.png",},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {choppy = 2, oddly_breakable_by_hand = 1,},
	sounds = default.node_sound_wood_defaults(),
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
	long_description = S("When the sun sets and the stalls of the King's Market close, other vendors are just waking up to share their wares. The Night Market is not as voluminous as the King's Market but accepts a wider range of wares. It accepts the same gold coinage of the realm, @1 coins to the gold ingot.", coins_per_ingot),
	currency = {
		["default:gold_ingot"] = coins_per_ingot,
		["commoditymarket_fantasy:gold_coins"] = 1
	},
	currency_symbol = "☼", --"\u{263C}"
	inventory_limit = 10000,
	--sell_limit =, -- no sell limit for the Night Market
	initial_items = default_items,
	anonymous = true,
}

register_gold_coins()

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
	tiles = {"default_chest_top.png","default_chest_top.png",
		"default_chest_side.png","default_chest_side.png",
		"commoditymarket_empty_shelf.png","default_chest_side.png^commoditymarket_moon.png",},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {choppy = 2, oddly_breakable_by_hand = 1,},
	sounds = default.node_sound_wood_defaults(),
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

-------------------------------------------------------------------------------
if minetest.settings:get_bool("commoditymarket_enable_caravan_market", true) then
-- "Trader's Caravan" - small-capacity market that players can summon

local time_until_caravan = 120 -- caravan arrives in two minutes
local dwell_time = 600 -- caravan leaves ten minutes after last usage

local caravan_def = {
	description = S("Trader's Caravan"),
	long_description = S("Unlike most markets that have well-known fixed locations that travelers congregate to, the network of Trader's Caravans is fluid and dynamic in their locations. A Trader's Caravan can show up anywhere, make modest trades, and then be gone the next time you visit them. These caravans accept gold and gold coins as a currency (one gold ingot to @1 gold coins exchange rate). Any reasonably-wealthy person can create a signpost marking a location where Trader's Caravans will make a stop.", coins_per_ingot),
	currency = {
		["default:gold_ingot"] = coins_per_ingot,
		["commoditymarket_fantasy:gold_coins"] = 1
	},
	currency_symbol = "☼", --"\u{263C}"
	inventory_limit = 1000,
	sell_limit = 1000,
	initial_items = default_items,
}

register_gold_coins()

minetest.register_craft({
	output = "commoditymarket_fantasy:caravan_post",
	recipe = {
		{'group:wood', 'group:wood', ''},
		{'group:wood', "default:gold_ingot", ''},
		{'group:wood', "default:chest_locked", ''},
	}
})

commoditymarket.register_market("caravan", caravan_def)

local create_caravan_def = function(override_table)
local def = {
		description = caravan_def.description,
		_doc_items_longdesc = caravan_def.long_description,
		_doc_items_usagehelp = usage_help,
		drawtype = "mesh",
		mesh = "commoditymarket_wagon.obj",
		tiles = {
			{ name = "commoditymarket_door_wood.png", backface_culling = true }, -- door
			{ name = "default_wood.png", backface_culling = true }, -- base wood
			{ name = "default_fence_rail_wood.png", backface_culling = true }, -- wheel sides
			{ name = "default_coal_block.png", backface_culling = true }, -- wheel tyre
			{ name = "commoditymarket_shingles_wood.png", backface_culling = true }, -- roof
			{ name = "default_junglewood.png", backface_culling = true }, -- corner wood
			},
		collision_box = {
			type = "fixed",
			fixed = {
				-- Note: this oversized nodebox may cause slight problems when you stand on it.
				-- https://github.com/minetest/minetest/issues/9322
				{-0.75, -0.5, -1.25, 0.75, 1.5, 1.25},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {
				{-0.75, -0.5, -1.25, 0.75, 1.5, 1.25},
			},
		},
	
		paramtype2 = "facedir",
		drop = "",
		groups = {choppy = 2, oddly_breakable_by_hand = 1, not_in_creative_inventory = 1},
		sounds = default.node_sound_wood_defaults(),
		on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
			commoditymarket.show_market("caravan", clicker:get_player_name())
			local timer = minetest.get_node_timer(pos)
			timer:start(dwell_time)
		end,
		after_destruct = function(pos, oldnode)
			local facedir = oldnode.param2
			local dir = minetest.facedir_to_dir(facedir)
			local target = vector.add(pos, vector.multiply(dir,-3))
			local target_node = minetest.get_node(target)
			if target_node.name == "commoditymarket_fantasy:caravan_post" then
				local meta = minetest.get_meta(target)
				meta:set_string("infotext", S("Right-click to summon a trader's caravan"))
			end
		end,
		on_timer = function(pos, elapsed)
			minetest.set_node(pos, {name="air"})
			minetest.sound_play("commoditymarket_register_closed", {
				pos = pos,
				gain = 1.0,  -- default
				max_hear_distance = 32,  -- default, uses an euclidean metric
			})
		end,
	}
	if override_table then
		for k, v in pairs(override_table) do
			def[k] = v
		end
	end
	return def
end

-- Create five caravans with different textures, randomly pick which one shows up.
minetest.register_node("commoditymarket_fantasy:caravan_market_1", create_caravan_def())
minetest.register_node("commoditymarket_fantasy:caravan_market_2", create_caravan_def({
tiles = {
	{ name = "commoditymarket_door_wood.png^[multiply:#CCCCFF", backface_culling = true }, -- door
	{ name = "default_acacia_wood.png", backface_culling = true }, -- base wood
	{ name = "default_fence_rail_wood.png", backface_culling = true }, -- wheel sides
	{ name = "default_copper_block.png", backface_culling = true }, -- wheel tyre
	{ name = "commoditymarket_shingles_wood.png^[multiply:#CC8888", backface_culling = true }, -- roof
	{ name = "default_wood.png", backface_culling = true }, -- corner wood
}
}))
minetest.register_node("commoditymarket_fantasy:caravan_market_3", create_caravan_def({
tiles = {
	{ name = "commoditymarket_door_wood.png", backface_culling = true }, -- door
	{ name = "default_aspen_wood.png", backface_culling = true }, -- base wood
	{ name = "default_fence_aspen_wood.png", backface_culling = true }, -- wheel sides
	{ name = "default_cobble.png", backface_culling = true }, -- wheel tyre
	{ name = "default_stone_brick.png", backface_culling = true }, -- roof
	{ name = "default_pine_tree.png", backface_culling = true }, -- corner wood
}
}))
minetest.register_node("commoditymarket_fantasy:caravan_market_4", create_caravan_def({
tiles = {
	{ name = "commoditymarket_door_wood.png", backface_culling = true }, -- door
	{ name = "default_junglewood.png", backface_culling = true }, -- base wood
	{ name = "default_fence_rail_junglewood.png", backface_culling = true }, -- wheel sides
	{ name = "default_obsidian.png", backface_culling = true }, -- wheel tyre
	{ name = "commoditymarket_shingles_wood.png^[multiply:#88FF88", backface_culling = true }, -- roof
	{ name = "default_tree.png", backface_culling = true }, -- corner wood
}
}))
minetest.register_node("commoditymarket_fantasy:caravan_market_5", create_caravan_def({
tiles = {
	{ name = "commoditymarket_door_wood.png", backface_culling = true }, -- door
	{ name = "default_pine_wood.png", backface_culling = true }, -- base wood
	{ name = "default_chest_lock.png", backface_culling = true }, -- wheel sides
	{ name = "default_chest_top.png", backface_culling = true }, -- wheel tyre
	{ name = "default_furnace_top.png", backface_culling = true }, -- roof
	{ name = "default_wood.png", backface_culling = true }, -- corner wood
}
}))

local caravan_protect = minetest.settings:get_bool("commoditymarket_protect_caravan_market", true)
local on_blast
if caravan_protect then
	on_blast = function() end
end

-- This one doesn't delete itself, server admins can place a permanent instance of it that way. Maybe inside towns next to bigger stationary markets.
minetest.register_node("commoditymarket_fantasy:caravan_market_permanent", {
	description = caravan_def.description,
	_doc_items_longdesc = caravan_def.long_description,
	_doc_items_usagehelp = usage_help,
	drawtype = "mesh",
	mesh = "commoditymarket_wagon.obj",
	tiles = {
		{ name = "commoditymarket_door_wood.png", backface_culling = true }, -- door
		{ name = "default_wood.png", backface_culling = true }, -- base wood
		{ name = "default_fence_rail_wood.png", backface_culling = true }, -- wheel sides
		{ name = "default_coal_block.png", backface_culling = true }, -- wheel tyre
		{ name = "commoditymarket_shingles_wood.png", backface_culling = true }, -- roof
		{ name = "default_junglewood.png", backface_culling = true }, -- corner wood
		},
    collision_box = {
		type = "fixed",
        fixed = {
            {-0.75, -0.5, -1.25, 0.75, 1.5, 1.25},
        },
    },
	selection_box = {
		type = "fixed",
        fixed = {
            {-0.75, -0.5, -1.25, 0.75, 1.5, 1.25},
        },
    },

	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {choppy = 2, oddly_breakable_by_hand = 1,},
	sounds = default.node_sound_wood_defaults(),
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		commoditymarket.show_market("caravan", clicker:get_player_name())
	end,
	can_dig = function(pos, player)
		return not caravan_protect or minetest.check_player_privs(player, "protection_bypass")
	end,
	on_blast = on_blast,
})

-- is a 5x3 area centered around pos clear of obstruction and has usable ground?
local is_suitable_caravan_space = function(pos, facedir)
	local x_dim = 2
	local z_dim = 2
	local dir = minetest.facedir_to_dir(facedir)
	if dir.x ~= 0 then
		z_dim = 1
	elseif dir.z ~= 0 then
		x_dim = 1
	end	
	
	-- walkable ground?
	for x = pos.x - x_dim, pos.x + x_dim, 1 do
		for z = pos.z - z_dim, pos.z + z_dim, 1 do
			local node = minetest.get_node({x=x, y=pos.y-1, z=z})
			local node_def = minetest.registered_nodes[node.name]
			if node_def == nil or node_def.walkable ~= true then return false end
		end
	end
	-- buildable_to in the rest?
	for y = pos.y, pos.y+2, 1 do
		for x = pos.x - x_dim, pos.x + x_dim, 1 do
			for z = pos.z - z_dim, pos.z + z_dim, 1 do
				local node = minetest.get_node({x=x, y=y, z=z})
				local node_def = minetest.registered_nodes[node.name]
				if node_def == nil or node_def.buildable_to ~= true then return false end
			end
		end
	end
	return true
end

minetest.register_node("commoditymarket_fantasy:caravan_post", {
	description = S("Trading Post"),
	_long_items_longdesc = S("This post signals passing caravan traders that customers can be found here, and signals to customers that caravan traders can be found here. If no caravan is present, right-click to summon one."),
	_doc_items_usagehelp = S("The trader's caravan requires a suitable open space next to the trading post for it to arrive, and takes some time to arrive after being summoned. The post gives a countdown to the caravan's arrival when moused over."),
	tiles = {"commoditymarket_sign.png^[transformR90", "commoditymarket_sign.png^[transformR270",
		"commoditymarket_sign.png^commoditymarket_caravan_sign.png", "commoditymarket_sign.png^commoditymarket_caravan_sign.png^[transformFX",
		"commoditymarket_sign_post.png", "commoditymarket_sign_post.png"},
	groups = {choppy = 2, oddly_breakable_by_hand = 1,},
	sounds = default.node_sound_wood_defaults(),
	inventory_image = "commoditymarket_caravan_sign_inventory.png",
	paramtype= "light",
	paramtype2 = "facedir",
	drawtype = "nodebox",
	node_box = {
        type = "fixed",
        fixed = {
			{-0.125,-0.5,-0.5,0.125,2.0625,-0.25},
			{-0.0625,1.4375,-0.25,0.0625,2.0,0.5},
		},
    },
	on_construct = function(pos)
		local timer = minetest.get_node_timer(pos)
		timer:start(1.0)
	end,
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		local timer = minetest.get_node_timer(pos)
		timer:start(1.0)
	end,
	on_timer = function(pos, elapsed)
		local node = minetest.get_node(pos)
		local meta = minetest.get_meta(pos)
		if node.name ~=  "commoditymarket_fantasy:caravan_post" then
			return -- the node was removed
		end
		local facedir = node.param2
		local dir = minetest.facedir_to_dir(facedir)
		local target = vector.add(pos, vector.multiply(dir,3))

		local target_node = minetest.get_node(target)
		
		if target_node.name:sub(1,string.len("commoditymarket_fantasy:caravan_market")) == "commoditymarket_fantasy:caravan_market" then
			-- It's already here somehow, shut down timer.
			meta:set_string("infotext", "")
			meta:set_float("wait_time", 0)
			return
		end
		
		local is_suitable_space = is_suitable_caravan_space(target, facedir)
			
		if not is_suitable_space then
			meta:set_string("infotext", S("Indicated parking area isn't suitable.\nA 5x3 open space with solid ground\nis required for a caravan."))
			meta:set_float("wait_time", 0)
			local timer = minetest.get_node_timer(pos)
			timer:start(1.0)
			return
		end
		
		local wait_time = (meta:get_float("wait_time") or 0) + elapsed
		meta:set_float("wait_time", wait_time)
		if wait_time < time_until_caravan then
			meta:set_string("infotext", S("Caravan summoned\nETA: @1 seconds.", math.floor(time_until_caravan - wait_time)))
			local timer = minetest.get_node_timer(pos)
			timer:start(1.0)
			return
		end
		
		-- spawn the caravan. We've already established that the target pos is clear.
		minetest.set_node(target, {name="commoditymarket_fantasy:caravan_market_"..math.random(1,5), param2=facedir})
		minetest.sound_play("commoditymarket_register_opened", {
			pos = target,
			gain = 1.0,  -- default
			max_hear_distance = 32,  -- default, uses an euclidean metric
		})
		local timer = minetest.get_node_timer(target)
		timer:start(dwell_time)
		meta:set_string("infotext", "")
		meta:set_float("wait_time", 0)
	end,
})
end

-------------------------------------------------------------------------------
-- "Goblin Exchange"
if minetest.settings:get_bool("commoditymarket_enable_goblin_market", true) then

local goblin_def = {
	description = S("Goblin Exchange"),
	long_description = S("One does not usually associate Goblins with the sort of sophistication that running a market requires. Usually one just associates Goblins with savagery and violence. But they understand the principle of tit-for-tat exchange, and if approached correctly they actually respect the concepts of ownership and debt. However, for some peculiar reason they understand this concept in the context of coal lumps. Goblins deal in the standard coal lump as their form of currency, conceptually divided into 100 coal centilumps (though Goblin brokers prefer to \"keep the change\" when giving back actual coal lumps)."),
	currency = {
		["default:coal_lump"] = 100
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
	tiles = {"default_chest_top.png^(default_coal_block.png^[opacity:128)","default_chest_top.png^(default_coal_block.png^[opacity:128)",
		"default_chest_side.png^(default_coal_block.png^[opacity:128)","default_chest_side.png^(default_coal_block.png^[opacity:128)",
		"commoditymarket_empty_shelf.png^(default_coal_block.png^[opacity:128)","default_chest_side.png^(default_coal_block.png^[opacity:128)^commoditymarket_goblin.png",},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {choppy = 2, oddly_breakable_by_hand = 1,},
	sounds = default.node_sound_wood_defaults(),
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

if minetest.settings:get_bool("commoditymarket_enable_under_market", true) then
local undermarket_def = {
	description = S("Undermarket"),
	long_description = S("Deep in the bowels of the world, below even the goblin-infested warrens and ancient delvings of the dwarves, dark and mysterious beings once dwelt. A few still linger to this day, and facilitate barter for those brave souls willing to travel in their lost realms. The Undermarket uses Mese chips ('₥') as a currency - twenty chips to the Mese fragment. Though traders are loathe to physically break Mese crystals up into units that small, as it renders it useless for other purposes."),
	currency = {
		["default:mese"] = 9*9*20,
		["default:mese_crystal"] = 9*20,
		["default:mese_crystal_fragment"] = 20
	},
	currency_symbol = "₥", --"\u{20A5}" mill sign
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
	sounds = default.node_sound_stone_defaults(),
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
