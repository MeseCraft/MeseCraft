-- Cook gold ingots into 100 gold coins.
minetest.register_craft({
	type = "cooking",
	cooktime = "60",
	output = "coins:gold_coins 100",
	recipe = "default:gold_ingot",
})
