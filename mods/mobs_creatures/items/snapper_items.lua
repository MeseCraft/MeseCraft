-- Items and drops for the Snapper fish.

-- Register Raw Snapper.
minetest.register_craftitem("mobs_creatures:snapper_raw", {
        description = "Raw Snapper",
        inventory_image = "mobs_creatures_items_snapper_raw.png",
        on_use = minetest.item_eat(2),
        groups = {food_fish_raw = 1, flammable = 2},
})

-- Regiser Cooked snapper.
minetest.register_craftitem("mobs_creatures:snapper_cooked", {
        description = "Cooked Snapper",
        inventory_image = "mobs_creatures_items_snapper_cooked.png",
        on_use = minetest.item_eat(6),
        groups = {food_fish = 1, flammable = 2},
})

-- Regiser cooking recipe for raw Snapper to cooked Snapper.
minetest.register_craft({
        type = "cooking",
        output = "mobs_creatures:snapper_cooked",
        recipe = "mobs_creatures:snapper_raw",
        cooktime = 10,
})

