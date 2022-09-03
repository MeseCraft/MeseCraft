local S = minetest.get_translator(minetest.get_current_modname())


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

local farming_soil = df_dependencies.node_name_dirt_furrowed
local farming_soil_wet = df_dependencies.node_name_dirt_wet

--------------------------------------------------
-- Cave moss

-- cyan/dark cyan

local dirt_texture = df_dependencies.texture_dirt
local sand_texture = df_dependencies.texture_sand

local dirt_node = df_dependencies.node_name_dirt
local sand_node = df_dependencies.node_name_sand
local stone_node = df_dependencies.node_name_stone
local cobble_node = df_dependencies.node_name_cobble

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
	groups = {crumbly = 3, soil = 1, light_sensitive_fungus = 8, handy=1,shovely=1,dirt=2, soil_sapling=2, soil_sugarcane=1, cultivatable=1, enderman_takable=1, building_block=1, compostability=30, opaque=1},
	sounds = df_dependencies.sound_dirt({footstep = {name = df_dependencies.soundfile_grass_footstep, gain = 0.25},}),
	soil = {
		base = "df_mapitems:dirt_with_cave_moss",
		dry = farming_soil,
		wet = farming_soil_wet
	},
	_dfcaverns_dead_node = dirt_node,
	_mcl_blast_resistance = 0.5,
	_mcl_hardness = 0.6,
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
	groups = {crumbly = 3, soil = 1, light_sensitive_fungus = 8, handy=1,shovely=1, falling_node=1, sand=1, soil_sugarcane=1, enderman_takable=1, building_block=1, material_sand=1, opaque=1},
	sounds = df_dependencies.sound_sand({footstep = {name = "dfcaverns_squish", gain = 0.25},}),
	_dfcaverns_dead_node = sand_node,
	_mcl_blast_resistance = 0.5,
	_mcl_hardness = 0.5,
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
	groups = {crumbly = 3, soil = 1, light_sensitive_fungus = 8, handy=1,shovely=1,dirt=2, soil_sapling=2, soil_sugarcane=1, cultivatable=1, enderman_takable=1, building_block=1, compostability=30, opaque=1},
	sounds = df_dependencies.sound_dirt(),
	soil = {
		base = "df_mapitems:dirt_with_pebble_fungus",
		dry = farming_soil,
		wet = farming_soil_wet
	},
	_dfcaverns_dead_node = dirt_node,
	_mcl_blast_resistance = 0.5,
	_mcl_hardness = 0.6,
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
	groups = {crumbly = 3, soil = 1, light_sensitive_fungus = 8, handy=1,shovely=1,dirt=2, soil_sapling=2, soil_sugarcane=1, cultivatable=1, enderman_takable=1, building_block=1, compostability=30, opaque=1},
	sounds = df_dependencies.sound_dirt({footstep = {name = df_dependencies.soundfile_grass_footstep, gain = 0.25},}),
	soil = {
		base = "df_mapitems:dirt_with_stillworm",
		dry = farming_soil,
		wet = farming_soil_wet
	},
	_dfcaverns_dead_node = dirt_node,
	_mcl_blast_resistance = 0.5,
	_mcl_hardness = 0.6,
})

soil_type_spread("df_mapitems:stillworm_spread", "df_mapitems:dirt_with_stillworm", dirt_node)

---------------------------------------------------------------
-- Spongestone / Rock rot

minetest.register_node("df_mapitems:spongestone", {
	description = S("Spongestone"),
	_doc_items_longdesc = df_mapitems.doc.sponge_stone_desc,
	_doc_items_usagehelp = df_mapitems.doc.sponge_stone_usage,
	tiles = {"dfcaverns_ground_cover_sponge_stone.png"},
	drop = dirt_node,
	is_ground_content = false,
	paramtype = "light",
	groups = {crumbly = 3, soil = 1, light_sensitive_fungus = 8, shovely=1,dirt=2, enderman_takable=1, building_block=1, compostability=10, opaque=1},
	sounds = df_dependencies.sound_dirt(),
	soil = {
		base = "df_mapitems:spongestone",
		dry = farming_soil,
		wet = farming_soil_wet
	},
	_dfcaverns_dead_node = dirt_node,
	_mcl_blast_resistance = 0.6,
	_mcl_hardness = 0.6,
})

minetest.register_node("df_mapitems:rock_rot", {
	description = S("Rock Rot"),
	_doc_items_longdesc = df_mapitems.doc.rock_rot_desc,
	_doc_items_usagehelp = df_mapitems.doc.rock_rot_usage,
	tiles = {df_dependencies.texture_stone .. "^dfcaverns_ground_cover_rock_rot.png", df_dependencies.texture_stone, 
		{name = df_dependencies.texture_stone .. "^(dfcaverns_ground_cover_rock_rot.png^[mask:dfcaverns_ground_cover_side_mask.png)",
			tileable_vertical = false}},
	drop = df_dependencies.node_name_cobble,
	is_ground_content = false,
	light_source = 2,
	paramtype = "light",
	groups = {crumbly = 3, soil = 1, light_sensitive_fungus = 8, shovely=1,dirt=2, enderman_takable=1, building_block=1, compostability=5, opaque=1},
	sounds = df_dependencies.sound_dirt(),
	_dfcaverns_dead_node = stone_node,
	_mcl_blast_resistance = 3,
	_mcl_hardness = 1,
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
	tiles = {df_dependencies.texture_cobble .. "^dfcaverns_floor_fungus.png"},
	drop = cobble_node,
	paramtype = "light",
	is_ground_content = false,
	groups = {cracky = 3, stone = 2, slippery = 1, light_sensitive_fungus = 8, df_caverns_floor_fungus = 1, pickaxey=1, building_block=1, material_stone=1, opaque=1},
	_dfcaverns_dead_node = df_dependencies.node_name_cobble,
	sounds = df_dependencies.sound_stone({footstep = {name = "dfcaverns_squish", gain = 0.25},}),
	_mcl_blast_resistance = 6,
	_mcl_hardness = 1.5,
})

minetest.register_node("df_mapitems:cobble_with_floor_fungus_fine", {
	description = S("Cobblestone with Floor Fungus"),
	_doc_items_longdesc = df_mapitems.doc.floor_fungus_desc,
	_doc_items_usagehelp = df_mapitems.doc.floor_fungus_usage,
	tiles = {df_dependencies.texture_cobble .. "^dfcaverns_floor_fungus_fine.png"},
	drop = cobble_node,
	is_ground_content = false,
	paramtype = "light",
	groups = {cracky = 3, stone = 2, slippery = 1, light_sensitive_fungus = 8, df_caverns_floor_fungus = 1, pickaxey=1, building_block=1, material_stone=1, opaque=1},
	_dfcaverns_dead_node = df_dependencies.node_name_cobble,
	sounds = df_dependencies.sound_stone({footstep = {name = "dfcaverns_squish", gain = 0.25},}),
	_mcl_blast_resistance = 6,
	_mcl_hardness = 1.5,
	on_timer = function(pos, elapsed)
		minetest.swap_node(pos, {name="df_mapitems:cobble_with_floor_fungus"})
	end,
	on_destruct = function(pos)
		minetest.get_node_timer(pos):stop()
	end,
})

minetest.register_abm{
	label = "df_mapitems:floor_fungus_spread",
	nodenames = {cobble_node},
	neighbors = {"group:df_caverns_floor_fungus"},
	interval = 60,
	chance = 10,
	catch_up = true,
	action = function(pos)
		local above_def = minetest.registered_nodes[minetest.get_node({x=pos.x, y=pos.y+1, z=pos.z}).name]
		if above_def and (above_def.buildable_to == true or above_def.walkable == false) then
			minetest.swap_node(pos, {name="df_mapitems:cobble_with_floor_fungus_fine"})
			if math.random() > 0.5 then
				minetest.get_node_timer(pos):start(math.random(1000, 10000))
			end
		end
	end,
}

------------------------------------------------------
-- Hoar moss

minetest.register_node("df_mapitems:ice_with_hoar_moss", {
	description = S("Ice with Hoar Moss"),
	_doc_items_longdesc = df_mapitems.doc.hoar_moss_desc,
	_doc_items_usagehelp = df_mapitems.doc.hoar_moss_usage,
	tiles = {df_dependencies.texture_ice .. "^dfcaverns_hoar_moss.png"},
	drop = df_dependencies.node_name_ice,
	paramtype = "light",
	light_source = 2,
	is_ground_content = false,
	groups = {cracky = 3, puts_out_fire = 1, cools_lava = 1, slippery = 2, light_sensitive_fungus = 8, handy=1,pickaxey=1, building_block=1, ice=1, opaque=1},
	sounds = df_dependencies.sound_glass(),
	_dfcaverns_dead_node = df_dependencies.node_name_ice,
	_mcl_blast_resistance = 0.5,
	_mcl_hardness = 0.5,
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
		hard_pack_node_name = df_dependencies.node_name_sand,
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
