-- raw mutton
minetest.register_craftitem("mobs_creatures:mutton_raw", {
        description = "Raw Mutton",
        inventory_image = "mobs_creatures_items_mutton_raw.png",
        on_use = minetest.item_eat(2),
        groups = {food_meat_raw = 1, food_mutton_raw = 1, flammable = 2},
})

-- cooked mutton
minetest.register_craftitem("mobs_creatures:mutton_cooked", {
        description = "Cooked Mutton",
        inventory_image = "mobs_creatures_items_mutton_cooked.png",
        on_use = minetest.item_eat(6),
        groups = {food_meat = 1, food_mutton = 1, flammable = 2},
})

minetest.register_craft({
        type = "cooking",
        output = "mobs_creatures:mutton_cooked",
        recipe = "mobs_creatures:mutton_raw",
        cooktime = 5,
})

