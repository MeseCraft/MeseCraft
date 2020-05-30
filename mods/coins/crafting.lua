-- Cook gold ingots into 100 gold coins.
minetest.register_craft({
	type = "cooking",
	cooktime = "60",
	output = "coins:gold_coinss 8",
	recipe = "default:gold_ingot",
})

-- Use a bucket of coins to smelt coins back into ingots.
minetest.register_craft({
	type = "shapeless",
	output = "coins:gold_scrap_bucket",
	recipe = {
		"coins:gold_coins", "coins:gold_coins","coins:gold_coins",
		"coins:gold_coins", "bucket:bucket_empty","coins:gold_coins",
		"coins:gold_coins", "coins:gold_coins","coins:gold_coins"
	    	}
})

-- Cook a bucket of 8 gold coins to smelt gold ingot.
minetest.register_craft({
	type = "cooking",
	cooktime = "60",
	output = "default:gold_ingot",
	recipe = "coins:gold_scrap_bucket",
	replacements = {{"coins:gold_scrap_bucket","bucket:bucket_empty"}}
})