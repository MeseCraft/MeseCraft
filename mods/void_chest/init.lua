minetest.register_node("void_chest:void_chest", {
	description = "Void Chest",
	tiles = {"void_top.png", "void_top.png", "void_side.png",
		"void_side.png", "void_side.png", "void_front.png"},
	paramtype2 = "facedir",
	groups = {snappy=2, choppy=2, oddly_breakable_by_hand=2,},
	legacy_facedir_simple = true,
	sounds = default.node_sound_wood_defaults(),
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec",
				"size[8,9]"..
				default.gui_bg ..
				default.gui_bg_img ..
				default.gui_slots ..
				"list[current_player;void_chest:void_chest;0,0.3;8,4;]"..
				"list[current_player;main;0,4.85;8,1;]" ..
				"list[current_player;main;0,6.08;8,3;8]" ..
				"listring[current_player;void_chest:void_chest]" ..
				"listring[current_player;main]" ..
				default.get_hotbar_bg(0,4.85))

		meta:set_string("infotext", "Void Chest")
	end,
	on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		minetest.log("action", player:get_player_name()..
				" moves stuff in void chest at "..minetest.pos_to_string(pos))
	end,
    on_metadata_inventory_put = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
				" moves stuff to void chest at "..minetest.pos_to_string(pos))
	end,
    on_metadata_inventory_take = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
				" takes stuff from void chest at "..minetest.pos_to_string(pos))
	end,
})

minetest.register_craft({
	output = 'void_chest:void_chest',
	recipe = {
		{'default:steelblock','default:obsidian','default:steelblock'},
		{'default:obsidian','magic_materials:void_rune','default:obsidian'},
		{'default:steelblock','default:obsidian','default:steelblock'}
	}
})

minetest.register_on_joinplayer(function(player)
	local inv = player:get_inventory()
	inv:set_size("void_chest:void_chest", 8*4)
end)

