local S = minetest.get_translator(minetest.get_current_modname())

minetest.register_node("df_mapitems:salt_crystal", {
	description = S("Luminous Salt Crystal"),
	_doc_items_longdesc = df_mapitems.doc.salt_desc,
	_doc_items_usagehelp = df_mapitems.doc.salt_usage,
	tiles = {"dfcaverns_salt_crystal.png"},
	groups = {cracky = 2, pickaxey = 1, shovely=1, material_stone=1},
	paramtype = "light",
	paramtype2 = "facedir",
	drawtype = "mesh",
	mesh = "underch_crystal.obj",
	light_source = 6,
	sounds = df_dependencies.sound_glass(),
	use_texture_alpha = "blend",
	sunlight_propagates = true,
	is_ground_content = false,
	on_place = df_mapitems.place_against_surface,
	_mcl_blast_resistance = 1,
	_mcl_hardness = 1,
})

minetest.register_node("df_mapitems:salty_cobble", {
	description = S("Salty Cobble"),
	_doc_items_longdesc = df_mapitems.doc.salty_cobble_desc,
	_doc_items_usagehelp = df_mapitems.doc.salty_cobble_desc,
	tiles = {df_dependencies.texture_cobble .. "^dfcaverns_salty.png"},
	groups = {cracky = 3, stone = 1, lava_heatable = 1, pickaxey = 1, material_stone=1},
	_magma_conduits_heats_to = df_dependencies.node_name_cobble,
	is_ground_content = false,
	light_source = 2,
	drop = df_dependencies.node_name_cobble,
	sounds = df_dependencies.sound_stone(),
	_mcl_blast_resistance = 6,
	_mcl_hardness = 2,
})