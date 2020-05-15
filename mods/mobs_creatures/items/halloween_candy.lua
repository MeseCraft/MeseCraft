--[[ Candy ]]--

-- Candy base
minetest.register_craftitem("mobs_creatures:caramelized_sugar", {
    description = "Caramelized Sugar",
    inventory_image = "mobs_creatures_items_halloween_caramelized_sugar.png",
})

minetest.register_craft({
    type = "cooking",
    output = "mobs_creatures:caramelized_sugar",
    recipe = "farming:sugar",
    cooktime = 14,
})

-- Candies
minetest.register_craftitem("mobs_creatures:candycorn", {
    description = "Candycorn",
    inventory_image = "mobs_creatures_items_halloween_candycorn.png",
    on_use = minetest.item_eat(3),
})

minetest.register_craft({
    type = "shapeless",
    output = "mobs_creatures:candycorn 3",
    recipe = {"mobs_creatures:caramelized_sugar", "dye:orange", "dye:yellow", "dye:white"},
})

minetest.register_craftitem("mobs_creatures:halloween_chocolate", {
    description = "Halloween Chocolate",
    inventory_image = "mobs_creatures_items_halloween_chocolate.png",
    on_use = minetest.item_eat(5),
})

minetest.register_craft({
    type = "shapeless",
    output = "mobs_creatures:halloween_chocolate",
    recipe = {"mobs_creatures:caramelized_sugar", "farming:chocolate_dark", "dye:orange", "default:paper"},
})

minetest.register_craftitem("mobs_creatures:lolipop", {
	description = "Lolipop",
	inventory_image = "mobs_creatures_items_halloween_lolipop.png",
	on_use = minetest.item_eat(2),
})

minetest.register_craft({
	output = "mobs_creatures:lolipop 2",
	recipe = {
		{"", "dye:orange", ""},
		{"default:paper", "mobs_creatures:caramelized_sugar", "default:paper"},
		{"", "default:stick", ""},
	},
})

minetest.register_craftitem("mobs_creatures:caramel_apple", {
	description = "Caramel Apple",
	inventory_image = "mobs_creatures_items_halloween_caramel_apple.png",
	on_use = minetest.item_eat(4),
})

minetest.register_craft({
	output = "mobs_creatures:caramel_apple",
	recipe = {
		{"mobs_creatures:caramelized_sugar"},
		{"default:apple"},
		{ "default:stick",},
	},
})
