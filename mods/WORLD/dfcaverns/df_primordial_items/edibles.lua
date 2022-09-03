local S = minetest.get_translator(minetest.get_current_modname())

minetest.register_craftitem("df_primordial_items:primordial_fruit", {
	description = S("Primordial Fruit"),
	_doc_items_longdesc = df_primordial_items.doc.primordial_fruit_desc,
	_doc_items_usagehelp = df_primordial_items.doc.primordial_fruit_usage,
	inventory_image = "dfcaverns_primordial_fruit.png",
	groups = {food = 8, eatable=8, plant=1},
	sound = {eat = {name = "df_farming_gummy_chew", gain = 1.0}},
	on_use = minetest.item_eat(8),
	_hunger_ng = {heals = 8},
	_mcl_saturation = 12,
})

minetest.register_craftitem("df_primordial_items:glowtato", {
	description = S("Glowtato"),
	_doc_items_longdesc = df_primordial_items.doc.glowtato_desc,
	_doc_items_usagehelp = df_primordial_items.doc.glowtato_usage,
	inventory_image = "dfcaverns_glowtato.png",
	sound = {eat = {name = "df_farming_chomp_crunch", gain = 1.0}},
	groups = {food = 8, dfcaverns_cookable = 1, eatable=8, plant=1},
	on_use = minetest.item_eat(8),
	_hunger_ng = {satiates = 8},
	_mcl_saturation = 8,
})
