-- Pork drops for pig.

-- Register Raw Pork
minetest.register_craftitem("mobs_creatures:pork_raw", {
        description = "Raw Pork",
        inventory_image = "mobs_creatures_items_pork_raw.png",
        on_use = minetest.item_eat(4),
        groups = {food_meat_raw = 1, food_pork_raw = 1, flammable = 2},
})

-- Regiser Cooked Pork
minetest.register_craftitem("mobs_creatures:pork_cooked", {
        description = "Cooked Pork",
        inventory_image = "mobs_creatures_items_pork_cooked.png",
        on_use = minetest.item_eat(8),
        groups = {food_meat = 1, food_pork = 1, flammable = 2},
})

-- Regiser cooking recipe for raw pork --> cooked pork.
minetest.register_craft({
        type = "cooking",
        output = "mobs_creatures:pork_cooked",
        recipe = "mobs_creatures:pork_raw",
        cooktime = 5,
})

