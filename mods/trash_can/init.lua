--
-- Functions
--

local fdir_to_front = {
	{x=0, z=1},
	{x=1, z=0},
	{x=0, z=-1},
	{x=-1, z=0}
}
local function checkwall(pos)
	local fdir = minetest.get_node(pos).param2
	local second_node_x = pos.x + fdir_to_front[fdir + 1].x
	local second_node_z = pos.z + fdir_to_front[fdir + 1].z
	local second_node_pos = {x=second_node_x, y=pos.y, z=second_node_z}
	local second_node = minetest.get_node(second_node_pos)
	if not second_node or not minetest.registered_nodes[second_node.name]
	  or not minetest.registered_nodes[second_node.name].buildable_to then
		return true
	end

	return false
end

--
-- Nodeboxes
--

local trash_can_nodebox = {
	{-0.375, -0.5, 0.3125, 0.375, 0.5, 0.375},
	{0.3125, -0.5, -0.375, 0.375, 0.5, 0.375},
	{-0.375, -0.5, -0.375, 0.375, 0.5, -0.3125},
	{-0.375, -0.5, -0.375, -0.3125, 0.5, 0.375},
	{-0.3125, -0.5, -0.3125, 0.3125, -0.4375, 0.3125},
}

--
-- Node Registration
--

-- Normal Trash Can
minetest.register_node("trash_can:trash_can_wooden",{
	description = "Wooden Trash Can",
	drawtype="nodebox",
	paramtype = "light",
	tiles = {
		"trash_can_wooden_top.png",
		"trash_can_wooden_top.png",
		"trash_can_wooden.png"
	},
	node_box = {
		type = "fixed",
		fixed = trash_can_nodebox
	},
	groups = {
		snappy=1,
		choppy=2,
		oddly_breakable_by_hand=2,
		flammable=3
	},
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec",
			"size[8,9]" ..
			"button[0,0;2,1;empty;Empty Trash]" ..
			"list[context;trashlist;3,1;2,3;]" ..
			"list[current_player;main;0,5;8,4;]"
		)
		meta:set_string("infotext", "Trash Can")
		local inv = meta:get_inventory()
		inv:set_size("main", 8*4)
		inv:set_size("trashlist", 2*3)
	end,
	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos);
		local inv = meta:get_inventory()
				return inv:is_empty("main")
	end,
	on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		minetest.log("action", player:get_player_name() ..
			" moves stuff in trash can at " .. minetest.pos_to_string(pos))
	end,
	on_metadata_inventory_put = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name() ..
			" moves stuff to trash can at " .. minetest.pos_to_string(pos))
	end,
	on_metadata_inventory_take = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name() ..
			" takes stuff from trash can at " .. minetest.pos_to_string(pos))
	end,
	on_receive_fields = function(pos, formname, fields, sender)
		if fields.empty then
			local meta = minetest.get_meta(pos)
			local inv = meta:get_inventory()
			inv:set_list("trashlist", {})
			minetest.sound_play("trash", {to_player=sender:get_player_name(), gain = 1.0})
			minetest.log("action", sender:get_player_name() ..
				" empties trash can at " .. minetest.pos_to_string(pos))
		end
	end,
})

--
-- Crafting
--

-- Normal Trash Can
minetest.register_craft({
	output = 'trash_can:trash_can_wooden',
	recipe = {
		{'group:wood', '', 'group:wood'},
		{'group:wood', '', 'group:wood'},
		{'group:wood', 'group:wood', 'group:wood'},
	}
})

--
-- Misc
--

-- Remove any items thrown in trash can.
local old_on_step = minetest.registered_entities["__builtin:item"].on_step
minetest.registered_entities["__builtin:item"].on_step = function(self, dtime)
	local item_pos = self.object:getpos()
	-- Round the values.  Not essential, but makes logging look nicer.
	for key, value in pairs(item_pos) do item_pos[key] = math.floor(value + 0.5) end
	if minetest.get_node(item_pos).name == "trash_can:trash_can_wooden" then
		local item_stack = ItemStack(self.itemstring)
		local inv = minetest.get_inventory({type="node", pos=item_pos})
		local leftover = inv:add_item("trashlist", item_stack)
		if leftover:get_count() == 0 then
			self.object:remove()
			minetest.log("action", item_stack:to_string() ..
				" added to trash can at " .. minetest.pos_to_string(item_pos))
		elseif item_stack:get_count() - leftover:get_count() ~= 0 then
			self.set_item(self, leftover:to_string())
			minetest.log("action", item_stack:to_string() ..
				" added to trash can at " .. minetest.pos_to_string(item_pos) ..
				" with " .. leftover:to_string() .. " left over"
			)
		end
		return
	end
	old_on_step(self, dtime)
end
