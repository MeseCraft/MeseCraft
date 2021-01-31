--Blocks
for _,v in pairs({"februm", "egerum", "arcanite"}) do
    minetest.register_craft({
        output = 'magic_materials:' .. v .. '_block',
        recipe = {
                {'magic_materials:' .. v .. '_crystal', 'magic_materials:' .. v .. '_crystal', 'magic_materials:' .. v .. '_crystal'},
                {'magic_materials:' .. v .. '_crystal', 'magic_materials:' .. v .. '_crystal', 'magic_materials:' .. v .. '_crystal'},
                {'magic_materials:' .. v .. '_crystal', 'magic_materials:' .. v .. '_crystal', 'magic_materials:' .. v .. '_crystal'},
            },
    })

    minetest.register_craft({
        type = "shapeless",
        output = 'magic_materials:' .. v .. '_crystal 9',
        recipe = {
            "magic_materials:" .. v .. "_block",
        },
    })
end

--Craft items
minetest.register_craft({
    type = "cooking",
    output = "magic_materials:arcanite_crystal",
    recipe = "magic_materials:arcanite_fragments",
    cooktime = 3,
})

minetest.register_craft({
    type = "shapeless",
    output = 'magic_materials:arcanite_fragments',
    recipe = {
            "magic_materials:februm_crystal",
            "magic_materials:egerum_crystal",
    },
})

minetest.register_craft({
    output = "magic_materials:enchanted_page",
    recipe = {
        {"magic_materials:egerum_crystal", "magic_materials:arcanite_crystal", "magic_materials:egerum_crystal"},
        {"magic_materials:arcanite_crystal", "default:paper", "magic_materials:arcanite_crystal"},
        {"magic_materials:egerum_crystal", "magic_materials:arcanite_crystal", "magic_materials:egerum_crystal"},
    },
})

minetest.register_craft({
    output = "magic_materials:enchanted_book",
    recipe = {
        {"", "magic_materials:enchanted_page", ""},
        {"", "magic_materials:enchanted_page", ""},
        {"", "magic_materials:enchanted_page", ""},
    },
})

minetest.register_craft({
    output = "magic_materials:enchanted_rune",
    recipe = {
        {"magic_materials:arcanite_crystal", "magic_materials:egerum_crystal", "magic_materials:arcanite_crystal"},
        {"magic_materials:egerum_crystal", "default:stone", "magic_materials:egerum_crystal"},
        {"magic_materials:arcanite_crystal", "magic_materials:egerum_crystal", "magic_materials:arcanite_crystal"},
    },
})

minetest.register_craft({
    output = "magic_materials:enchanted_staff",
    recipe = {
        {"magic_materials:enchanted_rune", "default:steel_ingot", "magic_materials:enchanted_rune"},
        {"magic_materials:enchanted_rune", "group:stick", "magic_materials:enchanted_rune"},
        {"magic_materials:enchanted_rune", "group:stick", "magic_materials:enchanted_rune"},
    },
})

--Tools
minetest.register_craft({
    output = "magic_materials:pickaxe_arcanite",
    recipe = {
        {"magic_materials:arcanite_crystal", "magic_materials:arcanite_crystal", "magic_materials:arcanite_crystal"},
        {"", "group:stick", ""},
        {"", "group:stick", ""},
    },
})

minetest.register_craft({
    output = "magic_materials:axe_arcanite",
    recipe = {
        {"magic_materials:arcanite_crystal", "magic_materials:arcanite_crystal", ""},
        {"magic_materials:arcanite_crystal", "group:stick", ""},
        {"", "group:stick", ""},
    },
})

minetest.register_craft({
    output = "magic_materials:sword_arcanite",
    recipe = {
        {"", "magic_materials:arcanite_crystal", ""},
        {"", "magic_materials:arcanite_crystal", ""},
        {"", "group:stick", ""},
    },
})

minetest.register_craft({
    output = "magic_materials:shovel_arcanite",
    recipe = {
        {"", "magic_materials:arcanite_crystal", ""},
        {"", "group:stick", ""},
        {"", "group:stick", ""},
    },
})

if minetest.get_modpath("farming") then
    minetest.register_craft({
        output = "magic_materials:hoe_arcanite",
        recipe = {
            {"magic_materials:arcanite_crystal", "magic_materials:arcanite_crystal", ""},
            {"", "group:stick", ""},
            {"", "group:stick", ""},
        },
    })
end

minetest.register_craft({
    type = "shapeless",
    output = 'magic_materials:magic_root',
    recipe = {
            "group:tree",
            "magic_materials:egerum_crystal",
    },
})

minetest.register_craft({
    type = "shapeless",
    output = 'magic_materials:magic_flower',
    recipe = {
            "group:flower",
            "magic_materials:egerum_crystal",
    },
})

minetest.register_craft({
    type = "shapeless",
    output = 'magic_materials:magic_mushroom',
    recipe = {
            "flowers:mushroom_red",
            "magic_materials:egerum_crystal",
    },
})

minetest.register_craft({
    type = "shapeless",
    output = 'magic_materials:magic_mushroom',
    recipe = {
            "flowers:mushroom_brown",
            "magic_materials:egerum_crystal",
    },
})

minetest.register_craft({
    output = "magic_materials:fire_rune",
    recipe = {
        {"default:mese_crystal", "bucket:bucket_lava", "default:mese_crystal"},
        {"bucket:bucket_lava", "magic_materials:enchanted_rune", "bucket:bucket_lava"},
        {"default:mese_crystal", "bucket:bucket_lava", "default:mese_crystal"},
    },
    replacements = {{ "bucket:bucket_lava", "bucket:bucket_empty"}}
})

minetest.register_craft({
    output = "magic_materials:ice_rune",
    recipe = {
        {"default:diamond", "default:ice", "default:diamond"},
        {"default:ice", "magic_materials:enchanted_rune", "default:ice"},
        {"default:diamond", "default:ice", "default:diamond"},
    },
})

minetest.register_craft({
    output = "magic_materials:storm_rune",
    recipe = {
        {"default:diamond", "default:obsidian", "default:diamond"},
        {"default:obsidian", "magic_materials:enchanted_rune", "default:obsidian"},
        {"default:diamond", "default:obsidian", "default:diamond"},
    },
})

minetest.register_craft({
    output = "magic_materials:light_rune",
    recipe = {
        {"default:mese_crystal", "default:gold_ingot", "default:mese_crystal"},
        {"default:gold_ingot", "magic_materials:enchanted_rune", "default:gold_ingot"},
        {"default:mese_crystal", "default:gold_ingot", "default:mese_crystal"},
    },
})

minetest.register_craft({
    output = "magic_materials:void_rune",
    recipe = {
        {"magic_materials:arcanite_crystal", "default:obsidian", "magic_materials:arcanite_crystal"},
        {"default:obsidian", "magic_materials:enchanted_rune", "default:obsidian"},
        {"magic_materials:arcanite_crystal", "default:obsidian", "magic_materials:arcanite_crystal"},
    },
})

minetest.register_craft({
    output = "magic_materials:energy_rune",
    recipe = {
        {"default:diamond", "magic_materials:egerum_crystal", "default:diamond"},
        {"magic_materials:egerum_crystal", "magic_materials:enchanted_rune", "magic_materials:egerum_crystal"},
        {"default:diamond", "magic_materials:egerum_crystal", "default:diamond"},
    },
})

minetest.register_craft({
    output = "magic_materials:earth_rune",
    recipe = {
        {"default:coal_lump", "default:tin_lump", "default:copper_lump"},
        {"default:clay_lump", "magic_materials:enchanted_rune", "default:iron_lump"},
        {"default:gold_lump", "default:mese_crystal", "default:diamond"},
    },
})