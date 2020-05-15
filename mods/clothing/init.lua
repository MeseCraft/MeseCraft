local modpath = minetest.get_modpath(minetest.get_current_modname())

dofile(modpath.."/api.lua")
dofile(modpath.."/clothing.lua")

-- Inventory mod support

if minetest.get_modpath("inventory_plus") then
	clothing.inv_mod = "inventory_plus"
	clothing.formspec = clothing.formspec..
		"button[6,0;2,0.5;main;Back]"
elseif minetest.get_modpath("unified_inventory") and
		not unified_inventory.sfinv_compat_layer then
	clothing.inv_mod = "unified_inventory"
	unified_inventory.register_button("clothing", {
		type = "image",
		image = "inventory_plus_clothing.png",
	})
	unified_inventory.register_page("clothing", {
		get_formspec = function(player, perplayer_formspec)
			local fy = perplayer_formspec.formspec_y
			local name = player:get_player_name()
			local formspec = "background[0.06,"..fy..
				";7.92,7.52;clothing_ui_form.png]"..
				"label[0,0;Clothing]"..
				"list[detached:"..name.."_clothing;clothing;0,"..fy..";2,3;]"..
				"listring[current_player;main]"..
				"listring[detached:"..name.."_clothing;clothing]"
			return {formspec=formspec}
		end,
	})
elseif minetest.get_modpath("sfinv") then
	clothing.inv_mod = "sfinv"
	sfinv.register_page("clothing:clothing", {
		title = "Clothing",
		get = function(self, player, context)
			local name = player:get_player_name()
			local formspec = clothing.formspec..
				"list[detached:"..name.."_clothing;clothing;0,0.5;2,3;]"..
				"listring[current_player;main]"..
				"listring[detached:"..name.."_clothing;clothing]"
			return sfinv.make_formspec(player, context,
				formspec, false)
		end
	})
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
	local name = player:get_player_name()
	if clothing.inv_mod == "inventory_plus" and fields.clothing then
		inventory_plus.set_inventory_formspec(player, clothing.formspec..
			"list[detached:"..name.."_clothing;clothing;0,0.5;2,3;]"..
			"listring[current_player;main]"..
			"listring[detached:"..name.."_clothing;clothing]")
	end
end)

local function is_clothing(item)
	return minetest.get_item_group(item, "clothing") > 0 or
		minetest.get_item_group(item, "cape") > 0
end

local function save_clothing_metadata(player, clothing_inv)
	local player_inv = player:get_inventory()
	local is_empty = true
	local clothes = {}
	for i = 1, 6 do
		local stack = clothing_inv:get_stack("clothing", i)
		-- Move all non-clothes back to the player inventory
		if not stack:is_empty() and not is_clothing(stack:get_name()) then
			player_inv:add_item("main",
				clothing_inv:remove_item("clothing", stack))
			stack:clear()
		end
		if not stack:is_empty() then
			clothes[i] = stack:to_string()
			is_empty = false
		end
	end
	if is_empty then
		player:set_attribute("clothing:inventory", nil)
	else
		player:set_attribute("clothing:inventory",
			minetest.serialize(clothes))
	end
end

local function load_clothing_metadata(player, clothing_inv)
	local player_inv = player:get_inventory()
	local clothing_meta = player:get_attribute("clothing:inventory")
	local clothes = clothing_meta and minetest.deserialize(clothing_meta) or {}
	local dirty_meta = false
	if not clothing_meta then
		-- Backwards compatiblity
		for i = 1, 6 do
			local stack = player_inv:get_stack("clothing", i)
			if not stack:is_empty() then
				clothes[i] = stack:to_string()
				dirty_meta = true
			end
		end
	end
	-- Fill detached slots
	clothing_inv:set_size("clothing", 6)
	for i = 1, 6 do
		clothing_inv:set_stack("clothing", i, clothes[i] or "")
	end

	if dirty_meta then
		-- Requires detached inventory to be set up
		save_clothing_metadata(player, clothing_inv)
	end

	-- Clean up deprecated garbage after saving
	player_inv:set_size("clothing", 0)
end

minetest.register_on_joinplayer(function(player)
	local name = player:get_player_name()
	local player_inv = player:get_inventory()
	local clothing_inv = minetest.create_detached_inventory(name.."_clothing",{
		on_put = function(inv, listname, index, stack, player)
			save_clothing_metadata(player, inv)
			clothing:run_callbacks("on_equip", player, index, stack)
			clothing:set_player_clothing(player)
		end,
		on_take = function(inv, listname, index, stack, player)
			save_clothing_metadata(player, inv)
			clothing:run_callbacks("on_unequip", player, index, stack)
			clothing:set_player_clothing(player)
		end,
		on_move = function(inv, from_list, from_index, to_list, to_index, count, player)
			save_clothing_metadata(player, inv)
			clothing:set_player_clothing(player)
		end,
		allow_put = function(inv, listname, index, stack, player)
			local item = stack:get_name()
			if is_clothing(item) then
				return 1
			end
			return 0
		end,
		allow_take = function(inv, listname, index, stack, player)
			return stack:get_count()
		end,
		allow_move = function(inv, from_list, from_index, to_list, to_index, count, player)
			return count
		end,
	}, name)
	if clothing.inv_mod == "inventory_plus" then
		inventory_plus.register_button(player,"clothing", "Clothing")
	end

	load_clothing_metadata(player, clothing_inv)
	minetest.after(1, function(name)
		-- Ensure the ObjectRef is valid after 1s
		clothing:set_player_clothing(minetest.get_player_by_name(name))
	end, name)
end)
