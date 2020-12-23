local S = df_mapitems.S


local function soil_type_spread(label, node_to_spread, target_node)
	minetest.register_abm{
		label = label,
		nodenames = {target_node},
		neighbors = {node_to_spread},
		interval = 60,
		chance = 15,
		catch_up = true,
		action = function(pos)
			local above_def = minetest.registered_nodes[minetest.get_node({x=pos.x, y=pos.y+1, z=pos.z}).name]
			if above_def and (above_def.buildable_to == true or above_def.walkable == false) then
				minetest.swap_node(pos, {name=node_to_spread})
			end
		end,
	}
end

local farming_soil = df_mapitems.node_name.farming_soil
local farming_soil_wet = df_mapitems.node_name.farming_soil_wet

--------------------------------------------------
-- Cave moss

-- cyan/dark cyan

local dirt_texture = df_mapitems.texture.dirt
local sand_texture = df_mapitems.texture.sand

local dirt_node = df_mapitems.node_name.dirt
local sand_node = df_mapitems.node_name.sand
local stone_node = df_mapitems.node_name.stone
local cobble_node = df_mapitems.node_name.cobble

minetest.register_node("df_mapitems:dirt_with_cave_moss", {
	description = S("Dirt with Cave Moss"),
	_doc_items_longdesc = df_mapitems.doc.cave_moss_desc,
	_doc_items_usagehelp = df_mapitems.doc.cave_moss_usage,
	tiles = {dirt_texture .. "^dfcaverns_cave_moss.png", dirt_texture, 
		{name = dirt_texture .. "^(dfcaverns_cave_moss.png^[mask:dfcaverns_ground_cover_side_mask.png)",
			tileable_vertical = false}},
	drop = dirt_node,
	is_ground_content = false,
	light_source = 2,
	paramtype = "light",
	groups = {crumbly = 3, soil = 1, light_sensitive_fungus = 8},
	sounds = df_mapitems.sounds.dirt_mossy,
	soil = {
		base = "df_mapitems:dirt_with_cave_moss",
		dry = farming_soil,
		wet = farming_soil_wet
	},
	_dfcaverns_dead_node = dirt_node,
})

soil_type_spread("df_mapitems:cave_moss_spread", "df_mapitems:dirt_with_cave_moss", dirt_node)

---------------------------------------------------------------
-- Sand scum

minetest.register_node("df_mapitems:sand_scum", {
	description = S("Sand Scum"),
	_doc_items_longdesc = df_mapitems.doc.sand_scum_desc,
	_doc_items_usagehelp = df_mapitems.doc.sand_scum_usage,
	tiles = {"dfcaverns_ground_cover_sand_scum.png", sand_texture, 
		{name = sand_texture .. "^(dfcaverns_ground_cover_sand_scum.png^[mask:dfcaverns_ground_cover_side_mask.png)",
			tileable_vertical = false}},
	drop = sand_node,
	is_ground_content = false,
	light_source = 2,
	paramtype = "light",
	groups = {crumbly = 3, soil = 1, light_sensitive_fungus = 8},
	sounds = df_mapitems.sounds.sandscum,
	_dfcaverns_dead_node = sand_node,
})

soil_type_spread("df_mapitems:sand_scum_spread", "df_mapitems:sand_scum", sand_node)

---------------------------------------------------------------
-- Pebble fungus

minetest.register_node("df_mapitems:dirt_with_pebble_fungus", {
	description = S("Dirt with Pebble Fungus"),
	_doc_items_longdesc = df_mapitems.doc.pebble_fungus_desc,
	_doc_items_usagehelp = df_mapitems.doc.pebble_fungus_usage,
	tiles = {"dfcaverns_ground_cover_pebble_fungus.png", dirt_texture, 
		{name = dirt_texture .. "^(dfcaverns_ground_cover_pebble_fungus.png^[mask:dfcaverns_ground_cover_side_mask.png)",
			tileable_vertical = false}},
	drop = dirt_node,
	is_ground_content = false,
	light_source = 2,
	paramtype = "light",
	groups = {crumbly = 3, soil = 1, light_sensitive_fungus = 8},
	sounds = df_mapitems.sounds.dirt,
	soil = {
		base = "df_mapitems:dirt_with_pebble_fungus",
		dry = farming_soil,
		wet = farming_soil_wet
	},
	_dfcaverns_dead_node = dirt_node,
})

soil_type_spread("df_mapitems:pebble_fungus_spread", "df_mapitems:dirt_with_pebble_fungus", dirt_node)

---------------------------------------------------------------
-- Stillworm

minetest.register_node("df_mapitems:dirt_with_stillworm", {
	description = S("Dirt with Stillworm"),
	_doc_items_longdesc = df_mapitems.doc.stillworm_desc,
	_doc_items_usagehelp = df_mapitems.doc.stillworm_usage,
	tiles = {dirt_texture .. "^dfcaverns_ground_cover_stillworm.png", dirt_texture, 
		{name = dirt_texture .. "^(dfcaverns_ground_cover_stillworm.png^[mask:dfcaverns_ground_cover_side_mask.png)",
			tileable_vertical = false}},
	drop = dirt_node,
	is_ground_content = false,
	light_source = 2,
	paramtype = "light",
	groups = {crumbly = 3, soil = 1, light_sensitive_fungus = 8},
	sounds = df_mapitems.sounds.dirt_mossy,
	soil = {
		base = "df_mapitems:dirt_with_stillworm",
		dry = farming_soil,
		wet = farming_soil_wet
	},
	_dfcaverns_dead_node = dirt_node,
})

soil_type_spread("df_mapitems:stillworm_spread", "df_mapitems:dirt_with_stillworm", dirt_node)

---------------------------------------------------------------
-- Spongestone / Rock rot

minetest.register_node("df_mapitems:spongestone", {
	description = S("Spongestone"),
	_doc_items_longdesc = df_mapitems.doc.sponge_stone_desc,
	_doc_items_usagehelp = df_mapitems.doc.sponge_stone_usage,
	tiles = {"dfcaverns_ground_cover_sponge_stone.png"},
	is_ground_content = false,
	paramtype = "light",
	groups = {crumbly = 3, soil = 1, light_sensitive_fungus = 8},
	sounds = df_mapitems.sounds.dirt,
	soil = {
		base = "df_mapitems:spongestone",
		dry = farming_soil,
		wet = farming_soil_wet
	},
	_dfcaverns_dead_node = dirt_node,
})

minetest.register_node("df_mapitems:rock_rot", {
	description = S("Rock Rot"),
	_doc_items_longdesc = df_mapitems.doc.rock_rot_desc,
	_doc_items_usagehelp = df_mapitems.doc.rock_rot_usage,
	tiles = {df_mapitems.texture.stone .. "^dfcaverns_ground_cover_rock_rot.png", df_mapitems.texture.stone, 
		{name = df_mapitems.texture.stone .. "^(dfcaverns_ground_cover_rock_rot.png^[mask:dfcaverns_ground_cover_side_mask.png)",
			tileable_vertical = false}},
	drop = df_mapitems.node_name.cobble,
	is_ground_content = false,
	light_source = 2,
	paramtype = "light",
	groups = {crumbly = 3, soil = 1, light_sensitive_fungus = 8},
	sounds = df_mapitems.sounds.dirt,
	_dfcaverns_dead_node = stone_node,
})

soil_type_spread("df_mapitems:rock_rot_spread", "df_mapitems:rock_rot", stone_node)
soil_type_spread("df_mapitems:spongestone_spread", "df_mapitems:spongestone", "df_mapitems:rock_rot")

--------------------------------------------------
-- floor fungus

-- white/yellow

minetest.register_node("df_mapitems:cobble_with_floor_fungus", {
	description = S("Cobblestone with Floor Fungus"),
	_doc_items_longdesc = df_mapitems.doc.floor_fungus_desc,
	_doc_items_usagehelp = df_mapitems.doc.floor_fungus_usage,
	tiles = {df_mapitems.texture.cobble .. "^dfcaverns_floor_fungus.png"},
	drops = cobble_node,
	is_ground_content = false,
	paramtype = "light",
	groups = {cracky = 3, stone = 2, slippery = 1, light_sensitive_fungus = 8},
	_dfcaverns_dead_node = df_mapitems.node_name.cobble,
	sounds = df_mapitems.sounds.floor_fungus,
})

minetest.register_node("df_mapitems:cobble_with_floor_fungus_fine", {
	description = S("Cobblestone with Floor Fungus"),
	_doc_items_longdesc = df_mapitems.doc.floor_fungus_desc,
	_doc_items_usagehelp = df_mapitems.doc.floor_fungus_usage,
	tiles = {df_mapitems.texture.cobble .. "^dfcaverns_floor_fungus_fine.png"},
	drops = cobble_node,
	is_ground_content = false,
	paramtype = "light",
	groups = {cracky = 3, stone = 2, slippery = 1, light_sensitive_fungus = 8},
	_dfcaverns_dead_node = df_mapitems.node_name.cobble,
	df_mapitems.sounds.floor_fungus,
})

minetest.register_abm{
	label = "df_mapitems:floor_fungus_spread",
	nodenames = {cobble_node},
	neighbors = {"df_mapitems:cobble_with_floor_fungus"},
	interval = 60,
	chance = 10,
	catch_up = true,
	action = function(pos)
		minetest.swap_node(pos, {name="df_mapitems:cobble_with_floor_fungus_fine"})
	end,
}
minetest.register_abm{
	label = "df_mapitems:floor_fungus_thickening",
	nodenames = {"df_mapitems:cobble_with_floor_fungus_fine"},
	interval = 59,
	chance = 10,
	catch_up = true,
	action = function(pos)
		minetest.swap_node(pos, {name="df_mapitems:cobble_with_floor_fungus"})
	end,
}

------------------------------------------------------
-- Hoar moss

minetest.register_node("df_mapitems:ice_with_hoar_moss", {
	description = S("Ice with Hoar Moss"),
	_doc_items_longdesc = df_mapitems.doc.hoar_moss_desc,
	_doc_items_usagehelp = df_mapitems.doc.hoar_moss_usage,
	tiles = {df_mapitems.texture.ice .. "^dfcaverns_hoar_moss.png"},
	drops = df_mapitems.node_name.ice,
	paramtype = "light",
	light_source = 2,
	is_ground_content = false,
	groups = {cracky = 3, puts_out_fire = 1, cools_lava = 1, slippery = 2, light_sensitive_fungus = 8},
	sounds = df_mapitems.sounds.glass,
	_dfcaverns_dead_node = df_mapitems.node_name.ice,
})


----------------------------------------------------------------
-- Footprint-capable nodes

if minetest.get_modpath("footprints") then
	local HARDPACK_PROBABILITY = tonumber(minetest.settings:get("footprints_hardpack_probability")) or 0.9 -- Chance walked dirt/grass is worn and compacted to footprints:trail.
	local HARDPACK_COUNT = tonumber(minetest.settings:get("footprints_hardpack_count")) or 10 -- Number of times the above chance needs to be passed for soil to compact.

	footprints.register_trample_node("df_mapitems:dirt_with_cave_moss", {
		trampled_node_def_override = {description = S("Dirt with Cave Moss and Footprint"),},
		hard_pack_node_name = "footprints:trail",
		footprint_opacity = 128,
		hard_pack_probability = HARDPACK_PROBABILITY,
		hard_pack_count = HARDPACK_COUNT,
	})

	footprints.register_trample_node("df_mapitems:sand_scum", {
		trampled_node_def_override = {description = S("Sand Scum with Footprint"),},
		hard_pack_node_name = df_mapitems.node_name.sand,
		footprint_opacity = 128,
		hard_pack_probability = HARDPACK_PROBABILITY,
		hard_pack_count = HARDPACK_COUNT * 0.5,
	})

	footprints.register_trample_node("df_mapitems:spongestone", {
		trampled_node_def_override = {description = S("Spongestone with Footprint"),},
		hard_pack_node_name = "footprints:trail",
		footprint_opacity = 128,
		hard_pack_probability = HARDPACK_PROBABILITY,
		hard_pack_count = HARDPACK_COUNT * 2,
	})

	footprints.register_trample_node("df_mapitems:dirt_with_pebble_fungus", {
		trampled_node_def_override = {description = S("Dirt with Pebble Fungus and Footprint"),},
		hard_pack_node_name = "footprints:trail",
		footprint_opacity = 128,
		hard_pack_probability = HARDPACK_PROBABILITY,
		hard_pack_count = HARDPACK_COUNT,
	})

	footprints.register_trample_node("df_mapitems:dirt_with_stillworm", {
		trampled_node_def_override = {description = S("Dirt with Stillworm and Footprint"),},
		hard_pack_node_name = "footprints:trail",
		footprint_opacity = 192,
		hard_pack_probability = HARDPACK_PROBABILITY,
		hard_pack_count = HARDPACK_COUNT,
	})
end
