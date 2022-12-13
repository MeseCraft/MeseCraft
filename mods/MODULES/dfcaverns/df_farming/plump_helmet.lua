local S = minetest.get_translator(minetest.get_current_modname())

local displace_x = 0.125
local displace_z = 0.125

local plump_helmet_grow_time = df_farming.config.plant_growth_time * df_farming.config.plump_helmet_delay_multiplier / 4

local function copy_pointed_thing(pointed_thing)
	return {
		type  = pointed_thing.type,
		above = pointed_thing.above and vector.copy(pointed_thing.above),
		under = pointed_thing.under and vector.copy(pointed_thing.under),
		ref   = pointed_thing.ref,
	}
end

local plump_helmet_on_place =  function(itemstack, placer, pointed_thing, plantname)
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

	if minetest.is_protected(pt.under, placer:get_player_name()) then
		minetest.record_protection_violation(pt.under, placer:get_player_name())
		return
	end
	if minetest.is_protected(pt.above, placer:get_player_name()) then
		minetest.record_protection_violation(pt.above, placer:get_player_name())
		return
	end

	-- return if any of the nodes is not registered
	if not minetest.registered_nodes[under.name] then
		return itemstack
	end
	if not minetest.registered_nodes[above.name] then
		return itemstack
	end

	-- check if pointing at the top of the node
	if pt.above.y ~= pt.under.y+1 then
		return itemstack
	end

	-- check if you can replace the node above the pointed node
	if not minetest.registered_nodes[above.name].buildable_to then
		return itemstack
	end

	-- add the node and remove 1 item from the itemstack
	local new_param2 = math.random(0,3)
	local newnode= {name = plantname, param2 = new_param2, param1=0}
	local oldnode= minetest.get_node(pt.above)
	minetest.add_node(pt.above, newnode)
	
	local growth_permitted_function = df_farming.growth_permitted["df_farming:plump_helmet_spawn"] -- use the same permitted function for all plump helmets
	if not growth_permitted_function or growth_permitted_function(pt.above) then
		df_farming.plant_timer(pt.above, plantname)
	end

	-- Run script hook
	local take_item = true
	for _, callback in ipairs(core.registered_on_placenodes) do
		-- Deepcopy pos, node and pointed_thing because callback can modify them
		local place_to_copy = vector.copy(pt.above)
		local newnode_copy = {name=newnode.name, param1=newnode.param1, param2=newnode.param2}
		local oldnode_copy = {name=oldnode.name, param1=oldnode.param1, param2=oldnode.param2}
		local pointed_thing_copy = copy_pointed_thing(pointed_thing)
		if callback(place_to_copy, newnode_copy, placer, oldnode_copy, itemstack, pointed_thing_copy) then
			take_item = false
		end
	end

	if not minetest.is_creative_enabled(placer:get_player_name()) then
		itemstack:take_item()
	end
	return itemstack
end


minetest.register_node("df_farming:plump_helmet_spawn", {
	description = S("Plump Helmet Spawn"),
	_doc_items_longdesc = df_farming.doc.plump_helmet_desc,
	_doc_items_usagehelp = df_farming.doc.plump_helmet_usage,
	tiles = {
		"dfcaverns_plump_helmet_cap.png",
	},
	groups = {snappy = 3, plant = 1, attached_node = 1, light_sensitive_fungus = 11, dfcaverns_cookable = 1, digtron_on_place=1, destroy_by_lava_flow=1,dig_by_piston=1, handy=1, hoey=1},
	_dfcaverns_next_stage = "df_farming:plump_helmet_1",
	_dfcaverns_next_stage_time = plump_helmet_grow_time,
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	walkable = false,
	is_ground_content = false,
	floodable = true,
	node_box = {
		type = "fixed",
		fixed = {
			{-0.0625 + displace_x, -0.5, -0.125 + displace_z, 0.125 + displace_x, -0.375, 0.0625 + displace_z},
		}
	},
	_mcl_blast_resistance = 0.2,
	_mcl_hardness = 0.2,	
	
	on_place = function(itemstack, placer, pointed_thing)
		return plump_helmet_on_place(itemstack, placer, pointed_thing, "df_farming:plump_helmet_spawn")
	end,
	
	on_timer = function(pos, elapsed)
		df_farming.grow_underground_plant(pos, "df_farming:plump_helmet_spawn", elapsed)
	end,
	
	on_destruct = function(pos)
		minetest.get_node_timer(pos):stop()
	end,
})

local plump_helmet_groups = {snappy = 3, flammable = 2, plant = 1, not_in_creative_inventory = 1, attached_node = 1, light_sensitive_fungus = 11, dfcaverns_cookable = 1, plump_helmet = 1, digtron_on_place=1, fire_encouragement=30,fire_flammability=100,destroy_by_lava_flow=1,dig_by_piston=1,compostability=65}
local get_plump_helmet_groups = function(eatable)
	local ret = {}
	for key, val in pairs(plump_helmet_groups) do
		ret[key]=val
	end
	ret.eatable = eatable
	ret.food = eatable
	return ret
end

minetest.register_node("df_farming:plump_helmet_1", {
	description = S("Plump Helmet"),
	_doc_items_longdesc = df_farming.doc.plump_helmet_desc,
	_doc_items_usagehelp = df_farming.doc.plump_helmet_usage,
	tiles = {
		"dfcaverns_plump_helmet_cap.png",
		"dfcaverns_plump_helmet_cap.png",
		"dfcaverns_plump_helmet_cap.png^[lowpart:5:dfcaverns_plump_helmet_stem.png",
	},
	groups = get_plump_helmet_groups(1),
	_dfcaverns_next_stage = "df_farming:plump_helmet_2",
	_dfcaverns_next_stage_time = plump_helmet_grow_time,
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	is_ground_content = false,
	sounds = df_dependencies.sound_leaves(),
	sound = {eat = {name = "df_farming_gummy_chew", gain = 1.0}},
	walkable = false,
	floodable = true,
	node_box = {
		type = "fixed",
		fixed = {
			{-0.0625 + displace_x, -0.5, -0.125 + displace_z, 0.125 + displace_x, -0.25, 0.0625 + displace_z},      -- stalk
			{-0.125 + displace_x, -0.4375, -0.1875 + displace_z, 0.1875 + displace_x, -0.3125, 0.125 + displace_z}, -- cap
		}
	},
	_mcl_blast_resistance = 0.3,
	_mcl_hardness = 0.3,	

	on_place = function(itemstack, placer, pointed_thing)
		return plump_helmet_on_place(itemstack, placer, pointed_thing, "df_farming:plump_helmet_1")
	end,

	on_use = minetest.item_eat(1),
	_hunger_ng = {satiates = 1},
	_mcl_saturation = 0.5,

	on_timer = function(pos, elapsed)
		df_farming.grow_underground_plant(pos, "df_farming:plump_helmet_1", elapsed)
	end,
})


minetest.register_node("df_farming:plump_helmet_2", {
	description = S("Plump Helmet"),
	_doc_items_longdesc = df_farming.doc.plump_helmet_desc,
	_doc_items_usagehelp = df_farming.doc.plump_helmet_usage,
	tiles = {
		"dfcaverns_plump_helmet_cap.png",
		"dfcaverns_plump_helmet_cap.png",
		"dfcaverns_plump_helmet_cap.png^[lowpart:15:dfcaverns_plump_helmet_stem.png",
	},
	groups = get_plump_helmet_groups(2),
	_dfcaverns_next_stage = "df_farming:plump_helmet_3",
	_dfcaverns_next_stage_time = plump_helmet_grow_time,
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	sounds = df_dependencies.sound_leaves(),
	sound = {eat = {name = "df_farming_gummy_chew", gain = 1.0}},
	walkable = false,
	is_ground_content = false,
	floodable = true,
	node_box = {
		type = "fixed",
		fixed = {
			{-0.0625 + displace_x, -0.5, -0.125 + displace_z, 0.125 + displace_x, 0, 0.0625 + displace_z},  -- stalk
			{-0.125 + displace_x, -0.3125, -0.1875 + displace_z, 0.1875 + displace_x, -0.0625, 0.125 + displace_z},  -- cap
		}
	},
	_mcl_blast_resistance = 0.4,
	_mcl_hardness = 0.4,	
	
	on_place = function(itemstack, placer, pointed_thing)
		return plump_helmet_on_place(itemstack, placer, pointed_thing, "df_farming:plump_helmet_2")
	end,
	
	on_use = minetest.item_eat(2),
	_hunger_ng = {satiates = 2},
	_mcl_saturation = 0.7,

	on_timer = function(pos, elapsed)
		df_farming.grow_underground_plant(pos, "df_farming:plump_helmet_2", elapsed)
	end,
})

minetest.register_node("df_farming:plump_helmet_3", {
	description = S("Plump Helmet"),
	_doc_items_longdesc = df_farming.doc.plump_helmet_desc,
	_doc_items_usagehelp = df_farming.doc.plump_helmet_usage,
	tiles = {
		"dfcaverns_plump_helmet_cap.png",
		"dfcaverns_plump_helmet_cap.png",
		"dfcaverns_plump_helmet_cap.png^[lowpart:35:dfcaverns_plump_helmet_stem.png",
	},
	groups = get_plump_helmet_groups(3),
	_dfcaverns_next_stage = "df_farming:plump_helmet_4",
	_dfcaverns_next_stage_time = plump_helmet_grow_time,
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	sounds = df_dependencies.sound_leaves(),
	sound = {eat = {name = "df_farming_gummy_chew", gain = 1.0}},
	walkable = false,
	is_ground_content = false,
	floodable = true,
	node_box = {
		type = "fixed",
		fixed = {
			{-0.125 + displace_x, -0.5, -0.1875 + displace_z, 0.1875 + displace_x, 0.25, 0.125 + displace_z}, -- stalk
			{-0.1875 + displace_x, -0.125, -0.25 + displace_z, 0.25 + displace_x, 0.1875, 0.1875 + displace_z}, -- cap
		}
	},
	_mcl_blast_resistance = 0.5,
	_mcl_hardness = 0.5,

	on_place = function(itemstack, placer, pointed_thing)
		return plump_helmet_on_place(itemstack, placer, pointed_thing, "df_farming:plump_helmet_3")
	end,
	
	on_use = minetest.item_eat(3),
	_hunger_ng = {satiates = 3},
	_mcl_saturation = 0.9,

	on_timer = function(pos, elapsed)
		df_farming.grow_underground_plant(pos, "df_farming:plump_helmet_3", elapsed)
	end,
})

minetest.register_node("df_farming:plump_helmet_4", {
	description = S("Plump Helmet"),
	_doc_items_longdesc = df_farming.doc.plump_helmet_desc,
	_doc_items_usagehelp = df_farming.doc.plump_helmet_usage,
	tiles = {
		"dfcaverns_plump_helmet_cap.png",
		"dfcaverns_plump_helmet_cap.png",
		"dfcaverns_plump_helmet_cap.png^[lowpart:40:dfcaverns_plump_helmet_stem.png",
	},
	groups = get_plump_helmet_groups(4),
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	sounds = df_dependencies.sound_leaves(),
	sound = {eat = {name = "df_farming_gummy_chew", gain = 1.0}},
	walkable = false,
	is_ground_content = false,
	floodable = false, -- I figure full grown plump helmets are sturdy enough to survive inundation
	node_box = {
		type = "fixed",
		fixed = {
			{-0.125 + displace_x, -0.5, -0.1875 + displace_z, 0.1875 + displace_x, 0.375, 0.125 + displace_z}, -- stalk
			{-0.25 + displace_x, -0.0625, -0.3125 + displace_z, 0.3125 + displace_x, 0.25, 0.25 + displace_z}, -- cap
			{-0.1875 + displace_x, 0.25, -0.25 + displace_z, 0.25 + displace_x, 0.3125, 0.1875 + displace_z}, -- cap rounding
		}
	},
	_mcl_blast_resistance = 0.6,
	_mcl_hardness = 0.6,

	drop = {
		max_items = 4,
		items = {
			{
				items = {'df_farming:plump_helmet_4_picked'},
				rarity = 1,
			},
			{
				items = {'df_farming:plump_helmet_spawn'},
				rarity = 1,
			},
			{
				items = {'df_farming:plump_helmet_spawn'},
				rarity = 2,
			},
			{
				items = {'df_farming:plump_helmet_spawn'},
				rarity = 2,
			},
		},
	},
	on_place = function(itemstack, placer, pointed_thing)
		return plump_helmet_on_place(itemstack, placer, pointed_thing, "df_farming:plump_helmet_4")
	end,
	
	on_use = minetest.item_eat(4),
	_hunger_ng = {satiates = 4},
	_mcl_saturation = 1,
})

local picked_groups = {}
for key, val in pairs(plump_helmet_groups) do
	picked_groups[key]=val
	picked_groups.eatable=4
	picked_groups.food=4
end
picked_groups.not_in_creative_inventory = nil
-- Need a separate picked type to prevent it from giving infinite spawn by just placing and re-harvesting
minetest.register_node("df_farming:plump_helmet_4_picked", {
	description = S("Plump Helmet"),
	_doc_items_longdesc = df_farming.doc.plump_helmet_desc,
	_doc_items_usagehelp = df_farming.doc.plump_helmet_usage,
	tiles = {
		"dfcaverns_plump_helmet_cap.png",
		"dfcaverns_plump_helmet_cap.png",
		"dfcaverns_plump_helmet_cap.png^[lowpart:40:dfcaverns_plump_helmet_stem.png",
	},
	groups = picked_groups,
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	sounds = df_dependencies.sound_leaves(),
	sound = {eat = {name = "df_farming_gummy_chew", gain = 1.0}},
	walkable = false,
	is_ground_content = false,
	floodable = false,
	node_box = {
		type = "fixed",
		fixed = {
			{-0.125 + displace_x, -0.5, -0.1875 + displace_z, 0.1875 + displace_x, 0.375, 0.125 + displace_z}, -- stalk
			{-0.25 + displace_x, -0.0625, -0.3125 + displace_z, 0.3125 + displace_x, 0.25, 0.25 + displace_z}, -- cap
			{-0.1875 + displace_x, 0.25, -0.25 + displace_z, 0.25 + displace_x, 0.3125, 0.1875 + displace_z}, -- cap rounding
		}
	},
	_mcl_blast_resistance = 0.6,
	_mcl_hardness = 0.6,

	on_place = function(itemstack, placer, pointed_thing)
		return plump_helmet_on_place(itemstack, placer, pointed_thing, "df_farming:plump_helmet_4_picked")
	end,
	
	on_use = minetest.item_eat(4),
	_hunger_ng = {satiates = 4},
	_mcl_saturation = 1,
})

local place_list = {
	minetest.get_content_id("df_farming:plump_helmet_spawn"),
	minetest.get_content_id("df_farming:plump_helmet_1"),
	minetest.get_content_id("df_farming:plump_helmet_2"),
	minetest.get_content_id("df_farming:plump_helmet_3"),
	minetest.get_content_id("df_farming:plump_helmet_4"),
}
-- doesn't set the timer running, so plants placed by this method won't grow
df_farming.spawn_plump_helmet_vm = function(vi, area, data, param2_data)
	data[vi] = place_list[math.random(1,5)]
	param2_data[vi] = math.random(1,4)-1
end

minetest.register_craft({
	type = "fuel",
	recipe = "df_farming:plump_helmet_spawn",
	burntime = 1
})
minetest.register_craft({
	type = "fuel",
	recipe = "df_farming:plump_helmet_1",
	burntime = 1
})
minetest.register_craft({
	type = "fuel",
	recipe = "df_farming:plump_helmet_2",
	burntime = 2
})
minetest.register_craft({
	type = "fuel",
	recipe = "df_farming:plump_helmet_3",
	burntime = 3
})
minetest.register_craft({
	type = "fuel",
	recipe = "df_farming:plump_helmet_4",
	burntime = 4
})
minetest.register_craft({
	type = "fuel",
	recipe = "df_farming:plump_helmet_4_picked",
	burntime = 4
})