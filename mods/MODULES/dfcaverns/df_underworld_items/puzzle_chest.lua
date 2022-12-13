local S = minetest.get_translator(minetest.get_current_modname())

local sum_square = function(input)
	return {input[1] + input[2], input[3] + input[4], input[1] + input[3], input[2] + input[4]}
end

local initialize = function(pos, meta)
	if not meta:contains("key") then
		local inv = meta:get_inventory()
		inv:set_size("main", 8)		
		local next_seed = math.random() * 2^21
		math.randomseed(pos.x + pos.y^8 + pos.z^16)
		-- Key is consistent with location
		local key = {math.random(0,7), math.random(0,7), math.random(0,7), math.random(0,7)}
		math.randomseed(next_seed)
		local state = {math.random(0,7), math.random(0,7), math.random(0,7), math.random(0,7)}
		local key_sum = sum_square(key)
		local state_sum = sum_square(state)
		if (key_sum[1] == state_sum[1] and key_sum[2] == state_sum[2] and key_sum[3] == state_sum[3] and key_sum[4] == state_sum[4]) then
			-- if we randomly start off solved change one of the states to make it unsolved.
			-- lucky player gets an easy one.
			state[1] = (state[1] + 1) % 8
		end
		meta:set_string("key", minetest.serialize(key))
		meta:set_string("state", minetest.serialize(state))
		meta:mark_as_private("key")
		meta:mark_as_private("state") -- not really necessary, but for consistency
	end
end

-- 1 2
-- 3 4

local formspec_dial = function(identifier, state)
	return "image[0.5,0;2,1;dfcaverns_chest_dial_"..tostring(state)..".png]"
		.. "button[0,0.25;0.5,0.5;"..identifier.."+;<]"
		.. "button[2.5,0.25;0.5,0.5;"..identifier.."-;>]"
end

local formspec_bar = function(horizontal, state, key)
	if horizontal then
		return "box[0,0;".. tostring(key/14 * 2 + 0.1) ..",1;#222222ff]box[0.1,0.1;".. tostring(state/14 * 2)..",0.85;#ff00ff44]"
	end
	return "box[0,0;1,".. tostring(key/14 * 2 + 0.1) ..";#222222ff]box[0.1,0.1;0.85,".. tostring(state/14 * 2)..";#ff00ff44]"
end

local prefix = "df_underworld_items:puzzle_chest"
local prefix_len = string.len("df_underworld_items:puzzle_chest")

local itemslot_bg = df_dependencies.get_itemslot_bg_padded

local show_formspec = function(pos, node, clicker, itemstack, pointed_thing)
	local meta = minetest.get_meta(pos)
	initialize(pos, meta)
	local key = minetest.deserialize(meta:get_string("key"))
	local state = minetest.deserialize(meta:get_string("state"))
	local key_sum = sum_square(key)
	local state_sum = sum_square(state)
	local solved = key_sum[1] == state_sum[1] and key_sum[2] == state_sum[2] and key_sum[3] == state_sum[3] and key_sum[4] == state_sum[4]
	local playername = clicker:get_player_name()
	local formname = prefix .. minetest.pos_to_string(pos)
	local formspec = "formspec_version[6]"
		.. "size[11,12]"
		.. "container[1.5,0.5]"
		.. "container[0,0]" .. formspec_dial("dial1", state[1]) .. "container_end[]"
		.. "container[3,0]" .. formspec_dial("dial2", state[2]) .. "container_end[]"
		.. "container[0,1.5]" .. formspec_dial("dial3", state[3]) .. "container_end[]"
		.. "container[3,1.5]" .. formspec_dial("dial4", state[4]) .. "container_end[]"
		.. "container[6.1,0]" .. formspec_bar(true, state_sum[1], key_sum[1]) .. "container_end[]"		
		.. "container[6.1,1.5]" .. formspec_bar(true, state_sum[2], key_sum[2]) .. "container_end[]"		
		.. "container[1,2.75]" .. formspec_bar(false, state_sum[3], key_sum[3]) .. "container_end[]"		
		.. "container[4,2.75]" .. formspec_bar(false, state_sum[4], key_sum[4]) .. "container_end[]"
		.. "container_end[]"
		.. itemslot_bg(0.6,6.7,8,4,0.25)
		.. "list[current_player;main;0.6,6.7;8,4;]"
	if solved then
		local nodemeta = "nodemeta:"..pos.x..","..pos.y..","..pos.z
		formspec = formspec
			.. itemslot_bg(0.6,5.4,8,1,0.25)
			.. "list["..nodemeta..";main;0.6,5.4;8,1;]"
			.. "listring[]"
		if meta:get_string("solved") ~= "true" then
			minetest.sound_play("dfcaverns_puzzle_chest_open", {pos = pos})
			meta:set_string("solved", "true")
			local old_node = minetest.get_node(pos)
			minetest.swap_node(pos, {name="df_underworld_items:puzzle_chest_opened", param2=old_node.param2})
		end
	elseif meta:get_string("solved") == "true" then
		minetest.sound_play("dfcaverns_puzzle_chest_close", {pos = pos})
		meta:set_string("solved", "")
		local old_node = minetest.get_node(pos)
		minetest.swap_node(pos, {name="df_underworld_items:puzzle_chest_closed", param2=old_node.param2})
	end

	minetest.show_formspec(playername, formname, formspec)
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if string.sub(formname, 1, prefix_len) ~= prefix then return end
	if fields.quit then return end
	local pos = minetest.string_to_pos(string.sub(formname, prefix_len+1, -1))
	local meta = minetest.get_meta(pos)
	local state = minetest.deserialize(meta:get_string("state"))
	for i = 1,4 do
		if fields["dial"..tostring(i).."+"] then
			state[i] = (state[i] + 1) % 8
			break
		elseif fields["dial"..tostring(i).."-"] then
			state[i] = (state[i] - 1) % 8
			break
		end
	end
	meta:set_string("state", minetest.serialize(state))
	show_formspec(pos, nil, player)
end)

local puzzle_chest_can_dig = function(pos, player)
	local meta = minetest.get_meta(pos)
	initialize(pos, meta)
	local inv = meta:get_inventory()
	return inv:is_empty("main")
end

minetest.register_node("df_underworld_items:puzzle_chest_closed", {
	description = S("Puzzle Chest"),
	_doc_items_longdesc = df_underworld_items.doc.puzzle_chest_desc,
	_doc_items_usagehelp = df_underworld_items.doc.puzzle_chest_usage,
	tiles = {
		"dfcaverns_slade_block.png^dfcaverns_chest_mask_top.png",
		"dfcaverns_slade_block.png^dfcaverns_chest_mask_top.png",
		"dfcaverns_slade_block.png^dfcaverns_chest_mask_side.png",
		"dfcaverns_slade_block.png^dfcaverns_chest_mask_side.png",
		"dfcaverns_slade_block.png^dfcaverns_chest_mask_side.png",
		"dfcaverns_slade_block.png^dfcaverns_chest_mask_side.png^dfcaverns_chest_lock_plate.png^dfcaverns_chest_lock_colours.png",
	},
	paramtype2="facedir",
	is_ground_content = false,
	groups = {stone=1, slade=1, pit_plasma_resistant=1, mese_radiation_shield=1, cracky = 3, building_block=1, material_stone=1},
	sounds = df_dependencies.sound_stone({ footstep = { name = "bedrock2_step", gain = 1 } }),
	_mcl_blast_resistance = 1200,
	_mcl_hardness = 50,
	
	on_rightclick = show_formspec,
	can_dig = puzzle_chest_can_dig,
})

minetest.register_node("df_underworld_items:puzzle_chest_opened", {
	description = S("Puzzle Chest"),
	_doc_items_longdesc = df_underworld_items.doc.puzzle_chest_desc,
	_doc_items_usagehelp = df_underworld_items.doc.puzzle_chest_usage,
	tiles = {
		{name = "dfcaverns_slade_block.png^dfcaverns_chest_mask_top.png", backface_culling = true},
		{name = "dfcaverns_slade_block.png^dfcaverns_chest_mask_top.png", backface_culling = true},
		{name = "dfcaverns_slade_block.png^dfcaverns_chest_mask_side.png", backface_culling = true},
		{name = "dfcaverns_slade_block.png^dfcaverns_chest_mask_side.png", backface_culling = true},
		{name = "dfcaverns_slade_block.png^dfcaverns_chest_mask_side.png^dfcaverns_chest_lock_plate.png^dfcaverns_chest_lock_colours.png", backface_culling = true},
		{name = "([combine:16x32:0,0=dfcaverns_slade_block.png:0,16=dfcaverns_slade_block.png)^dfcaverns_chest_mask_interior.png", backface_culling = true},
	},
	is_ground_content = false,
	mesh = "dfcaverns_chest_open.obj",
	drawtype= "mesh",
	visual = "mesh",
	paramtype2="facedir",
	groups = {stone=1, slade=1, pit_plasma_resistant=1, mese_radiation_shield=1, cracky = 3, building_block=1, material_stone=1, not_in_creative_inventory=1},
	drop = "df_underworld_items:puzzle_chest_closed",
	sounds = df_dependencies.sound_stone({ footstep = { name = "bedrock2_step", gain = 1 } }),
	_mcl_blast_resistance = 1200,
	_mcl_hardness = 50,
	
	on_rightclick = show_formspec,
	can_dig = puzzle_chest_can_dig,
})
