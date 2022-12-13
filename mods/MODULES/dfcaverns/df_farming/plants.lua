local S = minetest.get_translator(minetest.get_current_modname())

-----------------------------------------------------------------------
-- Plants

minetest.register_node("df_farming:dead_fungus", {
	description = S("Dead Fungus"),
	_doc_items_longdesc = df_farming.doc.dead_fungus_desc,
	_doc_items_usagehelp = df_farming.doc.dead_fungus_usage,
	drawtype = "plantlike",
	tiles = {"dfcaverns_dead_fungus.png"},
	inventory_image = "dfcaverns_dead_fungus.png",
	paramtype = "light",
	walkable = false,
	is_ground_content = false,
	buildable_to = true,
	floodable = true,
	groups = {snappy = 3, flammable = 2, plant = 1, not_in_creative_inventory = 1, attached_node = 1, flow_through = 1, fire_encouragement=60,fire_flammability=100,destroy_by_lava_flow=1,dig_by_piston=1, compostability=65, handy=1, hoey=1},
	sounds = df_dependencies.sound_leaves(),
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, 0.0, 0.5},
	},
	_mcl_blast_resistance = 0.2,
	_mcl_hardness = 0.2,
})

minetest.register_craft({
	type = "fuel",
	recipe = "df_farming:dead_fungus",
	burntime = 2
})

local c_dead_fungus = minetest.get_content_id("df_farming:dead_fungus")
df_farming.spawn_dead_fungus_vm = function(vi, area, data, param2_data)
	data[vi] = c_dead_fungus
	param2_data[vi] = 0
end

minetest.register_node("df_farming:cavern_fungi", {
	description = S("Cavern Fungi"),
	_doc_items_longdesc = df_farming.doc.cavern_fungi_desc,
	_doc_items_usagehelp = df_farming.doc.cavern_fungi_usage,
	drawtype = "plantlike",
	tiles = {"dfcaverns_fungi.png"},
	inventory_image = "dfcaverns_fungi.png",
	paramtype = "light",
	walkable = false,
	is_ground_content = false,
	buildable_to = true,
	floodable = true,
	light_source = 6,
	groups = {snappy = 3, flammable = 2, plant = 1, not_in_creative_inventory = 1, attached_node = 1, light_sensitive_fungus = 11, flow_through = 1, fire_encouragement=50,fire_flammability=60,destroy_by_lava_flow=1,dig_by_piston=1, compostability=65, handy=1, hoey=1},
	sounds = df_dependencies.sound_leaves(),
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, 0.0, 0.5},
	},
	_mcl_blast_resistance = 0.2,
	_mcl_hardness = 0.2,
})

minetest.register_craft({
	type = "fuel",
	recipe = "df_farming:cavern_fungi",
	burntime = 2
})

local c_cavern_fungi = minetest.get_content_id("df_farming:cavern_fungi")
df_farming.spawn_cavern_fungi_vm = function(vi, area, data, param2_data)
	data[vi] = c_cavern_fungi
	param2_data[vi] = 0
end

-----------------------------------------------------------------------------------------

local marginal = {[df_dependencies.node_name_dirt] = true}
local growable = {[df_dependencies.node_name_dirt_wet] = true, [df_dependencies.node_name_dirt] = true}

df_farming.plant_timer = function(pos, plantname, elapsed)
	local next_stage_time = minetest.registered_nodes[plantname]._dfcaverns_next_stage_time
	if not next_stage_time then return end
	
	next_stage_time = next_stage_time + math.random(next_stage_time * -0.1, next_stage_time * 0.1)
	local below = minetest.get_node(vector.add(pos, {x=0, y=-1, z=0}))
	if marginal[below.name] then
		next_stage_time = next_stage_time * 5
	end
	if elapsed ~= nil then
		minetest.get_node_timer(pos):set(next_stage_time, elapsed-next_stage_time)
	else
		minetest.get_node_timer(pos):start(next_stage_time)
	end
end

local function copy_pointed_thing(pointed_thing)
	return {
		type  = pointed_thing.type,
		above = pointed_thing.above and vector.copy(pointed_thing.above),
		under = pointed_thing.under and vector.copy(pointed_thing.under),
		ref   = pointed_thing.ref,
	}
end

local place_seed = function(itemstack, placer, pointed_thing, plantname)
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
	local newnode= {name = itemstack:get_name(), param2 = 1, param1=0}
	local oldnode= minetest.get_node(pt.above)
	minetest.add_node(pt.above, {name = plantname, param2 = 1})
	
	local growth_permitted_function = df_farming.growth_permitted[plantname]
	if not growth_permitted_function or growth_permitted_function(pt.above) then
		df_farming.plant_timer(pt.above, plantname)
	else
		minetest.get_node_timer(pt.above):stop() -- make sure no old timers are running on this node
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

df_farming.register_seed = function(name, description, image, stage_one, grow_time, desc, usage)
	local def = {
		description = description,
		_doc_items_longdesc = desc,
		_doc_items_usagehelp = usage,
		tiles = {image},
		inventory_image = image,
		wield_image = image,
		drawtype = "signlike",
		paramtype2 = "wallmounted",
		groups = {seed = 1, snappy = 3, attached_node = 1, dfcaverns_cookable = 1, digtron_on_place=1,destroy_by_lava_flow=1,dig_by_piston=1, handy=1, hoey=1},
		_dfcaverns_next_stage = stage_one,
		_dfcaverns_next_stage_time = grow_time,
		paramtype = "light",
		walkable = false,
		is_ground_content = false,
		floodable = true,
		sunlight_propagates = true,
		selection_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, -0.5, 0.5, -5/16, 0.5},
		},
		_mcl_blast_resistance = 0.2,
		_mcl_hardness = 0.2,	
		
		on_place = function(itemstack, placer, pointed_thing)
			return place_seed(itemstack, placer, pointed_thing, "df_farming:"..name)
		end,
		
		on_timer = function(pos, elapsed)
			df_farming.grow_underground_plant(pos, "df_farming:"..name, elapsed)
		end,
		
		on_destruct = function(pos)
			minetest.get_node_timer(pos):stop()
		end,
	}
	
	minetest.register_node("df_farming:"..name, def)
	minetest.register_craft({
		type = "fuel",
		recipe = "df_farming:"..name,
		burntime = 1
	})
end

df_farming.grow_underground_plant = function(pos, plant_name, elapsed)
	if df_farming.kill_if_sunlit(pos) then
		return
	end
	local node_def = minetest.registered_nodes[plant_name]
	local next_stage = node_def._dfcaverns_next_stage
	if next_stage then
		local soil = minetest.get_node(vector.add(pos, {x=0, y=-1, z=0})).name
		if growable[soil] then
			local next_def = minetest.registered_nodes[next_stage]
			local node = minetest.get_node(pos)
			minetest.swap_node(pos, {name=next_stage, param2 = next_def.place_param2 or node.param2})
			df_farming.plant_timer(pos, next_stage, elapsed)
		else
			df_farming.plant_timer(pos, plant_name) -- reset timer, check again later
		end
	end
end

df_farming.kill_if_sunlit = function(pos, node)
	return false
end
if df_farming.config.light_kills_fungus then
	local kill_if_sunlit = function(pos, node)
		if not node then
			node = minetest.get_node(pos)
		end
		local node_def = minetest.registered_nodes[node.name]
		local light_sensitive_fungus_level = node_def.groups.light_sensitive_fungus
		
		-- This should never be the case, but I've received a report of it happening anyway in the ABM so guarding against it.
		if not light_sensitive_fungus_level then return false end
		
		local dead_node = node_def._dfcaverns_dead_node or "df_farming:dead_fungus"
		-- 11 is the value adjacent to a torch
		local light_level = minetest.get_node_light(pos, 0.5) -- check at 0.5 to get how bright it would be here at noon,
			-- prevents fungus from growing on the surface world by happenstance
		if light_level and light_level > light_sensitive_fungus_level then
			minetest.set_node(pos, {name=dead_node, param2 = node.param2})
			return true
		end
		return false
	end

	df_farming.kill_if_sunlit = kill_if_sunlit

	minetest.register_abm({
		label = "df_farming:kill_light_sensitive_fungus",
		nodenames = {"group:light_sensitive_fungus"},
		catch_up = true,
		interval = 30,
		chance = 5,
		action = function(pos, node)
			kill_if_sunlit(pos, node)
		end
	})
end
