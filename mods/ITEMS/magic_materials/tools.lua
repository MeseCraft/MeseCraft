minetest.register_tool("magic_materials:pickaxe_arcanite", {
    description = "Arcanite Pickaxe",
    inventory_image = "magic_materials_tool_pickaxe_arcanite.png",
    tool_capabilities = {
    full_punch_interval = 0.9,
        max_drop_level=3,
        groupcaps={
            cracky = {times={[1]=2.0, [2]=1.0, [3]=0.50}, uses=20, maxlevel=3},
        },
        damage_groups = {fleshy=5},
    },
    sound = {breaks = "default_tool_breaks"},
    groups = {pickaxe = 1}
}) 

minetest.register_tool("magic_materials:shovel_arcanite", {
    description = "Arcanite Shovel",
    inventory_image = "magic_materials_tool_shovel_arcanite.png",
    wield_image = "magic_materials_tool_shovel_arcanite.png^[transformR90",
    tool_capabilities = {
        full_punch_interval = 1.0,
        max_drop_level=1,
        groupcaps={
            crumbly = {times={[1]=1.10, [2]=0.50, [3]=0.30}, uses=20, maxlevel=3},
        },
        damage_groups = {fleshy=4},
    },
    sound = {breaks = "default_tool_breaks"},
    groups = {shovel = 1}
})

minetest.register_tool("magic_materials:axe_arcanite", {
    description = "Arcanite Axe",
    inventory_image = "magic_materials_tool_axe_arcanite.png",
    tool_capabilities = {
        full_punch_interval = 0.9,
        max_drop_level=1,
        groupcaps={
            choppy={times={[1]=2.10, [2]=0.90, [3]=0.50}, uses=20, maxlevel=3},
        },
        damage_groups = {fleshy=7},
    },
    sound = {breaks = "default_tool_breaks"},
    groups = {axe = 1}
})

minetest.register_tool("magic_materials:sword_arcanite", {
    description = "Arcanite Sword",
    inventory_image = "magic_materials_tool_sword_arcanite.png",
    tool_capabilities = {
        full_punch_interval = 0.7,
        max_drop_level=1,
        groupcaps={
            snappy={times={[1]=1.90, [2]=0.90, [3]=0.30}, uses=30, maxlevel=3},
        },
        damage_groups = {fleshy=8},
    },
    sound = {breaks = "default_tool_breaks"},
    groups = {sword = 1}
})

if minetest.get_modpath("farming") then
    farming.register_hoe("magic_materials:hoe_arcanite", {
        description = ("Arcanite Hoe"),
        inventory_image = "magic_materials_tool_hoe_arcanite.png",
        max_uses = 200,
        material = "magic_materials:arcanite_crystal"
    })
end