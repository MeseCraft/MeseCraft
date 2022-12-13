local S = minetest.get_translator(minetest.get_current_modname())

local nethercap_name = df_dependencies.nethercap_name

--stem
minetest.register_node("df_trees:nether_cap_stem", {
	description = S("@1 Stem", nethercap_name),
	_doc_items_longdesc = df_trees.doc.nether_cap_desc,
	_doc_items_usagehelp = df_trees.doc.nether_cap_usage,
	tiles = {"dfcaverns_nether_cap_stem.png"},
	is_ground_content = false,
	groups = {tree = 1, choppy = 2, oddly_breakable_by_hand = 1, puts_out_fire = 1, cools_lava = 1, freezes_water = 1, nether_cap = 1, handy=1,axey=1, building_block=1, material_wood=1},
	sounds = df_dependencies.sound_wood(),
	_mcl_blast_resistance = 0.7,
	_mcl_hardness = 0.7,
})

--cap
minetest.register_node("df_trees:nether_cap", {
	description = nethercap_name,
	_doc_items_longdesc = df_trees.doc.nether_cap_desc,
	_doc_items_usagehelp = df_trees.doc.nether_cap_usage,
	tiles = {"dfcaverns_nether_cap.png"},
	is_ground_content = false,
	groups = {tree = 1, choppy = 2, oddly_breakable_by_hand = 1, puts_out_fire = 1, cools_lava = 1, freezes_water = 1, nether_cap = 1, handy=1,axey=1, building_block=1, material_wood=1},
	sounds = df_dependencies.sound_wood({footstep = {name = df_dependencies.soundfile_snow_footstep, gain = 0.2},}),
	_mcl_blast_resistance = 0.5,
	_mcl_hardness = 0.5,
})

--gills
minetest.register_node("df_trees:nether_cap_gills", {
	description = S("@1 Gills", nethercap_name),
	_doc_items_longdesc = df_trees.doc.nether_cap_desc,
	_doc_items_usagehelp = df_trees.doc.nether_cap_usage,
	tiles = {"dfcaverns_nether_cap_gills.png"},
	is_ground_content = false,
	light_source = 6,
	groups = {snappy = 3, leafdecay = 1, leaves = 1, puts_out_fire = 1, cools_lava = 1, freezes_water = 1, nether_cap = 1,handy=1, hoey=1, shearsy=1, swordy=1, deco_block=1, dig_by_piston=1},
	sounds = df_dependencies.sound_leaves(),
	drawtype = "plantlike",
	paramtype = "light",
	drop = {
		max_items = 1,
		items = {
			{
				items = {'df_trees:nether_cap_sapling'},
				rarity = 5,
			},
			{
				items = {'df_trees:nether_cap_gills'},
			}
		}
	},
	after_place_node = df_dependencies.after_place_leaves,
	place_param2 = 1, -- Prevent leafdecay for placed nodes
	_mcl_blast_resistance = 0.1,
	_mcl_hardness = 0.1,
})

df_dependencies.register_leafdecay({
	trunks = {"df_trees:nether_cap"}, -- don't need stem nodes here
	leaves = {"df_trees:nether_cap_gills"},
	radius = 1,	
})

--Wood
minetest.register_craft({
	output = 'df_trees:nether_cap_wood 4',
	recipe = {
		{'df_trees:nether_cap'},
	}
})

minetest.register_craft({
	output = 'df_trees:nether_cap_wood 4',
	recipe = {
		{'df_trees:nether_cap_stem'},
	}
})

minetest.register_node("df_trees:nether_cap_wood", {
	description = S("@1 Planks", nethercap_name),
	_doc_items_longdesc = df_trees.doc.nether_cap_desc,
	_doc_items_usagehelp = df_trees.doc.nether_cap_usage,
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"dfcaverns_nether_cap_wood.png"},
	is_ground_content = false,
	groups = {choppy = 2, oddly_breakable_by_hand = 2, wood = 1, freezes_water = 1, handy=1,axey=1,building_block=1, material_wood=1},
	sounds = df_dependencies.sound_wood(),
	_mcl_blast_resistance = 0.5,
	_mcl_hardness = 0.5,
})

df_dependencies.register_all_stairs_and_fences("nether_cap_wood")

-- sapling
minetest.register_node("df_trees:nether_cap_sapling", {
	description = S("@1 Spawn", nethercap_name),
	_doc_items_longdesc = df_trees.doc.nether_cap_desc,
	_doc_items_usagehelp = df_trees.doc.nether_cap_usage,
	drawtype = "plantlike",
	visual_scale = 1.0,
	tiles = {"dfcaverns_nether_cap_sapling.png"},
	inventory_image = "dfcaverns_nether_cap_sapling.png",
	wield_image = "dfcaverns_nether_cap_sapling.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	is_ground_content = false,
	floodable = true, -- nether cap spawn aren't tough enough to freeze water yet
	selection_box = {
		type = "fixed",
		fixed = {-4 / 16, -0.5, -4 / 16, 4 / 16, 7 / 16, 4 / 16}
	},
	groups = {snappy = 2, dig_immediate = 3,
		attached_node = 1, sapling = 1, light_sensitive_fungus = 11, dig_immediate=3,dig_by_piston=1,destroy_by_lava_flow=1,deco_block=1},
	sounds = df_dependencies.sound_leaves(),
	_mcl_blast_resistance = 0.1,
	_mcl_hardness = 0.1,

	on_construct = function(pos)
		if df_trees.nether_cap_growth_permitted(pos) then
			minetest.get_node_timer(pos):start(math.random(
				df_trees.config.nether_cap_delay_multiplier*df_trees.config.tree_min_growth_delay,
				df_trees.config.nether_cap_delay_multiplier*df_trees.config.tree_max_growth_delay))
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
		df_trees.spawn_nether_cap(pos)
	end,
})

local c_stem = minetest.get_content_id("df_trees:nether_cap_stem")
local c_cap  = minetest.get_content_id("df_trees:nether_cap")
local c_gills  = minetest.get_content_id("df_trees:nether_cap_gills")

df_trees.spawn_nether_cap = function(pos)
	local x, y, z = pos.x, pos.y, pos.z
	local stem_height = math.random(1,3)
	local cap_radius = math.random(2,3)
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

df_trees.spawn_nether_cap_vm = function(vi, area, data)
	local stem_height = math.random(1,3)
	local cap_radius = math.random(2,3)
	subterrane.giant_mushroom(vi, area, data, c_stem, c_cap, c_gills, stem_height, cap_radius)
end

local water = df_dependencies.node_name_water_source
local river_water = df_dependencies.node_name_river_water_source
local ice = df_dependencies.node_name_ice
local water_flowing = df_dependencies.node_name_water_flowing
local river_water_flowing = df_dependencies.node_name_river_water_flowing
local snow = df_dependencies.node_name_snow

minetest.register_abm{
	label = "water freezing",
	nodenames = {water, river_water,},
	neighbors = {"group:freezes_water"},
	interval = 1,
	chance = 5,
	catch_up = true,
	action = function(pos)
		minetest.swap_node(pos, {name=ice})
	end,
}

minetest.register_abm{
	label = "flowing water freezing",
	nodenames = {water_flowing,  river_water_flowing},
	neighbors = {"group:freezes_water"},
	interval = 1,
	chance = 1,
	catch_up = true,
	action = function(pos)
		minetest.swap_node(pos, {name=snow})
	end,
}