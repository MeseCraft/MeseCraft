local cheap_items = {
    {"shields:shield_wood"},
    {"shields:shield_enhanced_wood"},
    {"shields:shield_cactus"},
    {"shields:shield_enhanced_cactus"},
}

local medium_items = {
    {"shields:shield_steel"},
    {"shields:shield_bronze"},
}

local expensive_items = {
    {"shields:shield_gold"},
    {"shields:shield_diamond"},
}

lootchests.add_to_loot_table("lootchests_default:ocean_chest", medium_items)
lootchests.add_to_loot_table("lootchests_default:urn", cheap_items)
lootchests.add_to_loot_table("lootchests_default:stone_chest", expensive_items)
