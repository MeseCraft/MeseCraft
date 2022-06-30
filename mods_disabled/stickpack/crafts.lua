minetest.register_craft({
    output = 'stickpack:springy_stick',
    recipe = {
        {'default:steel_ingot',},
        {'default:steel_ingot',},
        {'default:stick',},
    },
})

minetest.register_craft({
    output = 'stickpack:lead_stick',
    recipe = {
        {'default:stick',},
        {'default:steelblock',},
        {'default:steelblock',},
    },
})

minetest.register_craft({
    output = 'stickpack:sadstick',
    recipe = {
        {'bucket:bucket_water', '', 'bucket:bucket_water',},
        {'default:stick', 'default:stick', 'default:stick',},
        {'default:stick', '', 'default:stick',},
    },
})

minetest.register_craft({
    output = 'stickpack:1000_degree_stick',
    recipe = {
        {'bucket:bucket_lava', 'bucket:bucket_lava', 'bucket:bucket_lava',},
        {'bucket:bucket_lava', 'default:stick', 'bucket:bucket_lava',},
        {'bucket:bucket_lava', 'bucket:bucket_lava', 'bucket:bucket_lava',},
    },
})

minetest.register_craft({
    output = 'stickpack:1000_degree_stick',
    recipe = {
        {'bucket:bucket_lava', 'bucket:bucket_lava', 'bucket:bucket_lava',},
        {'bucket:bucket_lava', 'default:stick', 'bucket:bucket_lava',},
        {'bucket:bucket_lava', 'bucket:bucket_lava', 'bucket:bucket_lava',},
    },
})

minetest.register_craft({
    output = 'stickpack:trumpstick',
    recipe = {
        {'default:stone', 'default:stone', 'default:stone',},
        {'default:stone', 'default:stone', 'default:stone',},
        {'', 'default:stick', '',},
    },
})

minetest.register_craft({
    output = 'stickpack:clearstick',
    recipe = {
        {'default:glass',},
        {'default:stick',},
        {'default:stick',},
    },
})

minetest.register_craft({
    output = 'stickpack:lavastick',
    recipe = {
        {'bucket:bucket_lava',},
        {'default:stick',},
        {'default:stick',},
    },
})

minetest.register_craft({
    output = 'stickpack:lavastick',
    recipe = {
        {'bucket:bucket_water', 'default:ice', 'bucket:bucket_water',},
        {'bucket:bucket_water', 'default:ice', 'bucket:bucket_water',},
        {'', 'default:stick', '',},
    },
})

minetest.register_craft({
    output = 'stickpack:firestick',
    recipe = {
        {'', 'bucket:bucket_lava', '',},
        {'', 'default:stick', '',},
        {'', 'default:stick', '',},
    },
})

-- Rickstick
minetest.register_craftitem("stickpack:rickface", {
    description = "The Face of Rick Astley",
    inventory_image = "rick.png",
})

minetest.override_item("default:stone_with_mese", {
    drop = {
        max_items = 2,
        items = {
            {
                items = {"default:mese_crystal",},
                rarity = 1,
            },
            {
                items = {"stickpack:rickface",},
                rarity = 50,
            },
        },
    },
})

minetest.register_craft({
    output = 'stickpack:rickstick',
    recipe = {
        {'stickpack:rickface',},
        {'default:stick',},
        {'default:stick',},
    },
})