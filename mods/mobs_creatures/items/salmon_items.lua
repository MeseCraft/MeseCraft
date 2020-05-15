-- Items and drops for the Salmon fish.

-- Register Raw Salmon.
minetest.register_craftitem("mobs_creatures:salmon_raw", {
        description = "Raw Salmon",
        inventory_image = "mobs_creatures_items_salmon_raw.png",
        on_use = minetest.item_eat(2),
        groups = {food_fish_raw = 1, flammable = 2},
})

-- Regiser Cooked Salmon.
minetest.register_craftitem("mobs_creatures:salmon_cooked", {
        description = "Cooked Salmon",
        inventory_image = "mobs_creatures_items_salmon_cooked.png",
        on_use = minetest.item_eat(6),
        groups = {food_fish = 1, flammable = 2},
})

-- Regiser cooking recipe for raw Salmon to cooked Salmon.
minetest.register_craft({
        type = "cooking",
        output = "mobs_creatures:salmon_cooked",
        recipe = "mobs_creatures:salmon_raw",
        cooktime = 10,
})

