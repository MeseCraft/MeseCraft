-- raw rabbit
minetest.register_craftitem("mesecraft_mobs:rabbit_raw", {
        description = "Raw Rabbit",
        inventory_image = "mesecraft_mobs_items_rabbit_raw.png",
        on_use = minetest.item_eat(3),
        groups = {food_meat_raw = 1, food_rabbit_raw = 1, flammable = 2},
})

-- cooked rabbit
minetest.register_craftitem("mesecraft_mobs:rabbit_cooked", {
        description = "Cooked Rabbit",
        inventory_image = "mesecraft_mobs_items_rabbit_cooked.png",
        on_use = minetest.item_eat(5),
        groups = {food_meat = 1, food_rabbit = 1, flammable = 2},
})

minetest.register_craft({
        type = "cooking",
        output = "mesecraft_mobs:rabbit_cooked",
        recipe = "mesecraft_mobs:rabbit_raw",
        cooktime = 5,
})
-- rabbit hide
minetest.register_craftitem("mesecraft_mobs:rabbit_hide", {
        description = "Rabbit Hide",
        inventory_image = "mesecraft_mobs_items_rabbit_hide.png",
        groups = {flammable = 2},
})

minetest.register_craft({
        type = "fuel",
        recipe = "mesecraft_mobs:rabbit_hide",
        burntime = 2,
})

minetest.register_craft({
        output = "mesecraft_mobs:leather",
        type = "shapeless",
        recipe = {
                "mesecraft_mobs:rabbit_hide", "mesecraft_mobs:rabbit_hide",
                "mesecraft_mobs:rabbit_hide", "mesecraft_mobs:rabbit_hide"
        }
})

