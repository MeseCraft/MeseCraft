-- internationalization boilerplate
local MP = minetest.get_modpath(minetest.get_current_modname())
local S, NS = dofile(MP.."/intllib.lua")

--stem
minetest.register_node("df_trees:nether_cap_stem", {
	description = S("Nether Cap Stem"),
	_doc_items_longdesc = df_trees.doc.nether_cap_desc,
	_doc_items_usagehelp = df_trees.doc.nether_cap_usage,
	tiles = {"dfcaverns_nether_cap_stem.png"},
	is_ground_content = false,
	groups = {tree = 1, choppy = 2, oddly_breakable_by_hand = 1, puts_out_fire = 1, cools_lava = 1, freezes_water = 1, nether_cap = 1},
	sounds = default.node_sound_wood_defaults(),
})

--cap
minetest.register_node("df_trees:nether_cap", {
	description = S("Nether Cap"),
	_doc_items_longdesc = df_trees.doc.nether_cap_desc,
	_doc_items_usagehelp = df_trees.doc.nether_cap_usage,
	tiles = {"dfcaverns_nether_cap.png"},
	is_ground_content = false,
	groups = {tree = 1, choppy = 2, oddly_breakable_by_hand = 1, puts_out_fire = 1, cools_lava = 1, freezes_water = 1, nether_cap = 1},
	sounds = default.node_sound_wood_defaults({
		footstep = {name = "default_snow_footstep", gain = 0.2},
	}),
})

--gills
minetest.register_node("df_trees:nether_cap_gills", {
	description = S("Nether Cap Gills"),
	_doc_items_longdesc = df_trees.doc.nether_cap_desc,
	_doc_items_usagehelp = df_trees.doc.nether_cap_usage,
	tiles = {"dfcaverns_nether_cap_gills.png"},
	is_ground_content = false,
	light_source = 6,
	groups = {snappy = 3, leafdecay = 3, leaves = 1, puts_out_fire = 1, cools_lava = 1, freezes_water = 1, nether_cap = 1},
	sounds = default.node_sound_leaves_defaults(),
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
	after_place_node = default.after_place_leaves,
})

if default.register_leafdecay then -- default.register_leafdecay is very new, remove this check some time after 0.4.16 is released
	default.register_leafdecay({
		trunks = {"df_trees:nether_cap"}, -- don't need stem nodes here
		leaves = {"df_trees:nether_cap_gills"},
		radius = 1,	
	})
end

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
	description = S("Nether Cap Planks"),
	_doc_items_longdesc = df_trees.doc.nether_cap_desc,
	_doc_items_usagehelp = df_trees.doc.nether_cap_usage,
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"dfcaverns_nether_cap_wood.png"},
	is_ground_content = false,
	groups = {choppy = 2, oddly_breakable_by_hand = 2, wood = 1, freezes_water = 1},
	sounds = default.node_sound_wood_defaults(),
})

df_trees.register_all_stairs("nether_cap_wood")

-- sapling
minetest.register_node("df_trees:nether_cap_sapling", {
	description = S("Nether Cap Spawn"),
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
		attached_node = 1, sapling = 1, light_sensitive_fungus = 11},
	sounds = default.node_sound_leaves_defaults(),

	on_construct = function(pos)
		local node_below_name = minetest.get_node({x=pos.x, y=pos.y-1, z=pos.z}).name
		if minetest.get_item_group(node_below_name, "cools_lava") == 0 or minetest.get_item_group(node_below_name, "nether_cap") > 0 then
			return
		end

		minetest.get_node_timer(pos):start(math.random(
			df_trees.config.nether_cap_delay_multiplier*df_trees.config.tree_min_growth_delay,
			df_trees.config.nether_cap_delay_multiplier*df_trees.config.tree_max_growth_delay))
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

minetest.register_abm{
	label = "water freezing",
	nodenames = {"default:water_source", "default:river_water_source",},
	neighbors = {"group:freezes_water"},
	interval = 1,
	chance = 5,
	catch_up = true,
	action = function(pos)
		minetest.swap_node(pos, {name="default:ice"})
	end,
}

minetest.register_abm{
	label = "flowing water freezing",
	nodenames = {"default:water_flowing",  "default:river_water_flowing"},
	neighbors = {"group:freezes_water"},
	interval = 1,
	chance = 1,
	catch_up = true,
	action = function(pos)
		minetest.swap_node(pos, {name="default:snow"})
	end,
}