-- Bucket of Milk
minetest.register_craftitem("mobs_creatures:milk_bucket", {
        description = "Bucket of Milk",
        inventory_image = "mobs_creatures_items_milk_bucket.png",
        stack_max = 1,
        on_use = minetest.item_eat(8, 'mesecraft_bucket:bucket_empty'),
        groups = {food_milk = 1, flammable = 3},
})

-- Glass of Milk
minetest.register_craftitem("mobs_creatures:milk_glass", {
        description = "Glass of Milk",
        inventory_image = "mobs_creatures_items_milk_glass.png",
        on_use = minetest.item_eat(2, 'vessels:drinking_glass'),
        groups = {food_milk_glass = 1, flammable = 3, vessel = 1},
})

-- 4 glasses + milk bucket --> 4 milk glasses.
minetest.register_craft({
        type = "shapeless",
        output = "mobs_creatures:milk_glass 4",
        recipe = {
                'vessels:drinking_glass', 'vessels:drinking_glass',
                'vessels:drinking_glass', 'vessels:drinking_glass',
                'mobs_creatures:milk_bucket'
        },
        replacements = { {"mobs_creatures:milk_bucket", "mesecraft_bucket:bucket_empty"} }
})

-- Glasses of Milk --> Milk Bucket.
minetest.register_craft({
        type = "shapeless",
        output = "mobs_creatures:milk_bucket",
        recipe = {
                'mobs_creatures:milk_glass', 'mobs_creatures:milk_glass',
                'mobs_creatures:milk_glass', 'mobs_creatures:milk_glass',
                'mesecraft_bucket:bucket_empty'
        },
        replacements = { {"mobs_creatures:milk_glass", "vessels:drinking_glass 4"} }
})

