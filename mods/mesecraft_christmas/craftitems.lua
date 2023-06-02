-- Craft items and edibles for Christmas
-- these items can be made into blocks: candycanes, gingerbread man.

-- Candy Cane
minetest.register_craftitem("mesecraft_christmas:candy_cane", {
	description = "Candy Cane",
	inventory_image = "mesecraft_christmas_items_candy_cane.png",
	on_use = minetest.item_eat(3),
})

-- Green Candy Cane
minetest.register_craftitem("mesecraft_christmas:green_candy_cane", {
	description = "Green Candy Cane",
	inventory_image = "mesecraft_christmas_items_green_candy_cane.png",
	on_use = minetest.item_eat(3),
})

-- Gingerbread Dough
minetest.register_craftitem("mesecraft_christmas:gingerbread_dough", {
        description = "Gingerbread Dough",
        inventory_image = "mesecraft_christmas_items_gingerbread_dough.png",
        on_use = minetest.item_eat(2),
})


-- Gingerbread
minetest.register_craftitem("mesecraft_christmas:gingerbread", {
        description = "Gingerbread",
        inventory_image = "mesecraft_christmas_items_gingerbread.png",
        on_use = minetest.item_eat(6),
})

-- Peppermint Candies
minetest.register_craftitem("mesecraft_christmas:peppermint_candies", {
        description = "Peppermint Candies",
        inventory_image = "mesecraft_christmas_items_peppermint_candies.png",
        on_use = minetest.item_eat(2),
})

-- Green Peppermint Candies
minetest.register_craftitem("mesecraft_christmas:green_peppermint_candies", {
        description = "Green Peppermint Candies",
        inventory_image = "mesecraft_christmas_items_green_peppermint_candies.png",
        on_use = minetest.item_eat(2),
})

-- Gingerbread Cookie
minetest.register_craftitem("mesecraft_christmas:gingerbread_cookie", {
	description = "Gingerbread Cookie",
	inventory_image = "mesecraft_christmas_items_gingerbread_cookie.png",
	on_use = minetest.item_eat(4),
})

-- Sugar Cookie
minetest.register_craftitem("mesecraft_christmas:sugar_cookie", {
        description = "Sugar Cookie",
        inventory_image = "mesecraft_christmas_items_sugar_cookie.png",
        on_use = minetest.item_eat(6),
})

-- Bell Sugar Cookie
minetest.register_craftitem("mesecraft_christmas:sugar_cookie_bell", {
        description = "Bell Sugar Cookie",
        inventory_image = "mesecraft_christmas_items_sugar_cookie_bell.png",
        on_use = minetest.item_eat(6),
})

-- Star Sugar Cookie
minetest.register_craftitem("mesecraft_christmas:sugar_cookie_star", {
        description = "Star Sugar Cookie",
        inventory_image = "mesecraft_christmas_items_sugar_cookie_star.png",
        on_use = minetest.item_eat(6),
})

-- Tree Sugar Cookie
minetest.register_craftitem("mesecraft_christmas:sugar_cookie_tree", {
        description = "Tree Sugar Cookie",
        inventory_image = "mesecraft_christmas_items_sugar_cookie_tree.png",
        on_use = minetest.item_eat(6),
})

-- Glass of Eggnog
minetest.register_craftitem("mesecraft_christmas:eggnog_glass", {
        description = "Glass of Eggnog",
        inventory_image = "mesecraft_christmas_items_eggnog_glass.png",
	on_use = minetest.item_eat(3, 'vessels:drinking_glass'),
})
-- Glass of Hot Chocolate
minetest.register_craftitem("mesecraft_christmas:hot_chocolate_glass", {
        description = "Glass of Hot Chocolate",
        inventory_image = "mesecraft_christmas_items_hot_chocolate_glass.png",
	on_use = minetest.item_eat(2, 'vessels:drinking_glass'),
})
