--items

minetest.register_craftitem("basic_materials:oil_extract", {
	description = "Oil extract",
	inventory_image = "basic_materials_oil_extract.png",
})

minetest.register_craftitem("basic_materials:paraffin", {
	description = "Unprocessed paraffin",
	inventory_image = "basic_materials_paraffin.png",
})

minetest.register_craftitem("basic_materials:terracotta_base", {
	description = "Uncooked Terracotta Base",
	inventory_image = "basic_materials_terracotta_base.png",
})

minetest.register_craftitem("basic_materials:wet_cement", {
	description = "Wet Cement",
	inventory_image = "basic_materials_wet_cement.png",
})

-- nodes

minetest.register_node("basic_materials:cement_block", {
	description = "Cement",
	tiles = {"basic_materials_cement_block.png"},
	is_ground_content = true,
	groups = {cracky=2},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("basic_materials:concrete_block", {
	description = "Concrete Block",
	tiles = {"basic_materials_concrete_block.png",},
	groups = {cracky=1, level=2, concrete=1},
	sounds = default.node_sound_stone_defaults(),
})

-- crafts

minetest.register_craft({
	type = "shapeless",
	output = "basic_materials:oil_extract 2",
	recipe = {
		"group:leaves",
		"group:leaves",
		"group:leaves",
		"group:leaves",
		"group:leaves",
		"group:leaves"
	}
})

minetest.register_craft({
	type = "cooking",
	output = "basic_materials:paraffin",
	recipe = "basic_materials:oil_extract",
})

minetest.register_craft({
	type = "fuel",
	recipe = "basic_materials:oil_extract",
	burntime = 30,
})

minetest.register_craft({
	type = "fuel",
	recipe = "basic_materials:paraffin",
	burntime = 30,
})

minetest.register_craft( {
	type = "shapeless",
	output = "basic_materials:terracotta_base 8",
	recipe = {
		"bucket:bucket_water",
		"default:clay_lump",
		"default:gravel",
	},
	replacements = { {"bucket:bucket_water", "bucket:bucket_empty"}, },
})

minetest.register_craft({
	type = "shapeless",
	output = "basic_materials:wet_cement 3",
	recipe = {
		"default:dirt",
		"dye:dark_grey",
		"dye:dark_grey",
		"dye:dark_grey",
		"bucket:bucket_water"
	},
	replacements = {{'bucket:bucket_water', 'bucket:bucket_empty'},},
})

minetest.register_craft({
	type = "cooking",
	output = "basic_materials:cement_block",
	recipe = "basic_materials:wet_cement",
	cooktime = 8
})

minetest.register_craft({
	output = 'basic_materials:concrete_block 6',
	recipe = {
		{'group:sand',                'basic_materials:wet_cement', 'default:gravel'},
		{'basic_materials:steel_bar', 'basic_materials:wet_cement', 'basic_materials:steel_bar'},
		{'default:gravel',            'basic_materials:wet_cement', 'group:sand'},
	}
})

-- aliases

minetest.register_alias("homedecor:oil_extract",      "basic_materials:oil_extract")
minetest.register_alias("homedecor:paraffin",         "basic_materials:paraffin")
minetest.register_alias("homedecor:plastic_base",     "basic_materials:paraffin")
minetest.register_alias("homedecor:terracotta_base",  "basic_materials:terracotta_base")

minetest.register_alias("gloopblocks:wet_cement",     "basic_materials:wet_cement")
minetest.register_alias("gloopblocks:cement",         "basic_materials:cement_block")

minetest.register_alias("technic:concrete",           "basic_materials:concrete_block")
