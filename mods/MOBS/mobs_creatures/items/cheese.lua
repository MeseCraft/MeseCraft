-- Cheese Wedge
minetest.register_craftitem("mobs_creatures:cheese", {
        description = "Cheese",
        inventory_image = "mobs_creatures_items_cheese.png",
        on_use = minetest.item_eat(4),
        groups = {food_cheese = 1, flammable = 2},
})

-- Cooking Milk Bucket to Create Cheese
minetest.register_craft({
        type = "cooking",
        output = "mobs_creatures:cheese",
        recipe = "mobs_creatures:milk_bucket",
        cooktime = 5,
        replacements = {{ "mobs_creatures:milk_bucket", "mesecraft_bucket:bucket_empty"}}
})

-- Cheese Block
minetest.register_node("mobs_creatures:cheeseblock", {
        description = "Cheese Block",
        tiles = {"mobs_creatures_items_cheeseblock.png"},
        is_ground_content = false,
        groups = {crumbly = 3},
        sounds = default.node_sound_dirt_defaults()
})

-- 9 Cheese makes a Cheese Block.
minetest.register_craft({
        output = "mobs_creatures:cheeseblock",
        recipe = {
                {'mobs_creatures:cheese', 'mobs_creatures:cheese', 'mobs_creatures:cheese'},
                {'mobs_creatures:cheese', 'mobs_creatures:cheese', 'mobs_creatures:cheese'},
                {'mobs_creatures:cheese', 'mobs_creatures:cheese', 'mobs_creatures:cheese'},
        }
})

-- A cheese block can make 9 cheese.
minetest.register_craft({
        output = "mobs_creatures:cheese 9",
        recipe = {
                {'mobs_creatures:cheeseblock'},
        }
})
