local chest_items = {
    {"gadgets_consumables:potion_speed_01", 2},
    {"gadgets_consumables:potion_jump_01", 2},
    {"gadgets_consumables:potion_gravity_01", 2},
    {"gadgets_consumables:potion_dispel", 2},
    {"gadgets_consumables:potion_health_regen_01", 2},
    {"gadgets_consumables:potion_water_breath_01", 2},
    {"gadgets_consumables:water_bottle", 2},
}

local stone_chest_items = {
    {"gadgets_consumables:potion_teleport", 2},
    {"gadgets_consumables:potion_fire_shield_02", 2},
    {"gadgets_consumables:potion_speed_02", 2},
    {"gadgets_consumables:potion_jump_02", 2},
    {"gadgets_consumables:potion_gravity_02", 2},
    {"gadgets_consumables:potion_dispel", 2},
    {"gadgets_consumables:potion_health_regen_02", 2},
    {"gadgets_consumables:potion_water_breath_02", 2},
}

lootchests.add_to_loot_table("lootchests_default:ocean_chest", chest_items)
lootchests.add_to_loot_table("lootchests_default:stone_chest", stone_chest_items)

if minetest.get_modpath("lootchests_magic_materials") then
    lootchests.add_to_loot_table("lootchests_magic_materials:rune_urn", chest_items)
    lootchests.add_to_loot_table("lootchests_magic_materials:rune_chest", stone_chest_items)
end
