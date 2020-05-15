-- internationalization boilerplate
local MP = minetest.get_modpath(minetest.get_current_modname())
local S, NS = dofile(MP.."/intllib.lua")

-----------------------------------------------

df_mapitems.dry_stalagmite_ids = subterrane.register_stalagmite_nodes("df_mapitems:dry_stal", {
	description = S("Dry Dripstone"),
	_doc_items_longdesc = df_mapitems.doc.dripstone_desc,
	_doc_items_usagehelp = df_mapitems.doc.dripstone_usage,
	tiles = {
		"default_stone.png^[brighten",
	},
	groups = {cracky = 3, stone = 2},
	sounds = default.node_sound_stone_defaults(),
	is_ground_content = false,
})

minetest.register_node("df_mapitems:dry_flowstone", {
	description = S("Dry Flowstone"),
	_doc_items_longdesc = df_mapitems.doc.flowstone_desc,
	_doc_items_usagehelp = df_mapitems.doc.flowstone_usage,
	tiles = {"default_stone.png^[brighten"},
	groups = {cracky = 3, stone = 1, lava_heatable = 1},
	_magma_conduits_heats_to = "default:cobble",
	is_ground_content = false,
	drop = 'default:cobble',
	sounds = default.node_sound_stone_defaults(),
})

-----------------------------------------------

df_mapitems.wet_stalagmite_ids = subterrane.register_stalagmite_nodes("df_mapitems:wet_stal", {
	description = S("Wet Dripstone"),
	_doc_items_longdesc = df_mapitems.doc.dripstone_desc,
	_doc_items_usagehelp = df_mapitems.doc.dripstone_usage,
	tiles = {
		"default_stone.png^[brighten^dfcaverns_dripstone_streaks.png",
	},
	groups = {cracky = 3, stone = 2, subterrane_wet_dripstone = 1},
	sounds = default.node_sound_stone_defaults(),
	is_ground_content = false,
}, "df_mapitems:dry_stal")


minetest.register_node("df_mapitems:wet_flowstone", {
	description = S("Wet Flowstone"),
	_doc_items_longdesc = df_mapitems.doc.flowstone_desc,
	_doc_items_usagehelp = df_mapitems.doc.flowstone_usage,
	tiles = {"default_stone.png^[brighten^dfcaverns_dripstone_streaks.png"},
	groups = {cracky = 3, stone = 1, subterrane_wet_dripstone = 1, lava_heatable = 1},
	_magma_conduits_heats_to = "df_mapitems:dry_flowstone",
	is_ground_content = false,
	drop = 'default:cobble',
	sounds = default.node_sound_stone_defaults(),
})

-----------------------------------------------

df_mapitems.icicle_ids = subterrane.register_stalagmite_nodes("df_mapitems:icicle", {
	description = S("Icicle"),
	_doc_items_longdesc = df_mapitems.doc.icicle_desc,
	_doc_items_usagehelp = df_mapitems.doc.icicle_usage,
	tiles = {
		"default_ice.png",
	},
	groups = {cracky = 3, puts_out_fire = 1, cools_lava = 1, slippery = 3},
	sounds = default.node_sound_glass_defaults(),
})

