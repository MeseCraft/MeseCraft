-- raw rabbit
minetest.register_craftitem("mobs_creatures:rabbit_raw", {
        description = "Raw Rabbit",
        inventory_image = "mobs_creatures_items_rabbit_raw.png",
        on_use = minetest.item_eat(3),
        groups = {food_meat_raw = 1, food_rabbit_raw = 1, flammable = 2},
})

-- cooked rabbit
minetest.register_craftitem("mobs_creatures:rabbit_cooked", {
        description = "Cooked Rabbit",
        inventory_image = "mobs_creatures_items_rabbit_cooked.png",
        on_use = minetest.item_eat(5),
        groups = {food_meat = 1, food_rabbit = 1, flammable = 2},
})

minetest.register_craft({
        type = "cooking",
        output = "mobs_creatures:rabbit_cooked",
        recipe = "mobs_creatures:rabbit_raw",
        cooktime = 5,
})
-- rabbit hide
minetest.register_craftitem("mobs_creatures:rabbit_hide", {
        description = "Rabbit Hide",
        inventory_image = "mobs_creatures_items_rabbit_hide.png",
        groups = {flammable = 2},
})

minetest.register_craft({
        type = "fuel",
        recipe = "mobs_creatures:rabbit_hide",
        burntime = 2,
})

minetest.register_craft({
        output = "mobs_creatures:leather",
        type = "shapeless",
        recipe = {
                "mobs_creatures:rabbit_hide", "mobs_creatures:rabbit_hide",
                "mobs_creatures:rabbit_hide", "mobs_creatures:rabbit_hide"
        }
})

