-- Crafting

-- Dinosaur fence
minetest.register_craft({
	output = "paleotest:dinosaur_fence 64",
	recipe = {
		{"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"},
		{"", "default:mese_crystal", ""},
		{"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"}
	}
})

-- Fossil Analyzer
minetest.register_craft({
	output = "paleotest:fossil_analyzer",
	recipe = {
		{"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"},
		{"default:steel_ingot", "default:mese_crystal", "default:steel_ingot"},
		{"default:steel_ingot", "default:copper_ingot", "default:steel_ingot"}
	}
})

-- DNA Cultivator machine
minetest.register_craft({
	output = "paleotest:dna_cultivator",
	recipe = {
		{"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"},
		{"default:glass", "bucket:bucket_water", "default:glass"},
		{"default:steel_ingot", "default:mese_crystal", "default:steel_ingot"}
	}
})