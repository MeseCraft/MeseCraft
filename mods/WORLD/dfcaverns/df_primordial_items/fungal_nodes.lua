local S = minetest.get_translator(minetest.get_current_modname())

-----------------------------------------------------------------------------------------------
-- Plants

-- Grass

minetest.register_node("df_primordial_items:fungal_grass_1", {
	description = S("Primordial Fungal Grass"),
	_doc_items_longdesc = df_primordial_items.doc.fungal_grass_desc,
	_doc_items_usagehelp = df_primordial_items.doc.fungal_grass_usage,
	tiles = {"dfcaverns_mush_grass_01.png"},
	inventory_image = "dfcaverns_mush_grass_01.png",
	wield_image = "dfcaverns_mush_grass_01.png",
	groups = {snappy = 3, attached_node = 1, flammable = 1, primordial_fungal_plant = 1, light_sensitive_fungus = 11, plant=1, handy=1, swordy=1, hoey=1, destroy_by_lava_flow=1,dig_by_piston=1},
	paramtype = "light",
	drawtype = "plantlike",
	buildable_to = true,
	is_ground_content = false,
	walkable = false,
	floodable = true,
	sounds = df_dependencies.sound_leaves(),
	use_texture_alpha = "clip",
	sunlight_propagates = true,
	_mcl_blast_resistance = 0.2,
	_mcl_hardness = 0.2,
})

minetest.register_node("df_primordial_items:fungal_grass_2", {
	description = S("Primordial Fungal Grass"),
	_doc_items_longdesc = df_primordial_items.doc.fungal_grass_desc,
	_doc_items_usagehelp = df_primordial_items.doc.fungal_grass_usage,
	tiles = {"dfcaverns_mush_grass_02.png"},
	inventory_image = "dfcaverns_mush_grass_02.png",
	wield_image = "dfcaverns_mush_grass_02.png",
	groups = {snappy = 3, attached_node = 1, flammable = 1, primordial_fungal_plant = 1, light_sensitive_fungus = 11, plant=1, handy=1, swordy=1, hoey=1, destroy_by_lava_flow=1,dig_by_piston=1},
	paramtype = "light",
	drawtype = "plantlike",
	buildable_to = true,
	is_ground_content = false,
	walkable = false,
	floodable = true,
	place_param2 = 3,
	sounds = df_dependencies.sound_leaves(),
	use_texture_alpha = "clip",
	sunlight_propagates = true,
	_mcl_blast_resistance = 0.2,
	_mcl_hardness = 0.2,
})

-- Glowing

minetest.register_node("df_primordial_items:glow_orb", {
	description = S("Primordial Fungal Orb"),
	_doc_items_longdesc = df_primordial_items.doc.glow_orb_desc,
	_doc_items_usagehelp = df_primordial_items.doc.glow_orb_usage,
	tiles = {"dfcaverns_mush_orb.png"},
	inventory_image = "dfcaverns_mush_orb.png",
	wield_image = "dfcaverns_mush_orb.png",
	groups = {snappy = 3, attached_node = 1, flammable = 1, primordial_fungal_plant = 1, light_sensitive_fungus = 13, plant=1, handy=1, swordy=1, hoey=1, destroy_by_lava_flow=1,dig_by_piston=1},
	paramtype = "light",
	drawtype = "plantlike",
	buildable_to = true,
	is_ground_content = false,
	walkable = false,
	floodable = true,
	light_source = 9,
	sounds = df_dependencies.sound_leaves(),
	use_texture_alpha = "clip",
	sunlight_propagates = true,
	_mcl_blast_resistance = 0.2,
	_mcl_hardness = 0.2,
})

minetest.register_node("df_primordial_items:glow_orb_stalks", {
	description = S("Primordial Fungal Orb"),
	_doc_items_longdesc = df_primordial_items.doc.glow_orb_desc,
	_doc_items_usagehelp = df_primordial_items.doc.glow_orb_usage,
	tiles = {"dfcaverns_mush_stalks.png"},
	inventory_image = "dfcaverns_mush_stalks.png",
	wield_image = "dfcaverns_mush_stalks.png",
	groups = {snappy = 3, attached_node = 1, flammable = 1, primordial_fungal_plant = 1, light_sensitive_fungus = 13, plant=1, handy=1, swordy=1, hoey=1, destroy_by_lava_flow=1,dig_by_piston=1},
	paramtype = "light",
	drawtype = "plantlike",
	buildable_to = true,
	is_ground_content = false,
	walkable = false,
	floodable = true,
	light_source = 6,
	sounds = df_dependencies.sound_leaves(),
	use_texture_alpha = "clip",
	sunlight_propagates = true,
	_mcl_blast_resistance = 0.2,
	_mcl_hardness = 0.2,
})

minetest.register_node("df_primordial_items:glow_pods", {
	description = S("Primordial Fungal Pod"),
	_doc_items_longdesc = df_primordial_items.doc.glow_pod_desc,
	_doc_items_usagehelp = df_primordial_items.doc.glow_pod_usage,
	tiles = {"dfcaverns_mush_pods.png"},
	inventory_image = "dfcaverns_mush_pods.png",
	wield_image = "dfcaverns_mush_pods.png",
	groups = {snappy = 3, attached_node = 1, flammable = 1, primordial_fungal_plant = 1, light_sensitive_fungus = 13, plant=1, handy=1, swordy=1, hoey=1, destroy_by_lava_flow=1,dig_by_piston=1},
	paramtype = "light",
	drawtype = "plantlike",
	drop = {
		max_items = 2,
		items = {
			{
				rarity = 3,
				items = {"df_primordial_items:primordial_fruit"},
			},
			{
				rarity = 3,
				items = {"df_primordial_items:primordial_fruit"},
			},
		},
	},
	buildable_to = true,
	is_ground_content = false,
	walkable = false,
	floodable = true,
	light_source = 6,
	sounds = df_dependencies.sound_leaves(),
	use_texture_alpha = "clip",
	sunlight_propagates = true,
	_mcl_blast_resistance = 0.2,
	_mcl_hardness = 0.2,
})

------------------------------------------------------------------------------------
-- Dirt

minetest.register_node("df_primordial_items:dirt_with_mycelium", {
	description = S("Dirt with Primordial Mycelium"),
	_doc_items_longdesc = df_primordial_items.doc.dirt_with_mycelium_desc,
	_doc_items_usagehelp = df_primordial_items.doc.dirt_with_mycelium_usage,
	tiles = {"dfcaverns_mush_soil.png"},
	groups = {crumbly = 3, soil = 1, light_sensitive_fungus = 13, handy=1,shovely=1, dirt=2, building_block=1, opaque=1},
	_dfcaverns_dead_node = df_dependencies.node_name_dirt,
	is_ground_content = false,
	paramtype = "light",
	drop = df_dependencies.node_name_dirt,
	sounds = df_dependencies.sound_dirt(),
	light_source = 3,
	_mcl_blast_resistance = 0.5,
	_mcl_hardness = 0.6,
})

minetest.register_abm{
	label = "df_primordial_items:dirt_with_mycelium_spread",
	nodenames = {df_dependencies.node_name_dirt},
	neighbors = {"df_primordial_items:dirt_with_mycelium"},
	interval = 60,
	chance = 50,
	catch_up = true,
	action = function(pos)
		minetest.swap_node(pos, {name="df_primordial_items:dirt_with_mycelium"})
	end,
}

if minetest.get_modpath("footprints") then
	local HARDPACK_PROBABILITY = minetest.settings:get("footprints_hardpack_probability") or 0.9 -- Chance walked dirt/grass is worn and compacted to footprints:trail.
	local HARDPACK_COUNT = minetest.settings:get("footprints_hardpack_count") or 10 -- Number of times the above chance needs to be passed for soil to compact.

	footprints.register_trample_node("df_primordial_items:dirt_with_mycelium", {
		trampled_node_def_override = {description = S("Dirt with Primordial Mycelium and Footprint"),},
		footprint_opacity = 196,
		hard_pack_node_name = "footprints:trail",
		hard_pack_probability = HARDPACK_PROBABILITY,
		hard_pack_count = HARDPACK_COUNT,
	})	
end
