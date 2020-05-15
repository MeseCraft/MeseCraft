-- Register Chicken Egg
minetest.register_node("mobs_creatures:egg", {
        description = "Chicken Egg",
        tiles = {"mobs_creatures_items_chicken_egg.png"},
        inventory_image  = "mobs_creatures_items_chicken_egg.png",
        visual_scale = 0.7,
        drawtype = "plantlike",
        wield_image = "mobs_creatures_items_chicken_egg.png",
        paramtype = "light",
        walkable = false,
        is_ground_content = true,
        sunlight_propagates = true,
        selection_box = {
                type = "fixed",
                fixed = {-0.2, -0.5, -0.2, 0.2, 0, 0.2}
        },
        groups = {food_egg = 1, snappy = 2, dig_immediate = 3},
        after_place_node = function(pos, placer, itemstack)
                if placer:is_player() then
                        minetest.set_node(pos, {name = "mobs_creatures:egg", param2 = 1})
                end
        end,
})
-- Register "Fried Egg"
minetest.register_craftitem("mobs_creatures:chicken_egg_fried", {
        description = "Fried Egg",
        inventory_image = "mobs_creatures_items_chicken_egg_fried.png",
        on_use = minetest.item_eat(2),
        groups = {food_egg_fried = 1, flammable = 2},
})
-- Recipe for fried egg.
minetest.register_craft({
        type  =  "cooking",
        recipe  = "mobs_creatures:egg",
        output = "mobs_creatures:chicken_egg_fried",
})
-- Register raw chicken.
minetest.register_craftitem("mobs_creatures:chicken_raw", {
description = "Raw Chicken",
        inventory_image = "mobs_creatures_items_chicken_raw.png",
        on_use = minetest.item_eat(2),
        groups = {food_meat_raw = 1, food_chicken_raw = 1, flammable = 2},
})
-- Register cooked chicken.
minetest.register_craftitem("mobs_creatures:chicken_cooked", {
description = "Cooked Chicken",
        inventory_image = "mobs_creatures_items_chicken_cooked.png",
        on_use = minetest.item_eat(6),
        groups = {food_meat = 1, food_chicken = 1, flammable = 2},
})
-- Recipe for cooked chicken.
minetest.register_craft({
        type  =  "cooking",
        recipe  = "mobs_creatures:chicken_raw",
        output = "mobs_creatures:chicken_cooked",
})

-- Register feather.
minetest.register_craftitem("mobs_creatures:chicken_feather", {
        description = "Chicken Feather",
        inventory_image = "mobs_creatures_items_chicken_feather.png",
        groups = {flammable = 2},
})
-- Chicken feather make burnable.
minetest.register_craft({
        type = "fuel",
        recipe = "mobs_creatures:chicken_feather",
        burntime = 1,
})

