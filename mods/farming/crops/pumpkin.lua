
--[[
	Big thanks to PainterlyPack.net for allowing me to use these textures
]]

local S = farming.intllib

-- pumpkin slice
minetest.register_craftitem("farming:pumpkin_slice", {
	description = S("Pumpkin Slice"),
	inventory_image = "farming_pumpkin_slice.png",
	groups = {food_pumpkin_slice = 1, flammable = 2},
	on_place = function(itemstack, placer, pointed_thing)
		return farming.place_seed(itemstack, placer, pointed_thing, "farming:pumpkin_1")
	end,
	on_use = minetest.item_eat(2),
})

minetest.register_craft({
	output = "farming:pumpkin",
	recipe = {
		{"farming:pumpkin_slice", "farming:pumpkin_slice"},
	}
})

minetest.register_craft({
	type = "shapeless",
	output = "farming:pumpkin_slice 4",
	recipe = {"farming:pumpkin", "farming:cutting_board"},
	replacements = {{"farming:cutting_board", "farming:cutting_board"}},
})

-- jack 'o lantern
minetest.register_node("farming:jackolantern", {
	description = S("Jack 'O Lantern (punch to turn on and off)"),
	tiles = {
		"farming_pumpkin_top.png",
		"farming_pumpkin_top.png",
		"farming_pumpkin_side.png",
		"farming_pumpkin_side.png",
		"farming_pumpkin_side.png",
		"farming_pumpkin_face_off.png"
	},
	paramtype2 = "facedir",
	groups = {choppy = 1, oddly_breakable_by_hand = 1, flammable = 2},
	sounds = default.node_sound_wood_defaults(),
	on_punch = function(pos, node, puncher)
		local name = puncher:get_player_name() or ""
		if minetest.is_protected(pos, name) then return end
		node.name = "farming:jackolantern_on"
		minetest.swap_node(pos, node)
	end,
})

minetest.register_node("farming:jackolantern_on", {
	tiles = {
		"farming_pumpkin_top.png",
		"farming_pumpkin_top.png",
		"farming_pumpkin_side.png",
		"farming_pumpkin_side.png",
		"farming_pumpkin_side.png",
		"farming_pumpkin_face_on.png"
	},
	light_source = default.LIGHT_MAX - 1,
	paramtype2 = "facedir",
	groups = {
		choppy = 1, oddly_breakable_by_hand = 1, flammable = 2,
		not_in_creative_inventory = 1
	},
	sounds = default.node_sound_wood_defaults(),
	drop = "farming:jackolantern",
	on_punch = function(pos, node, puncher)
		local name = puncher:get_player_name() or ""
		if minetest.is_protected(pos, name) then return end
		node.name = "farming:jackolantern"
		minetest.swap_node(pos, node)
	end,
})

minetest.register_craft({
	output = "farming:jackolantern",
	recipe = {
		{"ethereal:candle"},
		{"group:food_pumpkin"},
	}
})

-- pumpkin bread
minetest.register_craftitem("farming:pumpkin_bread", {
	description = S("Pumpkin Bread"),
	inventory_image = "farming_pumpkin_bread.png",
	on_use = minetest.item_eat(8),
	groups = {food_bread = 1, flammable = 2},
})

minetest.register_craftitem("farming:pumpkin_dough", {
	description = S("Pumpkin Dough"),
	inventory_image = "farming_pumpkin_dough.png",
})

minetest.register_craft({
	output = "farming:pumpkin_dough",
	type = "shapeless",
	recipe = {"group:food_flour", "group:food_pumpkin_slice", "group:food_pumpkin_slice"}
})

minetest.register_craft({
	type = "cooking",
	output = "farming:pumpkin_bread",
	recipe = "farming:pumpkin_dough",
	cooktime = 10
})

-- pumpkin definition
local crop_def = {
	drawtype = "plantlike",
	tiles = {"farming_pumpkin_1.png"},
	paramtype = "light",
	sunlight_propagates = true,
	waving = 1,
	walkable = false,
	buildable_to = true,
	drop = "",
	selection_box = farming.select,
	groups = {
		snappy = 3, flammable = 2, plant = 1, attached_node = 1,
		not_in_creative_inventory = 1, growing = 1
	},
	sounds = default.node_sound_leaves_defaults()
}

-- stage 1
minetest.register_node("farming:pumpkin_1", table.copy(crop_def))

-- stage 2
crop_def.tiles = {"farming_pumpkin_2.png"}
minetest.register_node("farming:pumpkin_2", table.copy(crop_def))

-- stage 3
crop_def.tiles = {"farming_pumpkin_3.png"}
minetest.register_node("farming:pumpkin_3", table.copy(crop_def))

-- stage 4
crop_def.tiles = {"farming_pumpkin_4.png"}
minetest.register_node("farming:pumpkin_4", table.copy(crop_def))

-- stage 5
crop_def.tiles = {"farming_pumpkin_5.png"}
minetest.register_node("farming:pumpkin_5", table.copy(crop_def))

-- stage 6
crop_def.tiles = {"farming_pumpkin_6.png"}
minetest.register_node("farming:pumpkin_6", table.copy(crop_def))

-- stage 7
crop_def.tiles = {"farming_pumpkin_7.png"}
minetest.register_node("farming:pumpkin_7", table.copy(crop_def))

-- stage 8 (final)
--[[
crop_def.tiles = {"farming_pumpkin_8.png"}
crop_def.groups.growing = 0
crop_def.drop = {
	items = {
		{items = {'farming:pumpkin_slice 9'}, rarity = 1},
	}
}
minetest.register_node("farming:pumpkin_8", table.copy(crop_def))
]]

minetest.register_node("farming:pumpkin_8", {
	description = S("Pumpkin"),
	tiles = {
		"farming_pumpkin_top.png",
		"farming_pumpkin_top.png",
		"farming_pumpkin_side.png"
	},
	groups = {
		food_pumpkin = 1, choppy = 1, oddly_breakable_by_hand = 1,
		flammable = 2, plant = 1
	},
	sounds = default.node_sound_wood_defaults(),
})

minetest.register_alias("farming:pumpkin", "farming:pumpkin_8")

-- add to registered_plants
farming.registered_plants["farming:pumpkin"] = {
	crop = "farming:pumpkin",
	seed = "farming:pumpkin_slice",
	minlight = 13,
	maxlight = 15,
	steps = 8
}
