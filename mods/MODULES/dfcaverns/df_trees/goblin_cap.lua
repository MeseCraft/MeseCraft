local modpath = minetest.get_modpath(minetest.get_current_modname())
local S = minetest.get_translator(minetest.get_current_modname())

local log_location
if minetest.get_modpath("mapgen_helper") and mapgen_helper.log_location_enabled then
	log_location = mapgen_helper.log_first_location
end

--stem
minetest.register_node("df_trees:goblin_cap_stem", {
	description = S("Goblin Cap Stem"),
	_doc_items_longdesc = df_trees.doc.goblin_cap_desc,
	_doc_items_usagehelp = df_trees.doc.goblin_cap_usage,
	tiles = {"dfcaverns_goblin_cap_stem.png"},
	is_ground_content = false,
	groups = {tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, goblin_cap = 1, handy=1,axey=1, building_block=1, material_wood=1, fire_encouragement=5, fire_flammability=5},
	sounds = df_trees.node_sound_tree_soft_fungus_defaults(),
	_mcl_blast_resistance = 2,
	_mcl_hardness = 2,
})

--cap
minetest.register_node("df_trees:goblin_cap", {
	description = S("Goblin Cap"),
	_doc_items_longdesc = df_trees.doc.goblin_cap_desc,
	_doc_items_usagehelp = df_trees.doc.goblin_cap_usage,
	tiles = {"dfcaverns_goblin_cap.png"},
	is_ground_content = false,
	groups = {tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, goblin_cap = 1, handy=1,axey=1, building_block=1, material_wood=1, fire_encouragement=5, fire_flammability=5},
	sounds = df_trees.node_sound_tree_soft_fungus_defaults(),
	_mcl_blast_resistance = 2,
	_mcl_hardness = 2,
})

--gills
minetest.register_node("df_trees:goblin_cap_gills", {
	description = S("Goblin Cap Gills"),
	_doc_items_longdesc = df_trees.doc.goblin_cap_desc,
	_doc_items_usagehelp = df_trees.doc.goblin_cap_usage,
	tiles = {"dfcaverns_goblin_cap_gills.png"},
	is_ground_content = false,
	groups = {snappy = 3, leafdecay = 1, flammable = 2, leaves = 1, goblin_cap = 1,handy=1, hoey=1, shearsy=1, swordy=1, deco_block=1, dig_by_piston=1, fire_encouragement=15, fire_flammability=30, compostability=30},
	sounds = df_dependencies.sound_leaves(),
	drawtype = "plantlike",
	paramtype = "light",
	drop = {
		max_items = 1,
		items = {
			{
				items = {'df_trees:goblin_cap_sapling'},
				rarity = 15,
			},
			{
				items = {'df_trees:goblin_cap_gills'},
			}
		}
	},
	after_place_node = df_dependencies.after_place_leaves,
	place_param2 = 1, -- Prevent leafdecay for placed nodes
	_mcl_blast_resistance = 0.2,
	_mcl_hardness = 0.2,
})

df_dependencies.register_leafdecay({
	trunks = {"df_trees:goblin_cap"}, -- don't need stem nodes here
	leaves = {"df_trees:goblin_cap_gills"},
	radius = 1,	
})

--Wood
minetest.register_craft({
	output = 'df_trees:goblin_cap_wood 4',
	recipe = {
		{'df_trees:goblin_cap'},
	}
})

minetest.register_craft({
	output = 'df_trees:goblin_cap_stem_wood 4',
	recipe = {
		{'df_trees:goblin_cap_stem'},
	}
})

minetest.register_node("df_trees:goblin_cap_wood", {
	description = S("Goblin Cap Planks"),
	_doc_items_longdesc = df_trees.doc.goblin_cap_desc,
	_doc_items_usagehelp = df_trees.doc.goblin_cap_usage,
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"dfcaverns_goblin_cap_wood.png"},
	is_ground_content = false,
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, wood = 1, handy=1,axey=1, building_block=1, material_wood=1, fire_encouragement=5, fire_flammability=20},
	sounds = df_dependencies.sound_wood(),
	_mcl_blast_resistance = 3,
	_mcl_hardness = 2,
})

minetest.register_node("df_trees:goblin_cap_stem_wood", {
	description = S("Goblin Cap Stem Planks"),
	_doc_items_longdesc = df_trees.doc.goblin_cap_desc,
	_doc_items_usagehelp = df_trees.doc.goblin_cap_usage,
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"dfcaverns_goblin_cap_stem_wood.png"},
	is_ground_content = false,
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, wood = 1, handy=1,axey=1, building_block=1, material_wood=1, fire_encouragement=5, fire_flammability=20},
	sounds = df_dependencies.sound_wood(),
	_mcl_blast_resistance = 3,
	_mcl_hardness = 2,
})

df_dependencies.register_all_stairs_and_fences("goblin_cap_wood", {burntime = 12})
df_dependencies.register_all_stairs_and_fences("goblin_cap_stem_wood", {burntime = 7})

minetest.register_craft({
	type = "fuel",
	recipe = "df_trees:goblin_cap_wood",
	burntime = 12,
})
minetest.register_craft({
	type = "fuel",
	recipe = "df_trees:goblin_cap_stem_wood",
	burntime = 7,
})
minetest.register_craft({
	type = "fuel",
	recipe = "df_trees:goblin_cap",
	burntime = 40,
})
minetest.register_craft({
	type = "fuel",
	recipe = "df_trees:goblin_cap_stem",
	burntime = 30,
})
minetest.register_craft({
	type = "fuel",
	recipe = "df_trees:goblin_cap_gills",
	burntime = 2,
})
minetest.register_craft({
	type = "fuel",
	recipe = "df_trees:goblin_cap_sapling",
	burntime = 2,
})

local big_goblin_cap_schem = dofile(modpath.."/schematics/goblin_cap_big.lua")
local big_goblin_cap_hut_schem = dofile(modpath.."/schematics/goblin_cap_big_hut.lua")
local bigger_goblin_cap_schem = dofile(modpath.."/schematics/goblin_cap_bigger.lua")
local bigger_goblin_cap_hut_schem = dofile(modpath.."/schematics/goblin_cap_bigger_hut.lua")

-- The hut has a chest and furnace near pos, use this to initialize it
local chest_node = df_dependencies.node_name_chest
local furnace_node = df_dependencies.node_name_furnace
local gold_item = df_dependencies.node_name_gold_ingot
local apple_item = df_dependencies.node_name_apple

local chest_on_construct = minetest.registered_items[chest_node].on_construct
local furnace_on_construct = minetest.registered_items[furnace_node].on_construct
local init_hut = function(pos)
	local chest_pos = minetest.find_node_near({x=pos.x, y=pos.y+1, z=pos.z}, 2, chest_node)
	if chest_pos then
		chest_on_construct(chest_pos)
		local inv = minetest.get_inventory({type="node", pos=chest_pos})
		inv:add_item("main", apple_item.." 3")
		inv:add_item("main", gold_item.." ".. math.random(1,5))
	end
	local furnace_pos = minetest.find_node_near({x=pos.x, y=pos.y+1, z=pos.z}, 2, furnace_node)
	if furnace_pos then
		furnace_on_construct(furnace_pos)
	end
end
local init_vessels
if minetest.get_modpath("vessels") then
	local vessels_on_construct = minetest.registered_items["vessels:shelf"].on_construct
	init_vessels = function(pos)
		local vessel_pos = minetest.find_node_near({x=pos.x, y=pos.y+1, z=pos.z}, 2, "vessels:shelf")
		if vessel_pos then
			vessels_on_construct(vessel_pos)
			local inv = minetest.get_inventory({type="node", pos=vessel_pos})
			inv:add_item("vessels", "df_trees:glowing_bottle_red "..math.random(50,99))
			inv:add_item("vessels", "df_trees:glowing_bottle_green "..math.random(50,99))
			inv:add_item("vessels", "df_trees:glowing_bottle_cyan "..math.random(40,99))
			inv:add_item("vessels", "df_trees:glowing_bottle_golden "..math.random(30,99))
		end
	end
end

--local debug_test_hut = function(pos)
--	minetest.set_node(pos, {name="air"})
--	minetest.after(5, init_hut, pos)
--	if math.random() < 0.5 then
--		mapgen_helper.place_schematic(pos, big_goblin_cap_hut_schem, "random")
--	else
--		if init_vessels then
--			minetest.after(5, init_vessels, pos)
--		end
--		mapgen_helper.place_schematic(pos, bigger_goblin_cap_hut_schem, "random")
--	end
--end


-- sapling
minetest.register_node("df_trees:goblin_cap_sapling", {
	description = S("Goblin Cap Spawn"),
	_doc_items_longdesc = df_trees.doc.goblin_cap_desc,
	_doc_items_usagehelp = df_trees.doc.goblin_cap_usage,
	drawtype = "plantlike",
	visual_scale = 1.0,
	tiles = {"dfcaverns_goblin_cap_sapling.png"},
	inventory_image = "dfcaverns_goblin_cap_sapling.png",
	wield_image = "dfcaverns_goblin_cap_sapling.png",
	paramtype = "light",
	sunlight_propagates = true,
	is_ground_content = false,
	walkable = false,
	floodable = true,
	selection_box = {
		type = "fixed",
		fixed = {-4 / 16, -0.5, -4 / 16, 4 / 16, 7 / 16, 4 / 16}
	},
	groups = {snappy = 2, dig_immediate = 3, flammable = 2,
		attached_node = 1, sapling = 1, light_sensitive_fungus = 11, dig_immediate=3,dig_by_piston=1,destroy_by_lava_flow=1,deco_block=1, compostability=30},
	sounds = df_dependencies.sound_leaves(),
	_mcl_blast_resistance = 0.2,
	_mcl_hardness = 0.2,

	on_construct = function(pos)
		if df_trees.goblin_cap_growth_permitted(pos) then
			minetest.get_node_timer(pos):start(math.random(
				df_trees.config.goblin_cap_delay_multiplier*df_trees.config.tree_min_growth_delay,
				df_trees.config.goblin_cap_delay_multiplier*df_trees.config.tree_max_growth_delay))
		end
	end,
	on_destruct = function(pos)
		minetest.get_node_timer(pos):stop()
	end,
	
	on_timer = function(pos)
		if df_farming and df_farming.kill_if_sunlit(pos) then
			return
		end

		minetest.set_node(pos, {name="air"})
		if minetest.find_node_near({x=pos.x, y=pos.y-1, z=pos.z}, 1, {"group:straw"}) then
			if math.random() < 0.5 then
				mapgen_helper.place_schematic(pos, big_goblin_cap_schem)
			else
				mapgen_helper.place_schematic(pos, bigger_goblin_cap_schem)
			end
			return
		else
			df_trees.spawn_goblin_cap(pos)
		end
	end,
})

local c_stem = minetest.get_content_id("df_trees:goblin_cap_stem")
local c_cap  = minetest.get_content_id("df_trees:goblin_cap")
local c_gills  = minetest.get_content_id("df_trees:goblin_cap_gills")

df_trees.spawn_goblin_cap = function(pos)
	if math.random() < 0.1 then
		if math.random() < 0.5 then
			mapgen_helper.place_schematic(pos, big_goblin_cap_schem)
		else
			mapgen_helper.place_schematic(pos, bigger_goblin_cap_schem)
		end
		return
	end

	local x, y, z = pos.x, pos.y, pos.z
	
	local stem_height = math.random(1,3)
	local cap_radius = math.random(3,6)
	local maxy = y + stem_height + 3
	
	local vm = minetest.get_voxel_manip()
	local minp, maxp = vm:read_from_map(
		{x = x - cap_radius, y = y, z = z - cap_radius},
		{x = x + cap_radius, y = maxy + 3, z = z + cap_radius}
	)
	local area = VoxelArea:new({MinEdge = minp, MaxEdge = maxp})
	local data = vm:get_data()

	subterrane.giant_mushroom(area:indexp(pos), area, data, c_stem, c_cap, c_gills, stem_height, cap_radius)
	
	vm:set_data(data)
	vm:write_to_map()
	vm:update_map()
end

df_trees.spawn_goblin_cap_vm = function(vi, area, data, data_param2)
	if math.random() < 0.1 then
		local pos = area:position(vi)
		if math.random() < 0.5 then
			mapgen_helper.place_schematic_on_data(data, data_param2, area, pos, big_goblin_cap_schem)
			if log_location then log_location("goblin_cap_big", pos) end
		elseif math.random() < 0.9 then
			mapgen_helper.place_schematic_on_data(data, data_param2, area, pos, bigger_goblin_cap_schem)
			if log_location then log_location("goblin_cap_bigger", pos) end
		else
			-- easter egg - every once in a while (0.5%), a mapgen Goblin cap is a Smurf house
			minetest.after(5, init_hut, pos)
			if math.random() < 0.5 then
				mapgen_helper.place_schematic_on_data(data, data_param2, area, pos, big_goblin_cap_hut_schem)
				if log_location then log_location("goblin_cap_big_hut", pos) end
			else
				if init_vessels then
					minetest.after(5, init_vessels, pos)
				end
				mapgen_helper.place_schematic_on_data(data, data_param2, area, pos, bigger_goblin_cap_hut_schem)
				if log_location then log_location("goblin_cap_bigger_hut", pos) end
			end
		end
		return
	end

	local stem_height = math.random(1,3)
	local cap_radius = math.random(3,6)
	subterrane.giant_mushroom(vi, area, data, c_stem, c_cap, c_gills, stem_height, cap_radius)
end