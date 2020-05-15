
minetest.register_node("castle:dungeon_stone", {
	description = "Dungeon Stone",
	drawtype = "normal",
	tiles = {"castle_dungeon_stone.png"},
	groups = {cracky = 2},
	paramtype = "light",
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_craft({
	type = "shapeless",
	output = "castle:dungeon_stone",
	recipe = {"default:stonebrick", "default:obsidian"},
})

minetest.register_node("castle:crate", {
	description = "Crate",
	drawtype = "normal",
	tiles = {
		"castle_crate_top.png", "castle_crate_top.png",
		"castle_crate.png", "castle_crate.png",
		"castle_crate.png", "castle_crate.png"},
	groups = {choppy = 3},
	paramtype = "light",
	sounds = default.node_sound_wood_defaults(),

	on_construct = function(pos)

		local meta = minetest.get_meta(pos)

		meta:set_string("formspec", "size[8,9]"
			.. default.gui_bg
			.. default.gui_bg_img
			.. default.gui_slots
			.. "list[current_name;main;0,1;8,4;]"
			.. "list[current_player;main;0,5;8,4;]"
			.. "listring[]")

		meta:set_string("infotext", "Crate")

		local inv = meta:get_inventory()

		inv:set_size("main", 8 * 3)
	end,

	can_dig = function(pos,player)

		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()

		return inv:is_empty("main")
	end,
})

minetest.register_craft({
	output = "castle:crate",
	recipe = {
		{"group:wood", "group:wood", "group:wood"},
		{"group:wood", "default:steel_ingot", "group:wood"},
	}
})
