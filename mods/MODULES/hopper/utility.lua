-- internationalization boilerplate
local MP = minetest.get_modpath(minetest.get_current_modname())
local S, NS = dofile(MP.."/intllib.lua")

-- Target inventory retrieval

-- looks first for a registration matching the specific node name, then for a registration
-- matching group and value, then for a registration matching a group and *any* value
hopper.get_registered_inventories_for = function(target_node_name)
	local output = hopper.containers[target_node_name]
	if output ~= nil then return output end

	local target_def = minetest.registered_nodes[target_node_name]
	if target_def == nil or target_def.groups == nil then return nil end

	for group, value in pairs(target_def.groups) do
		local registered_group = hopper.groups[group]
		if registered_group ~= nil then
			output = registered_group[value]
			if output ~= nil then return output end
			output = registered_group["all"]
			if output ~= nil then return output end
		end
	end

	return nil
end

hopper.get_eject_button_texts = function(pos, loc_X, loc_Y)
	if not hopper.config.eject_button_enabled then return "" end

	local eject_button_text, eject_button_tooltip
	if minetest.get_meta(pos):get_string("eject") == "true" then
		eject_button_text = S("Don't\nEject")
		eject_button_tooltip = S("This hopper is currently set to eject items from its output\neven if there isn't a compatible block positioned to receive it.\nClick this button to disable this feature.")
	else
		eject_button_text = S("Eject\nItems")
		eject_button_tooltip = S("This hopper is currently set to hold on to item if there\nisn't a compatible block positioned to receive it.\nClick this button to have it eject items instead.")
	end
	return "button_exit["..loc_X..","..loc_Y..";1,1;eject;"..eject_button_text.."]tooltip[eject;"..eject_button_tooltip.."]"
end

hopper.get_string_pos = function(pos)
	return pos.x .. "," .. pos.y .. "," ..pos.z
end

-- Apparently node_sound_metal_defaults is a newer thing, I ran into games using an older version of the default mod without it.
if default.node_sound_metal_defaults ~= nil then
	hopper.metal_sounds = default.node_sound_metal_defaults()
else
	hopper.metal_sounds = default.node_sound_stone_defaults()
end

-------------------------------------------------------------------------------------------
-- Inventory transfer functions

local delay = function(x)
	return (function() return x end)
end

local get_placer = function(player_name)
	if player_name ~= "" then
		return minetest.get_player_by_name(player_name) or {
			is_player = delay(true),
			get_player_name = delay(player_name),
			is_fake_player = ":hopper",
			get_wielded_item = delay(ItemStack(nil))
		}
	end
	return nil
end

-- Used to remove items from the target block and put it into the hopper's inventory
hopper.take_item_from = function(hopper_pos, target_pos, target_node, target_inventory_name)
	if target_inventory_name == nil then
		return
	end
	local target_def = minetest.registered_nodes[target_node.name]
	if not target_def then
		return
	end

	--hopper inventory
	local hopper_meta = minetest.get_meta(hopper_pos);
	local hopper_inv = hopper_meta:get_inventory()
	local placer = get_placer(hopper_meta:get_string("placer"))

	--source inventory
	local target_inv = minetest.get_meta(target_pos):get_inventory()
	local target_inv_size = target_inv:get_size(target_inventory_name)
	if target_inv:is_empty(target_inventory_name) == false then
		for i = 1,target_inv_size do
			local stack = target_inv:get_stack(target_inventory_name, i)
			local item = stack:get_name()
			if item ~= "" then
				if hopper_inv:room_for_item("main", item) then
					local stack_to_take = stack:take_item(1)
					if target_def.allow_metadata_inventory_take == nil
					  or placer == nil -- backwards compatibility, older versions of this mod didn't record who placed the hopper
					  or target_def.allow_metadata_inventory_take(target_pos, target_inventory_name, i, stack_to_take, placer) > 0 then
						target_inv:set_stack(target_inventory_name, i, stack)
						--add to hopper
						hopper_inv:add_item("main", stack_to_take)
						if target_def.on_metadata_inventory_take ~= nil and placer ~= nil then
							target_def.on_metadata_inventory_take(target_pos, target_inventory_name, i, stack_to_take, placer)
						end
						break
					end
				end
			end
		end
	end
end

-- Used to put items from the hopper inventory into the target block
hopper.send_item_to = function(hopper_pos, target_pos, target_node, target_inventory_name, filtered_items)
	local hopper_meta = minetest.get_meta(hopper_pos)
	local target_def = minetest.registered_nodes[target_node.name]
	if not target_def then
		return false
	end

	local eject_item = hopper.config.eject_button_enabled and hopper_meta:get_string("eject") == "true" and target_def.buildable_to

	if not eject_item and not target_inventory_name then
		return false
	end

	--hopper inventory
	local hopper_meta = minetest.get_meta(hopper_pos);
	local hopper_inv = hopper_meta:get_inventory()
	if hopper_inv:is_empty("main") == true then
		return false
	end
	local hopper_inv_size = hopper_inv:get_size("main")
	local placer = get_placer(hopper_meta:get_string("placer"))

	--target inventory
	local target_inv = minetest.get_meta(target_pos):get_inventory()

	for i = 1,hopper_inv_size do
		local stack = hopper_inv:get_stack("main", i)
		local item = stack:get_name()
		if item ~= "" and (filtered_items == nil or filtered_items[item]) then
			if target_inventory_name then
				if target_inv:room_for_item(target_inventory_name, item) then
					local stack_to_put = stack:take_item(1)
					if target_def.allow_metadata_inventory_put == nil
					or placer == nil -- backwards compatibility, older versions of this mod didn't record who placed the hopper
					or target_def.allow_metadata_inventory_put(target_pos, target_inventory_name, i, stack_to_put, placer) > 0 then
						hopper_inv:set_stack("main", i, stack)
						--add to target node
						target_inv:add_item(target_inventory_name, stack_to_put)
						if target_def.on_metadata_inventory_put ~= nil and placer ~= nil then
							target_def.on_metadata_inventory_put(target_pos, target_inventory_name, i, stack_to_put, placer)
						end
						return true
					end
				end
			elseif eject_item then
				local stack_to_put = stack:take_item(1)
				minetest.add_item(target_pos, stack_to_put)
				hopper_inv:set_stack("main", i, stack)
				return true
			end
		end
	end
	return false
end
