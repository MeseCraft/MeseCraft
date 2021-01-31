local mailbox = {}
screwdriver = screwdriver or {}

local function get_img(img)
	local img_name = img:match("(.*)%.png")
	if img_name then return img_name..".png" end
end

local function img_col(stack)
	local def = minetest.registered_items[stack]
	if not def then return "" end

	if def.inventory_image ~= "" then
		local img = get_img(def.inventory_image)
		if img then return img end
	end

	if def.tiles then
		local tile, img = def.tiles[1]
		if type(tile) == "table" then
			img = get_img(tile.name)
		elseif type(tile) == "string" then
			img = get_img(tile)
		end
		if img then return img end
	end

	return ""
end

function mailbox:formspec(pos, owner, is_owner)
	local spos = pos.x..","..pos.y..","..pos.z
	local meta = minetest.get_meta(pos)
	local giver, img = "", ""

	if is_owner then
		for i = 1, 7 do
			local giving = meta:get_string("giver"..i)
			if giving ~= "" then
				local stack = meta:get_string("stack"..i)
				local giver_name = giving:sub(1,12)
				local stack_name = stack:match("[%w_:]+")
				local stack_count = stack:match("%s(%d+)") or 1

				giver = giver.."#FFFF00,"..giver_name..","..i..
					",#FFFFFF,x "..stack_count..","
				img = img..i.."="..
					img_col(stack_name).."^\\[resize:16x16,"
			end
		end

		return [[ size[9.5,9]
			label[0,0;Mailbox]
			label[6,0;Last donators]
			box[6,0.72;3.3,3.5;#555555]
			listring[current_player;main]
			list[current_player;main;0.75,5.25;8,4;]
			tableoptions[background=#00000000;highlight=#00000000;border=false] ]]..
			"tablecolumns[color;text;image,"..img.."0;color;text]"..
			"table[6,0.75;3.3,4;givers;"..giver.."]"..
			"list[nodemeta:"..spos..";mailbox;0,0.75;6,4;]"..
			"listring[nodemeta:"..spos..";mailbox]"..
			xbg..default.get_hotbar_bg(0.75,5.25)
	end
	return [[ size[8,5]
		list[current_player;main;0,1.25;8,4;] ]]..
		"label[0,0;Send your goods to\n"..
		(minetest.colorize and
			minetest.colorize("#FFFF00", owner) or owner).."]"..
		"list[nodemeta:"..spos..";drop;3.5,0;1,1;]"..
		xbg..default.get_hotbar_bg(0,1.25)
end

function mailbox.dig(pos, player)
	local meta = minetest.get_meta(pos)
	local owner = meta:get_string("owner")
	local player_name = player and player:get_player_name()
	local inv = meta:get_inventory()

	return inv:is_empty("mailbox") and player_name == owner
end

function mailbox.after_place_node(pos, placer)
	local meta = minetest.get_meta(pos)
	local player_name = placer:get_player_name()

	meta:set_string("owner", player_name)
	meta:set_string("infotext", player_name.."'s Mailbox")

	local inv = meta:get_inventory()
	inv:set_size("mailbox", 6*4)
	inv:set_size("drop", 1)
end

function mailbox.rightclick(pos, node, clicker, itemstack, pointed_thing)
	local meta = minetest.get_meta(pos)
	local player = clicker:get_player_name()
	local owner = meta:get_string("owner")

	minetest.show_formspec(player, "xdecor:mailbox", mailbox:formspec(pos,
			       owner, (player == owner)))
	return itemstack
end

function mailbox.put(pos, listname, _, stack, player)
	if listname == "drop" then
		local inv = minetest.get_meta(pos):get_inventory()
		if inv:room_for_item("mailbox", stack) then
			return -1
		else
			minetest.chat_send_player(player:get_player_name(),
						  "The mailbox is full")
		end
	end
	return 0
end

function mailbox.on_put(pos, listname, _, stack, player)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()

	if listname == "drop" and inv:room_for_item("mailbox", stack) then
		inv:set_list("drop", {})
		inv:add_item("mailbox", stack)

		for i = 7, 2, -1 do
			meta:set_string("giver"..i, meta:get_string("giver"..(i-1)))
			meta:set_string("stack"..i, meta:get_string("stack"..(i-1)))
		end

		meta:set_string("giver1", player:get_player_name())
		meta:set_string("stack1", stack:to_string())
	end
end

function mailbox.allow_take(pos, listname, index, stack, player)
	local meta = minetest.get_meta(pos)

	if player:get_player_name() ~= meta:get_string("owner") then
		return 0
	end
	return stack:get_count()
end

function mailbox.allow_move(pos)
	return 0
end

xdecor.register("mailbox", {
	description = "Mailbox",
	tiles = {"xdecor_mailbox_top.png", "xdecor_mailbox_bottom.png",
		 "xdecor_mailbox_side.png", "xdecor_mailbox_side.png",
		 "xdecor_mailbox.png", "xdecor_mailbox.png"},
	groups = {cracky=3, oddly_breakable_by_hand=1},
	on_rotate = screwdriver.rotate_simple,
	can_dig = mailbox.dig,
	on_rightclick = mailbox.rightclick,
	allow_metadata_inventory_take = mailbox.allow_take,
	allow_metadata_inventory_move = mailbox.allow_move,
	on_metadata_inventory_put = mailbox.on_put,
	allow_metadata_inventory_put = mailbox.put,
	after_place_node = mailbox.after_place_node
})

-- Recipes

minetest.register_craft({
	output = "xdecor:mailbox",
	recipe = {
		{"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"},
		{"dye:red", "default:paper", "dye:red"},
		{"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"}
	}
})