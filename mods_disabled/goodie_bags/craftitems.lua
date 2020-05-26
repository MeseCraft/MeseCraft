-- Blue Goodie Bag
minetest.register_craftitem("ff_goodie_bags:blue_goodie_bag", {
	description = "Blue Goodie Bag",
	inventory_image = "ff_goodie_bags_blue_goodie_bag.png",
	on_use = ff_goodie_bags.goodie_bag_on_use("blue"),
})

-- Red Goodie Bag
minetest.register_craftitem("ff_goodie_bags:red_goodie_bag", {
	description = "Red Goodie Bag",
	inventory_image = "ff_goodie_bags_red_goodie_bag.png",
	on_use = ff_goodie_bags.goodie_bag_on_use("red"),
})

-- Green Goodie Bag
minetest.register_craftitem("ff_goodie_bags:green_goodie_bag", {
	description = "Green Goodie Bag",
	inventory_image = "ff_goodie_bags_green_goodie_bag.png",
	on_use = ff_goodie_bags.goodie_bag_on_use("green"),
})

-- Orange Goodie Bag
minetest.register_craftitem("ff_goodie_bags:orange_goodie_bag", {
	description = "Orange Goodie Bag",
	inventory_image = "ff_goodie_bags_orange_goodie_bag.png",
	on_use = ff_goodie_bags.goodie_bag_on_use("orange"),
})

