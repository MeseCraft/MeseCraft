local modname = minetest.get_current_modname()
local S = minetest.get_translator(modname)

local sound
if df_dependencies.sound_leaves then
	sound = df_dependencies.sound_leaves()
end

local get_node_box = function(connector_thickness)
	return {
		type = "connected",
		--fixed = {-hub_thickness,-hub_thickness,-hub_thickness,hub_thickness,hub_thickness,hub_thickness},
		connect_top = {-connector_thickness, 0, -connector_thickness, connector_thickness, 0.5, connector_thickness},
		connect_bottom = {-connector_thickness, -0.5, -connector_thickness, connector_thickness, 0, connector_thickness},
		connect_back = {-connector_thickness, -connector_thickness, 0, connector_thickness, connector_thickness, 0.5},
		connect_right = {0, -connector_thickness, -connector_thickness, 0.5, connector_thickness, connector_thickness},
		connect_front = {-connector_thickness, -connector_thickness, -0.5, connector_thickness, connector_thickness, 0},
		connect_left = {-0.5, -connector_thickness, -connector_thickness, 0, connector_thickness, connector_thickness},
		disconnected = {-connector_thickness, -connector_thickness, -connector_thickness, connector_thickness, connector_thickness, connector_thickness},
	}
end

local anchor_groups = {"group:soil", "group:stone", "group:tree", "group:wood", "group:webbing", "group:solid"}

local in_anchor_group = function(name)
	for _, group in pairs(anchor_groups) do
		if minetest.get_item_group(name, string.sub(group, 7)) then
			return true
		end
	end
	if name == "ignore" then
		return true
	end
end

local cardinal_directions = {
	{x=1,y=0,z=0},
	{x=-1,y=0,z=0},
	{x=0,y=1,z=0},
	{x=0,y=-1,z=0},
	{x=0,y=0,z=1},
	{x=0,y=0,z=-1}
}

local cardinal_planes = {
	{3,5},
	{3,5},
	{1,5},
	{1,5},
	{1,3},
	{1,3},
}

local insert_if_not_in_hashtable = function(pos, insert_into, if_not_in)
	local hash = minetest.hash_node_position(pos)
	if if_not_in[hash] then
		return
	end
	table.insert(insert_into, pos)
end

-- flood fill through the web to get all web and anchor locations
local get_web_nodes = function(pos, webs, anchors)
	local to_check = {}
	table.insert(to_check, pos)
	while next(to_check) ~= nil do
		local check_pos = table.remove(to_check)
		local check_node = minetest.get_node(check_pos)
		if minetest.get_item_group(check_node.name, "webbing") > 0 then
			webs[minetest.hash_node_position(check_pos)] = true
			for _, dir in pairs(cardinal_directions) do
				insert_if_not_in_hashtable(vector.add(check_pos, dir), to_check, webs)
			end
		elseif in_anchor_group(check_node.name) then
			anchors[minetest.hash_node_position(check_pos)] = true
		end		
	end	
end

local web_line = function(pos, dir, distance)
	local anchored
	local web_spine = {}
	for i = 0, distance do
		local web_pos = vector.add(pos, vector.multiply(dir,i))
		local node_name = minetest.get_node(web_pos).name
		if node_name == "air" or node_name == "big_webs:webbing" then
			table.insert(web_spine, web_pos)
		elseif in_anchor_group(node_name) then
			anchored=true
			break
		else
			anchored=false
			break
		end
	end

	if anchored then
		for _, web_pos in pairs(web_spine) do
			if math.random() < 0.9 then
				minetest.set_node(web_pos, {name="big_webs:webbing"})
			end
		end
		return web_spine
	end
	return nil
end

local generate_web = function(pos)
	local dir_choice = math.random(1, 6)
	local dir = cardinal_directions[dir_choice]
	local web_spine = web_line(pos, dir, 30)
	if web_spine then
		local dir2 = cardinal_directions[cardinal_planes[dir_choice][math.random(1, 2)]]
		local dir2_opposite = vector.multiply(dir2, -1)
		for _, web_pos in pairs(web_spine) do
			web_line(web_pos, dir2, 15)
			web_line(web_pos, dir2_opposite, 15)
		end
	end
end

minetest.register_node("big_webs:webbing", {
	description = S("Giant Cave Spider Webbing"),
	_doc_items_longdesc = S("Thick ropes of sticky, springy silk, strung between cavern walls in hopes of catching bats and even larger beasts."),
	_doc_items_usagehelp = S("Webbing can be collected and re-strung elsewhere to aid in climbing. It absorbs all falling damage when you land on it."),
	tiles = {
		{name="big_webs.png"},
	},
	use_texture_alpha = "blend",
    connects_to = anchor_groups,
    connect_sides = { "top", "bottom", "front", "left", "back", "right" },
	drawtype = "nodebox",
	node_box = get_node_box(0.0625),
	collision_box = get_node_box(0.0625),
	inventory_image = "big_webs_item.png",
	wield_image = "big_webs_item.png",
	paramtype = "light",
	is_ground_content = false,
	climbable = true,
	groups = {snappy = 2, choppy = 2, webbing = 1, shearsy = 1,  swordy=1, flammable=1, destroy_by_lava_flow=1, fall_damage_add_percent=-100, bouncy=20},
	sounds = sound,
	on_construct = function(pos)
		minetest.get_node_timer(pos):start(30)
	end,
	on_destruct = function(pos)
		for _, dir in pairs(cardinal_directions) do
			local neighbor_pos = vector.add(pos, dir)
			if minetest.get_item_group(minetest.get_node(neighbor_pos).name, "webbing") > 0 then
				minetest.get_node_timer(neighbor_pos):start(30)
			end
		end
		minetest.get_node_timer(pos):stop()
	end,
	on_timer = function(pos, elapsed)
		local webs = {}
		local anchors = {}
		get_web_nodes(pos, webs, anchors)
		local first_anchor = next(anchors)
		for hash, _ in pairs(webs) do
			local web_pos = minetest.get_position_from_hash(hash)
			if first_anchor == nil then
				-- unsupported web
				minetest.set_node(web_pos, {name="air"})
				minetest.item_drop(ItemStack("big_webs:webbing"), nil, web_pos)
			end
			minetest.get_node_timer(web_pos):stop() -- no need to recheck
		end	
	end,
	_mcl_blast_resistance = 1.0,
	_mcl_hardness = 0.5,
})

minetest.register_node("big_webs:web_egg", {
	description = S("Giant Cave Spider Web Generator"),
	tiles = {
		{name="big_webs.png"},
	},
	use_texture_alpha = "blend",
    connects_to = anchor_groups,
    connect_sides = { "top", "bottom", "front", "left", "back", "right" },
	drawtype = "nodebox",
	node_box = get_node_box(0.0625),
	collision_box = get_node_box(0.0625),
	inventory_image = "big_webs_item.png",
	wield_image = "big_webs_item.png",
	paramtype = "light",
	is_ground_content = false,
	climbable = true,
	floodable = true,
	groups = {snappy = 2, choppy = 2, webbing = 1, flammable=1, fall_damage_add_percent=-100, bouncy=20},
	sounds = sound,
	on_construct = function(pos)
		minetest.get_node_timer(pos):start(1)
	end,
	on_timer = function(pos, elapsed)
		minetest.set_node(pos, {name="air"})
		generate_web(pos)
	end,
	_mcl_blast_resistance = 1.0,
	_mcl_hardness = 0.5,
})