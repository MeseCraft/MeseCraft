-- butter
minetest.register_craftitem("mobs_creatures:butter", {
        description = "Butter",
        inventory_image = "mobs_creatures_items_butter.png",
        on_use = minetest.item_eat(1),
        groups = {food_butter = 1, flammable = 2},
})

if minetest.get_modpath("farming") and farming and farming.mod then
minetest.register_craft({
        type = "shapeless",
        output = "mobs_creatures:butter",
        recipe = {"mobs_creatures:milk_bucket", "farming:salt"},
        replacements = {{ "mobs_creatures:milk_bucket", "mesecraft_bucket:bucket_empty"}}
})
else -- some saplings are high in sodium so makes a good replacement item
minetest.register_craft({
        type = "shapeless",
        output = "mobs_creatures:butter",
        recipe = {"mobs_creatures:milk_bucket", "default:sapling"},
        replacements = {{ "mobs_creatures:milk_bucket", "mesecraft_bucket:bucket_empty"}}
})
end
