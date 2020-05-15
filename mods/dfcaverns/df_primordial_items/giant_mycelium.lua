-- This file defines a type of root-like growth that spreads over the surface of the ground in a random web-like pattern

-- internationalization boilerplate
local MP = minetest.get_modpath(minetest.get_current_modname())
local S, NS = dofile(MP.."/intllib.lua")

-- hub_thickness -- the bit in the middle that's seen at the ends and corners of long hypha runs
-- connector_thickness
local get_node_box = function(hub_thickness, connector_thickness)
	return {
		type = "connected",
		fixed = {-hub_thickness,-hub_thickness,-hub_thickness,hub_thickness,hub_thickness,hub_thickness},
		connect_top = {-connector_thickness, 0, -connector_thickness, connector_thickness, 0.5, connector_thickness},
		connect_bottom = {-connector_thickness, -0.5, -connector_thickness, connector_thickness, 0, connector_thickness},
		connect_back = {-connector_thickness, -connector_thickness, 0, connector_thickness, connector_thickness, 0.5},
		connect_right = {0, -connector_thickness, -connector_thickness, 0.5, connector_thickness, connector_thickness},
		connect_front = {-connector_thickness, -connector_thickness, -0.5, connector_thickness, connector_thickness, 0},
		connect_left = {-0.5, -connector_thickness, -connector_thickness, 0, connector_thickness, connector_thickness},
		disconnected = {-connector_thickness, -connector_thickness, -connector_thickness, connector_thickness, connector_thickness, connector_thickness},
	}
end

minetest.register_node("df_primordial_items:giant_hypha_root", {
	description = S("Rooted Giant Hypha"),
	_doc_items_longdesc = df_primordial_items.doc.giant_hyphae_desc,
	_doc_items_usagehelp = df_primordial_items.doc.giant_hyphae_usage,
	tiles = {
		{name="dfcaverns_mush_giant_hypha.png"},
	},
    connects_to = {"group:soil", "group:hypha"},
    connect_sides = { "top", "bottom", "front", "left", "back", "right" },
	drawtype = "nodebox",
	node_box = get_node_box(0.1875, 0.25),
	collision_box = get_node_box(0.125, 0.1875),
	paramtype = "light",
	light_source = 2,
	is_ground_content = false,
	climbable = true,
	groups = {oddly_breakable_by_hand = 1, choppy = 2, hypha = 1},
	sounds = df_trees.node_sound_tree_soft_fungus_defaults(),
	drop = {
		max_items = 1,
		items = {
			{
				items = {"df_primordial_items:mycelial_fibers","df_primordial_items:giant_hypha_apical_meristem"},
				rarity = 100,
			},
			{
				items = {"df_primordial_items:mycelial_fibers"},
			},
		},
	},
})
minetest.register_node("df_primordial_items:giant_hypha", {
	description = S("Giant Hypha"),
	_doc_items_longdesc = df_primordial_items.doc.giant_hyphae_desc,
	_doc_items_usagehelp = df_primordial_items.doc.giant_hyphae_usage,
	tiles = {
		{name="dfcaverns_mush_giant_hypha.png"},
	},
    connects_to = {"group:hypha"},
    connect_sides = { "top", "bottom", "front", "left", "back", "right" },
	drawtype = "nodebox",
	node_box = get_node_box(0.1875, 0.25),
	collision_box = get_node_box(0.125, 0.1875),
	paramtype = "light",
	light_source = 2,
	is_ground_content = false,
	climbable = true,
	groups = {oddly_breakable_by_hand = 1, choppy = 2, hypha = 1},
	sounds = df_trees.node_sound_tree_soft_fungus_defaults(),
	drop = {
		max_items = 1,
		items = {
			{
				items = {"df_primordial_items:mycelial_fibers","df_primordial_items:giant_hypha_apical_meristem"},
				rarity = 100,
			},
			{
				items = {"df_primordial_items:mycelial_fibers"},
			},
		},
	},
})

minetest.register_craftitem("df_primordial_items:mycelial_fibers", {
	description = S("Giant Mycelial Fibers"),
	_doc_items_longdesc = df_primordial_items.doc.mycelial_fibers_desc,
	_doc_items_usagehelp = df_primordial_items.doc.mycelial_fibers_usage,
	groups = {wool = 1},
	inventory_image = "dfcaverns_mush_mycelial_fibers.png",
})

minetest.register_craftitem("df_primordial_items:mycelial_thread", {
	description = S("Mycelial thread"),
	_doc_items_longdesc = df_primordial_items.doc.mycelial_thread_desc,
	_doc_items_usagehelp = df_primordial_items.doc.mycelial_thread_usage,
	inventory_image = "dfcaverns_pig_tail_thread.png",
	groups = {flammable = 1, thread = 1},
})

minetest.register_craft({
	output = "df_primordial_items:mycelial_thread 4",
	type = "shapeless",
	recipe = { "df_primordial_items:mycelial_fibers"},
})

-- Check each of the six cardinal directions to see if it's buildable-to,
-- if it has an adjacent "soil" node (or if it's going out over the corner of an adjacent soil node),
-- and does *not* have an adjacent hypha already.
-- By growing with these conditions hyphae will hug the ground and will not immediately loop back on themselves
-- (though they can run into other pre-existing growths, forming larger loops - which is fine, large loops are nice)

local ystride = 3
local zstride = 9
local get_item_group = minetest.get_item_group
local get_node = minetest.get_node
local registered_nodes = minetest.registered_nodes
local math_random = math.random

local find_mycelium_growth_targets = function(pos)
	local nodes = {}
	local pos_x = pos.x
	local pos_y = pos.y
	local pos_z = pos.z
	
	for x = -1, 1 do
		for y = -1, 1 do
			for z = -1, 1 do
				if not (x == y and y == z) then -- we don't care about the diagonals or the center node
					local node = get_node({x=pos_x+x, y=pos_y+y, z=pos_z+z})
					local node_name = node.name
					if node_name == "ignore" then
						-- Pause growth! We're at the edge of the known world.
						return nil
					end
					if get_item_group(node_name, "soil") > 0 or
						get_item_group(node_name, "stone") > 0 and math_random() < 0.5 then -- let hyphae explore out over stone
						nodes[x + y*ystride + z*zstride] = "soil"
					elseif get_item_group(node_name, "hypha") > 0 then
						nodes[x + y*ystride + z*zstride] = "hypha"
					elseif registered_nodes[node_name] and registered_nodes[node_name].buildable_to then
						nodes[x + y*ystride + z*zstride] = "buildable"
					end
				end
			end
		end
	end

	--TODO there's probably some clever way to turn this into a subroutine, but I'm tired right now and
	--copy and pasting is easy and nobody's going to decide whether to hire or fire me based on this
	--particular snippet of code so what the hell. I'll fix it later when that clever way comes to me.
	local valid_targets = {}
	if nodes[-1] == "buildable" and
		-- test for soil to directly support new growth
		(nodes[-1 -ystride] == "soil" or
		nodes[-1 +ystride] == "soil" or
		nodes[-1 -zstride] == "soil" or
		nodes[-1 +zstride] == "soil" or
		-- test for soil "around the corner" to allow for growth over an edge
		nodes[-ystride] == "soil" or
		nodes[ystride] == "soil" or
		nodes[-zstride] == "soil" or
		nodes[zstride] == "soil")
		and not -- no adjacent hypha
		(nodes[-1 -ystride] == "hypha" or
		nodes[-1 +ystride] == "hypha" or
		nodes[-1 -zstride] == "hypha" or
		nodes[-1 +zstride] == "hypha")
	then
		table.insert(valid_targets, {x=pos_x-1, y=pos_y, z=pos_z})
	end
	if nodes[1] == "buildable" and
		-- test for soil to directly support new growth
		(nodes[1 -ystride] == "soil" or
		nodes[1 +ystride] == "soil" or
		nodes[1 -zstride] == "soil" or
		nodes[1 +zstride] == "soil" or
		-- test for soil "around the corner" to allow for growth over an edge
		nodes[-ystride] == "soil" or
		nodes[ystride] == "soil" or
		nodes[-zstride] == "soil" or
		nodes[zstride] == "soil")
		and not -- no adjacent hypha
		(nodes[1 -ystride] == "hypha" or
		nodes[1 +ystride] == "hypha" or
		nodes[1 -zstride] == "hypha" or
		nodes[1 +zstride] == "hypha")
	then
		table.insert(valid_targets, {x=pos_x+1, y=pos_y, z=pos_z})
	end
	if nodes[-ystride] == "buildable" and
		-- test for soil to directly support new growth
		(nodes[-1 -ystride] == "soil" or
		nodes[1 -ystride] == "soil" or
		nodes[-ystride -zstride] == "soil" or
		nodes[-ystride +zstride] == "soil" or
		-- test for soil "around the corner" to allow for growth over an edge
		nodes[-1] == "soil" or
		nodes[1] == "soil" or
		nodes[-zstride] == "soil" or
		nodes[zstride] == "soil")
		and not -- no adjacent hypha
		(nodes[-1 -ystride] == "hypha" or
		nodes[1 -ystride] == "hypha" or
		nodes[-ystride -zstride] == "hypha" or
		nodes[-ystride +zstride] == "hypha")
	then
		table.insert(valid_targets, {x=pos_x, y=pos_y-1, z=pos_z})
	end
	if nodes[ystride] == "buildable" and
		-- test for soil to directly support new growth
		(nodes[-1 +ystride] == "soil" or
		nodes[1 +ystride] == "soil" or
		nodes[ystride -zstride] == "soil" or
		nodes[ystride +zstride] == "soil" or
		-- test for soil "around the corner" to allow for growth over an edge
		nodes[-1] == "soil" or
		nodes[1] == "soil" or
		nodes[-zstride] == "soil" or
		nodes[zstride] == "soil")
		and not -- no adjacent hypha
		(nodes[-1] == "hypha" or
		nodes[1 + ystride] == "hypha" or
		nodes[ystride -zstride] == "hypha" or
		nodes[ystride +zstride] == "hypha")
	then
		table.insert(valid_targets, {x=pos_x, y=pos_y+1, z=pos_z})
	end
	if nodes[-zstride] == "buildable" and
		-- test for soil to directly support new growth
		(nodes[-1 -zstride] == "soil" or
		nodes[1 -zstride] == "soil" or
		nodes[-ystride -zstride] == "soil" or
		nodes[ystride -zstride] == "soil" or
		-- test for soil "around the corner" to allow for growth over an edge
		nodes[-1] == "soil" or
		nodes[1] == "soil" or
		nodes[-ystride] == "soil" or
		nodes[ystride] == "soil")
		and not -- no adjacent hypha
		(nodes[-1 -zstride] == "hypha" or
		nodes[1 -zstride] == "hypha" or
		nodes[-ystride -zstride] == "hypha" or
		nodes[ystride -zstride] == "hypha")
	then
		table.insert(valid_targets, {x=pos_x, y=pos_y, z=pos_z-1})
	end
	if nodes[zstride] == "buildable" and
		-- test for soil to directly support new growth
		(nodes[-1 +zstride] == "soil" or
		nodes[1 +zstride] == "soil" or
		nodes[-ystride +zstride] == "soil" or
		nodes[ystride +zstride] == "soil" or
		-- test for soil "around the corner" to allow for growth over an edge
		nodes[-1] == "soil" or
		nodes[1] == "soil" or
		nodes[-ystride] == "soil" or
		nodes[ystride] == "soil")
		and not -- no adjacent hypha
		(nodes[-1 +zstride] == "hypha" or
		nodes[1 +zstride] == "hypha" or
		nodes[-ystride + zstride] == "hypha" or
		nodes[ystride +zstride] == "hypha")
	then
		table.insert(valid_targets, {x=pos_x, y=pos_y, z=pos_z+1})
	end
	
	return valid_targets
end

local grow_mycelium = function(pos, meristem_name)
	local new_meristems = {}
	-- Can we grow? If so, pick a random direction and add a new meristem there
	local targets = find_mycelium_growth_targets(pos)
	
	if targets == nil then
		return nil -- We hit the edge of the known world, pause!
	end
	
	local target_count = #targets
	if target_count > 0 then
		local target = targets[math.random(1,target_count)]
		minetest.set_node(target, {name=meristem_name})
		table.insert(new_meristems, target)
	else
		--nowhere to grow, turn into a rooted hypha and we're done
		minetest.set_node(pos, {name="df_primordial_items:giant_hypha_root"})
		return new_meristems
	end

	if math.random() < 0.06 then -- Note: hypha growth pattern is very sensitive to this branching factor. Higher than about 0.06 will blanket the landscape with fungus.
		-- Split - try again from here next time
		table.insert(new_meristems, pos)
	-- Otherwise, just turn into a hypha and we're done
	elseif math.random() < 0.333 then
		minetest.set_node(pos, {name="df_primordial_items:giant_hypha_root"})
	else
		minetest.set_node(pos, {name="df_primordial_items:giant_hypha"})
	end
	return new_meristems
end

local min_growth_delay = tonumber(minetest.settings:get("dfcaverns_mycelium_min_growth_delay")) or 240
local max_growth_delay = tonumber(minetest.settings:get("dfcaverns_mycelium_max_growth_delay")) or 400
local avg_growth_delay = (min_growth_delay + max_growth_delay) / 2

minetest.register_node("df_primordial_items:giant_hypha_apical_meristem", {
	description = S("Giant Hypha Apical Meristem"),
	tiles = {
		{name="dfcaverns_mush_giant_hypha.png^[brighten"},
	},
    connects_to = {"group:hypha"},
    connect_sides = { "top", "bottom", "front", "left", "back", "right" },
	drawtype = "nodebox",
	light_source = 6,
	node_box = get_node_box(0.25, 0.375),
	paramtype = "light",

	is_ground_content = false,
	groups = {oddly_breakable_by_hand = 1, choppy = 2, hypha = 1, light_sensitive_fungus = 13},
	_dfcaverns_dead_node = "df_primordial_items:giant_hypha_root",
	sounds = df_trees.node_sound_tree_soft_fungus_defaults(),
	on_construct = function(pos)
		minetest.get_node_timer(pos):start(math.random(min_growth_delay, max_growth_delay))
	end,
	on_destruct = function(pos)
		minetest.get_node_timer(pos):stop()
	end,
	on_timer = function(pos, elapsed)
		if df_farming and df_farming.kill_if_sunlit(pos) then
			return
		end
	
		if elapsed > max_growth_delay then
			-- We've been unloaded for a while, need to do multiple growth iterations.
			local iterations = math.floor(elapsed / avg_growth_delay) -- the number of iterations we've missed
			local stack = {pos} -- initialize with the current location
			for i = 1, iterations do
				local new_stack = {} -- populate this with new node output.
				for _, stackpos in ipairs(stack) do -- for each currently growing location
					local ret = grow_mycelium(stackpos, "df_primordial_items:giant_hypha_apical_meristem")
					if ret == nil then
						-- We hit the edge of the known world, stop and retry later
						minetest.get_node_timer(stackpos):start(math.random(min_growth_delay,max_growth_delay))
					else
						for _, retpos in ipairs(ret) do
							-- put the new locations into new_stack
							table.insert(new_stack, retpos)
						end
					end
				end
				stack = new_stack -- replace the old stack with the new
			end
			for _, donepos in ipairs(stack) do
				-- After all the iterations are done, if there's any leftover growing positions set a timer for each of them
				minetest.get_node_timer(donepos):start(math.random(min_growth_delay,max_growth_delay))
			end
		else
			-- just do one iteration.
			local new_meristems = grow_mycelium(pos, "df_primordial_items:giant_hypha_apical_meristem")
			if new_meristems == nil then
				-- We hit the end of the known world, try again later. Unlikely in this case, but theoretically possible I guess.
				minetest.get_node_timer(pos):start(math.random(min_growth_delay,max_growth_delay))
			else
				for _, newpos in ipairs(new_meristems) do
					minetest.get_node_timer(newpos):start(math.random(min_growth_delay,max_growth_delay))
				end
			end
		end		
	end,
})

-- this version grows instantly, it is meant for mapgen usage.

local grow_mycelium_immediately = function(pos)
	local stack = {pos}
	while #stack > 0 do
		local pos = table.remove(stack)
		if not (df_farming and df_farming.kill_if_sunlit(pos)) then
			local new_poses = grow_mycelium(pos, "df_primordial_items:giant_hypha_apical_mapgen")
			if new_poses then
				for _, new_pos in ipairs(new_poses) do
					table.insert(stack, new_pos)
				end
			else
				-- if we hit the end of the world, just stop. There'll be a mapgen meristem left here, re-trigger it.
				minetest.get_node_timer(pos):start(math.random(10,60))
			end
		end
	end	
end

minetest.register_node("df_primordial_items:giant_hypha_apical_mapgen", {
	description = S("Giant Hypha Apical Meristem"),
	tiles = {
		{name="dfcaverns_mush_giant_hypha.png^[brighten"},
	},
    connects_to = {"group:hypha"},
    connect_sides = { "top", "bottom", "front", "left", "back", "right" },
	drawtype = "nodebox",
	_dfcaverns_dead_node = "df_primordial_items:giant_hypha_root",
	light_source = 6,
	node_box = get_node_box(0.25, 0.375),
	paramtype = "light",

	is_ground_content = false,
	groups = {oddly_breakable_by_hand = 1, choppy = 2, hypha = 1, not_in_creative_inventory = 1, light_sensitive_fungus = 13},
	sounds = df_trees.node_sound_tree_soft_fungus_defaults(),
	on_timer = function(pos, elapsed)
		grow_mycelium_immediately(pos)
	end,
	on_construct = function(pos)
		minetest.get_node_timer(pos):start(1)
	end,
	on_destruct = function(pos)
		minetest.get_node_timer(pos):stop()
	end,
})

-- Just in case mapgen fails to trigger the timer on a mapgen mycelium this ABM will clean up.
minetest.register_abm({
	label = "df_primordial_items ensure giant mycelium growth",
	nodenames = {"df_primordial_items:giant_hypha_apical_mapgen"},
	interval = 10.0,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local timer = minetest.get_node_timer(pos)
		if not timer:is_started() then
			timer:start(math.random(1,10))
		end
	end,
})