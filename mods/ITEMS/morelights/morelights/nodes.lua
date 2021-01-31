minetest.register_craftitem("morelights:bulb", {
  description = "Light Bulb",
  inventory_image = "morelights_bulb.png"
})

--
-- Craft recipes
--

minetest.register_craft({
  output = "morelights:bulb",
  recipe = {
    {"", "default:glass", ""},
    {"", "default:copper_ingot", ""},
    {"", "default:steel_ingot", "default:mese_crystal_fragment"}
  }
})
