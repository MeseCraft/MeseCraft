-- Items and drops for the clownfish.

-- Register Raw Clownfish.
minetest.register_craftitem("mesecraft_mobs:clownfish_raw", {
        description = "Raw Clownfish",
        inventory_image = "mesecraft_mobs_items_clownfish_raw.png",
        on_use = minetest.item_eat(2),
        groups = {food_fish_raw = 1, flammable = 2},
})

-- Regiser Cooked Clownfish.
minetest.register_craftitem("mesecraft_mobs:clownfish_cooked", {
        description = "Cooked Clownfish",
        inventory_image = "mesecraft_mobs_items_clownfish_cooked.png",
        on_use = minetest.item_eat(6),
        groups = {food_fish = 1, flammable = 2},
})

-- Regiser cooking recipe for raw clownfish to cooked clownfish.
minetest.register_craft({
        type = "cooking",
        output = "mesecraft_mobs:clownfish_cooked",
        recipe = "mesecraft_mobs:clownfish_raw",
        cooktime = 10,
})

