local S = df_mapitems.S

-----------------------------------------------

df_mapitems.dry_stalagmite_ids = subterrane.register_stalagmite_nodes("df_mapitems:dry_stal", {
	description = S("Dry Dripstone"),
	_doc_items_longdesc = df_mapitems.doc.dripstone_desc,
	_doc_items_usagehelp = df_mapitems.doc.dripstone_usage,
	tiles = {
		df_mapitems.texture.stone .. "^[brighten",
	},
	groups = {cracky = 3, stone = 2},
	sounds = df_mapitems.sounds.stone,
	is_ground_content = false,
})

minetest.register_node("df_mapitems:dry_flowstone", {
	description = S("Dry Flowstone"),
	_doc_items_longdesc = df_mapitems.doc.flowstone_desc,
	_doc_items_usagehelp = df_mapitems.doc.flowstone_usage,
	tiles = {df_mapitems.texture.stone .. "^[brighten"},
	groups = {cracky = 3, stone = 1, lava_heatable = 1},
	_magma_conduits_heats_to = df_mapitems.node_name.cobble,
	is_ground_content = false,
	drop = df_mapitems.node_name.cobble,
	sounds = df_mapitems.sounds.stone,
})

-----------------------------------------------

df_mapitems.wet_stalagmite_ids = subterrane.register_stalagmite_nodes("df_mapitems:wet_stal", {
	description = S("Wet Dripstone"),
	_doc_items_longdesc = df_mapitems.doc.dripstone_desc,
	_doc_items_usagehelp = df_mapitems.doc.dripstone_usage,
	tiles = {
		df_mapitems.texture.stone .. "^[brighten^dfcaverns_dripstone_streaks.png",
	},
	groups = {cracky = 3, stone = 2, subterrane_wet_dripstone = 1},
	sounds = df_mapitems.sounds.stone,
	is_ground_content = false,
}, "df_mapitems:dry_stal")


minetest.register_node("df_mapitems:wet_flowstone", {
	description = S("Wet Flowstone"),
	_doc_items_longdesc = df_mapitems.doc.flowstone_desc,
	_doc_items_usagehelp = df_mapitems.doc.flowstone_usage,
	tiles = {df_mapitems.texture.stone .. "^[brighten^dfcaverns_dripstone_streaks.png"},
	groups = {cracky = 3, stone = 1, subterrane_wet_dripstone = 1, lava_heatable = 1},
	_magma_conduits_heats_to = "df_mapitems:dry_flowstone",
	is_ground_content = false,
	drop = df_mapitems.node_name.cobble,
	sounds = df_mapitems.sounds.stone,
})

-----------------------------------------------

df_mapitems.icicle_ids = subterrane.register_stalagmite_nodes("df_mapitems:icicle", {
	description = S("Icicle"),
	_doc_items_longdesc = df_mapitems.doc.icicle_desc,
	_doc_items_usagehelp = df_mapitems.doc.icicle_usage,
	tiles = {
		df_mapitems.texture.ice,
	},
	groups = {cracky = 3, puts_out_fire = 1, cools_lava = 1, slippery = 3},
	sounds = df_mapitems.sounds.glass,
})

