-- items

minetest.register_craftitem("basic_materials:plastic_sheet", {
	description = "Plastic sheet",
	inventory_image = "basic_materials_plastic_sheet.png",
})

minetest.register_craftitem("basic_materials:plastic_strip", {
	description = "Plastic strips",
	inventory_image = "basic_materials_plastic_strip.png",
})

minetest.register_craftitem("basic_materials:empty_spool", {
	description = "Empty wire spool",
	inventory_image = "basic_materials_empty_spool.png"
})

-- crafts

minetest.register_craft({
	type = "cooking",
	output = "basic_materials:plastic_sheet",
	recipe = "basic_materials:paraffin",
})

minetest.register_craft({
	type = "fuel",
	recipe = "basic_materials:plastic_sheet",
	burntime = 30,
})

minetest.register_craft( {
    output = "basic_materials:plastic_strip 9",
    recipe = {
		{ "basic_materials:plastic_sheet", "basic_materials:plastic_sheet", "basic_materials:plastic_sheet" }
    },
})

minetest.register_craft( {
	output = "basic_materials:empty_spool 3",
	recipe = {
		{ "basic_materials:plastic_sheet", "basic_materials:plastic_sheet", "basic_materials:plastic_sheet" },
		{ "", "basic_materials:plastic_sheet", "" },
		{ "basic_materials:plastic_sheet", "basic_materials:plastic_sheet", "basic_materials:plastic_sheet" }
	},
})

-- aliases

minetest.register_alias("homedecor:plastic_sheeting", "basic_materials:plastic_sheet")
minetest.register_alias("homedecor:plastic_strips",   "basic_materials:plastic_strip")
minetest.register_alias("homedecor:empty_spool",      "basic_materials:empty_spool")
