-- raw mutton
minetest.register_craftitem("mesecraft_mobs:mutton_raw", {
        description = "Raw Mutton",
        inventory_image = "mesecraft_mobs_items_mutton_raw.png",
        on_use = minetest.item_eat(2),
        groups = {food_meat_raw = 1, food_mutton_raw = 1, flammable = 2},
})

-- cooked mutton
minetest.register_craftitem("mesecraft_mobs:mutton_cooked", {
        description = "Cooked Mutton",
        inventory_image = "mesecraft_mobs_items_mutton_cooked.png",
        on_use = minetest.item_eat(6),
        groups = {food_meat = 1, food_mutton = 1, flammable = 2},
})

minetest.register_craft({
        type = "cooking",
        output = "mesecraft_mobs:mutton_cooked",
        recipe = "mesecraft_mobs:mutton_raw",
        cooktime = 5,
})

