--[[
Minetest Mod Storage Drawers - A Mod adding storage drawers

Copyright (C) 2017-2020 Linus Jahn <lnj@kaidan.im>
Copyright (C) 2018 isaiah658

MIT License

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]--

--[[ The gist of how the drawers mod stores data is that there are entities
and the drawer node itself. The entities are needed to allow having multiple
drawers in one node. The entities and node each store metadata about the item
counts and such. It is necessary to change both at once otherwise in some cases
the entity values are used and in other cases the node metadata is used.

The gist of how the controller works is this. The drawer controller scans the
adjacent tiles and puts the item names and other info such as coordinates and
the visualid of the entity in a table. That table is saved in the controllers
metadata. The table is used to help prevent needing to scan all the drawers to
deposit an item in certain situations. The table is only updated on an as needed
basis, not by a specific time/interval. Controllers that have no items will not
continue scanning drawers. ]]--

-- Load support for intllib.
local MP = core.get_modpath(core.get_current_modname())
local S, NS = dofile(MP.."/intllib.lua")

local default_loaded = core.get_modpath("default") and default
local mcl_loaded = core.get_modpath("mcl_core") and mcl_core
local pipeworks_loaded = core.get_modpath("pipeworks") and pipeworks
local digilines_loaded = core.get_modpath("digilines") and digilines

local function controller_formspec(pos)
	local formspec =
		"size[8,8.5]"..
		drawers.gui_bg..
		drawers.gui_bg_img..
		drawers.gui_slots..
		"label[0,0;" .. S("Drawer Controller") .. "]" ..
		"list[current_name;src;3.5,1.75;1,1;]"..
		"list[current_player;main;0,4.25;8,1;]"..
		"list[current_player;main;0,5.5;8,3;8]"..
		"listring[current_player;main]"..
		"listring[current_name;src]"..
		"listring[current_player;main]"

	if digilines_loaded and pipeworks_loaded then
		formspec = formspec .. "field[1,3.5;4,1;digilineChannel;" .. S("Digiline Channel") .. ";${digilineChannel}]"
		formspec = formspec .. "button_exit[5,3.2;2,1;saveChannel;" .. S("Save") .. "]"
	end

	return formspec
end

local function is_valid_drawer_index_slot(net_index, item_name)
	return net_index and
			net_index[item_name] and
			net_index[item_name].drawer_pos and
			net_index[item_name].drawer_pos.x and
			net_index[item_name].drawer_pos.y and
			net_index[item_name].drawer_pos.z and
			net_index[item_name].visualid
end

local function controller_index_slot(pos, visualid)
	return {
		drawer_pos = pos,
		visualid = visualid
	}
end

local function compare_pos(pos1, pos2)
	return pos1.x == pos2.x and pos1.y == pos2.y and pos1.z == pos2.z
end

local function contains_pos(list, p)
	for _,v in ipairs(list) do
		if compare_pos(v, p) then
			return true
		end
	end
	return false
end

-- iterator for iterating from 1 -> to
local function range(to)
	local i = 0
	return function()
		if i == to then
			return nil
		end
		i = i + 1
		return i, i
	end
end

local function pos_in_range(pos1, pos2)
	local diff = {
		pos1.x - pos2.x,
		pos1.y - pos2.y,
		pos1.z - pos2.z
	}
	for _,v in ipairs(diff) do
		if v < 0 then
			v = v * -1
		end
		if v > drawers.CONTROLLER_RANGE then
			return false
		end
	end
	return true
end

local function add_drawer_to_inventory(controllerInventory, pos)
	-- the number of slots is saved as drawer group
	local slots = core.get_item_group(core.get_node(pos).name, "drawer")
	if not slots then
		return
	end

	local meta = core.get_meta(pos)
	if not meta then
		return
	end

	local i = 1
	while i <= slots do
		-- nothing is appended in case the drawer has only one slot
		local slot_id = ""
		if slots ~= 1 then
			slot_id = tostring(i)
		end

		local item_id = meta:get_string("name" .. slot_id)
		local drawer_meta_entity_infotext = meta:get_string("entity_infotext" .. slot_id)

		if item_id == "" and not controllerInventory["empty"] then
			controllerInventory["empty"] = controller_index_slot(pos, slot_id)
		elseif item_id ~= "" then
			-- If we already indexed this item previously, check which drawer
			-- has the most space and have that one be the one indexed
			if controllerInventory[item_id] then
				local content = drawers.drawer_get_content(controllerInventory[item_id].drawer_pos, controllerInventory[item_id].visualid)
				local new_content = drawers.drawer_get_content(pos, slot_id)

				-- If the already indexed drawer has less space, we override the
				-- table index for that item with the new drawer
				if (new_content.maxCount - new_content.count) > (content.maxCount - content.count) then
					controllerInventory[item_id] = controller_index_slot(pos, slot_id)
				end
			else
				controllerInventory[item_id] = controller_index_slot(pos, slot_id)
			end
		end

		i = i + 1
	end
end

local function find_connected_drawers(controller_pos, pos, foundPositions)
	foundPositions = foundPositions or {}
	pos = pos or controller_pos

	local newPositions = core.find_nodes_in_area(
		{x = pos.x - 1, y = pos.y - 1, z = pos.z - 1},
		{x = pos.x + 1, y = pos.y + 1, z = pos.z + 1},
		{"group:drawer", "group:drawer_connector"}
	)

	for _,p in ipairs(newPositions) do
		-- check that this node hasn't been scanned yet
		if not compare_pos(pos, p) and not contains_pos(foundPositions, p)
		   and pos_in_range(controller_pos, pos) then
			-- add new position
			table.insert(foundPositions, p)
			-- search for other drawers from the new pos
			find_connected_drawers(controller_pos, p, foundPositions)
		end
	end

	return foundPositions
end

local function index_drawers(pos)
	--[[
	The pos parameter is the controllers position

	We store the item name as a string key and the value is a table with position x,
	position y, position z, and visualid. Those are all strings as well with the
	values assigned to them that way we don't need to worry about the ordering of
	the table. The count and max count are not stored as those values have a high
	potential of being outdated quickly. It's better to grab the values from the
	drawer when needed so you know you are working with accurate numbers.
	]]

	local controllerInventory = {}
	for _,drawerPos in ipairs(find_connected_drawers(pos)) do
		add_drawer_to_inventory(controllerInventory, drawerPos)
	end

	return controllerInventory
end

--[[
	Returns a table of all stored itemstrings in the drawer network with their
	drawer position and visualid.

	It uses the cached data, if possible, but if the itemstring is not contained
	the network is reindexed.
]]
local function controller_get_drawer_index(pos, itemstring)
	local meta = core.get_meta(pos)

	-- If the index has not been created, the item isn't in the index, the
	-- item in the drawer is no longer the same item in the index, or the item
	-- is in the index but it's full, run the index_drawers function.
	local drawer_net_index = core.deserialize(meta:get_string("drawers_table_index"))

	-- If the index has not been created
	-- If the item isn't in the index (or the index is corrupted)
	if not is_valid_drawer_index_slot(drawer_net_index, itemstring) then
		drawer_net_index = index_drawers(pos)
		meta:set_string("drawers_table_index", core.serialize(drawer_net_index))

	-- There is a valid entry in the index: check that the entry is still up-to-date
	else
		local content = drawers.drawer_get_content(
			drawer_net_index[itemstring].drawer_pos,
			drawer_net_index[itemstring].visualid)

		if content.name ~= itemstring or content.count >= content.maxCount then
			drawer_net_index = index_drawers(pos)
			meta:set_string("drawers_table_index", core.serialize(drawer_net_index))
		end
	end

	return drawer_net_index
end

local function controller_insert_to_drawers(pos, stack)
	-- Inizialize metadata
	local meta = core.get_meta(pos)
	local inv = meta:get_inventory()

	local drawer_net_index = controller_get_drawer_index(pos, stack:get_name())

	-- We check if there is a drawer with the item and it isn't full. We will
	-- put the items we can into it.
	if drawer_net_index[stack:get_name()] then
		local drawer_pos = drawer_net_index[stack:get_name()]["drawer_pos"]
		local visualid = drawer_net_index[stack:get_name()]["visualid"]
		local content = drawers.drawer_get_content(drawer_pos, visualid)

		-- If the the item in the drawer is the same as the one we are trying to
		-- store, the drawer is not full, and the drawer entity is loaded, we
		-- will put the items in the drawer
		if content.name == stack:get_name() and
				content.count < content.maxCount and
				drawers.drawer_visuals[core.hash_node_position(drawer_pos)] then
			return drawers.drawer_insert_object(drawer_pos, stack, visualid)
		end
	elseif drawer_net_index["empty"] then
		local drawer_pos = drawer_net_index["empty"]["drawer_pos"]
		local visualid = drawer_net_index["empty"]["visualid"]
		local content = drawers.drawer_get_content(drawer_pos, visualid)

		-- If the drawer is still empty and the drawer entity is loaded, we will
		-- put the items in the drawer
		if content.name == "" and drawers.drawer_visuals[core.hash_node_position(drawer_pos)] then
			local leftover = drawers.drawer_insert_object(drawer_pos, stack, visualid)

			-- Add the item to the drawers table index and set the empty one to nil
			drawer_net_index["empty"] = nil
			drawer_net_index[stack:get_name()] = controller_index_slot(drawer_pos, visualid)

			-- Set the controller metadata
			meta:set_string("drawers_table_index", core.serialize(drawer_net_index))

			return leftover
		end
	end

	return stack
end

local function controller_can_dig(pos, player)
	local meta = core.get_meta(pos);
	local inv = meta:get_inventory()
	return inv:is_empty("src")
end

local function controller_on_construct(pos)
	local meta = core.get_meta(pos)
	meta:set_string("drawers_table_index", "")
	meta:set_string("formspec", controller_formspec(pos))

	meta:get_inventory():set_size("src", 1)
end

local function controller_on_blast(pos)
	local drops = {}
	default.get_inventory_drops(pos, "src", drops)
	drops[#drops+1] = "drawers:controller"
	core.remove_node(pos)
	return drops
end

local function controller_allow_metadata_inventory_put(pos, listname, index, stack, player)
	if (player and core.is_protected(pos, player:get_player_name())) or listname ~= "src" then
		return 0
	end

	local drawer_net_index = controller_get_drawer_index(pos, stack:get_name())

	if drawer_net_index[stack:get_name()] then
		local drawer = drawer_net_index[stack:get_name()]

		if drawers.drawer_get_content(drawer.drawer_pos, drawer.visualid).name == stack:get_name() then
			return drawers.drawer_can_insert_stack(drawer.drawer_pos, stack, drawer["visualid"])
		end
	end

	if drawer_net_index["empty"] then
		local drawer = drawer_net_index["empty"]

		if drawers.drawer_get_content(drawer.drawer_pos, drawer.visualid).name == "" then
			return drawers.drawer_can_insert_stack(drawer.drawer_pos, stack, drawer.visualid)
		end
	end

	return 0
end

local function controller_allow_metadata_inventory_move(pos, from_list, from_index, to_list, to_index, count, player)
	local meta = core.get_meta(pos)
	local inv = meta:get_inventory()
	local stack = inv:get_stack(from_list, from_index)
	return controller_allow_metadata_inventory_put(pos, to_list, to_index, stack, player)
end

local function controller_allow_metadata_inventory_take(pos, listname, index, stack, player)
	if core.is_protected(pos, player:get_player_name()) then
		return 0
	end
	return stack:get_count()
end

local function controller_on_metadata_inventory_put(pos, listname, index, stack, player)
	if listname ~= "src" then
		return
	end

	local inv = core.get_meta(pos):get_inventory()

	local complete_stack = inv:get_stack("src", 1)
	local leftover = controller_insert_to_drawers(pos, complete_stack)
	inv:set_stack("src", 1, leftover)
end

local function controller_on_digiline_receive(pos, _, channel, msg)
	local meta = core.get_meta(pos)

	if channel ~= meta:get_string("digilineChannel") then
		return
	end

	local item = ItemStack(msg)
	local drawers_index = controller_get_drawer_index(pos, item:get_name())

	if not drawers_index[item:get_name()] then
		-- we can't do anything: the requested item doesn't exist
		return
	end

	local taken_stack = drawers.drawer_take_item(
		drawers_index[item:get_name()]["drawer_pos"], item)
	local dir = core.facedir_to_dir(core.get_node(pos).param2)

	-- prevent crash if taken_stack ended up with a nil value
	if taken_stack then
		pipeworks.tube_inject_item(pos, pos, dir, taken_stack:to_string())
	end
end

local function controller_on_receive_fields(pos, formname, fields, sender)
	if core.is_protected(pos, sender:get_player_name()) then
		return
	end
	local meta = core.get_meta(pos)
	if fields.saveChannel then
		meta:set_string("digilineChannel", fields.digilineChannel)
	end
end

-- Registers the drawer controller
local function register_controller()
	-- Set the controller definition using a table to allow for pipeworks and
	-- potentially other mod support
	local def = {}

	def.description = S("Drawer Controller")
	def.drawtype = "nodebox"
	def.node_box = { type = "fixed", fixed = drawers.node_box_simple }
	def.collision_box = { type = "regular" }
	def.selection_box = { type = "regular" }
	def.paramtype = "light"
	def.paramtype2 = "facedir"
	def.legacy_facedir_simple = true

	-- add pipe connectors, if pipeworks is enabled
	if pipeworks_loaded then
		def.tiles = {
			"drawers_controller_top.png^pipeworks_tube_connection_metallic.png",
			"drawers_controller_top.png^pipeworks_tube_connection_metallic.png",
			"drawers_controller_side.png^pipeworks_tube_connection_metallic.png",
			"drawers_controller_side.png^pipeworks_tube_connection_metallic.png",
			"drawers_controller_top.png^pipeworks_tube_connection_metallic.png",
			"drawers_controller_front.png"
		}
	else
		def.tiles = {
			"drawers_controller_top.png",
			"drawers_controller_top.png",
			"drawers_controller_side.png",
			"drawers_controller_side.png",
			"drawers_controller_top.png",
			"drawers_controller_front.png"
		}
	end

	-- MCL2 requires a few different groups and parameters that MTG does not
	if mcl_loaded then
		def.groups = {
			pickaxey = 1, stone = 1, building_block = 1, material_stone = 1
		}
		def._mcl_blast_resistance = 30
		def._mcl_hardness = 1.5
	else
		def.groups = {
			cracky = 3, level = 2
		}
	end

	def.can_dig = controller_can_dig
	def.on_construct = controller_on_construct
	def.on_blast = controller_on_blast
	def.on_receive_fields = controller_on_receive_fields
	def.on_metadata_inventory_put = controller_on_metadata_inventory_put

	def.allow_metadata_inventory_put = controller_allow_metadata_inventory_put
	def.allow_metadata_inventory_move = controller_allow_metadata_inventory_move
	def.allow_metadata_inventory_take = controller_allow_metadata_inventory_take

	if pipeworks_loaded then
		def.groups.tubedevice = 1
		def.groups.tubedevice_receiver = 1

		def.tube = {}
		def.tube.insert_object = function(pos, node, stack, tubedir)
			return controller_insert_to_drawers(pos, stack)
		end

		def.tube.can_insert = function(pos, node, stack, tubedir)
			return controller_allow_metadata_inventory_put(pos, "src", nil, stack, nil) > 0
		end

		def.tube.connect_sides = {
			left = 1, right = 1, back = 1, top = 1, bottom = 1
		}

		def.after_place_node = pipeworks.after_place
		def.after_dig_node = pipeworks.after_dig
	end

	if digilines_loaded and pipeworks_loaded then
		def.digiline = {
			receptor = {},
			effector = {
				action = controller_on_digiline_receive
			},
		}
	end

	core.register_node("drawers:controller", def)
end

-- register drawer controller
register_controller()

if default_loaded then
	core.register_craft({
		output = 'drawers:controller',
		recipe = {
			{'default:steel_ingot', 'default:diamond', 'default:steel_ingot'},
			{'default:tin_ingot',    'group:drawer',   'default:copper_ingot'},
			{'default:steel_ingot', 'default:diamond', 'default:steel_ingot'},
		}
	})
elseif mcl_loaded then
	core.register_craft({
		output = 'drawers:controller',
		recipe = {
			{'mcl_core:iron_ingot', 'mcl_core:diamond', 'mcl_core:iron_ingot'},
			{'mcl_core:gold_ingot',   'group:drawer',   'mcl_core:gold_ingot'},
			{'mcl_core:iron_ingot', 'mcl_core:diamond', 'mcl_core:iron_ingot'},
		}
	})
else
	-- Because the rest of the drawers mod doesn't have a hard depend on
	-- default, I changed the recipe to have an alternative
	core.register_craft({
		output = 'drawers:controller',
		recipe = {
			{'group:stone', 'group:stone',  'group:stone'},
			{'group:stone', 'group:drawer', 'group:stone'},
			{'group:stone', 'group:stone',  'group:stone'},
		}
	})
end

