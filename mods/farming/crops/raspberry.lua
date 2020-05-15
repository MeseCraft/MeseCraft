
local S = farming.intllib

-- raspberries
minetest.register_craftitem("farming:raspberries", {
	description = S("Raspberries"),
	inventory_image = "farming_raspberries.png",
	groups = {food_raspberries = 1, food_raspberry = 1, food_berry = 1, flammable = 2},
	on_place = function(itemstack, placer, pointed_thing)
		return farming.place_seed(itemstack, placer, pointed_thing, "farming:raspberry_1")
	end,
	on_use = minetest.item_eat(1),
})

-- raspberries definition
local crop_def = {
	drawtype = "plantlike",
	tiles = {"farming_raspberry_1.png"},
	paramtype = "light",
	sunlight_propagates = true,
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
minetest.register_node("farming:raspberry_1", table.copy(crop_def))

-- stage 2
crop_def.tiles = {"farming_raspberry_2.png"}
minetest.register_node("farming:raspberry_2", table.copy(crop_def))

-- stage 3
crop_def.tiles = {"farming_raspberry_3.png"}
minetest.register_node("farming:raspberry_3", table.copy(crop_def))

-- stage 4 (final)
crop_def.tiles = {"farming_raspberry_4.png"}
crop_def.groups.growing = 0
crop_def.drop = {
	items = {
		{items = {'farming:raspberries 2'}, rarity = 1},
		{items = {'farming:raspberries'}, rarity = 2},
		{items = {'farming:raspberries'}, rarity = 3},
	}
}
minetest.register_node("farming:raspberry_4", table.copy(crop_def))

-- add to registered_plants
farming.registered_plants["farming:raspberries"] = {
	crop = "farming:raspberry",
	seed = "farming:raspberries",
	minlight = 13,
	maxlight = 15,
	steps = 4
}
