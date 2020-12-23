local S = df_primordial_items.S

----------------------------------------------------
-- Ferns

minetest.register_node("df_primordial_items:fern_1", {
	description = S("Primordial Fern"),
	_doc_items_longdesc = df_primordial_items.doc.fern_desc,
	_doc_items_usagehelp = df_primordial_items.doc.fern_usage,
	tiles = {"dfcaverns_jungle_fern_01.png"},
	inventory_image = "dfcaverns_jungle_fern_01.png",
	wield_image = "dfcaverns_jungle_fern_01.png",
	groups = {snappy = 3, flora = 1, attached_node = 1, flammable = 1, primordial_jungle_plant = 1, light_sensitive_fungus = 13},
	_dfcaverns_dead_node = df_primordial_items.node_names.dry_shrub,
	visual_scale = 1.69,
	paramtype = "light",
	drawtype = "plantlike",
	buildable_to = true,
	is_ground_content = false,
	walkable = false,
	sounds = df_primordial_items.sounds.leaves,
	use_texture_alpha = true,
	sunlight_propagates = true,
})

minetest.register_node("df_primordial_items:fern_2", {
	description = S("Primordial Fern"),
	_doc_items_longdesc = df_primordial_items.doc.fern_desc,
	_doc_items_usagehelp = df_primordial_items.doc.fern_usage,
	tiles = {"dfcaverns_jungle_fern_02.png"},
	visual_scale = 1.69,
	inventory_image = "dfcaverns_jungle_fern_02.png",
	wield_image = "dfcaverns_jungle_fern_02.png",
	groups = {snappy = 3, flora = 1, attached_node = 1, flammable = 1, primordial_jungle_plant = 1, light_sensitive_fungus = 13},
	_dfcaverns_dead_node = df_primordial_items.node_names.dry_shrub,
	paramtype = "light",
	drawtype = "plantlike",
	buildable_to = true,
	is_ground_content = false,
	walkable = false,
	sounds = df_primordial_items.sounds.leaves,
	use_texture_alpha = true,
	sunlight_propagates = true,
})

---------------------------------------------------------
-- Glowing plants

minetest.register_node("df_primordial_items:glow_plant_1", {
	description = S("Primordial Flower"),
	_doc_items_longdesc = df_primordial_items.doc.glow_plant_desc,
	_doc_items_usagehelp = df_primordial_items.doc.glow_plant_usage,
	tiles = {"dfcaverns_jungle_flower_01.png"},
	inventory_image = "dfcaverns_jungle_flower_01.png",
	wield_image = "dfcaverns_jungle_flower_01.png",
	groups = {snappy = 3, flora = 1, attached_node = 1, flammable = 1, primordial_jungle_plant = 1, light_sensitive_fungus = 13},
	_dfcaverns_dead_node = df_primordial_items.node_names.dry_shrub,
	paramtype = "light",
	drawtype = "plantlike",
	buildable_to = true,
	is_ground_content = false,
	walkable = false,
	light_source = 6,
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
	sounds = df_primordial_items.sounds.leaves,
	use_texture_alpha = true,
	sunlight_propagates = true,
})

minetest.register_node("df_primordial_items:glow_plant_2", {
	description = S("Primordial Jungle Pod"),
	_doc_items_longdesc = df_primordial_items.doc.glow_plant_desc,
	_doc_items_usagehelp = df_primordial_items.doc.glow_plant_usage,
	tiles = {"dfcaverns_jungle_glow_plant_01.png"},
	inventory_image = "dfcaverns_jungle_glow_plant_01.png",
	wield_image = "dfcaverns_jungle_glow_plant_01.png",
	groups = {snappy = 3, flora = 1, attached_node = 1, flammable = 1, primordial_jungle_plant = 1, light_sensitive_fungus = 13},
	_dfcaverns_dead_node = df_primordial_items.node_names.dry_shrub,
	paramtype = "light",
	drawtype = "plantlike",
	buildable_to = true,
	is_ground_content = false,
	walkable = false,
	drop = "df_primordial_items:glowtato",
	light_source = 6,
	sounds = df_primordial_items.sounds.leaves,
	use_texture_alpha = true,
	sunlight_propagates = true,
})

minetest.register_node("df_primordial_items:glow_plant_3", {
	description = S("Primordial Jungle Pod"),
	_doc_items_longdesc = df_primordial_items.doc.glow_plant_desc,
	_doc_items_usagehelp = df_primordial_items.doc.glow_plant_usage,
	tiles = {"dfcaverns_jungle_glow_plant_02.png"},
	inventory_image = "dfcaverns_jungle_glow_plant_02.png",
	wield_image = "dfcaverns_jungle_glow_plant_02.png",
	groups = {snappy = 3, flora = 1, attached_node = 1, flammable = 1, primordial_jungle_plant = 1, light_sensitive_fungus = 13},
	_dfcaverns_dead_node = df_primordial_items.node_names.dry_shrub,
	paramtype = "light",
	drawtype = "plantlike",
	drop = "df_primordial_items:glowtato 2",
	buildable_to = true,
	is_ground_content = false,
	walkable = false,
	light_source = 6,
	sounds = df_primordial_items.sounds.leaves,
	use_texture_alpha = true,
	sunlight_propagates = true,
})


-------------------------------------------------------------------
-- Grass

minetest.register_node("df_primordial_items:jungle_grass_1", {
	description = S("Primordial Jungle Grass"),
	_doc_items_longdesc = df_primordial_items.doc.grass_desc,
	_doc_items_usagehelp = df_primordial_items.doc.grass_usage,
	tiles = {"dfcaverns_jungle_grass_01.png"},
	inventory_image = "dfcaverns_jungle_grass_01.png",
	wield_image = "dfcaverns_jungle_grass_01.png",
	groups = {snappy = 3, flora = 1, attached_node = 1, flammable = 1, primordial_jungle_plant = 1, light_sensitive_fungus = 13},
	_dfcaverns_dead_node = df_primordial_items.node_names.dry_grass_3,
	paramtype = "light",
	drawtype = "plantlike",
	buildable_to = true,
	is_ground_content = false,
	walkable = false,
	sounds = df_primordial_items.sounds.leaves,
	use_texture_alpha = true,
	sunlight_propagates = true,
})

minetest.register_node("df_primordial_items:jungle_grass_2", {
	description = S("Primordial Jungle Grass"),
	_doc_items_longdesc = df_primordial_items.doc.grass_desc,
	_doc_items_usagehelp = df_primordial_items.doc.grass_usage,
	tiles = {"dfcaverns_jungle_grass_02.png"},
	inventory_image = "dfcaverns_jungle_grass_02.png",
	wield_image = "dfcaverns_jungle_grass_02.png",
	groups = {snappy = 3, flora = 1, attached_node = 1, flammable = 1, primordial_jungle_plant = 1, light_sensitive_fungus = 13},
	_dfcaverns_dead_node = df_primordial_items.node_names.dry_grass_4,
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

minetest.register_node("df_primordial_items:jungle_grass_3", {
	description = S("Primordial Jungle Grass"),
	_doc_items_longdesc = df_primordial_items.doc.grass_desc,
	_doc_items_usagehelp = df_primordial_items.doc.grass_usage,
	tiles = {"dfcaverns_jungle_grass_03.png"},
	inventory_image = "dfcaverns_jungle_grass_03.png",
	wield_image = "dfcaverns_jungle_grass_03.png",
	groups = {snappy = 3, flora = 1, attached_node = 1, flammable = 1, primordial_jungle_plant = 1, light_sensitive_fungus = 13},
	_dfcaverns_dead_node = df_primordial_items.node_names.dry_grass_4,
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


-----------------------------------------------------------------------------------------
-- Ivy

minetest.register_node("df_primordial_items:jungle_ivy", {
	description = S("Primordial Jungle Ivy"),
	_doc_items_longdesc = df_primordial_items.doc.ivy_desc,
	_doc_items_usagehelp = df_primordial_items.doc.ivy_usage,
	tiles = {"dfcaverns_jungle_ivy_01.png"},
	inventory_image = "dfcaverns_jungle_ivy_01.png",
	wield_image = "dfcaverns_jungle_ivy_01.png",
	groups = {snappy = 3, flora = 1, flammable = 1, vines = 1},
	paramtype = "light",
	drawtype = "plantlike",
	place_param2 = 3,
	--paramtype2 = "wallmouinted",
	--drawtype = "signlike",
	sounds = df_primordial_items.sounds.leaves,
	use_texture_alpha = true,
	sunlight_propagates = true,
	is_ground_content = false,
	walkable = false,
	climbable = true,
--	selection_box = {
--		type = "wallmounted",
--	},
})

-------------------------------------------------------------------------------------
-- Small jungle mushrooms

minetest.register_node("df_primordial_items:jungle_mushroom_1", {
	description = S("Primordial Jungle Mushroom"),
	_doc_items_longdesc = df_primordial_items.doc.small_mushroom_desc,
	_doc_items_usagehelp = df_primordial_items.doc.small_mushroom_usage,
	tiles = {"dfcaverns_jungle_mushroom_01.png^[multiply:#f3df2a"},
	inventory_image = "dfcaverns_jungle_mushroom_01.png^[multiply:#f3df2a",
	wield_image = "dfcaverns_jungle_mushroom_01.png^[multiply:#f3df2a",
	groups = {snappy = 3, flora = 1, attached_node = 1, flammable = 1, primordial_jungle_plant = 1, light_sensitive_fungus = 11},
	paramtype = "light",
	drawtype = "plantlike",
	buildable_to = true,
	is_ground_content = false,
	walkable = false,
	sounds = df_primordial_items.sounds.leaves,
	use_texture_alpha = true,
	sunlight_propagates = true,
})

minetest.register_node("df_primordial_items:jungle_mushroom_2", {
	description = S("Large Primordial Jungle Mushroom"),
	_doc_items_longdesc = df_primordial_items.doc.small_mushroom_desc,
	_doc_items_usagehelp = df_primordial_items.doc.small_mushroom_usage,
	tiles = {"dfcaverns_jungle_mushroom_02.png"},
	inventory_image = "dfcaverns_jungle_mushroom_02.png",
	wield_image = "dfcaverns_jungle_mushroom_02.png",
	groups = {snappy = 3, flora = 1, attached_node = 1, flammable = 1, primordial_jungle_plant = 1, light_sensitive_fungus = 11},
	paramtype = "light",
	drawtype = "plantlike",
	buildable_to = true,
	is_ground_content = false,
	walkable = false,
	sounds = df_primordial_items.sounds.leaves,
	use_texture_alpha = true,
	sunlight_propagates = true,
})

----------------------------------------------------------------------------------------
-- Dirt

minetest.register_node("df_primordial_items:dirt_with_jungle_grass", {
	description = S("Dirt With Primordial Jungle Grass"),
	_doc_items_longdesc = df_primordial_items.doc.dirt_with_jungle_grass_desc,
	_doc_items_usagehelp = df_primordial_items.doc.dirt_with_jungle_grass_usage,
	tiles = {"dfcaverns_jungle_plant_grass_node_01.png"},
	paramtype = "light",
	groups = {crumbly = 3, soil = 1, light_sensitive_fungus = 13},
	_dfcaverns_dead_node = df_primordial_items.node_names.dirt,
	is_ground_content = false,
	drops = df_primordial_items.node_names.dirt,
	sounds = df_primordial_items.sounds.dirt,
})

minetest.register_abm{
	label = "df_primordial_items:jungle_grass_spread",
	nodenames = {df_primordial_items.node_names.dirt},
	neighbors = {"df_mapitems:dirt_with_jungle_grass"},
	interval = 60,
	chance = 50,
	catch_up = true,
	action = function(pos)
		local above_def = minetest.registered_nodes[minetest.get_node({x=pos.x, y=pos.y+1, z=pos.z}).name]
		if above_def and (above_def.buildable_to == true or above_def.walkable == false) then
			minetest.swap_node(pos, {name="df_mapitems:dirt_with_jungle_grass"})
		end
	end,
}

minetest.register_node("df_primordial_items:plant_matter", {
	description = S("Primordial Plant Matter"),
	_doc_items_longdesc = df_primordial_items.doc.plant_matter_desc,
	_doc_items_usagehelp = df_primordial_items.doc.plant_matter_usage,
	tiles = {"dfcaverns_jungle_plant_matter_01.png"},
	is_ground_content = false,
	paramtype = "light",
	groups = {crumbly = 3, soil = 1, flammable = 1},
	sounds = df_primordial_items.sounds.dirt,
	on_timer = function(pos, elapsed)
		if elapsed > 130 then
			-- the timer triggered more than ten seconds after it was suppposed to,
			-- it may have been in an unloaded block. Rather than have all the timers
			-- go off at once now that the block's loaded, stagger them out again.
			minetest.get_node_timer(pos):start(math.random(10, 120))
			return
		end
		if minetest.find_node_near(pos, 1, {"air"}) == nil then
			minetest.set_node(pos, {name="df_primordial_items:packed_roots"})
		end
	end,
})

minetest.register_node("df_primordial_items:packed_roots", {
	description = S("Packed Primordial Jungle Roots"),
	_doc_items_longdesc = df_primordial_items.doc.packed_roots_desc,
	_doc_items_usagehelp = df_primordial_items.doc.packed_roots_usage,
	tiles = {"dfcaverns_jungle_plant_packed_roots_01.png"},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
	sounds = df_primordial_items.sounds.wood,
})


if minetest.get_modpath("footprints") then
	local HARDPACK_PROBABILITY = tonumber(minetest.settings:get("footprints_hardpack_probability")) or 0.9 -- Chance walked dirt/grass is worn and compacted to footprints:trail.
	local HARDPACK_COUNT = tonumber(minetest.settings:get("footprints_hardpack_count")) or 10 -- Number of times the above chance needs to be passed for soil to compact.

	footprints.register_trample_node("df_primordial_items:dirt_with_jungle_grass", {
		trampled_node_def_override = {description = S("Dirt With Primordial Jungle Grass and Footprint"),},
		footprint_opacity = 128,
		hard_pack_node_name = "footprints:trail",
		hard_pack_probability = HARDPACK_PROBABILITY,
		hard_pack_count = HARDPACK_COUNT,
	})	
	footprints.register_trample_node("df_primordial_items:plant_matter", {
		trampled_node_def_override = {description = S("Primordial Plant Matter with Footprint"),},
		footprint_opacity = 128,
		hard_pack_node_name = "df_primordial_items:packed_roots",
		hard_pack_probability = HARDPACK_PROBABILITY,
		hard_pack_count = HARDPACK_COUNT,
	})
end

minetest.register_craft({
	type = "fuel",
	recipe = "df_primordial_items:packed_roots",
	burntime = 40,
})

minetest.register_craft({
	type = "fuel",
	recipe = "df_primordial_items:plant_matter",
	burntime = 20,
})

----------------------------------------------------------------------------------------
-- Roots

minetest.register_node("df_primordial_items:jungle_roots_1", {
	description = S("Primordial Jungle Roots"),
	_doc_items_longdesc = df_primordial_items.doc.roots_desc,
	_doc_items_usagehelp = df_primordial_items.doc.roots_usage,
	tiles = {"dfcaverns_jungle_root_01.png"},
	inventory_image = "dfcaverns_jungle_root_01.png",
	wield_image = "dfcaverns_jungle_root_01.png",
	groups = {snappy = 3, flora = 1, flammable = 1, vines = 1},
	paramtype = "light",
	drawtype = "plantlike",
	sounds = df_primordial_items.sounds.leaves,
	use_texture_alpha = true,
	sunlight_propagates = true,
	walkable = false,
	climbable = true,
	is_ground_content = false,
})

minetest.register_node("df_primordial_items:jungle_roots_2", {
	description = S("Primordial Jungle Root"),
	_doc_items_longdesc = df_primordial_items.doc.roots_desc,
	_doc_items_usagehelp = df_primordial_items.doc.roots_usage,
	tiles = {"dfcaverns_jungle_root_02.png"},
	inventory_image = "dfcaverns_jungle_root_02.png",
	wield_image = "dfcaverns_jungle_root_02.png",
	groups = {snappy = 3, flora = 1, flammable = 1, vines = 1},
	paramtype = "light",
	drawtype = "plantlike",
	sounds = df_primordial_items.sounds.leaves,
	use_texture_alpha = true,
	is_ground_content = false,
	sunlight_propagates = true,
	walkable = false,
	climbable = true,
})

--------------------------------------------------------------------------------
-- Thorns

minetest.register_node("df_primordial_items:jungle_thorns", {
	description = S("Primordial Jungle Thorns"),
	_doc_items_longdesc = df_primordial_items.doc.thorn_desc,
	_doc_items_usagehelp = df_primordial_items.doc.thorn_usage,
	tiles = {"dfcaverns_jungle_thorns_01.png"},
	visual_scale = 1.41,
	inventory_image = "dfcaverns_jungle_thorns_01.png",
	wield_image = "dfcaverns_jungle_thorns_01.png",
	groups = {snappy = 3, flora = 1, flammable = 1, primordial_jungle_plant = 1},
	paramtype = "light",
	drawtype = "plantlike",
	walkable = false,
	is_ground_content = false,
	place_param2 = 3,
	sounds = df_primordial_items.sounds.leaves,
	use_texture_alpha = true,
	sunlight_propagates = true,
	damage_per_second = 1,
})


-- TODO I had an idea to make thorns grow into mazes naturally using cellular automata rules, but it turned out to be 
-- complicated and probably not worth it right now. Deal with it later.

--local thorn_dir = 
--{
--	{x=1,y=0,z=1},
--	{x=-1,y=0,z=-1},
--	{x=1,y=0,z=0},
--	{x=1,y=0,z=-1},
--	{x=-1,y=0,z=0},
--	{x=-1,y=0,z=1},
--}
--
--
--local thorn_name = "df_primordial_items:jungle_thorns"
--minetest.register_abm({
--	label = "Primordial thorn growth",
--	nodenames = {thorn_name},
--	neighbors = {"group:soil"},
--	interval = 1.0,
--	chance = 5,
--	catch_up = true,
--	action = function(pos, node, active_object_count, active_object_count_wider)
--		if math.random() < 0.1 then
--			local above = vector.add({x=0,y=1,z=0},pos)
--			local below = vector.add({x=0,y=-1,z=0},pos)
--			local above_node = minetest.get_node(above)
--			local below_node = minetest.get_node(below)
--			if above_node.name == "air" and minetest.get_item_group(below_node.name, "soil") then
--				minetest.set_node(above, {name=thorn_name})
--			end
--			if below_node.name == "air" then
--				minetest.set_node(below, {name=thorn_name})
--			end
--			return
--		end
--	
--		local dir = thorn_dir[math.random(#thorn_dir)]
--		local target_pos = vector.add(dir, pos)
--		-- This gets the corners of the target zone
--		local pos1 = vector.add(target_pos, thorn_dir[1])
--		local pos2 = vector.add(target_pos, thorn_dir[2])
--
--		local list, counts = minetest.find_nodes_in_area(pos1, pos2, {thorn_name})
--		local count = counts[thorn_name]
--		local target_node = minetest.get_node(target_pos)
--		-- Cellular automaton rule B3/S12345, approximately
--		if count == 3 and target_node.name == "air" then
--			minetest.set_node(target_pos, {name=thorn_name})
--		elseif count > 5 then
--			minetest.set_node(target_pos, {name="air"})
--		end
--	end
--})
