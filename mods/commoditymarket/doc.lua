if not minetest.get_modpath("doc") then
	return
end

-- internationalization boilerplate
local MP = minetest.get_modpath(minetest.get_current_modname())
local S, NS = dofile(MP.."/intllib.lua")

doc.add_category("commoditymarket",
{
	name = S("Commodity Markets"),
	description = S("Game-wide marketplaces where goods can be bought and sold at prices of your choice."),
	build_formspec = doc.entry_builders.text_and_gallery,
})

doc.add_entry("commoditymarket", "ui_inventory", {
	name = S("User Interface: Inventory"),
	data = { text =
S("Each player's account has an inventory that serves as a holding area for items that are destined to be sold or that have been bought by the player but not yet retrieved. This inventory is a bit different from the standard Minetest inventory in that it doesn't hold item \"stacks\", it just tracks the total number of that item present. Some markets allow for extremely large quantities of an item to be stored here for sale."
.."\n\n"..
"To add an item to your market inventory for eventual sale either shift-click on the item in your player inventory or drag the item stack to the inventory slot below the main market inventory list. Some markets may have restrictions on what items can be bought and sold, if an item is not valid for that market it won't go into the market's inventory. Some items are considered \"currency\" and will add to your account's currency balance instead of being listed in your market inventory."
.."\n\n"..
"Tools cannot be added to the market inventory if they have any wear on them. The market also can't handle items with attached metadata such as books that have had text added to them."
.."\n\n"..
"To remove an item from your market inventory, double-click in it in the market inventory list. As much of the item as can fit into your player inventory will be transferred to you, with any remainder staying behind in the market inventory. To withdraw currency from your market balance type the amount you'd like to withdraw in the field next to the \"Withdraw\" button. The currency will be converted into items and added to your player inventory, with whatever cannot be converted remaining behind in your market balance.")
}})

doc.add_entry("commoditymarket", "ui_orders", {
	name = S("User Interface: Orders"),
	data = { text =
S(
"At the core of how a market operates are \"buy\" and \"sell\" orders. A buy order is an announcement to the world that you are interested in purchasing a certain quantity of item and are willing to pay a certain amount of currency in exchange for each unit of that item. Conversely, a sell order is an announcement to the world that you are interested in selling a certain quantity of item and will accept a certain amount of currency in exchange for each unit of that item."
.."\n\n"..
"The market price of an item is determined by where the existing buy and sell orders for that item intersect. When you offer to buy an item for a price that someone is offering to sell it at, the item is transferred to you and currency is transferred from your account to theirs to cover the cost. The market will keep track of the most recent price that an item was successfully sold for, but note that this information is for historical interest only - there's no guarantee that anyone is currently willing to match the historical price."
.."\n\n"..
"When an item is selected in the upper list, the currently existing buy and sell orders for that item will be displayed in the lower list. Sell orders are listed first in descending price, followed by buy orders in ascending price. The current market price will be somewhere in between the lowest sell order and the highest buy order. If you wish to cancel a buy or sell order that you've placed for an item, double-click on the order and the item or currency that you put into that order will be returned to your inventory."
.."\n\n"..
"If you place a buy order and there are already sell orders for the item that meet or are below your price, some or all of your buy order might be immediately fulfilled. Your purchases will be made at the price that the sell orders have been set to - if you were willing to pay 15 units of currency per item but someone was already offering to sell for 2 units of currency per item, you only pay 2 units for each of that offer's items. If there aren't enough compatible sell orders to fulfill your buy order, the remainder will be placed into the market and made available for future sellers to see and fulfill if they agree to your price. Your buy order will immediately deduct the currency required for it from your account's balance, but if you cancel your order you will get that currency back - it's not gone until the order is actually fulfilled."
.."\n\n"..
"If you place a sell order and there are already buy orders that meet or exceed your price, some or all of your sell order may be immediately fulfilled. You'll be paid the price that the buyers are offering rather than the amount you're demanding. If any of your sell offer is left unfulfilled, the sell order will be added to the market for future buyers to see. The items for this offer will be immediately taken from your market inventory but if you cancel your order you will get those items back.")
}})