local modpath_default = minetest.get_modpath("default")
if not (minetest.settings:get_bool("settlements_generate_books", true) and modpath_default) then
	return
end

-- internationalization boilerplate
local S, NS = settlements.S, settlements.NS

-- values taken from default's craftitems.lua
local max_text_size = 10000
local max_title_size = 80
local short_title_size = 35
local lpp = 14

local generate_book = function(title, owner, text)
	local book = ItemStack("default:book_written")
	local meta = book:get_meta()

	meta:set_string("title", title:sub(1, max_title_size))
	meta:set_string("owner", owner)
	local short_title = title
	-- Don't bother trimming the title if the trailing dots would make it longer
	if #short_title > short_title_size + 3 then
		short_title = short_title:sub(1, short_title_size) .. "..."
	end
	meta:set_string("description", S("@1 by @2", short_title, owner))
	text = text:sub(1, max_text_size)
	text = text:gsub("\r\n", "\n"):gsub("\r", "\n")
	meta:set_string("text", text)
	meta:set_int("page", 1)
	meta:set_int("page_max", math.ceil((#text:gsub("[^\n]", "") + 1) / lpp))

	return book
end

----------------------------------------------------------------------------------------------------------------

local half_map_chunk_size = settlements.half_map_chunk_size
local bookshelf_def = minetest.registered_items["default:bookshelf"]
local bookshelf_on_construct
if bookshelf_def then
	bookshelf_on_construct = bookshelf_def.on_construct
end

minetest.register_abm({
	label = "Settlement book authoring",
	nodenames = {"default:bookshelf"},
	interval = 60, -- Operation interval in seconds
	chance = 1440, -- Chance of triggering `action` per-node per-interval is 1.0 / this value
	catch_up = true,
	-- If true, catch-up behaviour is enabled: The `chance` value is
	-- temporarily reduced when returning to an area to simulate time lost
	-- by the area being unattended. Note that the `chance` value can often
	-- be reduced to 1.

	action = function(pos, node, active_object_count, active_object_count_wider)
		local inv = minetest.get_inventory( {type="node", pos=pos} )

		-- Can we fit a book?
		if not inv or not inv:room_for_item("books", "default:book_written") then
			return
		end

		-- find any settlements within the shelf's mapchunk
		-- There's probably only ever going to be one, but might as well do a closeness check to be on the safe side.
		local min_edge = vector.subtract(pos, half_map_chunk_size)
		local max_edge = vector.add(pos, half_map_chunk_size)
		local settlement_list = named_waypoints.get_waypoints_in_area("settlements", min_edge, max_edge)
		local closest_settlement
		for _, settlement in pairs(settlement_list) do
			local target_pos = settlement.pos
			if not closest_settlement or vector.distance(pos, target_pos) < vector.distance(pos, closest_settlement.pos) then
				closest_settlement = settlement
			end
		end

		if not closest_settlement then
			return
		end

		-- Get the settlement def and, if it generate books, generate one
		local data = closest_settlement.data
		local town_name = data.name
		local town_type = data.settlement_type
		local town_def = settlements.registered_settlements[town_type]
		if town_def and town_def.generate_book then
			local book = town_def.generate_book(closest_settlement.pos, town_name)
			if book then
				inv:add_item("books", book)
				if bookshelf_on_construct then
					bookshelf_on_construct(pos) -- this should safely update the bookshelf's infotext without disturbing its contents
				end
			end
		end
	end,
})

---------------------------------------------------------------------------
-- Commoditymarket ledgers

if minetest.get_modpath("commoditymarket") then
--{item=item, quantity=quantity, price=price, purchaser=purchaser, seller=seller, timestamp = minetest.get_gametime()}
local log_to_string = function(log_entry, market)
	local anonymous = market.def.anonymous
	local purchaser = log_entry.purchaser
	local seller = log_entry.seller
	local purchaser_name
	if purchaser == seller then
		purchaser_name = S("themself")
	elseif anonymous then
		purchaser_name = S("someone")
	else
		purchaser_name = purchaser.name
	end
	local seller_name
	if anonymous then
		seller_name = S("someone")
	else
		seller_name = seller.name
	end

	local itemname = log_entry.item
	local item_def = minetest.registered_items[log_entry.item]
	if item_def then
		itemname = item_def.description:gsub("\n", " ")
	end

	return S("On day @1 @2 sold @3 @4 to @5 at @6@7 each for a total of @6@8.",
		math.ceil(log_entry.timestamp/86400), seller_name, log_entry.quantity, itemname,
		purchaser_name, market.def.currency_symbol, log_entry.price, log_entry.quantity*log_entry.price)
end

local get_log_strings = function(market, quantity)
	local accounts = market.player_accounts
	local all_logs = {}
	for player_name, account in pairs(accounts) do
		for _, log_entry in pairs(account.log) do
			table.insert(all_logs, log_entry)
		end
	end
	if #all_logs == 0 then
		return
	end
	table.sort(all_logs, function(log1, log2) return log1.timestamp > log2.timestamp end)
	local start_range = math.max(#all_logs, #all_logs - quantity)
	local start_point = math.random(start_range)
	local end_point = math.min(start_point+quantity, #all_logs)
	local out = {}
	local last_timestamp = all_logs[end_point].timestamp
	for i = start_point, end_point do
		table.insert(out, log_to_string(all_logs[i], market))
	end
	return out, last_timestamp
end

settlements.generate_ledger = function(market_name, town_name)
	local market = commoditymarket.registered_markets[market_name]
	if not market then
		return
	end
	local strings, last_timestamp = get_log_strings(market, math.random(5,15))
	if not strings then
		return
	end
	strings = table.concat(strings, "\n")
	local day = math.ceil(last_timestamp/86400)
	local title = S("@1 Ledger on Day @2", market.def.description, day)
	local author = S("@1's market clerk", town_name)
	return generate_book(title, author, strings)
end
end

--------------------------------------------------------------------------------
-- Travel guides

-- returns {pos, data}
local half_map_chunk_size = settlements.half_map_chunk_size
local get_random_settlement_within_range = function(pos, range_max, range_min)
	range_min = range_min or half_map_chunk_size -- If no minimum provided, at least don't look within your own chunk
	if range_max <= range_min then
		return
	end
	local min_edge = vector.subtract(pos, range_max)
	local max_edge = vector.add(pos, range_max)
	local settlement_list = named_waypoints.get_waypoints_in_area("settlements", min_edge, max_edge)
	local settlements_within_range = {}
	for _, settlement in pairs(settlement_list) do
		local distance = vector.distance(pos, settlement.pos)
		if distance < range_max and distance > range_min then
			table.insert(settlements_within_range, settlement)
		end
	end
	if #settlements_within_range == 0 then
		return
	end

	local target = settlements_within_range[math.random(#settlements_within_range)]
	return target
end

local compass_dirs = {
	[0] = S("west"),
	S("west-southwest"),
	S("southwest"),
	S("south-southwest"),
	S("south"),
	S("south-southeast"),
	S("southeast"),
	S("east-southeast"),
	S("east"),
	S("east-northeast"),
	S("northeast"),
	S("north-northeast"),
	S("north"),
	S("north-northwest"),
	S("northwest"),
	S("west-northwest"),
	S("west"),
}
local increment = 2*math.pi/#compass_dirs -- Divide the circle up into pieces
local reframe = math.pi - increment/2 -- Adjust the angle to run through a range divisible into indexes
local compass_direction = function(p1, p2)
	local dir = vector.subtract(p2, p1)
	local angle = math.atan2(dir.z, dir.x);
	angle = angle + reframe
	angle = math.ceil(angle / increment)
	return compass_dirs[angle]
end

local get_altitude = function(pos)
	if pos.y > 100 then
		return S("highlands")
	elseif pos.y > 20 then
		return S("midlands")
	elseif pos.y > 0 then
		return S("lowlands")
	else
		-- TODO: need to update this system once there are underground settlements
		return S("waters")
	end
end

settlements.generate_travel_guide = function(source_pos, source_name)
	local range = math.random(settlements.min_dist_settlements*2, settlements.min_dist_settlements*5)
	local target = get_random_settlement_within_range(source_pos, range)
	if not target then
		return
	end
	local target_name = target.data.name
	local target_type = target.data.settlement_type
	local target_desc = S("settlement")
	if target_type then
		local def = settlements.registered_settlements[target_type]
		if def and def.description then
			target_desc = def.description
		end
	end

	local title = S("A travel guide to @1", target_name)
	local author = S("a resident of @1", source_name)

	local dir = compass_direction(source_pos, target.pos)
	local distance = vector.distance(source_pos, target.pos)
	local kilometers = string.format("%.1f", distance/1000)
	local altitude = get_altitude(target.pos)

	local text = S("In the @1 @2 kilometers to the @3 of @4 lies the @5 of @6.", altitude, kilometers, dir, source_name, target_desc, target_name)
	return generate_book(title, author, text)
end
