-- Cheese Wedge
minetest.register_craftitem("mesecraft_mobs:cheese", {
        description = "Cheese",
        inventory_image = "mesecraft_mobs_items_cheese.png",
        on_use = minetest.item_eat(4),
        groups = {food_cheese = 1, flammable = 2},
})

-- Cooking Milk Bucket to Create Cheese
minetest.register_craft({
        type = "cooking",
        output = "mesecraft_mobs:cheese",
        recipe = "mesecraft_mobs:milk_bucket",
        cooktime = 5,
        replacements = {{ "mesecraft_mobs:milk_bucket", "mesecraft_bucket:bucket_empty"}}
})

-- Cheese Block
minetest.register_node("mesecraft_mobs:cheeseblock", {
        description = "Cheese Block",
        tiles = {"mesecraft_mobs_items_cheeseblock.png"},
        is_ground_content = false,
        groups = {crumbly = 3},
        sounds = default.node_sound_dirt_defaults()
})

-- 9 Cheese makes a Cheese Block.
minetest.register_craft({
        output = "mesecraft_mobs:cheeseblock",
        recipe = {
                {'mesecraft_mobs:cheese', 'mesecraft_mobs:cheese', 'mesecraft_mobs:cheese'},
                {'mesecraft_mobs:cheese', 'mesecraft_mobs:cheese', 'mesecraft_mobs:cheese'},
                {'mesecraft_mobs:cheese', 'mesecraft_mobs:cheese', 'mesecraft_mobs:cheese'},
        }
})

-- A cheese block can make 9 cheese.
minetest.register_craft({
        output = "mesecraft_mobs:cheese 9",
        recipe = {
                {'mesecraft_mobs:cheeseblock'},
        }
})
