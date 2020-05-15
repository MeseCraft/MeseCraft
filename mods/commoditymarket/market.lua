local S = minetest.get_translator(minetest.get_current_modname())

commoditymarket.registered_markets = {}
local log_length_limit = 30

-- from http://lua-users.org/wiki/BinaryInsert
--[[
   table.bininsert( table, value [, comp] )
   
   Inserts a given value through BinaryInsert into the table sorted by [, comp].
   
   If 'comp' is given, then it must be a function that receives
   two table elements, and returns true when the first is less
   than the second, e.g. comp = function(a, b) return a > b end,
   will give a sorted table, with the biggest value on position 1.
   [, comp] behaves as in table.sort(table, value [, comp])
   returns the index where 'value' was inserted
]]--
local comp_default = function(a, b) return a < b end
function table.bininsert(t, value, comp)
	-- Initialise compare function
	local comp = comp or comp_default
	--  Initialise numbers
	local iStart, iEnd, iMid, iState = 1, #t, 1, 0
	-- Get insert position
	while iStart <= iEnd do
		-- calculate middle
		iMid = math.floor( (iStart+iEnd)/2 )
		-- compare
		if comp(value, t[iMid]) then
			iEnd, iState = iMid - 1, 0
		else
			iStart, iState = iMid + 1, 1
		end
	end
	local target = iMid+iState
	table.insert(t, target, value)
	return target
end

-- lowest price first
local buy_comp = function(order1, order2)
	local price1 = order1.price
	local price2 = order2.price
	if price1 < price2 then
		return true
	elseif price1 == price2 and order1.timestamp < order2.timestamp then
		return true
	end
	return false
end
-- highest price first
local sell_comp = function(order1, order2)
	local price1 = order1.price
	local price2 = order2.price
	if price1 > price2 then
		return true
	elseif price1 == price2 and order1.timestamp < order2.timestamp then
		return true
	end
	return false
end

---------------------------------

local get_account = function(market, player_name)
	local account = market.player_accounts[player_name]
	if account then
		return account
	end
	account = {}
	account.search = ""
	account.name = player_name
	account.balance = 0 -- currency
	account.inventory = {} -- items stored in the market inventory that aren't part of sell orders yet. stored as "[item] = count"
	account.filter_participating = "false"
	account.log = {} -- might want to use a more sophisticated queue, but this isn't going to be a big list so that's more trouble than it's worth right now.
	market.player_accounts[player_name] = account
	return account	
end

-- Caution: the data structures produced by sale logging caused me to discover
-- issue https://github.com/minetest/minetest/issues/8719 with minetest.serialize()
-- I'm working around it by using the code in persistence.lua instead
local log_sale = function(item, quantity, price, purchaser, seller)
	local log_entry = {item=item, quantity=quantity, price=price, purchaser=purchaser, seller=seller, timestamp = minetest.get_gametime()}
	local purchaser_log = purchaser.log
	local seller_log = seller.log
	table.insert(purchaser_log, log_entry)
	if #purchaser_log > log_length_limit then
		table.remove(purchaser_log, 1)
	end
	if (purchaser ~= seller) then
		table.insert(seller_log, log_entry)
		if #seller_log > log_length_limit then
			table.remove(seller_log, 1)
		end
	end
end

local remove_orders_by_account = function(orders, account)
	if not orders then return end
	local i = 1
	while i < #orders do
		local order = orders[i]
		if order.account == account then
			table.remove(orders, i)
		else
			i = i + 1
		end
	end
end

local remove_account = function(player_name)
	local account = player_accounts[player_name]
	if account == nil then
		return
	end
		
	player_accounts[player_name] = nil
	for item, lists in pairs(market) do
		remove_orders_by_account(lists.buy_orders, account)
		remove_orders_by_account(lists.sell_orders, account)
	end
end

------------------------------------------------------------------------------------------

local add_inventory_to_account = function(market, account, item, quantity)
	if quantity < 1 then
		return false
	end
	
	if market.def.currency[item] then
		account.balance = account.balance + market.def.currency[item] * quantity
	else
		account.inventory[item] = (account.inventory[item] or 0) + quantity
	end
	return true
end

local remove_inventory_from_account = function(account, item, quantity)
	if quantity < 1 then
		return false
	end
	
	local inventory = account.inventory
	local current_quantity = inventory[item] or 0
	if current_quantity < quantity then
		return false
	end
	
	local new_quantity = current_quantity - quantity
	if new_quantity == 0 then
		inventory[item] = nil
	else
		inventory[item] = new_quantity
	end
	return true
end

local remove_order = function(order, array)
	for i, market_order in ipairs(array) do
		if order == market_order then
			table.remove(array, i)
			return true
		end
	end
	return false
end

-----------------------------------------------------------------------------------------------------------

local add_sell = function(market, account, item, price, quantity)
	price = tonumber(price)
	quantity = tonumber(quantity)
	
	local sell_limit = market.def.sell_limit
	local sell_limit_exceeded
	if sell_limit then
		local total_sell = 0
		for item, orders in pairs(market.orders_for_items) do
			for _, order in ipairs(orders.sell_orders) do
				if order.account == account then
					total_sell = total_sell + order.quantity
				end
			end
		end
		sell_limit_exceeded = total_sell + quantity > sell_limit
	end
	
	-- validate that this sell order is possible
	if sell_limit_exceeded or price < 0 or quantity < 1 or not remove_inventory_from_account(account, item, quantity) then
		minetest.sound_play({name = "commoditymarket_error", gain = 0.1}, {to_player=account.name})
		if sell_limit_exceeded then
			minetest.chat_send_player(account.name, S("You have too many items listed for sale in this market, please cancel some sell orders to make room for new ones."))
		elseif price < 0 then
			minetest.chat_send_player(account.name, S("You can't sell items for a negative price."))
		elseif quantity < 1 then
			minetest.chat_send_player(account.name, S("You can't sell fewer than one item."))			
		else
			minetest.chat_send_player(account.name, S("You don't have enough of that item in your inventory to post this sell order."))
		end
		return false
	end

	local buy_market = market.orders_for_items[item].buy_orders
	local buy_order = buy_market[#buy_market]
	local current_buy_volume = market.orders_for_items[item].buy_volume
	
	-- go through existing buy orders that are more expensive than or equal to the price
	-- we're demanding, selling them at the order's price until we run out of
	-- buy orders or run out of demand
	while quantity > 0 and buy_order and buy_order.price >= price do
		local quantity_to_sell = math.min(buy_order.quantity, quantity)
		quantity = quantity - quantity_to_sell
		local earned = quantity_to_sell*buy_order.price
		account.balance = account.balance + earned
		add_inventory_to_account(market, buy_order.account, item, quantity_to_sell)
		buy_order.quantity = buy_order.quantity - quantity_to_sell
		current_buy_volume = current_buy_volume - quantity_to_sell
		
		if buy_order.account ~= account then
			-- don't update the last price if a player is just buying and selling from themselves
			market.orders_for_items[item].last_price = buy_order.price
		end
		
		log_sale(item, quantity_to_sell, buy_order.price, buy_order.account, account)
		
		if buy_order.quantity == 0 then
			table.remove(buy_market, #buy_market)
		end
		buy_order = buy_market[#buy_market]
	end
	market.orders_for_items[item].buy_volume = current_buy_volume
	
	if quantity > 0 then
		local sell_market = market.orders_for_items[item].sell_orders
	
		-- create the order and insert it into order arrays
		local order = {account=account, price=price, quantity=quantity, timestamp=minetest.get_gametime()}
		table.bininsert(sell_market, order, sell_comp)
		market.orders_for_items[item].sell_volume = market.orders_for_items[item].sell_volume + quantity
	end

	minetest.sound_play({name = "commoditymarket_register_opened", gain = 0.1}, {to_player=account.name})
	return true
end

local cancel_sell = function(market, item, order)
	local account = order.account
	local quantity = order.quantity
	
	local sell_market = market.orders_for_items[item].sell_orders
	
	remove_order(order, sell_market)
	market.orders_for_items[item].sell_volume = market.orders_for_items[item].sell_volume - quantity
	add_inventory_to_account(market, account, item, quantity)
	
	minetest.sound_play({name = "commoditymarket_register_closed", gain = 0.1}, {to_player=account.name})
end

-----------------------------------------------------------------------------------------------------------

local test_buy = function(market, balance, item, price, quantity)
	local sell_market = market.orders_for_items[item].sell_orders
	local test_quantity = quantity
	local test_balance = balance
	local i = 0
	local sell_order = sell_market[#sell_market]
	while test_quantity > 0 and sell_order and sell_order.price <= price do
		local quantity_to_buy = math.min(sell_order.quantity, test_quantity)
		test_quantity = test_quantity - quantity_to_buy
		test_balance = test_balance - quantity_to_buy*sell_order.price
		i = i + 1
		sell_order = sell_market[#sell_market-i]
	end
	local spent = balance - test_balance
	test_balance = test_balance - test_quantity*price
	if test_balance < 0 then
		return false, spent, test_quantity
	end
	
	return true, spent, test_quantity
end

local add_buy = function(market, account, item, price, quantity)
	price = tonumber(price)
	quantity = tonumber(quantity)
	if price < 0 or quantity < 1 or not test_buy(market, account.balance, item, price, quantity) then
		minetest.sound_play({name = "commoditymarket_error", gain = 0.1}, {to_player=account.name})
		if price < 0 then
			minetest.chat_send_player(account.name, S("You can't pay less than nothing for an item."))
		elseif quantity < 1 then
			minetest.chat_send_player(account.name, S("You have to buy at least one item."))
		else
			minetest.chat_send_player(account.name, S("You can't afford that many of this item."))
		end
		return false
	end

	local sell_market = market.orders_for_items[item].sell_orders
	local sell_order = sell_market[#sell_market]
	local current_sell_volume = market.orders_for_items[item].sell_volume
	
	-- go through existing sell orders that are cheaper than or equal to the price
	-- we're wanting to offer, buying them up at the offered price until we run out of
	-- sell orders or run out of supply
	while quantity > 0 and sell_order and sell_order.price <= price do
		local quantity_to_buy = math.min(sell_order.quantity, quantity)
		quantity = quantity - quantity_to_buy
		local spent = quantity_to_buy*sell_order.price
		account.balance = account.balance - spent
		sell_order.account.balance = sell_order.account.balance + spent
		sell_order.quantity = sell_order.quantity - quantity_to_buy
		current_sell_volume = current_sell_volume - quantity_to_buy
		add_inventory_to_account(market, account, item, quantity_to_buy)

		if sell_order.account ~= account then
			-- don't update the last price if a player is just buying and selling from themselves
			market.orders_for_items[item].last_price = sell_order.price
		end
		
		log_sale(item, quantity_to_buy, sell_order.price, account, sell_order.account)
		
		-- Sell order completely used up, remove it
		if sell_order.quantity == 0 then
			table.remove(sell_market, #sell_market)
		end
		
		-- get the next sell order
		sell_order = sell_market[#sell_market]
	end
	market.orders_for_items[item].sell_volume = current_sell_volume

	if quantity > 0 then
		local buy_market = market.orders_for_items[item].buy_orders
		-- create the order for the remainder and insert it into order arrays
		local order = {account=account, price=price, quantity=quantity, timestamp=minetest.get_gametime()}
		account.balance = account.balance - quantity*price -- buy orders are pre-paid
		table.bininsert(buy_market, order, buy_comp)
		market.orders_for_items[item].buy_volume = market.orders_for_items[item].buy_volume + quantity
	end
	
	minetest.sound_play({name = "commoditymarket_register_opened", gain = 0.1}, {to_player=account.name})
	return true
end

local cancel_buy = function(market, item, order)
	local account = order.account
	local quantity = order.quantity
	local price = order.price
	
	local buy_market = market.orders_for_items[item].buy_orders
	market.orders_for_items[item].buy_volume = market.orders_for_items[item].buy_volume - quantity
	
	remove_order(order, buy_market)
	
	account.balance = account.balance + price*quantity
	
	minetest.sound_play({name = "commoditymarket_register_closed", gain = 0.1}, {to_player=account.name})
end

local initialize_market_item = function(orders_for_items, item)
	if orders_for_items[item] == nil then
		local lists = {}
		lists.buy_orders = {}
		lists.sell_orders = {}
		lists.buy_volume = 0
		lists.sell_volume = 0
		lists.item = item
		-- leave last_price nil to indicate it's never been sold before
		orders_for_items[item] = lists
	end
end

-----------------------------------------------------------------------------------------------------------
-- Chat commands

minetest.register_chatcommand("market.show", {
	params = "marketname",
	privs = {server=true},
	description = S("show market interface"),
	func = function(name, param)
		local market = commoditymarket.registered_markets[param]
		if market == nil then return end
		local formspec = market:get_formspec(market:get_account(name))
		minetest.show_formspec(name, "commoditymarket:"..param..":"..name, formspec)
	end,
})

minetest.register_chatcommand("market.list", {
	params = "",
	privs = {server=true},
	description = S("list all registered markets"),
	func = function(name, param)
		local list = {}
		for marketname, def in pairs(commoditymarket.registered_markets) do
			table.insert(list, marketname)
		end
		table.sort(list)
		minetest.chat_send_player(name, "Registered markets: " .. table.concat(list, ", "))
	end,
})

local remove_market_item = function(market, item)
	local marketitem = market.orders_for_items[item]
	if marketitem then
		local buy_orders = marketitem.buy_orders
		while #buy_orders > 0 do
			market:cancel_buy(item, buy_orders[#buy_orders])
		end
		local sell_orders = marketitem.sell_orders
		while #sell_orders > 0 do
			market:cancel_sell(item, sell_orders[#sell_orders])
		end
		market.orders_for_items[item] = nil
	end
end

minetest.register_chatcommand("market.removeitem", {
	params = "marketname item",
	privs = {server=true},
	description = S("remove item from market. All existing buys and sells will be canceled."),
	func = function(name, param)
		local params = param:split(" ")
		if #params ~= 2 then
			minetest.chat_send_player(name, "Incorrect parameter count")
			return
		end
		local market = commoditymarket.registered_markets[params[1]]
		if market == nil then
			minetest.chat_send_player(name, "No such market: " .. params[1])
			return
		end
		remove_market_item(market, params[2])
	end,
})

minetest.register_chatcommand("market.purge_unknowns", {
	params = "",
	privs = {server=true},
	description = S("removes all unknown items from all markets. All existing buys and sells for those items will be canceled."),
	func = function(name, param)
		for market_name, market in pairs(commoditymarket.registered_markets) do
			local items_to_remove = {}
			local items_to_move = {}
			for item, orders in pairs(market.orders_for_items) do
				local icon = commoditymarket.get_icon(item)
				if icon == "unknown_item.png" then
					table.insert(items_to_remove, item)
				end
			end
			for _, item in ipairs(items_to_remove) do
				minetest.chat_send_player(name, S("Purging item: @1 from market: @2", tostring(item), market_name))
				minetest.log("warning", "[commoditymarket] Purging unknown item: " .. tostring(item) .. " from market: " .. market_name)
				remove_market_item(market, item)
			end
		end
	end,
})

-- Used during development and debugging to find items that break the market formspecs when added
local debugging_commands = false
if debugging_commands then
	minetest.register_chatcommand("market.addeverything", {
		params = "marketname",
		privs = {server=true},
		description = S("Add all registered items to the provided market"),
		func = function(name, param)
			local params = param:split(" ")
			if #params ~= 1 then
				minetest.chat_send_player(name, "Incorrect parameter count")
				return
			end
			local market = commoditymarket.registered_markets[params[1]]
			if market == nil then
				minetest.chat_send_player(name, "No such market: " .. params[1])
				return
			end
			for item_name, def in pairs(minetest.registered_items) do
				initialize_market_item(market.orders_for_items, item_name)
			end			
		end,
	})
end

-----------------------------------------------------------------------------------------------------------

-- API exposed to the outside world
local add_inventory = function(self, player_name, item, quantity)
	return add_inventory_to_account(self, get_account(self, player_name), item, quantity)
end
local remove_inventory = function(self, player_name, item, quantity)
	return remove_inventory_from_account(get_account(self, player_name), item, quantity)
end
local sell = function(self, player_name, item, quantity, price)
	return add_sell(self, get_account(self, player_name), item, price, quantity)
end
local buy = function(self, player_name, item, quantity, price)
	return add_buy(self, get_account(self, player_name), item, price, quantity)
end

-- Using this instead of minetest.serialize because of https://github.com/minetest/minetest/issues/8719
local MP = minetest.get_modpath(minetest.get_current_modname())
local persistence_store, persistence_load = dofile(MP.."/persistence.lua")

local worldpath = minetest.get_worldpath()
local load_market_data = function(marketname)
	local filename = worldpath .. "/market_"..marketname..".lua"
	return persistence_load(filename)
end

local save_market_data = function(market)
	local filename = worldpath .. "/market_"..market.name..".lua"
	local data = {}
	data.player_accounts = market.player_accounts
	data.orders_for_items = market.orders_for_items
	persistence_store(filename, data)
	return true
end

local make_doc_entry = function() return end
if minetest.get_modpath("doc") then
	make_doc_entry = function(market_name, market_def)
		local currencies = {}
		for _, currency_item in ipairs(market_def.currency_ordered) do
			local item_def = minetest.registered_items[currency_item.item]
			table.insert(currencies, S("1 @1 = @2@3", item_def.description, market_def.currency_symbol, currency_item.amount))
		end
		local inventory_limit
		if market_def.inventory_limit then
			inventory_limit = S("Market inventory is limited to @1 items.", market_def.inventory_limit)
		else
			inventory_limit = S("Market has unlimited inventory space.")
		end
		
		local sell_limit	
		if market_def.sell_limit then
			sell_limit = S("Total pending sell orders are limited to @1 items.", market_def.inventory_limit)
		else
			sell_limit = S("Market supports unlimited pending sell orders.")
		end
		
		doc.add_entry("commoditymarket", "market_"..market_name, {
			name = market_def.description,
			data = { text = market_def.long_description
				.."\n\n"
				..S("Currency item values:") .. "\n    " .. table.concat(currencies, "\n    ")
				.."\n\n"
				..inventory_limit
				.."\n"
				..sell_limit
			}
		})
	end
end

commoditymarket.register_market = function(market_name, market_def)
	assert(not commoditymarket.registered_markets[market_name])
	assert(market_def.currency)
	
	market_def.currency_symbol = market_def.currency_symbol or "¤" -- \u{00A4} -- defaults to the generic currency symbol ("scarab")
	market_def.description = market_def.description or S("Market")
	market_def.long_description = market_def.long_description or S("A market where orders to buy or sell items can be placed and fulfilled.")
	
	-- Reprocess currency table into a form easier for the withdraw code to work with
	market_def.currency_ordered = {}
	for item, amount in pairs(market_def.currency) do
		table.insert(market_def.currency_ordered, {item=item, amount=amount})
	end
	table.sort(market_def.currency_ordered, function(currency1, currency2) return currency1.amount > currency2.amount end)
	
	make_doc_entry(market_name, market_def) -- market_def has now been normalized, make documentation for it if doc is installed.
	
	-- Just in case a developer supplied strings that don't work well in formspecs, escape them now so we don't have to do it
	-- wherever they're used.
	market_def.currency_symbol = minetest.formspec_escape(market_def.currency_symbol)
	market_def.description = minetest.formspec_escape(market_def.description)
	market_def.long_description = minetest.formspec_escape(market_def.long_description)

	local new_market = {}
	new_market.def = market_def
	commoditymarket.registered_markets[market_name] = new_market
	
	local loaded_data = load_market_data(market_name)
	if loaded_data then
		new_market.player_accounts = loaded_data.player_accounts
		new_market.orders_for_items = loaded_data.orders_for_items
	else
		new_market.player_accounts = {}
		new_market.orders_for_items = {}
	end
	
	-- If there's a list of initial items in the market def, initialize them. allow_item can trump this.
	local initial_items = market_def.initial_items
	if initial_items then
		-- defer until after to ensure that all initial items have been registered, so we can guard against invalid items
		minetest.after(0,
			function()
				for _, item in ipairs(initial_items) do
					if minetest.registered_items[item] and 
						((not market_def.allow_item) or market_def.allow_item(item)) and
						not market_def.currency[item] then
						initialize_market_item(new_market.orders_for_items, item)
					end
				end
			end)
	end
	market_def.initial_items = nil -- don't need this any more

	new_market.name = market_name
	
	new_market.add_inventory = add_inventory
	new_market.remove_inventory = remove_inventory
	new_market.sell = sell
	new_market.buy = buy
	new_market.cancel_sell = cancel_sell
	new_market.cancel_buy = cancel_buy
	new_market.get_formspec = commoditymarket.get_formspec
	new_market.get_account = get_account
	new_market.save = save_market_data

	-- save markets on shutdown
	minetest.register_on_shutdown(function() new_market:save() end)
	
	-- and also every ten minutes, to be on the safe side in case Minetest crashes
	-- TODO: a more sophisticated approach that checks whether the market data is "dirty" before actually saving
	local until_next_save = 600
	minetest.register_globalstep(function(dtime)
		until_next_save = until_next_save - dtime
		if until_next_save < 0 then
			new_market:save()
			until_next_save = 600
		end
	end)

	----------------------------------------------------------------------
	-- Detached inventory for adding items into the market
	
	local inv = minetest.create_detached_inventory("commoditymarket:"..market_name, {
		allow_move = function(inv, from_list, from_index, to_list, to_index, count, player)
			return 0
		end,
		allow_put = function(inv, listname, index, stack, player)
			local item = stack:get_name()
			
			-- reject unknown items
			if minetest.registered_items[item] == nil then
				return 0
			end
		
			-- Currency items are always allowed
			if new_market.def.currency[item] then
				return stack:get_count()
			end
			
			-- only new tools, no used tools
			if stack:get_wear() ~= 0 then
				return 0
			end

			--nothing with metadata permitted
			local meta = stack:get_meta():to_table()
			local fields = meta.fields
			local inventory = meta.inventory
			if (fields and next(fields)) or (inventory and next(inventory)) then
				return 0
			end

			-- If there's no allow_item function defined, allow everything. Otherwise check if the item is allowed
			if (not market_def.allow_item) or market_def.allow_item(item) then
				local allowed_count = stack:get_count()
				
				if market_def.inventory_limit then
					-- limit additions to the inventory_limit, if there is one
					local current_count = 0
					for _, inventory_quantity in pairs(new_market:get_account(player:get_player_name()).inventory) do
						current_count = current_count + inventory_quantity
					end
					allowed_count = math.min(allowed_count, allowed_count + market_def.inventory_limit - (current_count+allowed_count))
					if allowed_count <= 0 then return 0 end
				end
			
				--ensures the item is in the market listing if it wasn't before
				initialize_market_item(new_market.orders_for_items, item)
				return allowed_count
			end
			return 0
		end,
		allow_take = function(inv, listname, index, stack, player)
			return 0
		end,
		on_move = function(inv, from_list, from_index, to_list, to_index, count, player)
		end,
		on_take = function(inv, listname, index, stack, player)
		end,
		on_put = function(inv, listname, index, stack, player)
			if listname == "add" then
				local item = stack:get_name()
				local count = stack:get_count()
				new_market:add_inventory(player:get_player_name(), item, count)
				inv:set_list("add", {})
				local name = player:get_player_name()
				local formspec = new_market:get_formspec(new_market:get_account(name))
				minetest.show_formspec(name, "commoditymarket:"..market_name..":"..name, formspec)
			end
		end
	})
	inv:set_size("add", 1)
end
 
commoditymarket.show_market = function(market_name, player_name)
	local market = commoditymarket.registered_markets[market_name]
	if market == nil then return end
	local formspec = market:get_formspec(market:get_account(player_name))
	minetest.show_formspec(player_name, "commoditymarket:"..market_name..":"..player_name, formspec)
end