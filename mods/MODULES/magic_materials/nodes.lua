minetest.register_node("magic_materials:stone_with_februm", {
    description = "Februm Ore",
    tiles = {"default_stone.png^magic_materials_mineral_februm.png"},
    groups = {cracky = 1},
    drop = "magic_materials:februm_crystal",
    sounds = default.node_sound_stone_defaults(),
    light_source = 2,
})

minetest.register_node("magic_materials:stone_with_egerum", {
    description = "Egerum Ore",
    tiles = {"default_stone.png^magic_materials_mineral_egerum.png"},
    groups = {cracky = 1},
    drop = "magic_materials:egerum_crystal",
    sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("magic_materials:arcanite_block", {
    description = "Arcanite Block",
    tiles = {"magic_materials_arcanite_block.png"},
    is_ground_content = false,
    groups = {cracky = 1, level = 2},
    sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("magic_materials:februm_block", {
    description = "Februm Block",
    tiles = {"magic_materials_februm_block.png"},
    is_ground_content = false,
    groups = {cracky = 1, level = 2},
    sounds = default.node_sound_stone_defaults(),
    light_source = 3,
})

minetest.register_node("magic_materials:egerum_block", {
    description = "Egerum Block",
    tiles = {"magic_materials_egerum_block.png"},
    is_ground_content = false,
    groups = {cracky = 1, level = 2},
    sounds = default.node_sound_stone_defaults(),
})

if minetest.get_modpath("stairs") then
    for k,v in pairs({Arcanite="arcanite", Februm="februm", Egerum="egerum"}) do
        stairs.register_stair_and_slab(
        v,
        "magic_materials:" .. v .. "_block",
        {cracky=1, level=2},
        {"magic_materials_" .. v .. "_block.png"},
        k .. " Stair",
        k .. " Slab",
        default.node_sound_stone_defaults(),
        false
        )
    end
end
