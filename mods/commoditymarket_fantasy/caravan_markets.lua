if not minetest.settings:get_bool("commoditymarket_enable_caravan_market", true) then
	return
end

local S = commoditymarket_fantasy.S
local coins_per_ingot = commoditymarket_fantasy.coins_per_ingot
local default_items = commoditymarket_fantasy.default_items
local gold_ingot = commoditymarket_fantasy.gold_ingot
local gold_currency = commoditymarket_fantasy.gold_currency
local chest_locked = commoditymarket_fantasy.chest_locked
local wood_sounds = commoditymarket_fantasy.wood_sounds
local usage_help = commoditymarket_fantasy.usage_help

commoditymarket_fantasy.register_gold_coins()

local time_until_caravan = 120 -- caravan arrives in two minutes
local dwell_time = 600 -- caravan leaves ten minutes after last usage

local caravan_def = {
	description = S("Trader's Caravan"),
	long_description = S("Unlike most markets that have well-known fixed locations that travelers congregate to, the network of Trader's Caravans is fluid and dynamic in their locations. A Trader's Caravan can show up anywhere, make modest trades, and then be gone the next time you visit them. These caravans accept gold and gold coins as a currency (one gold ingot to @1 gold coins exchange rate). Any reasonably-wealthy person can create a signpost marking a location where Trader's Caravans will make a stop.", coins_per_ingot),
	currency = gold_currency,
	currency_symbol = "☼", --"\u{263C}"
	inventory_limit = 1000,
	sell_limit = 1000,
	initial_items = default_items,
}

minetest.register_craft({
	output = "commoditymarket_fantasy:caravan_post",
	recipe = {
		{'group:wood', 'group:wood', ''},
		{'group:wood', gold_ingot, ''},
		{'group:wood', chest_locked, ''},
	}
})

commoditymarket.register_market("caravan", caravan_def)

local caravan_nodebox = {
	type = "fixed",
	fixed = {
		-- Note: this nodebox should have a height of 1.5, but using 95/64 as a workaround for
		-- https://github.com/minetest/minetest/issues/9322
		{-0.75, -0.5, -1.25, 0.75, 95/64, 1.25},
	},
}


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
			{ name = "commoditymarket_default_fence_rail_wood.png", backface_culling = true }, -- wheel sides
			{ name = "default_coal_block.png", backface_culling = true }, -- wheel tyre
			{ name = "commoditymarket_shingles_wood.png", backface_culling = true }, -- roof
			{ name = "default_junglewood.png", backface_culling = true }, -- corner wood
			},
		collision_box = caravan_nodebox,
		selection_box = caravan_nodebox,
	
		paramtype2 = "facedir",
		drop = "",
		groups = {choppy = 2, oddly_breakable_by_hand = 1, not_in_creative_inventory = 1},
		sounds = wood_sounds,
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
	{ name = "commoditymarket_default_fence_rail_wood.png", backface_culling = true }, -- wheel sides
	{ name = "commoditymarket_default_copper_block.png", backface_culling = true }, -- wheel tyre
	{ name = "commoditymarket_shingles_wood.png^[multiply:#CC8888", backface_culling = true }, -- roof
	{ name = "default_wood.png", backface_culling = true }, -- corner wood
}
}))
minetest.register_node("commoditymarket_fantasy:caravan_market_3", create_caravan_def({
tiles = {
	{ name = "commoditymarket_door_wood.png", backface_culling = true }, -- door
	{ name = "commoditymarket_default_aspen_wood.png", backface_culling = true }, -- base wood
	{ name = "commoditymarket_default_fence_aspen_wood.png", backface_culling = true }, -- wheel sides
	{ name = "default_cobble.png", backface_culling = true }, -- wheel tyre
	{ name = "default_stone_brick.png", backface_culling = true }, -- roof
	{ name = "commoditymarket_default_pine_tree.png", backface_culling = true }, -- corner wood
}
}))
minetest.register_node("commoditymarket_fantasy:caravan_market_4", create_caravan_def({
tiles = {
	{ name = "commoditymarket_door_wood.png", backface_culling = true }, -- door
	{ name = "default_junglewood.png", backface_culling = true }, -- base wood
	{ name = "commoditymarket_default_fence_rail_junglewood.png", backface_culling = true }, -- wheel sides
	{ name = "default_obsidian.png", backface_culling = true }, -- wheel tyre
	{ name = "commoditymarket_shingles_wood.png^[multiply:#88FF88", backface_culling = true }, -- roof
	{ name = "default_tree.png", backface_culling = true }, -- corner wood
}
}))
minetest.register_node("commoditymarket_fantasy:caravan_market_5", create_caravan_def({
tiles = {
	{ name = "commoditymarket_door_wood.png", backface_culling = true }, -- door
	{ name = "commoditymarket_default_pine_wood.png", backface_culling = true }, -- base wood
	{ name = "commoditymarket_default_chest_lock.png", backface_culling = true }, -- wheel sides
	{ name = "commoditymarket_default_chest_top.png", backface_culling = true }, -- wheel tyre
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
		{ name = "commoditymarket_default_fence_rail_wood.png", backface_culling = true }, -- wheel sides
		{ name = "default_coal_block.png", backface_culling = true }, -- wheel tyre
		{ name = "commoditymarket_shingles_wood.png", backface_culling = true }, -- roof
		{ name = "default_junglewood.png", backface_culling = true }, -- corner wood
		},
    collision_box = caravan_nodebox,
	selection_box = caravan_nodebox,

	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {choppy = 2, oddly_breakable_by_hand = 1,},
	sounds = wood_sounds,
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
	sounds = wood_sounds,
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