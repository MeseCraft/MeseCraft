-- internationalization boilerplate
local MP = minetest.get_modpath(minetest.get_current_modname())
local S, NS = dofile(MP.."/intllib.lua")

local function get_chute_formspec(pos)
	local spos = hopper.get_string_pos(pos)
	local formspec =
		"size[8,7]"
		.. hopper.formspec_bg
		.. "list[nodemeta:" .. spos .. ";main;3,0.3;2,2;]"
		.. hopper.get_eject_button_texts(pos, 7, 0.8)
		.. "list[current_player;main;0,2.85;8,1;]"
		.. "list[current_player;main;0,4.08;8,3;8]"
		.. "listring[nodemeta:" .. spos .. ";main]"
		.. "listring[current_player;main]"
	return formspec
end

minetest.register_node("hopper:chute", {
	description = S("Hopper Chute"),
	_doc_items_longdesc = hopper.doc.chute_long_desc,
    _doc_items_usagehelp = hopper.doc.chute_usage,
	drop = "hopper:chute",
	groups = {cracky = 3},
	sounds = hopper.metal_sounds,
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	tiles = {
		"hopper_bottom_" .. hopper.config.texture_resolution .. ".png^hopper_chute_arrow_" .. hopper.config.texture_resolution .. ".png",
		"hopper_bottom_" .. hopper.config.texture_resolution .. ".png^(hopper_chute_arrow_" .. hopper.config.texture_resolution .. ".png^[transformR180)",
		"hopper_bottom_" .. hopper.config.texture_resolution .. ".png^(hopper_chute_arrow_" .. hopper.config.texture_resolution .. ".png^[transformR270)",
		"hopper_bottom_" .. hopper.config.texture_resolution .. ".png^(hopper_chute_arrow_" .. hopper.config.texture_resolution .. ".png^[transformR90)",
		"hopper_top_" .. hopper.config.texture_resolution .. ".png",
		"hopper_bottom_" .. hopper.config.texture_resolution .. ".png"
	},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.3, -0.3, -0.3, 0.3, 0.3, 0.3},
			{-0.2, -0.2, 0.3, 0.2, 0.2, 0.7},
		},
	},
	
	on_construct = function(pos)
		local inv = minetest.get_meta(pos):get_inventory()
		inv:set_size("main", 2*2)
	end,

	on_place = function(itemstack, placer, pointed_thing, node_name)
		local pos  = pointed_thing.under
		local pos2 = pointed_thing.above
		local x = pos.x - pos2.x
		local z = pos.z - pos2.z

		local returned_stack, success = minetest.item_place_node(itemstack, placer, pointed_thing)
		if success then
			local meta = minetest.get_meta(pos2)
			meta:set_string("placer", placer:get_player_name())
		end
		return returned_stack
	end,
	
	can_dig = function(pos,player)
		local inv = minetest.get_meta(pos):get_inventory()
		return inv:is_empty("main")
	end,

	on_rightclick = function(pos, node, clicker, itemstack)
		if minetest.is_protected(pos, clicker:get_player_name()) and not minetest.check_player_privs(clicker, "protection_bypass") then
			return
		end
		minetest.show_formspec(clicker:get_player_name(),
			"hopper_formspec:"..minetest.pos_to_string(pos), get_chute_formspec(pos))
	end,

	on_metadata_inventory_put = function(pos, listname, index, stack, player)
		minetest.log("action", S("@1 moves stuff to chute at @2",
			player:get_player_name(), minetest.pos_to_string(pos)))

		local timer = minetest.get_node_timer(pos)
		if not timer:is_started() then
			timer:start(1)
		end		
	end,

	on_timer = function(pos, elapsed)
		local meta = minetest.get_meta(pos);
		local inv = meta:get_inventory()

		local node = minetest.get_node(pos)
		local dir = minetest.facedir_to_dir(node.param2)
		local destination_pos = vector.add(pos, dir)
		local output_direction
		if dir.y == 0 then
			output_direction = "horizontal"
		end
		
		local destination_node = minetest.get_node(destination_pos)
		local registered_inventories = hopper.get_registered_inventories_for(destination_node.name)
		if registered_inventories ~= nil then
			if output_direction == "horizontal" then
				hopper.send_item_to(pos, destination_pos, destination_node, registered_inventories["side"])
			else
				hopper.send_item_to(pos, destination_pos, destination_node, registered_inventories["bottom"])
			end
		else
			hopper.send_item_to(pos, destination_pos, destination_node)
		end
		
		if not inv:is_empty("main") then
			minetest.get_node_timer(pos):start(1)
		end
	end,
})