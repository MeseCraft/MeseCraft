viaduct = {}

function viaduct.register_wood_bridge(name, def)
	local node_def = minetest.registered_nodes[name]
	if not node_def then
		if minetest.get_current_modname() ~= "viaduct" then minetest.log("warning", "["..minetest.get_current_modname().."] node "..name.." not found in function viaduct.register_wood_bridge") end
		return
	end

	local item = name:split(':')[2]

	if not def.description then
		def.description = node_def.description.." Bridge"
	end

	if not def.tiles then
		def.tiles = node_def.tiles
	end

	local group
	if not def.groups then
		group = table.copy(node_def.groups)
		group.wood = 0
		group.planks = 0
	else
		group = def.groups
	end
	group.bridge = 1

	if not def.sounds then
		def.sounds = node_def.sounds
	end

	local nocgroup = table.copy(group)
	nocgroup.not_in_creative_inventory = 1

	local stick
	if not def.stick then
		stick = "group:stick"
	else
		stick = def.stick
	end

	local update = function(pos)
		local north = minetest.get_node({x = pos.x, y = pos.y, z = pos.z + 1})
		local east = minetest.get_node({x = pos.x + 1, y = pos.y, z = pos.z})
		local south = minetest.get_node({x = pos.x, y = pos.y, z = pos.z - 1})
		local west = minetest.get_node({x = pos.x - 1, y = pos.y, z = pos.z})
		local northup = minetest.get_node({x = pos.x, y = pos.y + 1, z = pos.z + 1})
		local eastup = minetest.get_node({x = pos.x + 1, y = pos.y + 1, z = pos.z})
		local southup = minetest.get_node({x = pos.x, y = pos.y + 1, z = pos.z - 1})
		local westup = minetest.get_node({x = pos.x - 1, y = pos.y + 1, z = pos.z})
		local above = minetest.get_node({x = pos.x, y = pos.y + 1, z = pos.z})
		local northdown = minetest.get_node({x = pos.x, y = pos.y - 1, z = pos.z + 1})
		local eastdown = minetest.get_node({x = pos.x + 1, y = pos.y - 1, z = pos.z})
		local southdown = minetest.get_node({x = pos.x, y = pos.y - 1, z = pos.z - 1})
		local westdown = minetest.get_node({x = pos.x - 1, y = pos.y - 1, z = pos.z})
		local bridgeus
		if northdown.name:split('_bridge_')[2] == "us" then bridgeus = true else bridgeus = false end
		local bridgeuw
		if eastdown.name:split('_bridge_')[2] == "uw" then bridgeuw = true else bridgeuw = false end
		local bridgeun
		if southdown.name:split('_bridge_')[2] == "un" then bridgeun = true else bridgeun = false end
		local bridgeue
		if westdown.name:split('_bridge_')[2] == "ue" then bridgeue = true else bridgeue = false end
		local n
		if minetest.get_item_group(north.name, "bridge") == 1 or bridgeus then n = true else n = false end
		local e
		if minetest.get_item_group(east.name, "bridge") == 1 or bridgeuw then e = true else e = false end
		local s
		if minetest.get_item_group(south.name, "bridge") == 1 or bridgeun then s = true else s = false end
		local w
		if minetest.get_item_group(west.name, "bridge") == 1 or bridgeue then w = true else w = false end
		local nu
		if minetest.get_item_group(northup.name, "bridge") == 1 and above.name == "air" then nu = true else nu = false end
		local eu
		if minetest.get_item_group(eastup.name, "bridge") == 1 and above.name == "air" then eu = true else eu = false end
		local su
		if minetest.get_item_group(southup.name, "bridge") == 1 and above.name == "air" then su = true else su = false end
		local wu
		if minetest.get_item_group(westup.name, "bridge") == 1 and above.name == "air" then wu = true else wu = false end
		local nd
		if northdown.name == "air" then nd = true else nd = false end
		local ed
		if eastdown.name == "air" then ed = true else ed = false end
		local sd
		if southdown.name == "air" then sd = true else sd = false end
		local wd
		if westdown.name == "air" then wd = true else wd = false end
		if n and e and s and w then
			minetest.swap_node(pos, {name = "viaduct:"..item.."_bridge_nesw"})
		elseif n and e and s and not w then
			minetest.swap_node(pos, {name = "viaduct:"..item.."_bridge_nes"})
		elseif n and e and not s and w then
			minetest.swap_node(pos, {name = "viaduct:"..item.."_bridge_new"})
		elseif n and e and not s and not w then
			minetest.swap_node(pos, {name = "viaduct:"..item.."_bridge_ne"})
		elseif n and not e and s and w then
			minetest.swap_node(pos, {name = "viaduct:"..item.."_bridge_nsw"})
		elseif n and not e and s and not w then
			minetest.swap_node(pos, {name = "viaduct:"..item.."_bridge_ns"})
		elseif n and not e and not s and w then
			minetest.swap_node(pos, {name = "viaduct:"..item.."_bridge_nw"})
		elseif n and not e and not s and not w then
			if su then
				minetest.swap_node(pos, {name = "viaduct:"..item.."_bridge_us"})
			elseif sd then
				minetest.swap_node(pos, {name = "viaduct:"..item.."_bridge_n"})
			else
				minetest.swap_node(pos, {name = "viaduct:"..item.."_bridge_ns"})
			end
		elseif not n and e and s and w then
			minetest.swap_node(pos, {name = "viaduct:"..item.."_bridge_esw"})
		elseif not n and e and s and not w then
			minetest.swap_node(pos, {name = "viaduct:"..item.."_bridge_es"})
		elseif not n and e and not s and w then
			minetest.swap_node(pos, {name = "viaduct:"..item.."_bridge_ew"})
		elseif not n and e and not s and not w then
			if wu then
				minetest.swap_node(pos, {name = "viaduct:"..item.."_bridge_uw"})
			elseif wd then
				minetest.swap_node(pos, {name = "viaduct:"..item.."_bridge_e"})
			else
				minetest.swap_node(pos, {name = "viaduct:"..item.."_bridge_ew"})
			end
		elseif not n and not e and s and w then
			minetest.swap_node(pos, {name = "viaduct:"..item.."_bridge_sw"})
		elseif not n and not e and s and not w then
			if nu then
				minetest.swap_node(pos, {name = "viaduct:"..item.."_bridge_un"})
			elseif nd then
				minetest.swap_node(pos, {name = "viaduct:"..item.."_bridge_s"})
			else
				minetest.swap_node(pos, {name = "viaduct:"..item.."_bridge_ns"})
			end
		elseif not n and not e and not s and w then
			if eu then
				minetest.swap_node(pos, {name = "viaduct:"..item.."_bridge_ue"})
			elseif ed then
				minetest.swap_node(pos, {name = "viaduct:"..item.."_bridge_w"})
			else
				minetest.swap_node(pos, {name = "viaduct:"..item.."_bridge_ew"})
			end
		else
			if nu then
				minetest.swap_node(pos, {name = "viaduct:"..item.."_bridge_un"})
			elseif eu then
				minetest.swap_node(pos, {name = "viaduct:"..item.."_bridge_ue"})
			elseif su then
				minetest.swap_node(pos, {name = "viaduct:"..item.."_bridge_us"})
			elseif wu then
				minetest.swap_node(pos, {name = "viaduct:"..item.."_bridge_uw"})
			else
				minetest.swap_node(pos, {name = "viaduct:"..item.."_bridge"})
			end
		end
	end

	minetest.register_node(":viaduct:"..item.."_bridge", {
		description = def.description,
		tiles = def.tiles,
		paramtype = "light",
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, -0.4375, 0.5},
				{-0.5, -0.4375, 0.375, -0.375, 0.5, 0.5},
				{0.375, -0.4375, 0.375, 0.5, 0.5, 0.5},
				{-0.5, -0.4375, -0.5, -0.375, 0.5, -0.375},
				{0.375, -0.4375, -0.5, 0.5, 0.5, -0.375},
				{-0.375, 0.3125, 0.375, 0.375, 0.4375, 0.4375},
				{-0.375, -0.1875, 0.375, 0.375, -0.0625, 0.4375},
				{0.375, 0.3125, -0.375, 0.4375, 0.4375, 0.375},
				{0.375, -0.1875, -0.375, 0.4375, -0.0625, 0.375},
				{-0.375, 0.3125, -0.4375, 0.375, 0.4375, -0.375},
				{-0.375, -0.1875, -0.4375, 0.375, -0.0625, -0.375},
				{-0.4375, 0.3125, -0.375, -0.375, 0.4375, 0.375},
				{-0.4375, -0.1875, -0.375, -0.375, -0.0625, 0.375},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
		},
		drop = "viaduct:"..item.."_bridge",
		sounds = def.sounds,
		groups = group,
		after_place_node = function(pos, placer, itemstack, pointed_thing)
			local node = minetest.get_node(pos)
			local node_def = minetest.registered_nodes[node.name]
			node_def.update_bridge(pos)
			local nodes = minetest.find_nodes_in_area({x = pos.x - 1, y = pos.y - 1, z = pos.z - 1}, {x = pos.x + 1, y = pos.y + 1, z = pos.z + 1}, {"group:bridge"})
			for i,v in ipairs(nodes) do
				local node = minetest.get_node(v)
				local node_def = minetest.registered_nodes[node.name]
				node_def.update_bridge(v)
			end
		end,
		after_dig_node = function(pos, oldnode, oldmetadata, digger)
			local nodes = minetest.find_nodes_in_area({x = pos.x - 1, y = pos.y - 1, z = pos.z - 1}, {x = pos.x + 1, y = pos.y + 1, z = pos.z + 1}, {"group:bridge"})
			for i,v in ipairs(nodes) do
				local node = minetest.get_node(v)
				local node_def = minetest.registered_nodes[node.name]
				node_def.update_bridge(v)
			end
		end,
		update_bridge = function(pos)
			update(pos)
		end,
	})

	minetest.register_node(":viaduct:"..item.."_bridge_w", {
		description = def.description,
		tiles = def.tiles,
		paramtype = "light",
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, -0.4375, 0.5},
				{-0.5, -0.4375, 0.375, -0.375, 0.5, 0.5},
				{0.375, -0.4375, 0.375, 0.5, 0.5, 0.5},
				{-0.5, -0.4375, -0.5, -0.375, 0.5, -0.375},
				{0.375, -0.4375, -0.5, 0.5, 0.5, -0.375},
				{-0.375, 0.3125, 0.375, 0.375, 0.4375, 0.4375},
				{-0.375, -0.1875, 0.375, 0.375, -0.0625, 0.4375},
				{0.375, 0.3125, -0.375, 0.4375, 0.4375, 0.375},
				{0.375, -0.1875, -0.375, 0.4375, -0.0625, 0.375},
				{-0.375, 0.3125, -0.4375, 0.375, 0.4375, -0.375},
				{-0.375, -0.1875, -0.4375, 0.375, -0.0625, -0.375},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
		},
		drop = "viaduct:"..item.."_bridge",
		sounds = def.sounds,
		groups = nocgroup,
		after_dig_node = function(pos, oldnode, oldmetadata, digger)
			local nodes = minetest.find_nodes_in_area({x = pos.x - 1, y = pos.y - 1, z = pos.z - 1}, {x = pos.x + 1, y = pos.y + 1, z = pos.z + 1}, {"group:bridge"})
			for i,v in ipairs(nodes) do
				local node = minetest.get_node(v)
				local node_def = minetest.registered_nodes[node.name]
				node_def.update_bridge(v)
			end
		end,
		update_bridge = function(pos)
			update(pos)
		end,
	})

	minetest.register_node(":viaduct:"..item.."_bridge_s", {
		description = def.description,
		tiles = def.tiles,
		paramtype = "light",
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, -0.4375, 0.5},
				{-0.5, -0.4375, 0.375, -0.375, 0.5, 0.5},
				{0.375, -0.4375, 0.375, 0.5, 0.5, 0.5},
				{-0.5, -0.4375, -0.5, -0.375, 0.5, -0.375},
				{0.375, -0.4375, -0.5, 0.5, 0.5, -0.375},
				{-0.375, 0.3125, 0.375, 0.375, 0.4375, 0.4375},
				{-0.375, -0.1875, 0.375, 0.375, -0.0625, 0.4375},
				{0.375, 0.3125, -0.375, 0.4375, 0.4375, 0.375},
				{0.375, -0.1875, -0.375, 0.4375, -0.0625, 0.375},
				{-0.4375, 0.3125, -0.375, -0.375, 0.4375, 0.375},
				{-0.4375, -0.1875, -0.375, -0.375, -0.0625, 0.375},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
		},
		drop = "viaduct:"..item.."_bridge",
		sounds = def.sounds,
		groups = nocgroup,
		after_dig_node = function(pos, oldnode, oldmetadata, digger)
			local nodes = minetest.find_nodes_in_area({x = pos.x - 1, y = pos.y - 1, z = pos.z - 1}, {x = pos.x + 1, y = pos.y + 1, z = pos.z + 1}, {"group:bridge"})
			for i,v in ipairs(nodes) do
				local node = minetest.get_node(v)
				local node_def = minetest.registered_nodes[node.name]
				node_def.update_bridge(v)
			end
		end,
		update_bridge = function(pos)
			update(pos)
		end,
	})

	minetest.register_node(":viaduct:"..item.."_bridge_sw", {
		description = def.description,
		tiles = def.tiles,
		paramtype = "light",
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, -0.4375, 0.5},
				{-0.5, -0.4375, 0.375, -0.375, 0.5, 0.5},
				{0.375, -0.4375, 0.375, 0.5, 0.5, 0.5},
				{-0.5, -0.4375, -0.5, -0.375, 0.5, -0.375},
				{0.375, -0.4375, -0.5, 0.5, 0.5, -0.375},
				{-0.375, 0.3125, 0.375, 0.375, 0.4375, 0.4375},
				{-0.375, -0.1875, 0.375, 0.375, -0.0625, 0.4375},
				{0.375, 0.3125, -0.375, 0.4375, 0.4375, 0.375},
				{0.375, -0.1875, -0.375, 0.4375, -0.0625, 0.375},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
		},
		drop = "viaduct:"..item.."_bridge",
		sounds = def.sounds,
		groups = nocgroup,
		after_dig_node = function(pos, oldnode, oldmetadata, digger)
			local nodes = minetest.find_nodes_in_area({x = pos.x - 1, y = pos.y - 1, z = pos.z - 1}, {x = pos.x + 1, y = pos.y + 1, z = pos.z + 1}, {"group:bridge"})
			for i,v in ipairs(nodes) do
				local node = minetest.get_node(v)
				local node_def = minetest.registered_nodes[node.name]
				node_def.update_bridge(v)
			end
		end,
		update_bridge = function(pos)
			update(pos)
		end,
	})

	minetest.register_node(":viaduct:"..item.."_bridge_e", {
		description = def.description,
		tiles = def.tiles,
		paramtype = "light",
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, -0.4375, 0.5},
				{-0.5, -0.4375, 0.375, -0.375, 0.5, 0.5},
				{0.375, -0.4375, 0.375, 0.5, 0.5, 0.5},
				{-0.5, -0.4375, -0.5, -0.375, 0.5, -0.375},
				{0.375, -0.4375, -0.5, 0.5, 0.5, -0.375},
				{-0.375, 0.3125, 0.375, 0.375, 0.4375, 0.4375},
				{-0.375, -0.1875, 0.375, 0.375, -0.0625, 0.4375},
				{-0.375, 0.3125, -0.4375, 0.375, 0.4375, -0.375},
				{-0.375, -0.1875, -0.4375, 0.375, -0.0625, -0.375},
				{-0.4375, 0.3125, -0.375, -0.375, 0.4375, 0.375},
				{-0.4375, -0.1875, -0.375, -0.375, -0.0625, 0.375},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
		},
		drop = "viaduct:"..item.."_bridge",
		sounds = def.sounds,
		groups = nocgroup,
		after_dig_node = function(pos, oldnode, oldmetadata, digger)
			local nodes = minetest.find_nodes_in_area({x = pos.x - 1, y = pos.y - 1, z = pos.z - 1}, {x = pos.x + 1, y = pos.y + 1, z = pos.z + 1}, {"group:bridge"})
			for i,v in ipairs(nodes) do
				local node = minetest.get_node(v)
				local node_def = minetest.registered_nodes[node.name]
				node_def.update_bridge(v)
			end
		end,
		update_bridge = function(pos)
			update(pos)
		end,
	})

	minetest.register_node(":viaduct:"..item.."_bridge_ew", {
		description = def.description,
		tiles = def.tiles,
		paramtype = "light",
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, -0.4375, 0.5},
				{-0.5, -0.4375, 0.375, -0.375, 0.5, 0.5},
				{0.375, -0.4375, 0.375, 0.5, 0.5, 0.5},
				{-0.5, -0.4375, -0.5, -0.375, 0.5, -0.375},
				{0.375, -0.4375, -0.5, 0.5, 0.5, -0.375},
				{-0.375, 0.3125, 0.375, 0.375, 0.4375, 0.4375},
				{-0.375, -0.1875, 0.375, 0.375, -0.0625, 0.4375},
				{-0.375, 0.3125, -0.4375, 0.375, 0.4375, -0.375},
				{-0.375, -0.1875, -0.4375, 0.375, -0.0625, -0.375},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
		},
		drop = "viaduct:"..item.."_bridge",
		sounds = def.sounds,
		groups = nocgroup,
		after_dig_node = function(pos, oldnode, oldmetadata, digger)
			local nodes = minetest.find_nodes_in_area({x = pos.x - 1, y = pos.y - 1, z = pos.z - 1}, {x = pos.x + 1, y = pos.y + 1, z = pos.z + 1}, {"group:bridge"})
			for i,v in ipairs(nodes) do
				local node = minetest.get_node(v)
				local node_def = minetest.registered_nodes[node.name]
				node_def.update_bridge(v)
			end
		end,
		update_bridge = function(pos)
			update(pos)
		end,
	})

	minetest.register_node(":viaduct:"..item.."_bridge_es", {
		description = def.description,
		tiles = def.tiles,
		paramtype = "light",
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, -0.4375, 0.5},
				{-0.5, -0.4375, 0.375, -0.375, 0.5, 0.5},
				{0.375, -0.4375, 0.375, 0.5, 0.5, 0.5},
				{-0.5, -0.4375, -0.5, -0.375, 0.5, -0.375},
				{0.375, -0.4375, -0.5, 0.5, 0.5, -0.375},
				{-0.375, 0.3125, 0.375, 0.375, 0.4375, 0.4375},
				{-0.375, -0.1875, 0.375, 0.375, -0.0625, 0.4375},
				{-0.4375, 0.3125, -0.375, -0.375, 0.4375, 0.375},
				{-0.4375, -0.1875, -0.375, -0.375, -0.0625, 0.375},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
		},
		drop = "viaduct:"..item.."_bridge",
		sounds = def.sounds,
		groups = nocgroup,
		after_dig_node = function(pos, oldnode, oldmetadata, digger)
			local nodes = minetest.find_nodes_in_area({x = pos.x - 1, y = pos.y - 1, z = pos.z - 1}, {x = pos.x + 1, y = pos.y + 1, z = pos.z + 1}, {"group:bridge"})
			for i,v in ipairs(nodes) do
				local node = minetest.get_node(v)
				local node_def = minetest.registered_nodes[node.name]
				node_def.update_bridge(v)
			end
		end,
		update_bridge = function(pos)
			update(pos)
		end,
	})

	minetest.register_node(":viaduct:"..item.."_bridge_esw", {
		description = def.description,
		tiles = def.tiles,
		paramtype = "light",
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, -0.4375, 0.5},
				{-0.5, -0.4375, 0.375, -0.375, 0.5, 0.5},
				{0.375, -0.4375, 0.375, 0.5, 0.5, 0.5},
				{-0.5, -0.4375, -0.5, -0.375, 0.5, -0.375},
				{0.375, -0.4375, -0.5, 0.5, 0.5, -0.375},
				{-0.375, 0.3125, 0.375, 0.375, 0.4375, 0.4375},
				{-0.375, -0.1875, 0.375, 0.375, -0.0625, 0.4375},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
		},
		drop = "viaduct:"..item.."_bridge",
		sounds = def.sounds,
		groups = nocgroup,
		after_dig_node = function(pos, oldnode, oldmetadata, digger)
			local nodes = minetest.find_nodes_in_area({x = pos.x - 1, y = pos.y - 1, z = pos.z - 1}, {x = pos.x + 1, y = pos.y + 1, z = pos.z + 1}, {"group:bridge"})
			for i,v in ipairs(nodes) do
				local node = minetest.get_node(v)
				local node_def = minetest.registered_nodes[node.name]
				node_def.update_bridge(v)
			end
		end,
		update_bridge = function(pos)
			update(pos)
		end,
	})

	minetest.register_node(":viaduct:"..item.."_bridge_n", {
		description = def.description,
		tiles = def.tiles,
		paramtype = "light",
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, -0.4375, 0.5},
				{-0.5, -0.4375, 0.375, -0.375, 0.5, 0.5},
				{0.375, -0.4375, 0.375, 0.5, 0.5, 0.5},
				{-0.5, -0.4375, -0.5, -0.375, 0.5, -0.375},
				{0.375, -0.4375, -0.5, 0.5, 0.5, -0.375},
				{0.375, 0.3125, -0.375, 0.4375, 0.4375, 0.375},
				{0.375, -0.1875, -0.375, 0.4375, -0.0625, 0.375},
				{-0.375, 0.3125, -0.4375, 0.375, 0.4375, -0.375},
				{-0.375, -0.1875, -0.4375, 0.375, -0.0625, -0.375},
				{-0.4375, 0.3125, -0.375, -0.375, 0.4375, 0.375},
				{-0.4375, -0.1875, -0.375, -0.375, -0.0625, 0.375},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
		},
		drop = "viaduct:"..item.."_bridge",
		sounds = def.sounds,
		groups = nocgroup,
		after_dig_node = function(pos, oldnode, oldmetadata, digger)
			local nodes = minetest.find_nodes_in_area({x = pos.x - 1, y = pos.y - 1, z = pos.z - 1}, {x = pos.x + 1, y = pos.y + 1, z = pos.z + 1}, {"group:bridge"})
			for i,v in ipairs(nodes) do
				local node = minetest.get_node(v)
				local node_def = minetest.registered_nodes[node.name]
				node_def.update_bridge(v)
			end
		end,
		update_bridge = function(pos)
			update(pos)
		end,
	})

	minetest.register_node(":viaduct:"..item.."_bridge_nw", {
		description = def.description,
		tiles = def.tiles,
		paramtype = "light",
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, -0.4375, 0.5},
				{-0.5, -0.4375, 0.375, -0.375, 0.5, 0.5},
				{0.375, -0.4375, 0.375, 0.5, 0.5, 0.5},
				{-0.5, -0.4375, -0.5, -0.375, 0.5, -0.375},
				{0.375, -0.4375, -0.5, 0.5, 0.5, -0.375},
				{0.375, 0.3125, -0.375, 0.4375, 0.4375, 0.375},
				{0.375, -0.1875, -0.375, 0.4375, -0.0625, 0.375},
				{-0.375, 0.3125, -0.4375, 0.375, 0.4375, -0.375},
				{-0.375, -0.1875, -0.4375, 0.375, -0.0625, -0.375},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
		},
		drop = "viaduct:"..item.."_bridge",
		sounds = def.sounds,
		groups = nocgroup,
		after_dig_node = function(pos, oldnode, oldmetadata, digger)
			local nodes = minetest.find_nodes_in_area({x = pos.x - 1, y = pos.y - 1, z = pos.z - 1}, {x = pos.x + 1, y = pos.y + 1, z = pos.z + 1}, {"group:bridge"})
			for i,v in ipairs(nodes) do
				local node = minetest.get_node(v)
				local node_def = minetest.registered_nodes[node.name]
				node_def.update_bridge(v)
			end
		end,
		update_bridge = function(pos)
			update(pos)
		end,
	})

	minetest.register_node(":viaduct:"..item.."_bridge_ns", {
		description = def.description,
		tiles = def.tiles,
		paramtype = "light",
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, -0.4375, 0.5},
				{-0.5, -0.4375, 0.375, -0.375, 0.5, 0.5},
				{0.375, -0.4375, 0.375, 0.5, 0.5, 0.5},
				{-0.5, -0.4375, -0.5, -0.375, 0.5, -0.375},
				{0.375, -0.4375, -0.5, 0.5, 0.5, -0.375},
				{0.375, 0.3125, -0.375, 0.4375, 0.4375, 0.375},
				{0.375, -0.1875, -0.375, 0.4375, -0.0625, 0.375},
				{-0.4375, 0.3125, -0.375, -0.375, 0.4375, 0.375},
				{-0.4375, -0.1875, -0.375, -0.375, -0.0625, 0.375},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
		},
		drop = "viaduct:"..item.."_bridge",
		sounds = def.sounds,
		groups = nocgroup,
		after_dig_node = function(pos, oldnode, oldmetadata, digger)
			local nodes = minetest.find_nodes_in_area({x = pos.x - 1, y = pos.y - 1, z = pos.z - 1}, {x = pos.x + 1, y = pos.y + 1, z = pos.z + 1}, {"group:bridge"})
			for i,v in ipairs(nodes) do
				local node = minetest.get_node(v)
				local node_def = minetest.registered_nodes[node.name]
				node_def.update_bridge(v)
			end
		end,
		update_bridge = function(pos)
			update(pos)
		end,
	})

	minetest.register_node(":viaduct:"..item.."_bridge_nsw", {
		description = def.description,
		tiles = def.tiles,
		paramtype = "light",
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, -0.4375, 0.5},
				{-0.5, -0.4375, 0.375, -0.375, 0.5, 0.5},
				{0.375, -0.4375, 0.375, 0.5, 0.5, 0.5},
				{-0.5, -0.4375, -0.5, -0.375, 0.5, -0.375},
				{0.375, -0.4375, -0.5, 0.5, 0.5, -0.375},
				{0.375, 0.3125, -0.375, 0.4375, 0.4375, 0.375},
				{0.375, -0.1875, -0.375, 0.4375, -0.0625, 0.375},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
		},
		drop = "viaduct:"..item.."_bridge",
		sounds = def.sounds,
		groups = nocgroup,
		after_dig_node = function(pos, oldnode, oldmetadata, digger)
			local nodes = minetest.find_nodes_in_area({x = pos.x - 1, y = pos.y - 1, z = pos.z - 1}, {x = pos.x + 1, y = pos.y + 1, z = pos.z + 1}, {"group:bridge"})
			for i,v in ipairs(nodes) do
				local node = minetest.get_node(v)
				local node_def = minetest.registered_nodes[node.name]
				node_def.update_bridge(v)
			end
		end,
		update_bridge = function(pos)
			update(pos)
		end,
	})

	minetest.register_node(":viaduct:"..item.."_bridge_ne", {
		description = def.description,
		tiles = def.tiles,
		paramtype = "light",
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, -0.4375, 0.5},
				{-0.5, -0.4375, 0.375, -0.375, 0.5, 0.5},
				{0.375, -0.4375, 0.375, 0.5, 0.5, 0.5},
				{-0.5, -0.4375, -0.5, -0.375, 0.5, -0.375},
				{0.375, -0.4375, -0.5, 0.5, 0.5, -0.375},
				{-0.375, 0.3125, -0.4375, 0.375, 0.4375, -0.375},
				{-0.375, -0.1875, -0.4375, 0.375, -0.0625, -0.375},
				{-0.4375, 0.3125, -0.375, -0.375, 0.4375, 0.375},
				{-0.4375, -0.1875, -0.375, -0.375, -0.0625, 0.375},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
		},
		drop = "viaduct:"..item.."_bridge",
		sounds = def.sounds,
		groups = nocgroup,
		after_dig_node = function(pos, oldnode, oldmetadata, digger)
			local nodes = minetest.find_nodes_in_area({x = pos.x - 1, y = pos.y - 1, z = pos.z - 1}, {x = pos.x + 1, y = pos.y + 1, z = pos.z + 1}, {"group:bridge"})
			for i,v in ipairs(nodes) do
				local node = minetest.get_node(v)
				local node_def = minetest.registered_nodes[node.name]
				node_def.update_bridge(v)
			end
		end,
		update_bridge = function(pos)
			update(pos)
		end,
	})

	minetest.register_node(":viaduct:"..item.."_bridge_new", {
		description = def.description,
		tiles = def.tiles,
		paramtype = "light",
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, -0.4375, 0.5},
				{-0.5, -0.4375, 0.375, -0.375, 0.5, 0.5},
				{0.375, -0.4375, 0.375, 0.5, 0.5, 0.5},
				{-0.5, -0.4375, -0.5, -0.375, 0.5, -0.375},
				{0.375, -0.4375, -0.5, 0.5, 0.5, -0.375},
				{-0.375, 0.3125, -0.4375, 0.375, 0.4375, -0.375},
				{-0.375, -0.1875, -0.4375, 0.375, -0.0625, -0.375},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
		},
		drop = "viaduct:"..item.."_bridge",
		sounds = def.sounds,
		groups = nocgroup,
		after_dig_node = function(pos, oldnode, oldmetadata, digger)
			local nodes = minetest.find_nodes_in_area({x = pos.x - 1, y = pos.y - 1, z = pos.z - 1}, {x = pos.x + 1, y = pos.y + 1, z = pos.z + 1}, {"group:bridge"})
			for i,v in ipairs(nodes) do
				local node = minetest.get_node(v)
				local node_def = minetest.registered_nodes[node.name]
				node_def.update_bridge(v)
			end
		end,
		update_bridge = function(pos)
			update(pos)
		end,
	})

	minetest.register_node(":viaduct:"..item.."_bridge_nes", {
		description = def.description,
		tiles = def.tiles,
		paramtype = "light",
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, -0.4375, 0.5},
				{-0.5, -0.4375, 0.375, -0.375, 0.5, 0.5},
				{0.375, -0.4375, 0.375, 0.5, 0.5, 0.5},
				{-0.5, -0.4375, -0.5, -0.375, 0.5, -0.375},
				{0.375, -0.4375, -0.5, 0.5, 0.5, -0.375},
				{-0.4375, 0.3125, -0.375, -0.375, 0.4375, 0.375},
				{-0.4375, -0.1875, -0.375, -0.375, -0.0625, 0.375},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
		},
		drop = "viaduct:"..item.."_bridge",
		sounds = def.sounds,
		groups = nocgroup,
		after_dig_node = function(pos, oldnode, oldmetadata, digger)
			local nodes = minetest.find_nodes_in_area({x = pos.x - 1, y = pos.y - 1, z = pos.z - 1}, {x = pos.x + 1, y = pos.y + 1, z = pos.z + 1}, {"group:bridge"})
			for i,v in ipairs(nodes) do
				local node = minetest.get_node(v)
				local node_def = minetest.registered_nodes[node.name]
				node_def.update_bridge(v)
			end
		end,
		update_bridge = function(pos)
			update(pos)
		end,
	})

	minetest.register_node(":viaduct:"..item.."_bridge_nesw", {
		description = def.description,
		tiles = def.tiles,
		paramtype = "light",
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, -0.4375, 0.5},
				{-0.5, -0.4375, 0.375, -0.375, 0.5, 0.5},
				{0.375, -0.4375, 0.375, 0.5, 0.5, 0.5},
				{-0.5, -0.4375, -0.5, -0.375, 0.5, -0.375},
				{0.375, -0.4375, -0.5, 0.5, 0.5, -0.375},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
		},
		drop = "viaduct:"..item.."_bridge",
		sounds = def.sounds,
		groups = nocgroup,
		after_dig_node = function(pos, oldnode, oldmetadata, digger)
			local nodes = minetest.find_nodes_in_area({x = pos.x - 1, y = pos.y - 1, z = pos.z - 1}, {x = pos.x + 1, y = pos.y + 1, z = pos.z + 1}, {"group:bridge"})
			for i,v in ipairs(nodes) do
				local node = minetest.get_node(v)
				local node_def = minetest.registered_nodes[node.name]
				node_def.update_bridge(v)
			end
		end,
		update_bridge = function(pos)
			update(pos)
		end,
	})

	minetest.register_node(":viaduct:"..item.."_bridge_un", {
		description = def.description,
		tiles = def.tiles,
		paramtype = "light",
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, -0.4375, 0},
				{-0.5, 0, 0, 0.5, 0.0625, 0.5},
				{-0.5, 0.0625, 0.375, -0.375, 1, 0.5},
				{0.375, 0.0625, 0.375, 0.5, 1, 0.5},
				{-0.5, 0.0625, 0, -0.375, 1, 0.125},
				{0.375, 0.0625, 0, 0.5, 1, 0.125},
				{-0.5, -0.4375, -0.125, -0.375, 0.5, 0},
				{0.375, -0.4375, -0.125, 0.5, 0.5, 0},
				{-0.5, -0.4375, -0.5, -0.375, 0.5, -0.375},
				{0.375, -0.4375, -0.5, 0.5, 0.5, -0.375},
				{-0.4375, 0.8125, 0.125, -0.375, 0.9375, 0.375},
				{-0.4375, 0.3125, 0.125, -0.375, 0.4375, 0.375},
				{0.375, 0.8125, 0.125, 0.4375, 0.9375, 0.375},
				{0.375, 0.3125, 0.125, 0.4375, 0.4375, 0.375},
				{-0.4375, 0.3125, -0.375, -0.375, 0.4375, -0.125},
				{-0.4375, -0.1875, -0.375, -0.375, -0.0625, -0.125},
				{0.375, 0.3125, -0.375, 0.4375, 0.4375, -0.125},
				{0.375, -0.1875, -0.375, 0.4375, -0.0625, -0.125},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
		},
		drop = "viaduct:"..item.."_bridge",
		sounds = def.sounds,
		groups = nocgroup,
		after_dig_node = function(pos, oldnode, oldmetadata, digger)
			local nodes = minetest.find_nodes_in_area({x = pos.x - 1, y = pos.y - 1, z = pos.z - 1}, {x = pos.x + 1, y = pos.y + 1, z = pos.z + 1}, {"group:bridge"})
			for i,v in ipairs(nodes) do
				local node = minetest.get_node(v)
				local node_def = minetest.registered_nodes[node.name]
				node_def.update_bridge(v)
			end
		end,
		update_bridge = function(pos)
			update(pos)
		end,
	})

	minetest.register_node(":viaduct:"..item.."_bridge_ue", {
		description = def.description,
		tiles = def.tiles,
		paramtype = "light",
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0, -0.4375, 0.5},
				{0, 0, -0.5, 0.5, 0.0625, 0.5},
				{-0.5, -0.4375, 0.375, -0.375, 0.5, 0.5},
				{-0.125, -0.4375, 0.375, 0, 0.5, 0.5},
				{-0.5, -0.4375, -0.5, -0.375, 0.5, -0.375},
				{-0.125, -0.4375, -0.5, 0, 0.5, -0.375},
				{0, 0.0625, 0.375, 0.125, 1, 0.5},
				{0.375, 0.0625, 0.375, 0.5, 1, 0.5},
				{0, 0.0625, -0.5, 0.125, 1, -0.375},
				{0.375, 0.0625, -0.5, 0.5, 1, -0.375},
				{-0.375, 0.3125, 0.375, -0.125, 0.4375, 0.4375},
				{-0.375, -0.1875, 0.375, -0.125, -0.0625, 0.4375},
				{-0.375, 0.3125, -0.4375, -0.125, 0.4375, -0.375},
				{-0.375, -0.1875, -0.4375, -0.125, -0.0625, -0.375},
				{0.125, 0.8125, 0.375, 0.375, 0.9375, 0.4375},
				{0.125, 0.3125, 0.375, 0.375, 0.4375, 0.4375},
				{0.125, 0.8125, -0.4375, 0.375, 0.9375, -0.375},
				{0.125, 0.3125, -0.4375, 0.375, 0.4375, -0.375},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
		},
		drop = "viaduct:"..item.."_bridge",
		sounds = def.sounds,
		groups = nocgroup,
		after_dig_node = function(pos, oldnode, oldmetadata, digger)
			local nodes = minetest.find_nodes_in_area({x = pos.x - 1, y = pos.y - 1, z = pos.z - 1}, {x = pos.x + 1, y = pos.y + 1, z = pos.z + 1}, {"group:bridge"})
			for i,v in ipairs(nodes) do
				local node = minetest.get_node(v)
				local node_def = minetest.registered_nodes[node.name]
				node_def.update_bridge(v)
			end
		end,
		update_bridge = function(pos)
			update(pos)
		end,
	})

	minetest.register_node(":viaduct:"..item.."_bridge_us", {
		description = def.description,
		tiles = def.tiles,
		paramtype = "light",
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, 0, -0.5, 0.5, 0.0625, 0},
				{-0.5, -0.5, 0, 0.5, -0.4375, 0.5},
				{-0.5, -0.4375, 0.375, -0.375, 0.5, 0.5},
				{0.375, -0.4375, 0.375, 0.5, 0.5, 0.5},
				{-0.5, -0.4375, 0, -0.375, 0.5, 0.125},
				{0.375, -0.4375, 0, 0.5, 0.5, 0.125},
				{-0.5, 0.0625, -0.125, -0.375, 1, 0},
				{0.375, 0.0625, -0.125, 0.5, 1, 0},
				{-0.5, 0.0625, -0.5, -0.375, 1, -0.375},
				{0.375, 0.0625, -0.5, 0.5, 1, -0.375},
				{-0.4375, 0.3125, 0.125, -0.375, 0.4375, 0.375},
				{-0.4375, -0.1875, 0.125, -0.375, -0.0625, 0.375},
				{0.375, 0.3125, 0.125, 0.4375, 0.4375, 0.375},
				{0.375, -0.1875, 0.125, 0.4375, -0.0625, 0.375},
				{-0.4375, 0.8125, -0.375, -0.375, 0.9375, -0.125},
				{-0.4375, 0.3125, -0.375, -0.375, 0.4375, -0.125},
				{0.375, 0.8125, -0.375, 0.4375, 0.9375, -0.125},
				{0.375, 0.3125, -0.375, 0.4375, 0.4375, -0.125},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
		},
		drop = "viaduct:"..item.."_bridge",
		sounds = def.sounds,
		groups = nocgroup,
		after_dig_node = function(pos, oldnode, oldmetadata, digger)
			local nodes = minetest.find_nodes_in_area({x = pos.x - 1, y = pos.y - 1, z = pos.z - 1}, {x = pos.x + 1, y = pos.y + 1, z = pos.z + 1}, {"group:bridge"})
			for i,v in ipairs(nodes) do
				local node = minetest.get_node(v)
				local node_def = minetest.registered_nodes[node.name]
				node_def.update_bridge(v)
			end
		end,
		update_bridge = function(pos)
			update(pos)
		end,
	})

	minetest.register_node(":viaduct:"..item.."_bridge_uw", {
		description = def.description,
		tiles = def.tiles,
		paramtype = "light",
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, 0, -0.5, 0, 0.0625, 0.5},
				{0, -0.5, -0.5, 0.5, -0.4375, 0.5},
				{-0.5, 0.0625, 0.375, -0.375, 1, 0.5},
				{-0.125, 0.0625, 0.375, 0, 1, 0.5},
				{-0.5, 0.0625, -0.5, -0.375, 1, -0.375},
				{-0.125, 0.0625, -0.5, 0, 1, -0.375},
				{0, -0.4375, 0.375, 0.125, 0.5, 0.5},
				{0.375, -0.4375, 0.375, 0.5, 0.5, 0.5},
				{0, -0.4375, -0.5, 0.125, 0.5, -0.375},
				{0.375, -0.4375, -0.5, 0.5, 0.5, -0.375},
				{-0.375, 0.8125, 0.375, -0.125, 0.9375, 0.4375},
				{-0.375, 0.3125, 0.375, -0.125, 0.4375, 0.4375},
				{-0.375, 0.8125, -0.4375, -0.125, 0.9375, -0.375},
				{-0.375, 0.3125, -0.4375, -0.125, 0.4375, -0.375},
				{0.125, 0.3125, 0.375, 0.375, 0.4375, 0.4375},
				{0.125, -0.1875, 0.375, 0.375, -0.0625, 0.4375},
				{0.125, 0.3125, -0.4375, 0.375, 0.4375, -0.375},
				{0.125, -0.1875, -0.4375, 0.375, -0.0625, -0.375},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
		},
		drop = "viaduct:"..item.."_bridge",
		sounds = def.sounds,
		groups = nocgroup,
		after_dig_node = function(pos, oldnode, oldmetadata, digger)
			local nodes = minetest.find_nodes_in_area({x = pos.x - 1, y = pos.y - 1, z = pos.z - 1}, {x = pos.x + 1, y = pos.y + 1, z = pos.z + 1}, {"group:bridge"})
			for i,v in ipairs(nodes) do
				local node = minetest.get_node(v)
				local node_def = minetest.registered_nodes[node.name]
				node_def.update_bridge(v)
			end
		end,
		update_bridge = function(pos)
			update(pos)
		end,
	})

	minetest.register_craft({
		output = "viaduct:"..item.."_bridge 3",
		recipe = {
			{stick, "", stick},
			{stick, "", stick},
			{name, name, name},
		}
	})
end

function viaduct.register_rope_bridge(name, def)
	local node_def = minetest.registered_nodes[name]
	if not node_def then
		if minetest.get_current_modname() ~= "viaduct" then minetest.log("warning", "["..minetest.get_current_modname().."] node "..name.." not found in function viaduct.register_rope_bridge") end
		return
	end

	local item = name:split(':')[2]

	if not def.description then
		def.description = node_def.description.." Bridge"
	end

	if not def.tiles then
		def.tiles = node_def.tiles
	end

	local group
	if not def.groups then
		group = table.copy(node_def.groups)
	else
		group = def.groups
	end
	group.bridge = 1

	if not def.sounds then
		def.sounds = node_def.sounds
	end

	minetest.register_node(":viaduct:"..item.."_bridge_rope", {
		description = def.description,
		tiles = def.tiles,
		paramtype = "light",
		paramtype2 = "facedir",
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, 0.375, -0.5, -0.375, 0.5, 0.5},
				{0.375, 0.375, -0.5, 0.5, 0.5, 0.5},
				{-0.5, -0.5, -0.5, -0.375, -0.375, 0.5},
				{0.375, -0.5, -0.5, 0.5, -0.375, 0.5},
				{-0.5, -0.375, -0.0625, -0.375, 0.375, 0.0625},
				{0.375, -0.375, -0.0625, 0.5, 0.375, 0.0625},
				{-0.1875, -0.5, -0.5, -0.0625, -0.375, 0.5},
				{0.0625, -0.5, -0.5, 0.1875, -0.375, 0.5},
				{-0.375, -0.5, 0.25, 0.375, -0.375, 0.375},
				{-0.375, -0.5, -0.0625, 0.375, -0.375, 0.0625},
				{-0.375, -0.5, -0.375, 0.375, -0.375, -0.25},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
		},
		drop = "viaduct:"..item.."_bridge_rope",
		sounds = def.sounds,
		groups = group,
		after_place_node = function(pos, placer, itemstack, pointed_thing)
			local node = minetest.get_node(pos)
			local node_def = minetest.registered_nodes[node.name]
			node_def.update_bridge(pos)
			local nodes = minetest.find_nodes_in_area({x = pos.x - 1, y = pos.y - 1, z = pos.z - 1}, {x = pos.x + 1, y = pos.y + 1, z = pos.z + 1}, {"group:bridge"})
			for i,v in ipairs(nodes) do
				local node = minetest.get_node(v)
				local node_def = minetest.registered_nodes[node.name]
				node_def.update_bridge(v)
			end
		end,
		after_dig_node = function(pos, oldnode, oldmetadata, digger)
			local nodes = minetest.find_nodes_in_area({x = pos.x - 1, y = pos.y - 1, z = pos.z - 1}, {x = pos.x + 1, y = pos.y + 1, z = pos.z + 1}, {"group:bridge"})
			for i,v in ipairs(nodes) do
				local node = minetest.get_node(v)
				local node_def = minetest.registered_nodes[node.name]
				node_def.update_bridge(v)
			end
		end,
		update_bridge = function(pos)
			local north = minetest.get_node({x = pos.x, y = pos.y, z = pos.z + 1})
			local south = minetest.get_node({x = pos.x, y = pos.y, z = pos.z - 1})
			if minetest.get_item_group(north.name, "bridge") == 1 or minetest.get_item_group(south.name, "bridge") == 1 then
				minetest.swap_node(pos, {name = "viaduct:"..item.."_bridge_rope", param2 = 0})
			else
				minetest.swap_node(pos, {name = "viaduct:"..item.."_bridge_rope", param2 = 1})
			end
		end,
	})

	minetest.register_alias("viaduct:"..item.."_bridge_rope_r", "viaduct:"..item.."_bridge_rope")

	minetest.register_craft({
		output = "viaduct:"..item.."_bridge_rope",
		recipe = {
			{name, "", name},
			{"", "", ""},
			{name, name, name},
		}
	})

	minetest.register_craft({
		type = "shapeless",
		output = name.." 5",
		recipe = {"viaduct:"..item.."_bridge_rope"},
	})
end

function viaduct.register_wood_bridge_alias(old, new)
	minetest.register_alias("viaduct:"..old.."_bridge", "viaduct:"..new.."_bridge")
	minetest.register_alias("viaduct:"..old.."_bridge_w", "viaduct:"..new.."_bridge_w")
	minetest.register_alias("viaduct:"..old.."_bridge_s", "viaduct:"..new.."_bridge_s")
	minetest.register_alias("viaduct:"..old.."_bridge_sw", "viaduct:"..new.."_bridge_sw")
	minetest.register_alias("viaduct:"..old.."_bridge_e", "viaduct:"..new.."_bridge_e")
	minetest.register_alias("viaduct:"..old.."_bridge_ew", "viaduct:"..new.."_bridge_ew")
	minetest.register_alias("viaduct:"..old.."_bridge_es", "viaduct:"..new.."_bridge_es")
	minetest.register_alias("viaduct:"..old.."_bridge_esw", "viaduct:"..new.."_bridge_esw")
	minetest.register_alias("viaduct:"..old.."_bridge_n", "viaduct:"..new.."_bridge_n")
	minetest.register_alias("viaduct:"..old.."_bridge_nw", "viaduct:"..new.."_bridge_nw")
	minetest.register_alias("viaduct:"..old.."_bridge_ns", "viaduct:"..new.."_bridge_ns")
	minetest.register_alias("viaduct:"..old.."_bridge_nsw", "viaduct:"..new.."_bridge_nsw")
	minetest.register_alias("viaduct:"..old.."_bridge_ne", "viaduct:"..new.."_bridge_ne")
	minetest.register_alias("viaduct:"..old.."_bridge_new", "viaduct:"..new.."_bridge_new")
	minetest.register_alias("viaduct:"..old.."_bridge_nes", "viaduct:"..new.."_bridge_nes")
	minetest.register_alias("viaduct:"..old.."_bridge_nesw", "viaduct:"..new.."_bridge_nesw")
	minetest.register_alias("viaduct:"..old.."_bridge_un", "viaduct:"..new.."_bridge_un")
	minetest.register_alias("viaduct:"..old.."_bridge_ue", "viaduct:"..new.."_bridge_ue")
	minetest.register_alias("viaduct:"..old.."_bridge_us", "viaduct:"..new.."_bridge_us")
	minetest.register_alias("viaduct:"..old.."_bridge_uw", "viaduct:"..new.."_bridge_uw")
end

viaduct.register_wood_bridge("default:wood", {description="Wooden Bridge"})
viaduct.register_wood_bridge("default:junglewood", {description="Junglewood Bridge"})
viaduct.register_wood_bridge("default:pine_wood", {description="Pine Wood Bridge"})
viaduct.register_wood_bridge("default:acacia_wood", {description="Acacia Wood Bridge"})
viaduct.register_wood_bridge("default:aspen_wood", {description="Aspen Wood Bridge"})
viaduct.register_wood_bridge("default:birch_wood", {})
viaduct.register_wood_bridge("default:maple_wood", {})
viaduct.register_wood_bridge("default:cherry_wood", {})
viaduct.register_wood_bridge("default:papyrus_block", {stick="default:papyrus"})
viaduct.register_wood_bridge("default:planks", {})
viaduct.register_wood_bridge("default:planks_oak", {})
viaduct.register_wood_bridge("default:planks_birch", {})
viaduct.register_rope_bridge("default:vine", {tiles={"viaduct_vine.png"}})
viaduct.register_rope_bridge("default:rope", {})

-- Add Ethereal support to Viaduct
if minetest.get_modpath("ethereal") then
	viaduct.register_wood_bridge("ethereal:banana_wood", {description="Banana Wood Bridge"})
	viaduct.register_wood_bridge("ethereal:birch_wood", {description="Birch Wood Bridge"})
	viaduct.register_wood_bridge("ethereal:frost_wood", {description="Frost Wood Bridge"})
	viaduct.register_wood_bridge("ethereal:mushroom_trunk", {description="Mushroom Trunk Bridge"})
	viaduct.register_wood_bridge("ethereal:palm_wood", {description="Palm Wood Bridge"})
	viaduct.register_wood_bridge("ethereal:redwood_wood", {description="Redwood Bridge"})
	viaduct.register_wood_bridge("ethereal:sakura_wood", {description="Sakura Wood Bridge"})
	viaduct.register_wood_bridge("ethereal:scorched_tree", {description="Scorched Bridge"})
	viaduct.register_wood_bridge("ethereal:willow_wood", {description="Willow Wood Bridge"})
	viaduct.register_wood_bridge("ethereal:yellow_wood", {description="Yellow Wood Bridge"})
end

-- Add df_caverns support to viaduct.
if minetest.get_modpath("df_trees") then
	viaduct.register_wood_bridge("df_trees:black_cap_wood", {description="Black Cap Bridge"})
	viaduct.register_wood_bridge("df_trees:blood_thorn_wood", {description="Blood Thorn Bridge"})
	viaduct.register_wood_bridge("df_trees:fungiwood_wood", {description="Fungiwood Bridge"})
	viaduct.register_wood_bridge("df_trees:goblin_cap_stem_wood", {description="Goblin Cap Stem Bridge"})
	viaduct.register_wood_bridge("df_trees:goblin_cap_wood", {description="Goblin Cap Bridge"})
	viaduct.register_wood_bridge("df_trees:nether_cap_wood", {description="Nether Cap Bridge"})
	viaduct.register_wood_bridge("df_trees:tower_cap_wood", {description="Tower Cap Bridge"})
	viaduct.register_wood_bridge("df_trees:spore_tree_wood", {description="Spore Tree Bridge"})
	viaduct.register_wood_bridge("df_trees:tunnel_tube_wood", {description="Tunnel Tube Bridge"})
end

if(minetest.get_modpath("deco")) then
	viaduct.register_wood_bridge("deco:oak_plank", {stick="tools:stick"})
	viaduct.register_wood_bridge("deco:birch_plank", {stick="tools:stick"})
	viaduct.register_wood_bridge("deco:cherry_plank", {stick="tools:stick"})
	viaduct.register_wood_bridge("deco:evergreen_plank", {stick="tools:stick"})
end

if(minetest.get_modpath("hemp")) then
	viaduct.register_rope_bridge("hemp:hemp_rope", {})
end

if(minetest.get_modpath("lottblocks")) then
	viaduct.register_rope_bridge("lottblocks:elven_rope", {tiles={"viaduct_elven_rope.png"}})
end

if(minetest.get_modpath("lottplants")) then
	viaduct.register_wood_bridge("lottplants:pinewood", {})
	viaduct.register_wood_bridge("lottplants:birchwood", {})
	viaduct.register_wood_bridge("lottplants:alderwood", {})
	viaduct.register_wood_bridge("lottplants:lebethronwood", {})
	viaduct.register_wood_bridge("lottplants:mallornwood", {})
end

if(minetest.get_modpath("moreblocks")) then
	viaduct.register_rope_bridge("moreblocks:rope", {tiles={"viaduct_vine.png"}})
end
