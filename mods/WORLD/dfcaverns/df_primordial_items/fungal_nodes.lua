local S = df_primordial_items.S

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
	groups = {snappy = 3, flora = 1, attached_node = 1, flammable = 1, primordial_fungal_plant = 1, light_sensitive_fungus = 11},
	paramtype = "light",
	drawtype = "plantlike",
	buildable_to = true,
	is_ground_content = false,
	walkable = false,
	sounds = df_primordial_items.sounds.leaves,
	use_texture_alpha = true,
	sunlight_propagates = true,
})

minetest.register_node("df_primordial_items:fungal_grass_2", {
	description = S("Primordial Fungal Grass"),
	_doc_items_longdesc = df_primordial_items.doc.fungal_grass_desc,
	_doc_items_usagehelp = df_primordial_items.doc.fungal_grass_usage,
	tiles = {"dfcaverns_mush_grass_02.png"},
	inventory_image = "dfcaverns_mush_grass_02.png",
	wield_image = "dfcaverns_mush_grass_02.png",
	groups = {snappy = 3, flora = 1, attached_node = 1, flammable = 1, primordial_fungal_plant = 1, light_sensitive_fungus = 11},
	paramtype = "light",
	drawtype = "plantlike",
	buildable_to = true,
	is_ground_content = false,
	walkable = false,
	place_param2 = 3,
	sounds = df_primordial_items.sounds.leaves,
	use_texture_alpha = true,
	sunlight_propagates = true,
})

-- Glowing

minetest.register_node("df_primordial_items:glow_orb", {
	description = S("Primordial Fungal Orb"),
	_doc_items_longdesc = df_primordial_items.doc.glow_orb_desc,
	_doc_items_usagehelp = df_primordial_items.doc.glow_orb_usage,
	tiles = {"dfcaverns_mush_orb.png"},
	inventory_image = "dfcaverns_mush_orb.png",
	wield_image = "dfcaverns_mush_orb.png",
	groups = {snappy = 3, flora = 1, attached_node = 1, flammable = 1, primordial_fungal_plant = 1, light_sensitive_fungus = 13},
	paramtype = "light",
	drawtype = "plantlike",
	buildable_to = true,
	is_ground_content = false,
	walkable = false,
	light_source = 9,
	sounds = df_primordial_items.sounds.leaves,
	use_texture_alpha = true,
	sunlight_propagates = true,
})

minetest.register_node("df_primordial_items:glow_orb_stalks", {
	description = S("Primordial Fungal Orb"),
	_doc_items_longdesc = df_primordial_items.doc.glow_orb_desc,
	_doc_items_usagehelp = df_primordial_items.doc.glow_orb_usage,
	tiles = {"dfcaverns_mush_stalks.png"},
	inventory_image = "dfcaverns_mush_stalks.png",
	wield_image = "dfcaverns_mush_stalks.png",
	groups = {snappy = 3, flora = 1, attached_node = 1, flammable = 1, primordial_fungal_plant = 1, light_sensitive_fungus = 13},
	paramtype = "light",
	drawtype = "plantlike",
	buildable_to = true,
	is_ground_content = false,
	walkable = false,
	light_source = 6,
	sounds = df_primordial_items.sounds.leaves,
	use_texture_alpha = true,
	sunlight_propagates = true,
})

minetest.register_node("df_primordial_items:glow_pods", {
	description = S("Primordial Fungal Pod"),
	_doc_items_longdesc = df_primordial_items.doc.glow_pod_desc,
	_doc_items_usagehelp = df_primordial_items.doc.glow_pod_usage,
	tiles = {"dfcaverns_mush_pods.png"},
	inventory_image = "dfcaverns_mush_pods.png",
	wield_image = "dfcaverns_mush_pods.png",
	groups = {snappy = 3, flora = 1, attached_node = 1, flammable = 1, primordial_fungal_plant = 1, light_sensitive_fungus = 13},
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
	light_source = 6,
	sounds = df_primordial_items.sounds.leaves,
	use_texture_alpha = true,
	sunlight_propagates = true,
})

------------------------------------------------------------------------------------
-- Dirt

minetest.register_node("df_primordial_items:dirt_with_mycelium", {
	description = S("Dirt with Primordial Mycelium"),
	_doc_items_longdesc = df_primordial_items.doc.dirt_with_mycelium_desc,
	_doc_items_usagehelp = df_primordial_items.doc.dirt_with_mycelium_usage,
	tiles = {"dfcaverns_mush_soil.png"},
	groups = {crumbly = 3, soil = 1},
	is_ground_content = false,
	paramtype = "light",
	drops = df_primordial_items.node_names.dirt,
	sounds = df_primordial_items.sounds.dirt,
	light_source = 3,
})

minetest.register_abm{
	label = "df_primordial_items:dirt_with_mycelium_spread",
	nodenames = {df_primordial_items.node_names.dirt},
	neighbors = {"df_mapitems:dirt_with_mycelium"},
	interval = 60,
	chance = 50,
	catch_up = true,
	action = function(pos)
		minetest.swap_node(pos, {name="df_mapitems:dirt_with_mycelium"})
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
