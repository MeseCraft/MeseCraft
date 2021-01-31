local S = df_trees.S

-- Rather than make this whole mod depend on subterrane just for this, I copied and pasted a chunk of stalactite code.
local x_disp = 0.125
local z_disp = 0.125

local stal_on_place = function(itemstack, placer, pointed_thing)
	local pt = pointed_thing
	-- check if pointing at a node
	if not pt then
		return itemstack
	end
	if pt.type ~= "node" then
		return itemstack
	end

	local under = minetest.get_node(pt.under)
	local above = minetest.get_node(pt.above)

	if minetest.is_protected(pt.above, placer:get_player_name()) then
		minetest.record_protection_violation(pt.above, placer:get_player_name())
		return
	end

	-- return if any of the nodes is not registered
	if not minetest.registered_nodes[under.name] or not minetest.registered_nodes[above.name] then
		return itemstack
	end
	-- check if you can replace the node above the pointed node
	if not minetest.registered_nodes[above.name].buildable_to then
		return itemstack
	end

	local new_param2
	-- check if pointing at an existing stalactite
	if minetest.get_item_group(under.name, "subterrane_stal_align") ~= 0 then
		new_param2 = under.param2
	else
		new_param2 = math.random(0,3)
	end

	-- add the node and remove 1 item from the itemstack
	minetest.add_node(pt.above, {name = itemstack:get_name(), param2 = new_param2})
	if not minetest.settings:get_bool("creative_mode", false) then
		itemstack:take_item()
	end
	return itemstack
end

local stal_box_1 = {{-0.0625+x_disp, -0.5, -0.0625+z_disp, 0.0625+x_disp, 0.5, 0.0625+z_disp}}
local stal_box_2 = {{-0.125+x_disp, -0.5, -0.125+z_disp, 0.125+x_disp, 0.5, 0.125+z_disp}}
local stal_box_3 = {{-0.25+x_disp, -0.5, -0.25+z_disp, 0.25+x_disp, 0.5, 0.25+z_disp}}
local stal_box_4 = {{-0.375+x_disp, -0.5, -0.375+z_disp, 0.375+x_disp, 0.5, 0.375+z_disp}}

local torch_node = df_trees.node_names.torch

minetest.register_node("df_trees:torchspine_1", {
	description = S("Torchspine Tip"),
	_doc_items_longdesc = df_trees.doc.torchspine_desc,
	_doc_items_usagehelp = df_trees.doc.torchspine_usage,
	tiles = {"dfcaverns_torchspine_0.5.png", "dfcaverns_torchspine_1.5.png", "dfcaverns_torchspine_1.png"},
	groups = {oddly_breakable_by_hand = 1, subterrane_stal_align = 1, flow_through = 1, fall_damage_add_percent = 100},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	is_ground_content = false,
	drop = torch_node,
	node_box = {
		type = "fixed",
		fixed = stal_box_1,
	},
	on_place = stal_on_place,
	on_punch = function(pos, node, puncher)
		if puncher:get_wielded_item():get_name() == torch_node then
			minetest.swap_node(pos, {name = "df_trees:torchspine_1_lit", param2 = node.param2})
		end
	end,
})

minetest.register_node("df_trees:torchspine_1_lit", {
	description = S("Torchspine Tip"),
	_doc_items_longdesc = df_trees.doc.torchspine_desc,
	_doc_items_usagehelp = df_trees.doc.torchspine_usage,
	tiles = {df_trees.textures.gold_block, "dfcaverns_torchspine_1.5.png", "dfcaverns_torchspine_1_lit.png"},
	groups = {oddly_breakable_by_hand = 1, subterrane_stal_align = 1, flow_through = 1, torch = 1, fall_damage_add_percent = 150, smokey = 4},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	light_source = 8,
	is_ground_content = false,
	drop = torch_node .. " 2",
	node_box = {
		type = "fixed",
		fixed = stal_box_1,
	},
	on_place = stal_on_place,
})

minetest.register_node("df_trees:torchspine_2", {
	description = S("Torchspine"),
	_doc_items_longdesc = df_trees.doc.torchspine_desc,
	_doc_items_usagehelp = df_trees.doc.torchspine_usage,
	tiles = {"dfcaverns_torchspine_1.5.png", "dfcaverns_torchspine_2.5.png", "dfcaverns_torchspine_2.png"},
	groups = {oddly_breakable_by_hand = 1, subterrane_stal_align = 1, flow_through = 1, fall_damage_add_percent = 50},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	is_ground_content = false,
	node_box = {
		type = "fixed",
		fixed = stal_box_2,
	},
	drop = {
            max_items = 1,
            items = {
                {
                    items = {"df_trees:torchspine_ember"},  -- Items to drop
                    rarity = 2,  -- Probability of dropping is 1 / rarity
                },
            },
        },
	on_place = stal_on_place,
})

minetest.register_node("df_trees:torchspine_3", {
	description = S("Torchspine"),
	_doc_items_longdesc = df_trees.doc.torchspine_desc,
	_doc_items_usagehelp = df_trees.doc.torchspine_usage,
	tiles = {"dfcaverns_torchspine_2.5.png", "dfcaverns_torchspine_3.5.png", "dfcaverns_torchspine_3.png"},
	groups = {oddly_breakable_by_hand = 1, subterrane_stal_align = 1, flow_through = 1},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	is_ground_content = false,
	node_box = {
		type = "fixed",
		fixed = stal_box_3,
	},
	drop = {
            max_items = 1,
            items = {
                {
                    items = {"df_trees:torchspine_ember"},  -- Items to drop
                    rarity = 2,  -- Probability of dropping is 1 / rarity
                },
                {
                    items = {"df_trees:torchspine_ember 2"},  -- Items to drop
                    rarity = 2,  -- Probability of dropping is 1 / rarity
                },
            },
        },
	on_place = stal_on_place,
})

minetest.register_node("df_trees:torchspine_4", {
	description = S("Torchspine"),
	_doc_items_longdesc = df_trees.doc.torchspine_desc,
	_doc_items_usagehelp = df_trees.doc.torchspine_usage,
	tiles = {"dfcaverns_torchspine_3.5.png", "dfcaverns_torchspine_4.5.png", "dfcaverns_torchspine_4.png"},
	groups = {oddly_breakable_by_hand = 1, subterrane_stal_align = 1, flow_through = 1},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	is_ground_content = false,
	node_box = {
		type = "fixed",
		fixed = stal_box_4,
	},
	drop = {
            max_items = 1,
            items = {
                {
                    items = {"df_trees:torchspine_ember 2"},  -- Items to drop
                    rarity = 2,  -- Probability of dropping is 1 / rarity
                },
                {
                    items = {"df_trees:torchspine_ember"},  -- Items to drop
                    rarity = 1,  -- Probability of dropping is 1 / rarity
                },
            },
        },	on_place = stal_on_place,
})

minetest.register_node("df_trees:torchspine_ember", {
	description = S("Torchspine Ember"),
	_doc_items_longdesc = df_trees.doc.torchspine_desc,
	_doc_items_usagehelp = df_trees.doc.torchspine_usage,
	tiles = {"dfcaverns_torchspine_0.5.png",},
	groups = {oddly_breakable_by_hand = 1, subterrane_stal_align = 1, flow_through = 1},
	drawtype = "nodebox",
	paramtype = "light",
	light_source = 2,
	paramtype2 = "facedir",
	walkable = false,
	is_ground_content = false,
	floodable = true,
	node_box = {
		type = "fixed",
		fixed = {
			{-0.0625 + x_disp, -0.5, -0.125 + z_disp, 0.125 + x_disp, -0.375, 0.0625 + z_disp},
		}
	},
	on_place = stal_on_place,
})

df_trees.spawn_torchspine = function(pos)
	local x, y, z = pos.x, pos.y, pos.z
	local stem_height = math.random(1,4)

	local vm = minetest.get_voxel_manip()
	local minp, maxp = vm:read_from_map(
		{x = x, y = y, z = z},
		{x = x, y = y+height-1, z = z}
	)
	local area = VoxelArea:new({MinEdge = minp, MaxEdge = maxp})
	local data = vm:get_data()
	local data_param2 = vm:get_param2_data()

	df_trees.spawn_torchspine_vm(vi, area, data, data_param2, height)
	
	vm:set_data(data)
	vm:write_to_map()
	vm:update_map()
end

local torchspine_c =
{
	minetest.get_content_id("df_trees:torchspine_1"),
	minetest.get_content_id("df_trees:torchspine_2"),
	minetest.get_content_id("df_trees:torchspine_3"),
	minetest.get_content_id("df_trees:torchspine_4")
}
local torchspine_lit_c =
{
	minetest.get_content_id("df_trees:torchspine_1_lit"),
	minetest.get_content_id("df_trees:torchspine_2"),
	minetest.get_content_id("df_trees:torchspine_3"),
	minetest.get_content_id("df_trees:torchspine_4")
}

df_trees.spawn_torchspine_vm = function(vi, area, data, data_param2, height, lit)
	if height == nil then height = math.random(1,4) end
	if lit == nil then lit = math.random() < 0.3 end
	local param2 = math.random(0,3)
	local list
	if lit then list = torchspine_lit_c else list = torchspine_c end
	
	for i = 0, height-1 do
		if not minetest.registered_nodes[minetest.get_name_from_content_id(data[vi + area.ystride*i])].buildable_to then
			height = i
			break
		end
	end
	
	for i = 0, height-1 do
		local index = vi + area.ystride*i
		data[index] = list[height-i]
		data_param2[index] = param2
	end	
end

-- overriding node groups using override_item doesn't appear to work with ABMs:
-- https://github.com/minetest/minetest/issues/5518
local coal_def = minetest.registered_nodes[df_trees.node_names.stone_with_coal]
local coal_block_def = minetest.registered_nodes[df_trees.node_names.coalblock]
if coal_def then
	coal_def.groups.coal = 1
	minetest.register_node(":"..df_trees.node_names.stone_with_coal, coal_def)
end
coal_block_def.groups.coal = 1
minetest.register_node(":"..df_trees.node_names.coalblock, coal_block_def)

minetest.register_abm{
	label = "torchspine germinating",
	nodenames = {"df_trees:torchspine_ember"},
	neighbors = {"group:flammable", "group:coal"},
	interval = 30,
	chance = 10,
	catch_up = true,
	action = function(pos)
		local below_name = minetest.get_node({x=pos.x, y=pos.y-1, z=pos.z}).name
		if minetest.get_item_group(below_name, "flammable") > 0 or  minetest.get_item_group(below_name, "coal") > 0 then
			minetest.swap_node(pos, {name="df_trees:torchspine_1", param2=minetest.get_node(pos).param2})
		end
	end,
}
minetest.register_abm{
	label = "torchspine lighting",
	nodenames = {"df_trees:torchspine_1"},
	interval = 30,
	chance = 10,
	catch_up = true,
	action = function(pos)
		local above_def = minetest.registered_nodes[minetest.get_node({x=pos.x, y=pos.y+1, z=pos.z}).name]
		if above_def and above_def.buildable_to then
			minetest.swap_node(pos, {name="df_trees:torchspine_1_lit", param2=minetest.get_node(pos).param2})
		end
	end,
}
local torchspine_list = {"df_trees:torchspine_1","df_trees:torchspine_2","df_trees:torchspine_3","df_trees:torchspine_4"}
minetest.register_abm{
	label = "torchspine growing",
	nodenames = {"df_trees:torchspine_1_lit"},
	interval = 37,
	chance = 10,
	catch_up = true,
	action = function(pos)
		local height = 0
		local param2 = minetest.get_node(pos).param2
		local dest_list = {{x=pos.x, y=pos.y+1, z=pos.z},pos,{x=pos.x, y=pos.y-1, z=pos.z},{x=pos.x, y=pos.y-2, z=pos.z},{x=pos.x, y=pos.y-3, z=pos.z}}
		local source_list = {
			minetest.get_node(dest_list[1]).name,
			minetest.get_node(dest_list[2]).name,
			minetest.get_node(dest_list[3]).name,
			minetest.get_node(dest_list[4]).name,
			minetest.get_node(dest_list[5]).name
		}
		local target_def = minetest.registered_nodes[source_list[1]]
		if target_def and target_def.buildable_to then
			for i = 2,4 do
				if minetest.get_item_group(source_list[i+1], "flammable") > 0 or minetest.get_item_group(source_list[i+1], "coal") > 0 then
					height = i
					break
				elseif source_list[i+1] ~= torchspine_list[i] then
					height = 0
					break
				end				
			end
		end
		if height == 0 then
			minetest.swap_node(pos, {name="df_trees:torchspine_1", param2=param2})
			return
		end
		for i = 1, height do
			minetest.swap_node(dest_list[i], {name=torchspine_list[i], param2=param2})
		end		
	end,
}
