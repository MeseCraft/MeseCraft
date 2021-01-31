local S = df_primordial_items.S

-- Leaves
minetest.register_node("df_primordial_items:jungle_leaves", {
	description = S("Primordial Jungle Tree Leaves"),
	_doc_items_longdesc = df_primordial_items.doc.leaves_desc,
	_doc_items_usagehelp = df_primordial_items.doc.leaves_usage,
	drawtype = "plantlike",
	walkable = false,
	waving = 2,
	visual_scale = 1.4,
	tiles = {"dfcaverns_jungle_leaves_01.png"},
	inventory_image = "dfcaverns_jungle_leaves_01.png",
	wield_image = "dfcaverns_jungle_leaves_01.png",
	paramtype = "light",
	is_ground_content = false,
	buildable_to = true,
	groups = {snappy = 3, leafdecay = 3, flammable = 2, leaves = 1},
	sounds = df_primordial_items.sounds.leaves,
	drop = {
		max_items = 1,
		items = {
			{
				items = {"df_primordial_items:jungletree_sapling"},
				rarity = 10,
			},
			{
				items = {"df_primordial_items:jungle_leaves"},
			}
		}
	},
	after_place_node = df_primordial_items.after_place_leaves,
})

minetest.register_node("df_primordial_items:jungle_leaves_glowing", {
	description = S("Phosphorescent Primordial Jungle Tree Leaves"),
	_doc_items_longdesc = df_primordial_items.doc.glowing_leaves_desc,
	_doc_items_usagehelp = df_primordial_items.doc.glowing_leaves_usage,
	drawtype = "plantlike",
	walkable = false,
	waving = 2,
	visual_scale = 1.4,
	tiles = {"dfcaverns_jungle_leaves_02.png"},
	inventory_image = "dfcaverns_jungle_leaves_02.png",
	wield_image = "dfcaverns_jungle_leaves_02.png",
	paramtype = "light",
	is_ground_content = false,
	buildable_to = true,
	light_source = 2,
	groups = {snappy = 3, leafdecay = 3, flammable = 2, leaves = 1},
	sounds = df_primordial_items.sounds.leaves,
	drop = {
		max_items = 1,
		items = {
			{
				items = {"df_primordial_items:jungletree_sapling"},
				rarity = 10,
			},
			{
				items = {"df_primordial_items:jungle_leaves_glowing"},
			}
		}
	},
	after_place_node = df_primordial_items.after_place_leaves,
})

-- Trunk

minetest.register_node("df_primordial_items:jungle_tree", {
	description = S("Primordial Jungle Tree"),
	_doc_items_longdesc = df_primordial_items.doc.tree_desc,
	_doc_items_usagehelp = df_primordial_items.doc.tree_usage,
	tiles = {"dfcaverns_jungle_wood_02.png", "dfcaverns_jungle_wood_02.png", "dfcaverns_jungle_wood_01.png"},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, primordial_jungle_tree = 1},
	sounds = df_primordial_items.sounds.wood,
	on_place = minetest.rotate_node
})

minetest.register_node("df_primordial_items:jungle_tree_mossy", {
	description = S("Mossy Primordial Jungle Tree"),
	_doc_items_longdesc = df_primordial_items.doc.tree_desc,
	_doc_items_usagehelp = df_primordial_items.doc.tree_usage,
	tiles = {"dfcaverns_jungle_wood_02.png", "dfcaverns_jungle_wood_02.png", "dfcaverns_jungle_wood_03.png"},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, primordial_jungle_tree = 1},
	sounds = df_primordial_items.sounds.wood,
	on_place = minetest.rotate_node
})

minetest.register_node("df_primordial_items:jungle_tree_glowing", {
	description = S("Phosphorescent Primordial Jungle Tree"),
	_doc_items_longdesc = df_primordial_items.doc.tree_glowing_desc,
	_doc_items_usagehelp = df_primordial_items.doc.tree_glowing_usage,
	tiles = {"dfcaverns_jungle_wood_02.png", "dfcaverns_jungle_wood_02.png", "dfcaverns_jungle_wood_04.png"},
	paramtype2 = "facedir",
	is_ground_content = false,
	light_source = 4,
	groups = {tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, primordial_jungle_tree = 1},
	sounds = df_primordial_items.sounds.wood,
	on_place = minetest.rotate_node
})

df_primordial_items.register_leafdecay({
	trunks = {"df_primordial_items:jungle_tree", "df_primordial_items:jungle_tree_mossy", "df_primordial_items:jungle_tree_glowing"},
	leaves = {"df_primordial_items:jungle_leaves", "df_primordial_items:jungle_leaves_glowing"},
	radius = 1,
})

minetest.register_craft({
	output = df_primordial_items.node_names.junglewood .. " 4",
	recipe = {
		{"group:primordial_jungle_tree"},
	}
})

----------------------------
-- Spawn

-- TODO: make use of the variant trunk and leaf nodes
local c_leaves = minetest.get_content_id("df_primordial_items:jungle_leaves")
local c_leaves_glow  = minetest.get_content_id("df_primordial_items:jungle_leaves_glowing")
local c_trunk  = minetest.get_content_id("df_primordial_items:jungle_tree")
local c_trunk_mossy = minetest.get_content_id("df_primordial_items:jungle_tree_mossy")
local c_trunk_glow = minetest.get_content_id("df_primordial_items:jungle_tree_glowing")

df_primordial_items.spawn_jungle_tree = function(pos)
	local x, y, z = pos.x, pos.y, pos.z
	local height = math.random(8,14)
	
	local vm = minetest.get_voxel_manip()
	local minp, maxp = vm:read_from_map(
		{x = x - 2, y = y - 2, z = z - 2},
		{x = x + 2, y = y + height, z = z + 2}
	)
	local area = VoxelArea:new({MinEdge = minp, MaxEdge = maxp})
	local data = vm:get_data()
	local vi = area:indexp(pos)
	
	df_primordial_items.spawn_jungle_tree_vm(height, vi, area, data)
	
	vm:set_data(data)
	vm:write_to_map()
	vm:update_map()
end

local get_tree_nodes = function()
	local rand = math.random()
	if rand < 0.5 then
		return c_trunk_glow, c_leaves_glow
	end
	if rand < 0.75 then
		return c_trunk_mossy, c_leaves
	end
	return c_trunk, c_leaves
end

df_primordial_items.spawn_jungle_tree_vm = function(height, vi, area, data)
	local ystride = area.ystride
	local zstride = area.zstride
	local buildable_to = mapgen_helper.buildable_to

	local roots_done = {[vi] = true}
	for i = 1, 6 do
		local root_column = vi + math.random(-1,1) + math.random(-1,1)*zstride
		if not roots_done[root_column] then
			local trunknode = get_tree_nodes()
			for y = -2, math.random(0,1) do -- root height is 1 to 2 nodes above ground
				local root_index = root_column + y * ystride
				if buildable_to(data[root_index]) then
					data[root_index] = trunknode
				end
			end
		end
		roots_done[root_column] = true
	end
	
	-- puts a trunk node in the center and surrounds it with leaves
	local branch = function(bi, glow)
		local trunknode, leafnode
		if buildable_to(data[bi]) then
			trunknode, leafnode = get_tree_nodes()
			data[bi] = trunknode
		else
			return -- if a branch is placed in a non-viable place, don't add leaves
		end
		for x = -1, 1 do
			for z = -1, 1 do
				for y = -1, 1 do
					if math.random() < 0.75 then
						local li = bi + x + z*zstride + y*ystride
						if buildable_to(data[li]) then
							data[li] = leafnode
						end
					end
				end
			end
		end
	end
	
	for i = 0, height-2 do
		local y_index = vi + i * ystride
		if buildable_to(data[y_index]) then
			data[y_index] = get_tree_nodes()
		else
			return -- if we hit something we can't grow through, stop.
		end
		if i > 4 then
			local branch_index = y_index + math.random(-1,1) + math.random(-1,1)*zstride
			branch(branch_index)			
		end
	end
	branch(vi + (height-1)*ystride) -- topper	
end

minetest.register_node("df_primordial_items:jungletree_sapling", {
	description = S("Primordial Jungle Tree Sapling"),
	_doc_items_longdesc = df_primordial_items.doc.tree_desc,
	_doc_items_usagehelp = df_primordial_items.doc.tree_usage,
	tiles = {"dfcaverns_jungle_sapling.png"},
	inventory_image = "dfcaverns_jungle_sapling.png",
	wield_image = "dfcaverns_jungle_sapling.png",
	groups = {snappy = 3, flora = 1, attached_node = 1, flammable = 1, sapling = 1, light_sensitive_fungus = 13},
	_dfcaverns_dead_node = df_primordial_items.node_names.dry_shrub,
	selection_box = {
		type = "fixed",
		fixed = {-4 / 16, -0.5, -4 / 16, 4 / 16, 7 / 16, 4 / 16}
	},
	paramtype = "light",
	drawtype = "plantlike",
	buildable_to = true,
	walkable = false,
	is_ground_content = false,
	sounds = df_primordial_items.sounds.leaves,
	use_texture_alpha = true,
	sunlight_propagates = true,
	on_construct = function(pos)
		if minetest.get_item_group(minetest.get_node({x=pos.x, y=pos.y-1, z=pos.z}).name, "soil") == 0 then
			return
		end
		minetest.get_node_timer(pos):start(math.random(
			df_trees.config.tree_min_growth_delay,
			df_trees.config.tree_max_growth_delay))
	end,
	on_destruct = function(pos)
		minetest.get_node_timer(pos):stop()
	end,
	on_timer = function(pos, elapsed)
		if df_farming and df_farming.kill_if_sunlit(pos) then
			return
		end
		if minetest.get_node_light(pos) > 6 then
			df_primordial_items.spawn_jungle_tree(pos)
		else
			minetest.get_node_timer(pos):start(df_trees.config.tree_min_growth_delay)
		end
	end,
})