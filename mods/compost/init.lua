--File name: init.lua
--Project name: compost, a Mod for Minetest
--License: General Public License, version 3 or later
--Original Work Copyright (C) 2016 cd2 (cdqwertz) <cdqwertz@gmail.com>
--Modified Work Copyright (C) Vitalie Ciubotaru <vitalie at ciubotaru dot tk>

-- Load support for intllib.
local MP = minetest.get_modpath(minetest.get_current_modname())
local S, NS = dofile(MP.."/intllib.lua")

minetest.log('action', 'MOD: Compost ' .. S("loading..."))
compost_version = '0.0.3'

compost = {}
compost.compostable_groups = {'flora', 'leaves', 'flower'}
compost.compostable_nodes = {
	'default:cactus',
	'default:papyrus',
	'default:dry_shrub',
	'default:junglegrass',
	'default:grass_1',
	'default:dry_grass_1',
	'farming:wheat',
	'farming:straw',
	'farming:cotton',
}
compost.compostable_items = {}
for _, v in pairs(compost.compostable_nodes) do
	compost.compostable_items[v] = true
end

local function formspec(pos)
	local spos = pos.x..','..pos.y..','..pos.z
	local formspec =
		'size[8,8.5]'..
		default.gui_bg..
		default.gui_bg_img..
		default.gui_slots..
		'list[nodemeta:'..spos..';src;0,0;8,1;]'..
		'list[nodemeta:'..spos..';dst;3.5,2;1,1;]'..
		'list[current_player;main;0,4.25;8,1;]'..
		'list[current_player;main;0,5.5;8,3;8]'..
		'listring[nodemeta:'..spos ..';dst]'..
		'listring[current_player;main]'..
		'listring[nodemeta:'..spos ..';src]'..
		'listring[current_player;main]'..
		default.get_hotbar_bg(0, 4.25)
	return formspec
end

local function is_compostable(input)
	if compost.compostable_items[input] then
		return true
	end
	for _, v in pairs(compost.compostable_groups) do
		if minetest.get_item_group(input, v) > 0 then
			return true
		end
	end
	return false
end

local function swap_node(pos, name)
	local node = minetest.get_node(pos)
	if node.name == name then
		return
	end
	node.name = name
	minetest.swap_node(pos, node)
end

local function count_input(pos)
	local q = 0
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	local stacks = inv:get_list('src')
	for k in pairs(stacks) do
		q = q + inv:get_stack('src', k):get_count()
	end
	return q
end

local function is_empty(pos)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	local stacks = inv:get_list('src')
	for k in pairs(stacks) do
		if not inv:get_stack('src', k):is_empty() then
			return false
		end
	end
	if not inv:get_stack('dst', 1):is_empty() then
		return false
	end
	return true
end

local function update_nodebox(pos)
	if is_empty(pos) then
		swap_node(pos, "compost:wood_barrel_empty")
	else
		swap_node(pos, "compost:wood_barrel")
	end
end

local function update_timer(pos)
	local timer = minetest.get_node_timer(pos)
	local meta = minetest.get_meta(pos)
	local count = count_input(pos)
	if not timer:is_started() and count >= 8 then
		timer:start(30)
		meta:set_int('Progress', 0)
		meta:set_string('infotext', S("progress: @1%", "0"))
		return
	end
	if timer:is_started() and count < 8 then
		timer:stop()
		meta:set_string('infotext', S("To start composting, place some organic matter inside."))
		meta:set_int('progress', 0)
	end
end

local function create_compost(pos)
	local q = 8
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	local stacks = inv:get_list('src')
	for k in pairs(stacks) do
		local stack = inv:get_stack('src', k)
		if not stack:is_empty() then
			local count = stack:get_count()
			if count <= q then
				inv:set_stack('src', k, '')
				q = q - count
			else
				inv:set_stack('src', k, stack:get_name() .. ' ' .. (count - q))
				q = 0
				break
			end
		end
	end
	local dirt_count = inv:get_stack('dst', 1):get_count()
	inv:set_stack('dst', 1, 'default:dirt ' .. (dirt_count + 1))
end

local function on_timer(pos)
	local timer = minetest.get_node_timer(pos)
	local meta = minetest.get_meta(pos)
	local progress = meta:get_int('progress') + 10
	if progress >= 100 then
		create_compost(pos)
		meta:set_int('progress', 0)
	else
		meta:set_int('progress', progress)
	end
	if count_input(pos) >= 8 then
		meta:set_string('infotext', S("progress: @1%", progress))
		return true
	else
		timer:stop()
		meta:set_string('infotext', S("To start composting, place some organic matter inside."))
		meta:set_int('progress', 0)
		return false
	end
end

local function on_construct(pos)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	inv:set_size('src', 8)
	inv:set_size('dst', 1)
	meta:set_string('infotext', S("To start composting, place some organic matter inside."))
	meta:set_int('progress', 0)
end

local function on_rightclick(pos, node, clicker, itemstack)
	minetest.show_formspec(
		clicker:get_player_name(),
		'compost:wood_barrel',
		formspec(pos)
	)
end

local function can_dig(pos,player)
	local meta = minetest.get_meta(pos)
	local inv  = meta:get_inventory()
	if inv:is_empty('src') and inv:is_empty('dst') then
		return true
	else
		return false
	end
end

local function allow_metadata_inventory_put(pos, listname, index, stack, player)
	if listname == 'src' and is_compostable(stack:get_name()) then
		return stack:get_count()
	else
		return 0
	end
end

local function on_metadata_inventory_put(pos, listname, index, stack, player)
	update_timer(pos)
	update_nodebox(pos)
	minetest.log('action', player:get_player_name() .. S(" moves stuff to compost bin at ") .. minetest.pos_to_string(pos))
	return
end

local function on_metadata_inventory_take(pos, listname, index, stack, player)
	update_timer(pos)
	update_nodebox(pos)
	minetest.log('action', player:get_player_name() .. S(" takes stuff from compost bin at ") .. minetest.pos_to_string(pos))
	return
end

local function allow_metadata_inventory_move(pos, from_list, from_index, to_list, to_index, count, player)
	local inv = minetest.get_meta(pos):get_inventory()
	if from_list == to_list then
		return inv:get_stack(from_list, from_index):get_count()
	else
		return 0
	end
end

local function on_punch(pos, node, player, pointed_thing)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	local wielded_item = player:get_wielded_item()
	if not wielded_item:is_empty() then
		local wielded_item_name = wielded_item:get_name()
		local wielded_item_count = wielded_item:get_count()
		if is_compostable(wielded_item_name) and inv:room_for_item('src', wielded_item_name) then
			player:set_wielded_item('')
			inv:add_item('src', wielded_item_name .. ' ' .. wielded_item_count)
			minetest.log('action', player:get_player_name() .. S(" moves stuff to compost bin at ") .. minetest.pos_to_string(pos))
			update_nodebox(pos)
			update_timer(pos)
		end
	end
	local compost_count = inv:get_stack('dst', 1):get_count()
	local wielded_item = player:get_wielded_item() --recheck
	if compost_count > 0 and wielded_item:is_empty() then
		inv:set_stack('dst', 1, '')
		player:set_wielded_item('default:dirt ' .. compost_count)
		minetest.log('action', player:get_player_name() .. S(" takes stuff from compost bin at ") .. minetest.pos_to_string(pos))
		update_nodebox(pos)
		update_timer(pos)
	end
end

minetest.register_node("compost:wood_barrel_empty", {
	description = S("Empty Compost Bin"),
	tiles = {
		"default_wood.png",
	},
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {{-1/2, -1/2, -1/2, 1/2, -3/8, 1/2},
			{-1/2, -1/2, -1/2, -3/8, 1/2, 1/2},
			{3/8, -1/2, -1/2, 1/2, 1/2, 1/2},
			{-1/2, -1/2, -1/2, 1/2, 1/2, -3/8},
			{-1/2, -1/2, 3/8, 1/2, 1/2, 1/2}},
	},
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}
	},
	paramtype = "light",
	is_ground_content = false,
	groups = {choppy = 3},
	sounds =  default.node_sound_wood_defaults(),
	on_timer = on_timer,
	on_construct = on_construct,
	on_rightclick = on_rightclick,
	can_dig = can_dig,
	allow_metadata_inventory_put = allow_metadata_inventory_put,
	allow_metadata_inventory_move = allow_metadata_inventory_move,
	on_metadata_inventory_put = on_metadata_inventory_put,
	on_metadata_inventory_take = on_metadata_inventory_take,
	on_punch = on_punch,
})

minetest.register_node("compost:wood_barrel", {
	description = S("Compost Bin"),
	tiles = {
		"default_wood.png^compost_compost.png",
		"default_wood.png",
	},
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {{-1/2, -1/2, -1/2, 1/2, -3/8, 1/2},
			{-1/2, -1/2, -1/2, -3/8, 1/2, 1/2},
			{3/8, -1/2, -1/2, 1/2, 1/2, 1/2},
			{-1/2, -1/2, -1/2, 1/2, 1/2, -3/8},
			{-1/2, -1/2, 3/8, 1/2, 1/2, 1/2},
			{-3/8, -1/2, -3/8, 3/8, 3/8, 3/8}},
	},
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}
	},
	paramtype = "light",
	is_ground_content = false,
	groups = {choppy = 3, not_in_creative_inventory = 1},
	sounds =  default.node_sound_wood_defaults(),
	on_timer = on_timer,
	on_construct = on_construct,
	on_rightclick = on_rightclick,
	can_dig = can_dig,
	allow_metadata_inventory_put = allow_metadata_inventory_put,
	allow_metadata_inventory_move = allow_metadata_inventory_move,
	on_metadata_inventory_put = on_metadata_inventory_put,
	on_metadata_inventory_take = on_metadata_inventory_take,
	on_punch = on_punch,
})

minetest.register_craft({
	output = "compost:wood_barrel_empty",
	recipe = {
		{"group:wood", "", "group:wood"},
		{"group:wood", "", "group:wood"},
		{"group:wood", "stairs:slab_wood", "group:wood"}
	}
})

minetest.log('action', "MOD: Compost version " .. compost_version .. S(" loaded."))
