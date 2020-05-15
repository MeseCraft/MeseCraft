-- internationalization boilerplate
local MP = minetest.get_modpath(minetest.get_current_modname())
local S, NS = dofile(MP.."/intllib.lua")

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
	sounds = default.node_sound_leaves_defaults(),
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
	sounds = default.node_sound_leaves_defaults(),
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
	sounds = default.node_sound_leaves_defaults(),
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
	sounds = default.node_sound_leaves_defaults(),
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
	buildable_to = true,
	is_ground_content = false,
	walkable = false,
	light_source = 6,
	sounds = default.node_sound_leaves_defaults(),
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
	drops = "default:dirt",
	sounds = default.node_sound_dirt_defaults(),
	light_source = 3,
})

minetest.register_abm{
	label = "df_primordial_items:dirt_with_mycelium_spread",
	nodenames = {"default:dirt"},
	neighbors = {"df_mapitems:dirt_with_mycelium"},
	interval = 60,
	chance = 50,
	catch_up = true,
	action = function(pos)
		minetest.swap_node(pos, {name="df_mapitems:dirt_with_mycelium"})
	end,
}

if minetest.get_modpath("trail") and trail and trail.register_trample_node then	
	local HARDPACK_PROBABILITY = minetest.settings:get("trail_hardpack_probability") or 0.5 -- Chance walked dirt/grass is worn and compacted to trail:trail.
	local HARDPACK_COUNT = minetest.settings:get("trail_hardpack_count") or 5 -- Number of times the above chance needs to be passed for soil to compact.

	trail.register_trample_node("df_primordial_items:dirt_with_mycelium", {
		trampled_node_def_override = {description = S("Dirt with Primordial Mycelium and Footprint"),},
		footprint_opacity = 196,
		hard_pack_node_name = "trail:trail",
		hard_pack_probability = HARDPACK_PROBABILITY,
		hard_pack_count = HARDPACK_COUNT,
	})	
end
