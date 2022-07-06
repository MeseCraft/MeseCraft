-- Items and drops for the Cod fish.

-- Register Raw Cod.
minetest.register_craftitem("mobs_creatures:cod_raw", {
        description = "Raw Cod",
        inventory_image = "mobs_creatures_items_cod_raw.png",
        on_use = minetest.item_eat(2),
        groups = {food_fish_raw = 1, flammable = 2},
})

-- Regiser Cooked Cod.
minetest.register_craftitem("mobs_creatures:cod_cooked", {
        description = "Cooked Cod",
        inventory_image = "mobs_creatures_items_cod_cooked.png",
        on_use = minetest.item_eat(6),
        groups = {food_fish = 1, flammable = 2},
})

-- Regiser cooking recipe for raw Cod to cooked Cod.
minetest.register_craft({
        type = "cooking",
        output = "mobs_creatures:cod_cooked",
        recipe = "mobs_creatures:cod_raw",
        cooktime = 10,
})

