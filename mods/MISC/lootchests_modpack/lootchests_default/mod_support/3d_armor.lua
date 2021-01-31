local cheap_items = {
    {"3d_armor:helmet_wood"},
    {"3d_armor:chestplate_wood"},
    {"3d_armor:leggings_wood"},
    {"3d_armor:boots_wood"},
    {"3d_armor:helmet_cactus"},
    {"3d_armor:chestplate_cactus"},
    {"3d_armor:leggings_cactus"},
    {"3d_armor:boots_cactus"},
}

local medium_items = {
    {"3d_armor:helmet_steel"},
    {"3d_armor:chestplate_steel"},
    {"3d_armor:leggings_steel"},
    {"3d_armor:boots_steel"},
    {"3d_armor:helmet_bronze"},
    {"3d_armor:chestplate_bronze"},
    {"3d_armor:leggings_bronze"},
    {"3d_armor:boots_bronze"},
}

local expensive_items = {
    {"3d_armor:helmet_gold"},
    {"3d_armor:chestplate_gold"},
    {"3d_armor:leggings_gold"},
    {"3d_armor:boots_gold"},
    {"3d_armor:helmet_diamond"},
    {"3d_armor:chestplate_diamond"},
    {"3d_armor:leggings_diamond"},
    {"3d_armor:boots_diamond"},
}

lootchests.add_to_loot_table("lootchests_default:ocean_chest", medium_items)
lootchests.add_to_loot_table("lootchests_default:urn", cheap_items)
lootchests.add_to_loot_table("lootchests_default:stone_chest", expensive_items)