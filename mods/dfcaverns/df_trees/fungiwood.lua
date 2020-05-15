--------------------------------------------------
-- Fungiwood

-- fine grain
-- Max trunk height 	8 
-- depth 1-2

-- internationalization boilerplate
local MP = minetest.get_modpath(minetest.get_current_modname())
local S, NS = dofile(MP.."/intllib.lua")

minetest.register_node("df_trees:fungiwood", {
	description = S("Fungiwood Stem"),
	_doc_items_longdesc = df_trees.doc.fungiwood_desc,
	_doc_items_usagehelp = df_trees.doc.fungiwood_usage,
	tiles = {"dfcaverns_fungiwood.png"},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {tree = 1, choppy = 3, oddly_breakable_by_hand = 1, flammable = 3},
	sounds = default.node_sound_wood_defaults(),

	on_place = minetest.rotate_node
})

--Wood
minetest.register_craft({
	output = 'df_trees:fungiwood_wood 4',
	recipe = {
		{'df_trees:fungiwood'},
	}
})

minetest.register_node("df_trees:fungiwood_wood", {
	description = S("Fungiwood Planks"),
	_doc_items_longdesc = df_trees.doc.fungiwood_desc,
	_doc_items_usagehelp = df_trees.doc.fungiwood_usage,
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"dfcaverns_fungiwood_wood.png"},
	is_ground_content = false,
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, wood = 1},
	sounds = default.node_sound_wood_defaults(),
})

df_trees.register_all_stairs("fungiwood_wood")

minetest.register_craft({
	type = "fuel",
	recipe = "df_trees:fungiwood_wood",
	burntime = 7,
})
minetest.register_craft({
	type = "fuel",
	recipe = "df_trees:fungiwood",
	burntime = 30,
})
minetest.register_craft({
	type = "fuel",
	recipe = "df_trees:fungiwood_shelf",
	burntime = 3,
})
minetest.register_craft({
	type = "fuel",
	recipe = "df_trees:fungiwood_sapling",
	burntime = 2,
})

minetest.register_node("df_trees:fungiwood_shelf",{
	description = S("Fungiwood Shelf"),
	_doc_items_longdesc = df_trees.doc.fungiwood_desc,
	_doc_items_usagehelp = df_trees.doc.fungiwood_usage,
	tiles = {"dfcaverns_fungiwood.png", "dfcaverns_fungiwood_shelf_underside.png", "dfcaverns_fungiwood.png"},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, 0.375, -0.5, 0.5, 0.5, 0.5}, -- NodeBox1
			{-0.5, 0.3125, -0.0625, 0.5, 0.375, 0.0625}, -- NodeBox2
			{-0.0625, 0.3125, -0.5, 0.0625, 0.375, 0.5}, -- NodeBox3
		}
	},
	is_ground_content = false,
	groups = {snappy = 3, leafdecay = 3, flammable = 2, leaves = 1},
	drop = {
		max_items = 1,
		items = {
			{items = {"df_trees:fungiwood_sapling"}, rarity = 10},
			{items = {"df_trees:fungiwood_shelf"}}
		}
	},
	sounds = default.node_sound_leaves_defaults(),

	after_place_node = default.after_place_leaves,
})

if default.register_leafdecay then -- default.register_leafdecay is very new, remove this check some time after 0.4.16 is released
	default.register_leafdecay({
		trunks = {"df_trees:fungiwood"},
		leaves = {"df_trees:fungiwood_shelf"},
		radius = 5,
	})
end

minetest.register_node("df_trees:fungiwood_sapling", {
	description = S("Fungiwood Spawn"),
	_doc_items_longdesc = df_trees.doc.fungiwood_desc,
	_doc_items_usagehelp = df_trees.doc.fungiwood_usage,
	drawtype = "plantlike",
	visual_scale = 1.0,
	tiles = {"dfcaverns_fungiwood_sapling.png"},
	inventory_image = "dfcaverns_fungiwood_sapling.png",
	wield_image = "dfcaverns_fungiwood_sapling.png",
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
		attached_node = 1, sapling = 1, light_sensitive_fungus = 11},
	sounds = default.node_sound_leaves_defaults(),

	on_construct = function(pos)
		if minetest.get_item_group(minetest.get_node({x=pos.x, y=pos.y-1, z=pos.z}).name, "soil") == 0 then
			return
		end
		minetest.get_node_timer(pos):start(math.random(
			df_trees.config.fungiwood_delay_multiplier*df_trees.config.tree_min_growth_delay,
			df_trees.config.fungiwood_delay_multiplier*df_trees.config.tree_max_growth_delay))
	end,
	on_destruct = function(pos)
		minetest.get_node_timer(pos):stop()
	end,
	
	on_timer = function(pos)
		if df_farming and df_farming.kill_if_sunlit(pos) then
			return
		end
		minetest.set_node(pos, {name="air"})
		df_trees.spawn_fungiwood(pos)
	end,
})

local c_air = minetest.get_content_id("air")
local c_ignore = minetest.get_content_id("ignore")
local c_fungiwood = minetest.get_content_id("df_trees:fungiwood")
local c_fungiwood_shelf  = minetest.get_content_id("df_trees:fungiwood_shelf")

function df_trees.spawn_fungiwood(pos)
	local x, y, z = pos.x, pos.y, pos.z
	local height = math.random(6, 10)
	local maxy = y + height -- Trunk top

	local vm = minetest.get_voxel_manip()
	local minp, maxp = vm:read_from_map(
		{x = x - 3, y = y, z = z - 3},
		{x = x + 3, y = maxy, z = z + 3}
	)
	local area = VoxelArea:new({MinEdge = minp, MaxEdge = maxp})
	local data = vm:get_data()

	df_trees.spawn_fungiwood_vm(area:indexp(pos), area, data, height)

	vm:set_data(data)
	vm:write_to_map()
	vm:update_map()
end

df_trees.spawn_fungiwood_vm = function(vi, area, data, height)
	if height == nil then height = math.random(6, 10) end
	local pos = area:position(vi)
	local x = pos.x
	local y = pos.y
	local z = pos.z
	local maxy = y + height -- Trunk top
	
	-- Upper branches layer
	local dev = 3
	for yy = maxy - 2, maxy do
		for zz = z - dev, z + dev do
			local vi = area:index(x - dev, yy, zz)
			local via = area:index(x - dev, yy + 1, zz)
			for xx = x - dev, x + dev do
				if math.random() < 0.95 - dev * 0.05 then
					local node_id = data[vi]
					if node_id == c_air or node_id == c_ignore then
						data[vi] = c_fungiwood_shelf
					end
				end
				vi  = vi + 1
				via = via + 1
			end
		end
		dev = dev - 1
	end

	-- Lower branches layer
	local my = 0
	for i = 1, 20 do -- Random 2x2 squares of shelf
		local xi = x + math.random(-3, 2)
		local yy = maxy + math.random(-6, -5)
		local zi = z + math.random(-3, 2)
		if yy > my then
			my = yy
		end
		for zz = zi, zi+1 do
			local vi = area:index(xi, yy, zz)
			local via = area:index(xi, yy + 1, zz)
			for xx = xi, xi + 1 do
				local node_id = data[vi]
				if node_id == c_air or node_id == c_ignore then
					data[vi] = c_fungiwood_shelf
				end
				vi  = vi + 1
				via = via + 1
			end
		end
	end

	-- Trunk
	for yy = y, maxy do
		local vi = area:index(x, yy, z)
		local node_id = data[vi]
		if node_id == c_air or node_id == c_ignore or
				node_id == c_fungiwood_shelf then
			data[vi] = c_fungiwood
		end
	end
end
