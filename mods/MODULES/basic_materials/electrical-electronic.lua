-- items

minetest.register_craftitem("basic_materials:silicon", {
	description = "Silicon lump",
	inventory_image = "basic_materials_silicon.png",
})

minetest.register_craftitem("basic_materials:ic", {
	description = "Simple Integrated Circuit",
	inventory_image = "basic_materials_ic.png",
})

minetest.register_craftitem("basic_materials:motor", {
	description = "Simple Motor",
	inventory_image = "basic_materials_motor.png",
})

minetest.register_craftitem("basic_materials:heating_element", {
	description = "Heating element",
	inventory_image = "basic_materials_heating_element.png",
})

minetest.register_craftitem("basic_materials:energy_crystal_simple", {
	description = "Simple energy crystal",
	inventory_image = "basic_materials_energy_crystal.png",
})

-- crafts

minetest.register_craft( {
	output = "mesecons_materials:silicon 4",
	recipe = {
		{ "default:sand", "default:sand" },
		{ "default:sand", "default:steel_ingot" },
	},
})

minetest.register_craft( {
	output = "basic_materials:ic 4",
	recipe = {
		{ "mesecons_materials:silicon", "mesecons_materials:silicon" },
		{ "mesecons_materials:silicon", "default:copper_ingot" },
	},
})

minetest.register_craft( {
    output = "basic_materials:motor 2",
    recipe = {
		{ "default:mese_crystal_fragment", "basic_materials:copper_wire", "basic_materials:plastic_sheet" },
		{ "default:copper_ingot",          "default:steel_ingot",         "default:steel_ingot" },
		{ "default:mese_crystal_fragment", "basic_materials:copper_wire", "basic_materials:plastic_sheet" }
    },
	replacements = {
		{ "basic_materials:copper_wire", "basic_materials:empty_spool" },
		{ "basic_materials:copper_wire", "basic_materials:empty_spool" },
	}
})

minetest.register_craft( {
    output = "basic_materials:heating_element 2",
    recipe = {
		{ "default:copper_ingot", "default:mese_crystal_fragment", "default:copper_ingot" }
    },
})

minetest.register_craft({
	--type = "shapeless",
	output = "basic_materials:energy_crystal_simple 2",
	recipe = {
		{ "default:mese_crystal_fragment", "default:torch", "default:mese_crystal_fragment" },
		{ "default:diamond", "default:gold_ingot", "default:diamond" }
	},
})

-- aliases

minetest.register_alias("homedecor:ic",                     "basic_materials:ic")
minetest.register_alias("homedecor:motor",                  "basic_materials:motor")
minetest.register_alias("technic:motor",                    "basic_materials:motor")
minetest.register_alias("homedecor:heating_element",        "basic_materials:heating_element")
minetest.register_alias("homedecor:power_crystal",          "basic_materials:energy_crystal_simple")

minetest.register_alias_force("mesecons_materials:silicon", "basic_materials:silicon")
