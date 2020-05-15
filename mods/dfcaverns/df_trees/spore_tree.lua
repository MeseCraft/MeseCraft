--------------------------------------------------
-- Spore Tree

-- Teal
-- raining spores
-- Max trunk height 	5
-- depth 2-3

-- internationalization boilerplate
local MP = minetest.get_modpath(minetest.get_current_modname())
local S, NS = dofile(MP.."/intllib.lua")

minetest.register_node("df_trees:spore_tree", {
	description = S("Spore Tree Stem"),
	_doc_items_longdesc = df_trees.doc.spore_tree_desc,
	_doc_items_usagehelp = df_trees.doc.spore_tree_usage,
	tiles = {"dfcaverns_spore_tree_top.png", "dfcaverns_spore_tree_top.png", "dfcaverns_spore_tree.png"},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
	sounds = default.node_sound_wood_defaults(),

	on_place = minetest.rotate_node,
})

--Wood
minetest.register_craft({
	output = "df_trees:spore_tree_wood 4",
	recipe = {
		{"df_trees:spore_tree"},
	}
})

minetest.register_node("df_trees:spore_tree_wood", {
	description = S("Spore Tree Planks"),
	_doc_items_longdesc = df_trees.doc.spore_tree_desc,
	_doc_items_usagehelp = df_trees.doc.spore_tree_usage,
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"dfcaverns_spore_tree_wood.png"},
	is_ground_content = false,
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, wood = 1},
	sounds = default.node_sound_wood_defaults(),
})

df_trees.register_all_stairs("spore_tree_wood")

minetest.register_craft({
	type = "fuel",
	recipe = "df_trees:spore_tree_wood",
	burntime = 6,
})
minetest.register_craft({
	type = "fuel",
	recipe = "df_trees:spore_tree",
	burntime = 20,
})
minetest.register_craft({
	type = "fuel",
	recipe = "df_trees:spore_tree_hyphae",
	burntime = 2,
})
minetest.register_craft({
	type = "fuel",
	recipe = "df_trees:spore_tree_fruiting_body",
	burntime = 2,
})
minetest.register_craft({
	type = "fuel",
	recipe = "df_trees:spore_tree_sapling",
	burntime = 1,
})

minetest.register_node("df_trees:spore_tree_hyphae", {
	description = S("Spore Tree Hyphae"),
	_doc_items_longdesc = df_trees.doc.spore_tree_desc,
	_doc_items_usagehelp = df_trees.doc.spore_tree_usage,
	waving = 1,
	tiles = {"dfcaverns_spore_tree.png"},
	is_ground_content = false,
	groups = {snappy = 3, leafdecay = 3, flammable = 2, leaves = 1, spore_tree_hyphae = 1},
	walkable = false,
	climbable = true,
	
	drawtype = "nodebox",
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.0625, -0.5, -0.0625, 0.0625, 0.5, 0.0625},
			{-0.0625, -0.0625, -0.5, 0.0625, 0.0625, 0.5},
			{-0.5, -0.0625, -0.0625, 0.5, 0.0625, 0.0625},
		}
	},
	sounds = default.node_sound_leaves_defaults(),

	after_place_node = default.after_place_leaves,
})

minetest.register_node("df_trees:spore_tree_fruiting_body", {
	description = S("Spore Tree Fruiting Body"),
	_doc_items_longdesc = df_trees.doc.spore_tree_desc,
	_doc_items_usagehelp = df_trees.doc.spore_tree_usage,
	waving = 1,
	tiles = {"dfcaverns_spore_tree.png"},
	is_ground_content = false,
	groups = {snappy = 3, leafdecay = 3, flammable = 2, leaves = 1, spore_tree_hyphae = 1},
	walkable = false,
	climbable = true,
	
	drawtype = "nodebox",
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.0625, -0.5, -0.0625, 0.0625, 0.5, 0.0625}, 
			{-0.0625, -0.0625, -0.5, 0.0625, 0.0625, 0.5}, 
			{-0.5, -0.0625, -0.0625, 0.5, 0.0625, 0.0625}, 
			{-0.25, -0.25, -0.25, 0.25, 0.25, 0.25},
		}
	},
	
	drop = {
		max_items = 1,
		items = {
			{
				items = {'df_trees:spore_tree_sapling'},
				rarity = 10,
			},
			{
				items = {'df_trees:spore_tree_hyphae'},
			}
		}
	},
	sounds = default.node_sound_leaves_defaults(),

	after_place_node = default.after_place_leaves,
})

if default.register_leafdecay then -- default.register_leafdecay is very new, remove this check some time after 0.4.16 is released
	default.register_leafdecay({
		trunks = {"df_trees:spore_tree"},
		leaves = {"df_trees:spore_tree_hyphae", "df_trees:spore_tree_fruiting_body"},
		radius = 3,	
	})
end

minetest.register_node("df_trees:spore_tree_sapling", {
	description = S("Spore Tree Spawn"),
	_doc_items_longdesc = df_trees.doc.spore_tree_desc,
	_doc_items_usagehelp = df_trees.doc.spore_tree_usage,
	drawtype = "plantlike",
	visual_scale = 1.0,
	tiles = {"dfcaverns_spore_tree_sapling.png"},
	inventory_image = "dfcaverns_spore_tree_sapling.png",
	wield_image = "dfcaverns_spore_tree_sapling.png",
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
			df_trees.config.spore_tree_delay_multiplier*df_trees.config.tree_min_growth_delay,
			df_trees.config.spore_tree_delay_multiplier*df_trees.config.tree_max_growth_delay))
	end,
	on_destruct = function(pos)
		minetest.get_node_timer(pos):stop()
	end,
	
	on_timer = function(pos)
		if df_farming and df_farming.kill_if_sunlit(pos) then
			return
		end
		minetest.set_node(pos, {name="air"})
		df_trees.spawn_spore_tree(pos)
	end,
})

local c_air = minetest.get_content_id("air")
local c_ignore = minetest.get_content_id("ignore")
local c_spore_pod = minetest.get_content_id("df_trees:spore_tree_fruiting_body")
local c_tree = minetest.get_content_id("df_trees:spore_tree")
local c_spore_frond = minetest.get_content_id("df_trees:spore_tree_hyphae")

df_trees.spawn_spore_tree_vm = function(vi, area, data, data_param2, height, size, iters, has_fruiting_bodies)
	if height == nil then height = math.random(3,6) end
	if size == nil then size = 2 end
	if iters == nil then iters = 10 end
	if has_fruiting_bodies == nil then has_fruiting_bodies = math.random() < 0.5 end

	local pos = area:position(vi)
	local x, y, z = pos.x, pos.y, pos.z
	
	local has_fruiting_bodies = true

	-- Trunk
	for yy = y, y + height - 1 do
		local vi = area:index(x, yy, z)
		local node_id = data[vi]
		if node_id == c_air or node_id == c_ignore or node_id == c_spore_frond or node_id == c_spore_pod then
			data[vi] = c_tree
			data_param2[vi] = 0
		end
	end

	-- Force leaves near the trunk
	for z_dist = -1, 1 do
	for y_dist = -size, 1 do
		local vi = area:index(x - 1, y + height + y_dist, z + z_dist)
		for x_dist = -1, 1 do
			if data[vi] == c_air or data[vi] == c_ignore then
				if has_fruiting_bodies and math.random() < 0.3 then
					data[vi] = c_spore_pod
				else
					data[vi] = c_spore_frond
				end
				data_param2[vi] = 0
			end
			vi = vi + 1
		end
	end
	end

	-- Randomly add fronds in 2x2x2 clusters.
	for i = 1, iters do
		local clust_x = x + math.random(-size, size - 1)
		local clust_y = y + height + math.random(-size, 0)
		local clust_z = z + math.random(-size, size - 1)

		for xi = 0, 1 do
			for yi = 0, 1 do
				for zi = 0, 1 do
					local vi = area:index(clust_x + xi, clust_y + yi, clust_z + zi)
					if data[vi] == c_air or data[vi] == c_ignore then
						if has_fruiting_bodies and math.random() < 0.3 then
							data[vi] = c_spore_pod
						else
							data[vi] = c_spore_frond
						end
						data_param2[vi] = 0
					end
				end
			end
		end
	end
end

df_trees.spawn_spore_tree = function(pos)
	local x, y, z = pos.x, pos.y, pos.z
	local height = math.random(4, 5)

	local vm = minetest.get_voxel_manip()
	local minp, maxp = vm:read_from_map(
		{x = x - 2, y = y, z = z - 2},
		{x = x + 2, y = y + height + 1, z = z + 2}
	)
	local area = VoxelArea:new({MinEdge = minp, MaxEdge = maxp})
	local data = vm:get_data()
	local data_param_2 = vm:get_param2_data()

	df_trees.spawn_spore_tree_vm(area:indexp(pos), area, data, data_param_2)

	vm:set_data(data)
	vm:set_param2_data(data_param_2)
	vm:write_to_map()
	vm:update_map()
end


minetest.register_abm{
	label = "spore tree raining spores",
	nodenames = {"df_trees:spore_tree_fruiting_body"},
	interval = 1,
	chance = 30,
	catch_up = false,
	action = function(pos)
		minetest.add_particle({
			pos = pos,
			velocity = {x=math.random() * 0.2 - 0.1, y=-1, z=math.random() * 0.2 - 0.1},
			acceleration = {x=0, y=0, z=0},
			expirationtime = 3,
			size = 10,
			collisiondetection = false,
			vertical = false,
			texture = "dfcaverns_spore_tree_spores.png",
		})
		if math.random() < 0.025 then
			minetest.sound_play("dfcaverns_spore_tree_pitter_patter", {
				pos = pos,
				gain = 0.2,
			})
		end
	end,
}


minetest.register_craft({
	output = 'df_trees:spore_tree_ladder 2',
	recipe = {
		{'group:spore_tree_hyphae'},
	}
})

minetest.register_craft({
	type = "fuel",
	recipe = "df_trees:spore_tree_ladder",
	burntime = 1,
})

minetest.register_node("df_trees:spore_tree_ladder", {
	description = S("Spore Tree Ladder"),
	drawtype = "signlike",
	tiles = {"dfcaverns_spore_tree_ladder.png"},
	inventory_image = "dfcaverns_spore_tree_ladder.png",
	wield_image = "dfcaverns_spore_tree_ladder.png",
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	walkable = false,
	climbable = true,
	is_ground_content = false,
	selection_box = {
		type = "wallmounted",
		--wall_top = = <default>
		--wall_bottom = = <default>
		--wall_side = = <default>
	},
	groups = {choppy = 2, oddly_breakable_by_hand = 3, flammable = 2},
	legacy_wallmounted = true,
	sounds = default.node_sound_wood_defaults(),
})
