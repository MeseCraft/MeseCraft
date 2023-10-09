local S = minetest.get_translator("mesecraft_mobs")

-- raw meat from mobs_redo
minetest.register_craftitem("mesecraft_mobs:meat", {
	description = S("Meat"),
	inventory_image = "mesecraft_mobs_items_meat.png",
	on_use = minetest.item_eat(3),
	groups = {food_meat_raw = 1, flammable = 2}
})

-- cooked meat from mobs_redo
minetest.register_craftitem("mesecraft_mobs:meat_cooked", {
	description = S("Cooked Meat"),
	inventory_image = "mesecraft_mobs_items_meat_cooked.png",
	on_use = minetest.item_eat(8),
	groups = {food_meat = 1, flammable = 2}
})

minetest.register_craft({
	type = "cooking",
	output = "mesecraft_mobs:meat_cooked",
	recipe = "mesecraft_mobs:meat",
	cooktime = 5
})