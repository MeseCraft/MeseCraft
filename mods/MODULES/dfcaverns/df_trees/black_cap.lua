local S = minetest.get_translator(minetest.get_current_modname())

--stem
minetest.register_node("df_trees:black_cap_stem", {
	description = S("Black Cap Stem"),
	_doc_items_longdesc = df_trees.doc.black_cap_desc,
	_doc_items_usagehelp = df_trees.doc.black_cap_usage,
	tiles = {"dfcaverns_black_cap_top.png","dfcaverns_black_cap_top.png","dfcaverns_black_cap_side.png",},
	is_ground_content = false,
	groups = {tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, handy=1,axey=1, building_block=1, material_wood=1, fire_encouragement=5, fire_flammability=5},
	sounds = df_dependencies.sound_wood(),
	_mcl_blast_resistance = 6,
	_mcl_hardness = 5,
})

--cap
minetest.register_node("df_trees:black_cap", {
	description = S("Black Cap"),
	_doc_items_longdesc = df_trees.doc.black_cap_desc,
	_doc_items_usagehelp = df_trees.doc.black_cap_usage,
	tiles = {"dfcaverns_black_cap_top.png","dfcaverns_black_cap_top.png","dfcaverns_black_cap_side.png^[transformR90",},
	is_ground_content = false,
	groups = {tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, handy=1,axey=1, building_block=1, material_wood=1, fire_encouragement=5, fire_flammability=5},
	sounds = df_dependencies.sound_wood(),
	_mcl_blast_resistance = 6,
	_mcl_hardness = 5,
})

--gills
minetest.register_node("df_trees:black_cap_gills", {
	description = S("Black Cap Gills"),
	_doc_items_longdesc = df_trees.doc.black_cap_desc,
	_doc_items_usagehelp = df_trees.doc.black_cap_usage,
	tiles = {"dfcaverns_black_cap_gills.png"},
	is_ground_content = false,
	groups = {snappy = 3, leafdecay = 1, flammable = 2, leaves = 1,handy=1, hoey=1, shearsy=1, swordy=1, deco_block=1, dig_by_piston=1, fire_encouragement=15, fire_flammability=30, compostability=30},
	sounds = df_dependencies.sound_leaves(),
	drawtype = "plantlike",
	paramtype = "light",
	drop = {
		max_items = 1,
		items = {
			{
				items = {'df_trees:black_cap_sapling', 'df_trees:black_cap_gills'},
				rarity = 5,
			},
			{
				items = {'df_trees:black_cap_gills'},
			}
		}
	},
	after_place_node = df_dependencies.after_place_leaves,
	place_param2 = 1, -- Prevent leafdecay for placed nodes
	_mcl_blast_resistance = 0.2,
	_mcl_hardness = 0.2,
})

df_dependencies.register_leafdecay({
	trunks = {"df_trees:black_cap"}, -- don't need stem nodes here
	leaves = {"df_trees:black_cap_gills"},
	radius = 1,	
})

-- Wood
minetest.register_craft({
	output = 'df_trees:black_cap_wood 4',
	recipe = {
		{'df_trees:black_cap'},
	}
})

minetest.register_craft({
	output = 'df_trees:black_cap_wood 4',
	recipe = {
		{'df_trees:black_cap_stem'},
	}
})

minetest.register_craft({
	output = df_dependencies.node_name_torch .. ' 8',
	recipe = {
		{'df_trees:black_cap_gills'},
		{'group:stick'},
	}
})

if minetest.get_modpath("basic_materials") then
	minetest.register_craft({
		type = "cooking",
		output = "basic_materials:paraffin",
		recipe = "df_trees:black_cap_gills",
		cooktime = 5,
	})
end

minetest.register_node("df_trees:black_cap_wood", {
	description = S("Black Cap Planks"),
	_doc_items_longdesc = df_trees.doc.black_cap_desc,
	_doc_items_usagehelp = df_trees.doc.black_cap_usage,
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"dfcaverns_black_cap_wood.png"},
	is_ground_content = false,
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, wood = 1, handy=1,axey=1, building_block=1, material_wood=1, fire_encouragement=5, fire_flammability=20},
	sounds = df_dependencies.sound_wood(),
	_mcl_blast_resistance = 5,
	_mcl_hardness = 5,
})

df_dependencies.register_all_stairs_and_fences("black_cap_wood", {burntime = 30})

minetest.register_craft({
	type = "fuel",
	recipe = "df_trees:black_cap_wood",
	burntime = 30,
})
minetest.register_craft({
	type = "fuel",
	recipe = "df_trees:black_cap",
	burntime = 120,
})
minetest.register_craft({
	type = "fuel",
	recipe = "df_trees:black_cap_stem",
	burntime = 120,
})
minetest.register_craft({
	type = "fuel",
	recipe = "df_trees:black_cap_gills",
	burntime = 6,
})
minetest.register_craft({
	type = "fuel",
	recipe = "df_trees:black_cap_sapling",
	burntime = 6,
})

-- sapling
minetest.register_node("df_trees:black_cap_sapling", {
	description = S("Black Cap Spawn"),
	_doc_items_longdesc = df_trees.doc.black_cap_desc,
	_doc_items_usagehelp = df_trees.doc.black_cap_usage,
	drawtype = "plantlike",
	visual_scale = 1.0,
	tiles = {"dfcaverns_black_cap_sapling.png"},
	inventory_image = "dfcaverns_black_cap_sapling.png",
	wield_image = "dfcaverns_black_cap_sapling.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	is_ground_content = false,
	floodable = true,
	selection_box = {
		type = "fixed",
		fixed = {-4 / 16, -0.5, -4 / 16, 4 / 16, 7 / 16, 4 / 16}
	},
	groups = {snappy = 2, dig_immediate = 3, flammable = 2,
		attached_node = 1, sapling = 1, light_sensitive_fungus = 11, dig_immediate=3,dig_by_piston=1,destroy_by_lava_flow=1,deco_block=1, compostability=30},
	sounds = df_dependencies.sound_leaves(),
	_mcl_blast_resistance = 0.5,
	_mcl_hardness = 0.5,

	on_construct = function(pos)
		if df_trees.black_cap_growth_permitted(pos) then
			minetest.get_node_timer(pos):start(math.random(
				df_trees.config.black_cap_delay_multiplier*df_trees.config.tree_min_growth_delay,
				df_trees.config.black_cap_delay_multiplier*df_trees.config.tree_max_growth_delay))
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
		df_trees.spawn_black_cap(pos)
	end,
})

local c_stem = minetest.get_content_id("df_trees:black_cap_stem")
local c_cap  = minetest.get_content_id("df_trees:black_cap")
local c_gills = minetest.get_content_id("df_trees:black_cap_gills")

df_trees.spawn_black_cap = function(pos)
	local x, y, z = pos.x, pos.y, pos.z
	local stem_height = math.random(1,5)
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

df_trees.spawn_black_cap_vm = function(vi, area, data)
	local stem_height = math.random(1,5)
	local cap_radius = math.random(2,3)
	
	subterrane.giant_mushroom(vi, area, data, c_stem, c_cap, c_gills, stem_height, cap_radius)
end

