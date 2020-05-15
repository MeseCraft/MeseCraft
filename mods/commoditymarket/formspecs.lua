local S = minetest.get_translator(minetest.get_current_modname())

local truncate_item_names_to = 30

-- Large textures can screw with the formspecs.
-- See https://github.com/minetest/minetest/issues/9300 for a feature request that would simplify and improve icon generation, if supported.
-- In the meantime, here's some methods for overriding item icons to manually work around this:
local override_item_icon = {}
commoditymarket.override_item_icon = function(item_name, new_icon_texture)
	override_item_icon[item_name] = new_icon_texture
end
local override_image_icon = {}
commoditymarket.override_image_icon = function(old_icon_texture, new_icon_texture)
	override_image_icon[old_icon_texture] = new_icon_texture
end
-- And a setting for disabling icons entirely:
local global_enable_item_icons = minetest.settings:get_bool("commoditymarket_enable_item_icons", true)

--[inventorycube{<top>{<left>{<right>
--Escaping does not apply here and `^` is replaced by `&` in texture names instead.
--Example:
--    [inventorycube{grass.png{dirt.png&grass_side.png{dirt.png&grass_side.png
--Creates an inventorycube with `grass.png`, `dirt.png^grass_side.png` and `dirt.png^grass_side.png` textures
local process_inventory_cube = function(texture_string)
	if not texture_string:sub(1,14) == "[inventorycube" then
		return texture_string
	end
	local split = texture_string:split("{")
	local left = split[3] -- the "front" of the cube we're seeing in the inventory list
	if left == nil then -- in case something weird happens, don't crash.
		return texture_string
	end
	left = left:gsub("&", "^")
	return left
end

local get_icon = function(item)
	local def = minetest.registered_items[item]
	local returnstring = "unknown_item.png"
	if def == nil then
		return returnstring
	end
	
	local override = override_item_icon[item]
	if override then
		return override
	end

	local inventory_image = def.inventory_image
	if inventory_image and inventory_image ~= "" then
		returnstring = inventory_image
	else
		local tiles = def.tiles
		if tiles then
			local tilecount = #tiles
			-- Textures of node; +Y, -Y, +X, -X, +Z, -Z
			local selected_tile = tiles[math.min(5,tilecount)]
			if type(selected_tile) == "string" then
				returnstring = selected_tile
			else
				local tile_name = selected_tile.name
				if tile_name then
					returnstring = tile_name
				end
			end
		end
	end
	returnstring = process_inventory_cube(returnstring)

	-- Formspec tables can't handle image compositing and modifiers
	local found_caret = returnstring:find("%^")
	if found_caret then
		returnstring = returnstring:sub(1, found_caret-1)
	end
	
	override = override_image_icon[returnstring]
	if override then
		return override
	end

	return minetest.formspec_escape(returnstring)
end
-- Exposed so that the purge_unknowns command can use it.
commoditymarket.get_icon = get_icon


local truncate_string = function(target, length)
	if target:len() > length then
		return target:sub(1,length-2).."..."
	end
	return target
end

local get_item_description = function(item)
	local def = minetest.registered_items[item]
	if def then
		local description = def.description
		if description then
			return minetest.formspec_escape(description:gsub("\n", " "))
		end
	end
	return S("Unknown Item")
end

-- Inventory formspec
-------------------------------------------------------------------------------------

local inventory_item_comp = function(invitem1, invitem2) return invitem1.item < invitem2.item end
local inventory_desc_comp = function(invitem1, invitem2) return invitem1.description < invitem2.description end

local get_account_formspec = function(market, account)
	local show_itemnames = account.show_itemnames == "true"
	local show_icons = global_enable_item_icons and ((account.show_icons or "true") == "true")
	local market_def = market.def

	local inventory = {}
	local inventory_count = 0
	for item, quantity in pairs(account.inventory) do
		local icon
		if show_icons then
			icon = get_icon(item)
		end
		table.insert(inventory, {item=item, quantity=quantity, icon=icon, description=get_item_description(item)})
		inventory_count = inventory_count + quantity
	end
	if show_itemnames then
		table.sort(inventory, inventory_item_comp)
	else
		table.sort(inventory, inventory_desc_comp)
	end

	local formspec = {
		"size[10,10]"
		.."tabheader[0,0;tabs;"..market_def.description..","..S("Your Inventory")..","..S("Market Orders")..";2;false;true]"
	}
	formspec[#formspec+1] = "tablecolumns["
	
	if show_icons then
		formspec[#formspec+1] = "image"
		for i=1, #inventory, 2 do
			formspec[#formspec+1] = ","..i.."="..inventory[i].icon
		end
		formspec[#formspec+1] = ";"
	end
	if show_itemnames then
		formspec[#formspec+1] = "text;"
	end
	formspec[#formspec+1] = "text;text,align=center"
	if show_icons then
		formspec[#formspec+1] = ";image"
		for i=2, #inventory, 2 do
			formspec[#formspec+1] = ","..i.."="..inventory[i].icon
		end
	end
	if show_itemnames then
		formspec[#formspec+1] = ";text"
	end
	formspec[#formspec+1] = ";text;text,align=center]"
		.."tooltip[inventory;"..S("All the items you've transfered to the market to sell and the items you've\npurchased with buy orders. Double-click on an item to bring it back into your\npersonal inventory.").."]"
		.."table[0,0;9.75,4;inventory;"
	if show_icons then
		formspec[#formspec+1] = "0,"
	end
	if show_itemnames then
		formspec[#formspec+1] = S("Item")..","
	end	
	formspec[#formspec+1] = S("Description")..","..S("Quantity")
	if show_icons then
		formspec[#formspec+1] = ",0"
	end
	if show_itemnames then
		formspec[#formspec+1] = ","..S("Item")
	end	
	formspec[#formspec+1] = ","..S("Description")..","..S("Quantity")

	for i, entry in ipairs(inventory) do
		if show_icons then
			formspec[#formspec+1] = "," .. i
		end
		if show_itemnames then
			formspec[#formspec+1] = "," .. truncate_string(entry.item, truncate_item_names_to)
		end	
		-- no need to formspec_escape description here, it gets done when it's initially added to the inventory table
		formspec[#formspec+1] = "," .. entry.description .. "," .. entry.quantity
	end	
	
	formspec[#formspec+1] = "]container[1,4.5]list[detached:commoditymarket:" .. market.name .. ";add;0,0;1,1;]"
		.."label[1,0;"..S("Drop items here to\nadd to your account").."]"
		.."listring[current_player;main]listring[detached:commoditymarket:" .. market.name .. ";add]"
		
	if market_def.inventory_limit then
		formspec[#formspec+1] = "label[3,0;"..S("Inventory limit:").."\n" .. inventory_count.."/" .. market_def.inventory_limit .. "]"
			.. "tooltip[3,0;1.5,1;"..S("You can still receive purchased items if you've exceeded your inventory limit,\nbut you won't be able to transfer items from your personal inventory into\nthe market until you've emptied it back down below the limit again.").."]"
	end
	formspec[#formspec+1] = "label[4.9,0;"..S("Balance:") .. "\n" .. market_def.currency_symbol .. account.balance .. "]"
		.."tooltip[4.9,0;3.5,1;"..S("Enter the amount of currency you'd like to withdraw then click the 'Withdraw'\nbutton to convert it into items and transfer it to your personal inventory.").."]"
		.."field[6.1,0.325;1,1;withdrawamount;;]"
		.."field_close_on_enter[withdrawamount;false]"
		.."button[6.7,0;1.2,1;withdraw;"..S("Withdraw").."]"
		.."container_end[]"
		.."container[1,5.75]list[current_player;main;0,0;8,1;]"
		.."list[current_player;main;0,1.25;8,3;8]container_end[]"
		
	return table.concat(formspec)
end


-- Market formspec
--------------------------------------------------------------------------------------------------------

local compare_market_item = function(mkt1, mkt2)
	return mkt1.item < mkt2.item
end
local compare_market_desc = function(mkt1, mkt2)
	-- TODO: see https://github.com/minetest/minetest/issues/8398 for sorting localized strings
	return get_item_description(mkt1.item) < get_item_description(mkt2.item)
end
local compare_buy_volume = function(mkt1, mkt2)
	return mkt1.buy_volume > mkt2.buy_volume
end
local compare_buy_max = function(mkt1, mkt2)
	return ((mkt1.buy_orders[#mkt1.buy_orders] or {}).price or -2^30) > ((mkt2.buy_orders[#mkt2.buy_orders] or {}).price or -2^30)
end
local compare_sell_volume = function(mkt1, mkt2)
	return mkt1.sell_volume > mkt2.sell_volume
end
local compare_sell_min = function(mkt1, mkt2)
	return ((mkt1.sell_orders[#mkt1.sell_orders] or {}).price or 2^31) < ((mkt2.sell_orders[#mkt2.sell_orders] or {}).price or 2^31)
end
local compare_last_price = function(mkt1, mkt2)
	return (mkt1.last_price or 2^31) < (mkt2.last_price or 2^31)
end

local sort_marketlist = function(item_list, account)
	-- I think tonumber is now redundant here, leaving it in in case upgrading a world that has text recorded in this field for an existing player account
	local sort_by = tonumber(account.sort_markets_by_column)
	if sort_by == nil then return end
	local show_itemnames = account.show_itemnames == "true"
	local show_icons = global_enable_item_icons and ((account.show_icons or "true") == "true")

	local icon_displace = 0
	if show_icons then
		icon_displace = 1
	end
	local itemname_displace = 0
	if show_itemnames then
		itemname_displace = 1
	end

	--	"Icon,Item,Description,#00FF00,Buy Vol,Buy Max,#FF0000,Sell Vol,Sell Min,Last Price"
	if sort_by == 1 + icon_displace and show_itemnames then
		table.sort(item_list, compare_market_item)
	elseif sort_by == 1 + icon_displace + itemname_displace then
		table.sort(item_list, compare_market_desc)
	elseif sort_by == 3 + icon_displace + itemname_displace then
		table.sort(item_list, compare_buy_volume)
	elseif sort_by == 4 + icon_displace + itemname_displace then
		table.sort(item_list, compare_buy_max)
	elseif sort_by == 6 + icon_displace + itemname_displace then
		table.sort(item_list, compare_sell_volume)
	elseif sort_by == 7 + icon_displace + itemname_displace then
		table.sort(item_list, compare_sell_min)
	elseif sort_by == 8 + icon_displace + itemname_displace then
		table.sort(item_list, compare_last_price)
	elseif sort_by == 9 + icon_displace + itemname_displace then
		table.sort(item_list, function(mkt1, mkt2)
			-- Define locally so that account is available
			return (account.inventory[mkt1.item] or 0) > (account.inventory[mkt2.item] or 0)
		end)
	end
end

local make_marketlist = function(market, account)
	local market_list = {}
	local search_filter = account.search or ""
	for item, row in pairs(market.orders_for_items) do
		if (search_filter == "" or string.find(item, search_filter)) then
			if account.filter_participating == "true" then
				local found = false
				for _, order in ipairs(row.buy_orders) do
					if account == order.account then
						found = true
						break
					end
				end
				if not found then
					for _, order in ipairs(row.sell_orders) do
						if account == order.account then
							found = true
							break
						end
					end
				end
				if found then
					table.insert(market_list, row)
				end
			else
				table.insert(market_list, row)
			end
		end
	end
	sort_marketlist(market_list, account)
	return market_list
end

local get_account_name = function(target_account, this_account, anonymous)
	if anonymous and target_account ~= this_account then
		return ""
	end
	return target_account.name
end

local get_market_formspec = function(market, account)
	local market_def = market.def
	local selected = account.selected
	local market_list = make_marketlist(market, account)
	local show_itemnames = account.show_itemnames == "true"
	local show_icons = global_enable_item_icons and ((account.show_icons or "true") == "true")
	local anonymous = market_def.anonymous

	local formspec = {
		"size[10,10]"
		.."tabheader[0,0;tabs;"..market_def.description..","..S("Your Inventory")..","..S("Market Orders")..";3;false;true]"
	}

	-- column definitions
	formspec[#formspec+1] = "tablecolumns["
	if show_icons then
		formspec[#formspec+1] = "image" -- icon
		for i, row in ipairs(market_list) do
			formspec[#formspec+1] = "," .. i .. "=" .. get_icon(row.item)
		end
		formspec[#formspec+1] = ";"
	end	if show_itemnames then
		formspec[#formspec+1] = "text;" -- itemname
	end
	formspec[#formspec+1] = "text;" -- description
		.."color,span=2;"
		.."text,align=right,tooltip="..S("Number of items there's demand for in the market.")..";"
		.."text,align=right,tooltip="..S("Maximum price being offered to buy one of these.")..";"
		.."color,span=2;"
		.."text,align=right,tooltip="..S("Number of items available for sale in the market.")..";"
		.."text,align=right,tooltip="..S("Minimum price being demanded to sell one of these.")..";"
		.."text,align=right,tooltip="..S("Price paid for one of these the last time one was sold.")..";"
		.."text,align=right,tooltip="..S("Quantity of this item that you have in your inventory ready to sell.").."]"
		.."table[0,0;9.75,5;summary;"
	if show_icons then
		formspec[#formspec+1] = "0,"-- icon
	end

	-- header row
	if show_itemnames then
		formspec[#formspec+1] = "Item," -- itemname
	end
	formspec[#formspec+1] = S("Description")..",#00FF00,"..S("Buy Vol")..","..S("Buy Max")
		..",#FF0000,"..S("Sell Vol")..","..S("Sell Min")..","..S("Last Price")..","..S("Inventory")

	local selected_idx
	local selected_row

	-- Show list of item market summaries
	for i, row in ipairs(market_list) do
		if show_icons then
			formspec[#formspec+1] = ","..i -- icon
		end

		if show_itemnames then
			formspec[#formspec+1] = "," .. truncate_string(row.item, truncate_item_names_to)
		end

		formspec[#formspec+1] = "," .. get_item_description(row.item)
		.. ",#00FF00,"
		.. row.buy_volume
		.. "," .. ((row.buy_orders[#row.buy_orders] or {}).price or "-")
		.. ",#FF0000,"
		.. row.sell_volume
		.. "," .. ((row.sell_orders[#row.sell_orders] or {}).price or "-")
		.. "," .. (row.last_price or "-")
		.. "," .. (account.inventory[row.item] or "-")

		-- we happen to be processing the row that matches the item this player has selected. Record that.
		if selected == row.item then
			selected_row = row
			selected_idx = i + 1
		end

	end
	-- a row that's visible is marked as the selected item, so make it selected in the formspec
	if selected_row then
		formspec[#formspec+1] = ";"..selected_idx
	end
	formspec[#formspec+1] = "]"

	-- search field
	formspec[#formspec+1] =	"container[2.5,5]field_close_on_enter[search_filter;false]"
		.."field[0,0.85;2.5,1;search_filter;;"..minetest.formspec_escape(account.search or "").."]"
		.."image_button[2.05,0.65;0.8,0.8;commoditymarket_search.png;apply_search;]"
		.."image_button[2.7,0.65;0.8,0.8;commoditymarket_clear.png;clear_search;]"
		.."checkbox[1.77,0;filter_participating;"..S("My orders")..";".. account.filter_participating .."]"
		.."tooltip[filter_participating;"..S("Select this to show only the markets where you have either a buy or a sell order pending.").."]"
		.."tooltip[search_filter;"..S("Enter substring to search item identifiers for.").."]"
		.."tooltip[apply_search;"..S("Apply search to outputs.").."]"
		.."tooltip[clear_search;"..S("Clear search.").."]"
		.."container_end[]"

	-- if a visible item market is selected, show the orders for it in detail
	if selected_row then
		local current_time = minetest.get_gametime()

		local desc_display
		if show_itemnames then
			desc_display = selected
		else
			local def = minetest.registered_items[selected_row.item] or {description=S("Unknown Item")}
			desc_display = minetest.formspec_escape(def.description:gsub("\n", " "))
		end

		-- player inventory for this item and for currency
		formspec[#formspec+1] = "label[0.1,5.1;"..desc_display.."\n"..S("In inventory:").." "
			.. tostring(account.inventory[selected] or 0) .."\n"..S("Balance:").." "..market_def.currency_symbol..account.balance .."]"
		-- buy/sell controls
			.. "container[6.1,5]"
		local sell_limit = market_def.sell_limit
		if sell_limit then
			local total_sell = 0
			for item, orders in pairs(market.orders_for_items) do
				for _, order in ipairs(orders.sell_orders) do
					if order.account == account then
						total_sell = total_sell + order.quantity
					end
				end
			end
			formspec[#formspec+1] = "label[0,0;"..S("Sell limit:").." ".. total_sell .. "/" .. sell_limit .."]"
				.."tooltip[0,0;2,0.25;"..S("This market limits the total number of items a given seller can have for sale at a time.\nYou have @1 items remaining. Cancel old sell orders to free up space.", sell_limit-total_sell).."]"
		end
		-- Buy, sell, quantity and price button
		formspec[#formspec+1] = "tooltip[0,0.25;3.75,1;"..S("Use these fields to enter buy and sell orders for the selected item.").."]"
			.."button[0,0.55;1,1;buy;"..S("Buy").."]field[1.2,0.85;1,1;quantity;"..S("Quantity")..";]"
			.."field[2.1,0.85;1,1;price;"..S("Price per")..";]button[2.7,0.55;1,1;sell;Sell]"
			.."field_close_on_enter[quantity;false]field_close_on_enter[price;false]"
			.."container_end[]"
		-- table of buy and sell orders
			.."tablecolumns[color;text;"
			.."text,align=right,tooltip="..S("The price per item in this order.")..";"
			.."text,align=right,tooltip="..S("The total amount of items in this particular order.")..";"
			.."text,align=right,tooltip="..S("The total amount of items available at this price accounting for the other orders also currently being offered.")..";"
			.."text,tooltip="..S("The name of the player who placed this order.\nDouble-click your own orders to cancel them.")..";"
			.."text,align=right,tooltip="..S("How many days ago this order was placed.").."]"
			.."table[0,6.5;9.75,3.5;orders;#FFFFFF,"..S("Order")..","..S("Price")..","..S("Quantity")..","..S("Total Volume")..","..S("Player")..","..S("Days Old")

		local sell_volume = selected_row.sell_volume
		for i, sell in ipairs(selected_row.sell_orders) do
			formspec[#formspec+1] = ",#FF0000,"..S("Sell")..","
				..sell.price..","
				..sell.quantity..","
				..sell_volume..","
				..get_account_name(sell.account, account, anonymous)..","
				..math.floor((current_time-sell.timestamp)/86400)
			sell_volume = sell_volume - sell.quantity
		end
		local buy_volume = 0
		local buy_orders = selected_row.buy_orders
		local buy_count = #buy_orders
		-- Show buy orders in reverse order
		for i = buy_count, 1, -1  do
			local buy = buy_orders[i]
			buy_volume = buy_volume + buy.quantity
			formspec[#formspec+1] = ",#00FF00,"..S("Buy")..","
				..buy.price..","
				..buy.quantity..","
				..buy_volume..","
				..get_account_name(buy.account, account, anonymous)..","
				..math.floor((current_time-buy.timestamp)/86400)
		end
		formspec[#formspec+1] = "]"
	else
		formspec[#formspec+1] = "label[0.1,5.1;"..S("Select an item to view or place orders.").."]"
	end

	return table.concat(formspec)
end

-------------------------------------------------------------------------------------
-- Information formspec

--{item=item, quantity=quantity, price=price, purchaser=purchaser, seller=seller, timestamp = minetest.get_gametime()}
local log_to_string = function(market, log_entry, account)
	local anonymous = market.def.anonymous
	local purchaser = log_entry.purchaser
	local seller = log_entry.seller
	local purchaser_name
	if purchaser == seller then
		purchaser_name = S("yourself")
	elseif anonymous and purchaser ~= account then
		purchaser_name = S("someone")
	elseif purchaser == account then
		purchaser_name = S("you")
	else
		purchaser_name = purchaser.name
	end
	local seller_name
	if anonymous and seller ~= account then
		seller_name = S("someone")
	elseif seller == account then
		seller_name = S("you")
	else
		seller_name = seller.name
	end
	local colour
	local new
	local last_acknowledged = account.last_acknowledged or 0
	if log_entry.timestamp > last_acknowledged then
		colour = "#FFFF00"
		new = true
	else
		colour = "#FFFFFF"
		new = false
	end
	local show_itemnames = account.show_itemnames == "true"
	local itemname = log_entry.item
	if not show_itemnames then
		local item_def = minetest.registered_items[log_entry.item]
		if item_def then
			itemname = minetest.formspec_escape(item_def.description:gsub("\n", " "))
		end
	end

	local currency_symbol = market.def.currency_symbol
	return colour .. S("On day @1 @2 sold @3 @4 to @5 at @6@7 each for a total of @8@9.",
			math.ceil(log_entry.timestamp/86400), seller_name, log_entry.quantity, itemname,
			purchaser_name, currency_symbol, log_entry.price, currency_symbol, log_entry.quantity*log_entry.price), new
end


local get_info_formspec = function(market, account)
	local formspec = {
		"size[10,10]"
		.."tabheader[0,0;tabs;"..market.def.description..","..S("Your Inventory")..","..S("Market Orders")..";1;false;true]"
		.."textarea[0.75,0.5;9.25,1.5;;"..S("Description:")..";"..market.def.long_description.."]"
		.."label[0.5,2.2;"..S("Your Recent Purchases and Sales:").."]"
		.."textlist[0.5,2.6;8.75,4;log_entries;"
	}
	if next(account.log) then
		local new = false
		for _, log_entry in ipairs(account.log) do
			local log_string, new_log = log_to_string(market, log_entry, account)
			new = new or new_log
			formspec[#formspec+1] = log_string
			formspec[#formspec+1] = ","
		end
		formspec[#formspec] = "]" -- Note: there's no +1 here deliberately, that way the "]" overwrites the last comma added by the loop above.
		if new then
			formspec[#formspec+1] = "button[7.1,6.9;2,0.5;acknowledge_log;"..S("Mark logs as read").."]" ..
			"tooltip[acknowledge_log;"..S("Log entries in yellow are new since last time you marked your log as read.").."]"
		end
	else
		formspec[#formspec+1] = "#CCCCCC"..S("No logged activities in this market yet.").."]"
	end
	local show_itemnames = account.show_itemnames or "false"

	formspec[#formspec+1] = "]container[0.5, 7.5]label[0,0;Settings:]checkbox[0,0.25;show_itemnames;"..S("Show Itemnames")..";"
		..show_itemnames.."]"
	if global_enable_item_icons then
		local show_icons = account.show_icons or "true"	
		formspec[#formspec+1] = "checkbox[2,0.25;show_icons;"..S("Show Icons")..";"..show_icons.."]"
	end		
	formspec[#formspec+1] = "container_end[]"

	return table.concat(formspec)
end

---------------------------------------------------------------------------------------

commoditymarket.get_formspec = function(market, account)
	local tab = account.tab
	if tab == 1 then
		return get_info_formspec(market, account)
	elseif tab == 2 then
		return get_account_formspec(market, account)
	else
		return get_market_formspec(market, account)
	end
end


------------------------------------------------------------------------------------
-- Handling recieve_fields

local add_to_player_inventory = function(name, item, amount)
	local playerinv = minetest.get_inventory({type="player", name=name})
	local not_full = true
	while amount > 0 and not_full do
		local stack = ItemStack(item .. " " .. amount)
		amount = amount - stack:get_count()
		local leftover = playerinv:add_item("main", stack)
		if leftover:get_count() > 0 then
			amount = amount + leftover:get_count()
			return amount
		end
	end
	return amount
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
	local formname_split = formname:split(":")

	if formname_split[1] ~= "commoditymarket" then
		return false
	end
	local market = commoditymarket.registered_markets[formname_split[2]]
	if not market then
		return false
	end

	local name = formname_split[3]
	if name ~= player:get_player_name() then
		return false
	end

	local account = market:get_account(name)
	local show_icons = global_enable_item_icons and ((account.show_icons or "true") == "true")

	local something_changed = false
	if fields.tabs then
		account.tab = tonumber(fields.tabs)
		something_changed = true
	end
	-- player clicked on an item in the market summary table
	if fields.summary then
		local summaryevent = minetest.explode_table_event(fields.summary)
		if summaryevent.type == "DCL" or summaryevent.type == "CHG" then
			if summaryevent.row == 1 then
				-- header clicked, sort by column
				local column = tonumber(summaryevent.column)
				if not (column == 1 and show_icons) then -- ignore clicks on the icon column header
					account.sort_markets_by_column = column
				end
			else
				-- item clicked, recreate the list to find out which one
				local marketlist = make_marketlist(market, account)
				local selected = marketlist[summaryevent.row-1]
				if selected then
					account.selected = selected.item
				end
			end
		elseif summaryevent.type == "INV" then
			account.selected = nil
		end
		something_changed = true
	end
	if fields.orders then
		local ordersevent = minetest.explode_table_event(fields.orders)
		if ordersevent.type == "DCL" and ordersevent.column > 0 then
			local selected_idx = ordersevent.row - 1 -- account for header
			local selected_row = market.orders_for_items[account.selected] -- sell orders come first
			local sell_orders = selected_row.sell_orders
			local sell_order_count = #sell_orders
			local selected_order
			if selected_idx <= sell_order_count then -- if the index is within the range of sell orders,
				selected_order = sell_orders[selected_idx]
				if selected_order and selected_order.account == account then -- and the order belongs to the current player,
					market:cancel_sell(account.selected, selected_order) -- cancel it
					something_changed = true
				end
			else
				-- otherwise we're in the buy group, shift the index up by sell_order_count and reverse index order
				local buy_orders = selected_row.buy_orders
				local buy_orders_count = #buy_orders
				selected_order = buy_orders[buy_orders_count - (selected_idx - sell_order_count - 1)]
				if selected_order and selected_order.account == account then
					market:cancel_buy(account.selected, selected_order)
					something_changed = true
				end
			end
		end
	end

	if fields.buy then
		local quantity = tonumber(fields.quantity)
		local price = tonumber(fields.price)
		if price ~= nil and quantity ~= nil then
			market:buy(name, account.selected, quantity, price)
			something_changed = true
		end
	end
	if fields.sell then
		local quantity = tonumber(fields.quantity)
		local price = tonumber(fields.price)
		if price ~= nil and quantity ~= nil then
			market:sell(name, account.selected, quantity, price)
			something_changed = true
		end
	end

	-- player clicked in their inventory table, may need to give him his stuff back
	if fields.inventory then
		local invevent = minetest.explode_table_event(fields.inventory)
		if invevent.type == "DCL" and invevent.column > 0 then
			local col_count = 8
			local show_itemnames = account.show_itemnames == "true"
			if not show_itemnames then
				col_count = col_count - 2
			end
			if not show_icons then
				col_count = col_count - 2
			end
			local index = math.floor(((invevent.row-1)*col_count + invevent.column - 1)/(col_count/2)) - 1
			local account = market:get_account(name)
			-- build a local copy of the inventory that would be displayed in the formspec so we can 
			-- figure out what item the index we were given is pointing to
			local inventory = {}
			for item, quantity in pairs(account.inventory) do
				table.insert(inventory, {item=item, quantity=quantity, description=get_item_description(item)})
			end
			if show_itemnames then
				table.sort(inventory, inventory_item_comp)
			else
				table.sort(inventory, inventory_desc_comp)
			end
			if inventory[index] then
				local item = inventory[index].item
				local amount = account.inventory[item]
				local remaining = add_to_player_inventory(name, item, amount)
				if remaining == 0 then
					account.inventory[item] = nil
				else
					account.inventory[item] = remaining
				end
				if remaining ~= amount then
					something_changed = true
				end
			end
		end
	end

	if fields.withdraw or fields.key_enter_field == "withdrawamount" then
		local withdrawvalue = tonumber(fields.withdrawamount)
		if withdrawvalue then
			local account = market:get_account(name)
			withdrawvalue = math.min(withdrawvalue, account.balance)
			for _, currency in ipairs(market.def.currency_ordered) do
				this_unit_amount = math.floor(withdrawvalue/currency.amount)
				if this_unit_amount > 0 then
					local remaining = add_to_player_inventory(name, currency.item, this_unit_amount)
					local value_given = (this_unit_amount - remaining) * currency.amount
					account.balance = account.balance - value_given
					withdrawvalue = withdrawvalue - value_given
					something_changed = true
				end
			end
		end
	end

	if fields.search_filter then
		local value = string.lower(fields.search_filter)
		if account.search ~= value then
			account.search = value
		end
	end

	local process_checkbox = function(property_name, fields, account)
		if (fields[property_name] == "true" and account[property_name] ~= "true") or
			(fields[property_name] == "false" and account[property_name] ~= "false") then
			account[property_name] = fields[property_name]
			return true
		end
		return false
	end

	if process_checkbox("filter_participating", fields, account) then something_changed = true end
	if process_checkbox("show_itemnames", fields, account) then something_changed = true end
	if process_checkbox("show_icons", fields, account) then something_changed = true end

	if fields.acknowledge_log then
		account.last_acknowledged = minetest.get_gametime()
		something_changed = true
	end

	if fields.apply_search or fields.key_enter_field == "search_filter" then
		something_changed = true
	end

	if fields.clear_search then
		account.search = ""
		something_changed = true
	end
	if something_changed then
		minetest.show_formspec(name, formname, market:get_formspec(account))
	end
end)
