minetest.register_node("morelights_extras:f_block", {
  description = "Futuristic Light Block",
  tiles = {"morelights_extras_f_block.png"},
  paramtype = "light",
  light_source = LIGHT_MAX,
  groups = {cracky = 2, oddly_breakable_by_hand = 3},
  sounds = default.node_sound_glass_defaults(),
})

minetest.register_node("morelights_extras:dirt_with_grass", {
  description = "Grass Light",
  tiles = {"default_grass.png^morelights_extras_blocklight.png",
    "default_dirt.png", "default_dirt.png^default_grass_side.png"},
  paramtype = "light",
  light_source = 12,
  groups = {cracky = 2, oddly_breakable_by_hand = 3},
  sounds = default.node_sound_glass_defaults()
})

minetest.register_node("morelights_extras:stone_block", {
  description = "Stone Block Light",
  tiles = {"default_stone_block.png^morelights_extras_blocklight.png"},
  paramtype = "light",
  light_source = 12,
  groups = {cracky = 2, oddly_breakable_by_hand = 3},
  sounds = default.node_sound_glass_defaults()
})

minetest.register_node("morelights_extras:sandstone_block", {
  description = "Sandstone Block Light",
  tiles = {"default_sandstone_block.png^morelights_extras_blocklight.png"},
  paramtype = "light",
  light_source = 12,
  groups = {cracky = 2, oddly_breakable_by_hand = 3},
  sounds = default.node_sound_glass_defaults()
})

--
-- Craft recipes
--

minetest.register_craft({
  output = "morelights_extras:f_block",
  recipe = {
    {"default:mese_crystal_fragment", "default:steel_ingot", "default:mese_crystal_fragment"},
    {morelights.glass, "morelights:bulb", morelights.glass},
    {"default:mese_crystal_fragment", "default:steel_ingot", "default:mese_crystal_fragment"}
  }
})

minetest.register_craft({
  output = "morelights_extras:dirt_with_grass",
  recipe = {
    {"", morelights.glass, ""},
    {"", "morelights:bulb", ""},
    {"default:grass_1", "default:dirt", ""}
  }
})

minetest.register_craft({
  output = "morelights_extras:stone_block",
  recipe = {
    {"", morelights.glass, ""},
    {"", "morelights:bulb", ""},
    {"", "default:stone_block", ""}
  }
})

minetest.register_craft({
  output = "morelights_extras:sandstone_block",
  recipe = {
    {"", morelights.glass, ""},
    {"", "morelights:bulb", ""},
    {"", "default:sandstone_block", ""}
  }
})
