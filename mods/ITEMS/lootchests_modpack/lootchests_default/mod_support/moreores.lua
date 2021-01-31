local chest_items = {
    {"moreores:silver_ingot", 8},
    {"moreores:mithril_lump", 2},
    {"moreores:sword_silver"},
    {"moreores:axe_silver"},
    {"moreores:shovel_silver"},
    {"moreores:pick_silver"},
}

local urn_items = {
    {"moreores:silver_lump", 8},
}

local stone_chest_items = {
    {"moreores:sword_silver"},
    {"moreores:axe_silver"},
    {"moreores:shovel_silver"},
    {"moreores:pick_silver"},
    {"moreores:sword_mithril"},
    {"moreores:axe_mithril"},
    {"moreores:shovel_mithril"},
    {"moreores:pick_mithril"},
    {"moreores:mithril_ingot", 4},
    {"moreores:silver_block", 2},
}

lootchests.add_to_loot_table("lootchests_default:ocean_chest", chest_items)
lootchests.add_to_loot_table("lootchests_default:urn", urn_items)
lootchests.add_to_loot_table("lootchests_default:stone_chest", stone_chest_items)