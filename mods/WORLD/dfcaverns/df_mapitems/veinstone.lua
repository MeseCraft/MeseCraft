local S = df_mapitems.S

minetest.register_node("df_mapitems:veinstone", {
	description = S("Veinstone"),
	_doc_items_longdesc = df_mapitems.doc.veinstone_desc,
	_doc_items_usagehelp = df_mapitems.doc.veinstone_usage,
	tiles = {df_mapitems.texture.stone .. "^dfcaverns_veins.png"},
	groups = {cracky = 3, stone = 1, lava_heatable = 1},
	_magma_conduits_heats_to = df_mapitems.node_name.cobble,
	is_ground_content = false,
	light_source = 2,
	drop = df_mapitems.node_name.cobble,
	sounds = df_mapitems.sounds.stone,
})