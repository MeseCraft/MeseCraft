local S = minetest.get_translator(minetest.get_current_modname())

--glowing mese crystal blocks
minetest.register_node("df_mapitems:glow_mese", {
	description = S("Flawless Mese Block"),
	_doc_items_longdesc = df_mapitems.doc.glow_mese_desc,
	_doc_items_usagehelp = df_mapitems.doc.glow_mese_usage,
	tiles = {"dfcaverns_glow_mese.png"},
	groups = {cracky=3, pickaxey=4, material_stone=1, enderman_takable=1},
	sounds = df_dependencies.sound_glass(),
	is_ground_content = false,
	light_source = 13,
	paramtype = "light",
	use_texture_alpha = "blend",
	drawtype = "glasslike",
	sunlight_propagates = true,
	_mcl_blast_resistance = 1.5,
	_mcl_hardness = 1.5,
})

minetest.register_craft({
	output = 'df_mapitems:mese_crystal 2',
	recipe = {
		{'df_mapitems:glow_mese'},
	}
})

minetest.register_node("df_mapitems:mese_crystal", {
	description = S("Flawless Mese Crystal"),
	_doc_items_longdesc = df_mapitems.doc.glow_mese_desc,
	_doc_items_usagehelp = df_mapitems.doc.glow_mese_usage,
	tiles = {"dfcaverns_glow_mese.png"},
	groups = {cracky = 2, pickaxey=4, material_stone=1, building_block=1, enderman_takable=1},
	paramtype = "light",
	paramtype2 = "facedir",
	drawtype = "mesh",
	mesh = "underch_crystal.obj",
	light_source = 12,
	is_ground_content = false,
	sounds = df_dependencies.sound_glass(),
	use_texture_alpha = "blend",
	sunlight_propagates = true,
	on_place = df_mapitems.place_against_surface,
	_mcl_blast_resistance = 1.5,
	_mcl_hardness = 1.5,
})

minetest.register_craft({
	output = df_dependencies.node_name_mese_crystal .. ' 18',
	recipe = {
		{'df_mapitems:mese_crystal'},
	}
})

if minetest.get_modpath("radiant_damage") and radiant_damage.override_radiant_damage and radiant_damage.config.enable_mese_damage then
	radiant_damage.override_radiant_damage("mese", {
		emitted_by = {
			["df_mapitems:glow_mese"] = radiant_damage.config.mese_damage*12,
			["df_mapitems:mese_crystal"] = radiant_damage.config.mese_damage*9
		}
	})
end
