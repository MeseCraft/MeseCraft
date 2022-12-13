--[[ Candy ]]--

-- Candy base
minetest.register_craftitem("halloween_holiday_pack:caramelized_sugar", {
    description = "Caramelized Sugar",
    inventory_image = "mobs_creatures_items_halloween_caramelized_sugar.png",
})

minetest.register_craft({
    type = "cooking",
    output = "halloween_holiday_pack:caramelized_sugar",
    recipe = "farming:sugar",
    cooktime = 14,
})

-- Candies
minetest.register_craftitem("halloween_holiday_pack:candycorn", {
    description = "Candycorn",
    inventory_image = "mobs_creatures_items_halloween_candycorn.png",
    on_use = minetest.item_eat(3),
})

minetest.register_craft({
    type = "shapeless",
    output = "halloween_holiday_pack:candycorn 3",
    recipe = {"halloween_holiday_pack:caramelized_sugar", "dye:orange", "dye:yellow", "dye:white"},
})

minetest.register_craftitem("halloween_holiday_pack:halloween_chocolate", {
    description = "Halloween Chocolate",
    inventory_image = "mobs_creatures_items_halloween_chocolate.png",
    on_use = minetest.item_eat(5),
})

minetest.register_craft({
    type = "shapeless",
    output = "halloween_holiday_pack:halloween_chocolate",
    recipe = {"halloween_holiday_pack:caramelized_sugar", "farming:chocolate_dark", "dye:orange", "default:paper"},
})

minetest.register_craftitem("halloween_holiday_pack:lolipop", {
	description = "Lolipop",
	inventory_image = "mobs_creatures_items_halloween_lolipop.png",
	on_use = minetest.item_eat(2),
})

minetest.register_craft({
	output = "halloween_holiday_pack:lolipop 2",
	recipe = {
		{"", "dye:orange", ""},
		{"default:paper", "halloween_holiday_pack:caramelized_sugar", "default:paper"},
		{"", "default:stick", ""},
	},
})

minetest.register_craftitem("halloween_holiday_pack:caramel_apple", {
	description = "Caramel Apple",
	inventory_image = "mobs_creatures_items_halloween_caramel_apple.png",
	on_use = minetest.item_eat(4),
})

minetest.register_craft({
	output = "halloween_holiday_pack:caramel_apple",
	recipe = {
		{"halloween_holiday_pack:caramelized_sugar"},
		{"default:apple"},
		{ "default:stick",},
	},
})
