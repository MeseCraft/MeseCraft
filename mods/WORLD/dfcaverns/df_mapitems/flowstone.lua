local S = minetest.get_translator(minetest.get_current_modname())

-----------------------------------------------

df_mapitems.dry_stalagmite_ids = subterrane.register_stalagmite_nodes("df_mapitems:dry_stal", {
	description = S("Dry Dripstone"),
	_doc_items_longdesc = df_mapitems.doc.dripstone_desc,
	_doc_items_usagehelp = df_mapitems.doc.dripstone_usage,
	tiles = {
		df_dependencies.texture_stone .. "^[brighten",
	},
	groups = {cracky = 3, stone = 2, pickaxey=1, building_block=1, material_stone=1},
	sounds = df_dependencies.sound_stone(),
	is_ground_content = false,
	_mcl_blast_resistance = 6,
	_mcl_hardness = 1.5,
})

minetest.register_node("df_mapitems:dry_flowstone", {
	description = S("Dry Flowstone"),
	_doc_items_longdesc = df_mapitems.doc.flowstone_desc,
	_doc_items_usagehelp = df_mapitems.doc.flowstone_usage,
	tiles = {df_dependencies.texture_stone .. "^[brighten"},
	groups = {cracky = 3, stone = 1, lava_heatable = 1, pickaxey=1, building_block=1, material_stone=1},
	_magma_conduits_heats_to = df_dependencies.node_name_cobble,
	is_ground_content = false,
	drop = df_dependencies.node_name_cobble,
	sounds = df_dependencies.sound_stone(),
	_mcl_blast_resistance = 6,
	_mcl_hardness = 1.5,
})

-----------------------------------------------

df_mapitems.wet_stalagmite_ids = subterrane.register_stalagmite_nodes("df_mapitems:wet_stal", {
	description = S("Wet Dripstone"),
	_doc_items_longdesc = df_mapitems.doc.dripstone_desc,
	_doc_items_usagehelp = df_mapitems.doc.dripstone_usage,
	tiles = {
		df_dependencies.texture_stone .. "^[brighten^dfcaverns_dripstone_streaks.png",
	},
	groups = {cracky = 3, stone = 2, subterrane_wet_dripstone = 1, pickaxey=1, building_block=1, material_stone=1},
	sounds = df_dependencies.sound_stone(),
	is_ground_content = false,
	_mcl_blast_resistance = 6,
	_mcl_hardness = 1.5,
}, "df_mapitems:dry_stal")


minetest.register_node("df_mapitems:wet_flowstone", {
	description = S("Wet Flowstone"),
	_doc_items_longdesc = df_mapitems.doc.flowstone_desc,
	_doc_items_usagehelp = df_mapitems.doc.flowstone_usage,
	tiles = {df_dependencies.texture_stone .. "^[brighten^dfcaverns_dripstone_streaks.png"},
	groups = {cracky = 3, stone = 1, subterrane_wet_dripstone = 1, lava_heatable = 1, pickaxey=1, building_block=1, material_stone=1},
	_magma_conduits_heats_to = "df_mapitems:dry_flowstone",
	is_ground_content = false,
	drop = df_dependencies.node_name_cobble,
	sounds = df_dependencies.sound_stone(),
	_mcl_blast_resistance = 6,
	_mcl_hardness = 1.5,
})

-----------------------------------------------

df_mapitems.icicle_ids = subterrane.register_stalagmite_nodes("df_mapitems:icicle", {
	description = S("Icicle"),
	_doc_items_longdesc = df_mapitems.doc.icicle_desc,
	_doc_items_usagehelp = df_mapitems.doc.icicle_usage,
	tiles = {
		df_dependencies.texture_ice,
	},
	groups = {cracky = 3, puts_out_fire = 1, cools_lava = 1, slippery = 3, pickaxey=1, building_block=1, handy=1, slippery=3, building_block=1, ice=1},
	sounds = df_dependencies.sound_glass(),
	_mcl_blast_resistance = 0.5,
	_mcl_hardness = 0.5,
})

