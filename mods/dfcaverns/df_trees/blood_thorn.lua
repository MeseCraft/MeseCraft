--------------------------------------------------
-- Blood thorn

-- Max trunk height 	5
-- red with purple mottling
-- High density wood
-- Depth 3

-- internationalization boilerplate
local MP = minetest.get_modpath(minetest.get_current_modname())
local S, NS = dofile(MP.."/intllib.lua")

local spike_directions = {
	{dir={x=0,y=0,z=1}, facedir=2},
	{dir={x=0,y=0,z=-1}, facedir=0},
	{dir={x=1,y=0,z=0}, facedir=3},
	{dir={x=-1,y=0,z=0}, facedir=1}
}
local spikes = {["df_trees:blood_thorn_spike"] = true, ["df_trees:blood_thorn_spike_dead"] = true}

local blood_thorn_after_dig = function(pos, oldnode, oldmetadata, digger)
	for _, spike_dir in pairs(spike_directions) do
		local loc = vector.add(pos,spike_dir.dir)
		local node = minetest.get_node(loc)
		if spikes[node.name] and spike_dir.facedir == node.param2 then
			minetest.node_dig(loc, node, digger)
		end
	end
end

minetest.register_node("df_trees:blood_thorn", {
	description = S("Blood Thorn Stem"),
	_doc_items_longdesc = df_trees.doc.blood_thorn_desc,
	_doc_items_usagehelp = df_trees.doc.blood_thorn_usage,
	tiles = {"dfcaverns_blood_thorn_top.png", "dfcaverns_blood_thorn_top.png",
		"dfcaverns_blood_thorn_side.png", "dfcaverns_blood_thorn_side.png", "dfcaverns_blood_thorn_side.png", "dfcaverns_blood_thorn_side.png"},
	paramtype2 = "facedir",
	paramtype = "light",
	groups = {choppy = 3, tree = 1, flammable = 2, light_sensitive_fungus = 11},
	_dfcaverns_dead_node = "df_trees:blood_thorn_dead",
	sounds = default.node_sound_wood_defaults(),
	is_ground_content = false,
	on_place = minetest.rotate_node,
	after_dig_node = blood_thorn_after_dig,
})

minetest.register_node("df_trees:blood_thorn_dead", {
	description = S("Dead Blood Thorn Stem"),
	_doc_items_longdesc = df_trees.doc.blood_thorn_desc,
	_doc_items_usagehelp = df_trees.doc.blood_thorn_usage,
	tiles = {"dfcaverns_blood_thorn_top.png^[multiply:#804000", "dfcaverns_blood_thorn_top.png^[multiply:#804000",
		"dfcaverns_blood_thorn_side.png^[multiply:#804000"},
	paramtype2 = "facedir",
	paramtype = "light",
	groups = {choppy = 3, tree = 1, flammable = 2},
	sounds = default.node_sound_wood_defaults(),
	is_ground_content = false,
	on_place = minetest.rotate_node,
	after_dig_node = blood_thorn_after_dig,
})

minetest.register_node("df_trees:blood_thorn_spike", {
	description = S("Blood Thorn Spike"),
	_doc_items_longdesc = df_trees.doc.blood_thorn_spike_desc,
	_doc_items_usagehelp = df_trees.doc.blood_thorn_spike_usage,
	tiles = {
		"dfcaverns_blood_thorn_spike_side.png^[transformR90",
		"dfcaverns_blood_thorn_spike_side.png^[transformR270",
		"dfcaverns_blood_thorn_spike_side.png",
		"dfcaverns_blood_thorn_spike_side.png^[transformR180",
		"dfcaverns_blood_thorn_spike_front.png",
		"dfcaverns_blood_thorn_spike_front.png"
		},
	groups = {choppy = 3, flammable = 2, fall_damage_add_percent=100, light_sensitive_fungus = 11},
	_dfcaverns_dead_node = "df_trees:blood_thorn_spike_dead",
	sounds = default.node_sound_wood_defaults(),
	drawtype = "nodebox",
	climbable = true,
	is_ground_content = false,
	damage_per_second = 1,
	paramtype = "light",
	paramtype2 = "facedir",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.1875, -0.1875, 0.1875, 0.1875, 0.1875, 0.5}, -- base
			{-0.125, -0.125, -0.125, 0.125, 0.125, 0.1875}, -- mid
			{-0.0625, -0.0625, -0.5, 0.0625, 0.0625, -0.125}, -- tip
		}
	},
})

minetest.register_node("df_trees:blood_thorn_spike_dead", {
	description = S("Dead Blood Thorn Spike"),
	_doc_items_longdesc = df_trees.doc.blood_thorn_spike_desc,
	_doc_items_usagehelp = df_trees.doc.blood_thorn_spike_usage,
	tiles = {
		"dfcaverns_blood_thorn_spike_side.png^[transformR90^[multiply:#804000",
		"dfcaverns_blood_thorn_spike_side.png^[transformR270^[multiply:#804000",
		"dfcaverns_blood_thorn_spike_side.png^[multiply:#804000",
		"dfcaverns_blood_thorn_spike_side.png^[transformR180^[multiply:#804000",
		"dfcaverns_blood_thorn_spike_front.png^[multiply:#804000",
		"dfcaverns_blood_thorn_spike_front.png^[multiply:#804000"
		},
	groups = {choppy = 3, flammable = 2, fall_damage_add_percent=100},
	sounds = default.node_sound_wood_defaults(),
	drawtype = "nodebox",
	climbable = true,
	is_ground_content = false,
	paramtype = "light",
	paramtype2 = "facedir",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.1875, -0.1875, 0.1875, 0.1875, 0.1875, 0.5}, -- base
			{-0.125, -0.125, -0.125, 0.125, 0.125, 0.1875}, -- mid
			{-0.0625, -0.0625, -0.5, 0.0625, 0.0625, -0.125}, -- tip
		}
	},
})


--Wood
minetest.register_craft({
	output = 'df_trees:blood_thorn_wood 4',
	recipe = {
		{'df_trees:blood_thorn'},
	}
})
minetest.register_craft({
	output = 'df_trees:blood_thorn_wood 4',
	recipe = {
		{'df_trees:blood_thorn_dead'},
	}
})

minetest.register_node("df_trees:blood_thorn_wood", {
	description = S("Blood Thorn Planks"),
	_doc_items_longdesc = df_trees.doc.blood_thorn_desc,
	_doc_items_usagehelp = df_trees.doc.blood_thorn_usage,
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"dfcaverns_blood_thorn_wood.png"},
	is_ground_content = false,
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, wood = 1},
	sounds = default.node_sound_wood_defaults(),
})

df_trees.register_all_stairs("blood_thorn_wood")

minetest.register_craft({
	type = "fuel",
	recipe = "df_trees:blood_thorn_wood",
	burntime = 40,
})

minetest.register_craft({
	type = "fuel",
	recipe = "df_trees:blood_thorn",
	burntime = 150,
})
minetest.register_craft({
	type = "fuel",
	recipe = "df_trees:blood_thorn_dead",
	burntime = 120,
})
minetest.register_craft({
	type = "fuel",
	recipe = "df_trees:blood_thorn_spike",
	burntime = 5,
})
minetest.register_craft({
	type = "fuel",
	recipe = "df_trees:blood_thorn_spike_dead",
	burntime = 5,
})

-- This ensures consistent random maximum to bloodthorn growth
local max_bloodthorn_height = function(pos)
	local next_seed = math.floor(math.random() * 2^31)
	math.randomseed(pos.x + pos.z * 2 ^ 8)
	local output = math.random(3,6)
	math.randomseed(next_seed)
	return output
end

function df_trees.grow_blood_thorn(pos, node)
	if df_farming and df_farming.kill_if_sunlit(pos) then
		return
	end
	
	-- node is tipped over
	if node.param2 >= 4 then
		return
	end
	pos.y = pos.y - 1
	if minetest.get_item_group(minetest.get_node(pos).name, "sand") == 0 then
		return
	end
	pos.y = pos.y + 1
	local height = 0
	local max_height = max_bloodthorn_height(pos)
	while node.name == "df_trees:blood_thorn" and height < max_height do
		height = height + 1
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if height == 7 or node.name ~= "air" then
		return
	end

	minetest.set_node(pos, {name = "df_trees:blood_thorn"})
	
	local dir = spike_directions[math.random(1,4)]
	local spike_pos = vector.add(pos, dir.dir)
	if minetest.get_node(spike_pos).name == "air" then
		minetest.set_node(spike_pos, {name="df_trees:blood_thorn_spike", param2=dir.facedir})
	end
	dir = spike_directions[math.random(1,4)]
	spike_pos = vector.add(pos, dir.dir)
	if minetest.get_node(spike_pos).name == "air" then
		minetest.set_node(spike_pos, {name="df_trees:blood_thorn_spike", param2=dir.facedir})
	end
	return true
end

minetest.register_abm({
	label = "Grow Blood Thorn",
	nodenames = {"df_trees:blood_thorn"},
	catch_up = true,
	interval = df_trees.config.blood_thorn_growth_interval,
	chance = df_trees.config.blood_thorn_growth_chance,
	action = function(pos, node)
		df_trees.grow_blood_thorn(pos, node)
	end
})

function df_trees.spawn_blood_thorn(pos)
	local height = max_bloodthorn_height(pos)
	local x, y, z = pos.x, pos.y, pos.z
	local maxy = y + height -- Trunk top

	local vm = minetest.get_voxel_manip()
	local minp, maxp = vm:read_from_map(
		{x = x - 1, y = y, z = z - 1},
		{x = x + 1, y = maxy, z = z + 1}
	)
	local area = VoxelArea:new({MinEdge = minp, MaxEdge = maxp})
	local data = vm:get_data()
	local data_param2 = vm:get_param2_data()

	df_trees.spawn_blood_thorn_vm(area:indexp(pos), area, data, data_param2, height)

	vm:set_data(data)
	vm:set_param2_data(data_param2)
	vm:write_to_map()
	vm:update_map()
end

local c_air = minetest.get_content_id("air")
local c_ignore = minetest.get_content_id("ignore")
local c_blood_thorn = minetest.get_content_id("df_trees:blood_thorn")
local c_blood_thorn_spike = minetest.get_content_id("df_trees:blood_thorn_spike")

local facedir_to_increment = function(direction, area)
	if direction == 0 then
		return -area.zstride
	elseif direction == 1 then
		return -1
	elseif direction == 2 then
		return area.zstride
	elseif direction == 3 then
		return 1
	end
end

df_trees.spawn_blood_thorn_vm = function(vi, area, data, data_param2, height)
	local pos = area:position(vi)
	if height == nil then height = max_bloodthorn_height(pos) end

	for i = 1, height do
		local node_id = data[vi]
		if node_id == c_air or node_id == c_ignore then
			data[vi] = c_blood_thorn
			
			for i = 1, 2 do
				local facedir = math.random(1,4)-1
				local spike_vi = vi + facedir_to_increment(facedir, area)
				if data[spike_vi] == c_air or data[spike_vi] == c_ignore then
					data[spike_vi] = c_blood_thorn_spike
					data_param2[spike_vi] = facedir
				end
			end
		else
			break
		end
		vi = vi + area.ystride
	end
end




	
