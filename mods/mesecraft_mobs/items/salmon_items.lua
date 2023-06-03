-- Items and drops for the Salmon fish.

-- Register Raw Salmon.
minetest.register_craftitem("mesecraft_mobs:salmon_raw", {
        description = "Raw Salmon",
        inventory_image = "mesecraft_mobs_items_salmon_raw.png",
        on_use = minetest.item_eat(2),
        groups = {food_fish_raw = 1, flammable = 2},
})

-- Regiser Cooked Salmon.
minetest.register_craftitem("mesecraft_mobs:salmon_cooked", {
        description = "Cooked Salmon",
        inventory_image = "mesecraft_mobs_items_salmon_cooked.png",
        on_use = minetest.item_eat(6),
        groups = {food_fish = 1, flammable = 2},
})

-- Regiser cooking recipe for raw Salmon to cooked Salmon.
minetest.register_craft({
        type = "cooking",
        output = "mesecraft_mobs:salmon_cooked",
        recipe = "mesecraft_mobs:salmon_raw",
        cooktime = 10,
})

