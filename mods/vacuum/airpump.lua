
local has_pipeworks = minetest.get_modpath("pipeworks")

local tube_entry = ""

if has_pipeworks then
	tube_entry = "^pipeworks_tube_connection_wooden.png"
end

local has_full_air_bottle = function(inv)
	return inv:contains_item("main", {name="vacuum:air_bottle", count=1})
end

local has_empty_air_bottle = function(inv)
	return inv:contains_item("main", {name="vessels:steel_bottle", count=1})
end

local do_empty_bottle = function(inv)
	if not has_full_air_bottle(inv) then
		return false
	end

	local new_stack = ItemStack("vessels:steel_bottle")
	inv:remove_item("main", {name="vacuum:air_bottle", count=1})

	if inv:room_for_item("main", new_stack) then
		inv:add_item("main", new_stack)
		return true
	end

	return false
end

local do_fill_bottle = function(inv)
	if not has_empty_air_bottle(inv) then
		return false
	end

	local new_stack = ItemStack("vacuum:air_bottle")
	inv:remove_item("main", {name="vessels:steel_bottle", count=1})

	if inv:room_for_item("main", new_stack) then
		inv:add_item("main", new_stack)
		return true
	end

	return false
end

-- just enabled
vacuum.airpump_enabled = function(meta)
	return meta:get_int("enabled") == 1
end

-- enabled and actively pumping
vacuum.airpump_active = function(meta)
	local inv = meta:get_inventory()
	return vacuum.airpump_enabled(meta) and has_full_air_bottle(inv)
end


local update_infotext = function(meta)
	local str = "Airpump: "

	if vacuum.airpump_enabled(meta) then
		str = str .. " (Enabled)"
	else
		str = str .. " (Disabled)"
	end

	meta:set_string("infotext", str)
end

-- update airpump formspec
local update_formspec = function(meta)
	local btnName = "State: "

	if meta:get_int("enabled") == 1 then
		btnName = btnName .. "<Enabled>"
	else
		btnName = btnName .. "<Disabled>"
	end

	meta:set_string("formspec", "size[8,7.2;]" ..
		"image[3,0;1,1;" .. vacuum.air_bottle_image .. "]" ..
		"image[4,0;1,1;vessels_steel_bottle.png]" ..
		"button[0,1;8,1;toggle;" .. btnName .. "]" ..
		"list[context;main;0,2;8,1;]" ..
		"list[current_player;main;0,3.2;8,4;]" ..
		"listring[]" ..
		"")

	update_infotext(meta)

end


minetest.register_node("vacuum:airpump", {
	description = "Air pump",--tube_entry
	tiles = { -- top, bottom
		"vacuum_airpump_top.png",
		"vacuum_airpump_side.png" .. tube_entry,
		"vacuum_airpump_side.png" .. tube_entry,
		"vacuum_airpump_side.png" .. tube_entry,
		"vacuum_airpump_side.png" .. tube_entry,
		"vacuum_airpump_front.png"
	},
	paramtype = "light",
	paramtype2 = "facedir",
	legacy_facedir_simple = true,
	groups = {cracky=3, oddly_breakable_by_hand=3, tubedevice=1, tubedevice_receiver=1},
	sounds = default.node_sound_glass_defaults(),

	mesecons = {effector = {
		action_on = function (pos, node)
			local meta = minetest.get_meta(pos)
			meta:set_int("enabled", 1)
			update_infotext(meta)
		end,
		action_off = function (pos, node)
			local meta = minetest.get_meta(pos)
			meta:set_int("enabled", 0)
			update_infotext(meta)
		end
	}},

	after_place_node = function(pos, placer)
		local meta = minetest.get_meta(pos)
		meta:set_string("owner", placer:get_player_name() or "")
	end,

	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_int("enabled", 0)

		local inv = meta:get_inventory()
		inv:set_size("main", 8)

		update_formspec(meta)
	end,

	can_dig = function(pos,player)
		if player and player:is_player() and minetest.is_protected(pos, player:get_player_name()) then
			-- protected
			return false
		end

		local meta = minetest.get_meta(pos);
		local inv = meta:get_inventory()
		return inv:is_empty("main")
	end,

	allow_metadata_inventory_take = function(pos, listname, index, stack, player)
		if player and player:is_player() and minetest.is_protected(pos, player:get_player_name()) then
			-- protected
			return 0
		end

		return stack:get_count()
	end,

	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		if player and player:is_player() and minetest.is_protected(pos, player:get_player_name()) then
			-- protected
			return 0
		end

		return stack:get_count()
	end,

	on_receive_fields = function(pos, formname, fields, sender)
		local meta = minetest.get_meta(pos);

                if minetest.is_protected(pos, sender:get_player_name()) then
                        -- not allowed
                        return
                end

		if fields.toggle then
			if meta:get_int("enabled") == 1 then
				meta:set_int("enabled", 0)
			else
				meta:set_int("enabled", 1)
			end
		end

		update_formspec(meta)
	end,

	tube = {
		insert_object = function(pos, node, stack, direction)
			local meta = minetest.get_meta(pos)
			local inv = meta:get_inventory()
			return inv:add_item("main", stack)
		end,
		can_insert = function(pos, node, stack, direction)
			local meta = minetest.get_meta(pos)
			local inv = meta:get_inventory()
			stack = stack:peek_item(1)
			return inv:room_for_item("main", stack)
		end,
		input_inventory = "main",
		connect_sides = {left = 1, right = 1, back = 1, bottom = 1, top = 1}
	}

})


minetest.register_abm({
        label = "airpump",
	nodenames = {"vacuum:airpump"},
	interval = 5,
	chance = 1,
	action = function(pos)
		local meta = minetest.get_meta(pos)
		if vacuum.airpump_enabled(meta) then

			local used
			if vacuum.is_pos_in_space(pos) then
				used = do_empty_bottle(meta:get_inventory())
			else
				used = do_fill_bottle(meta:get_inventory())
			end

			if used then
				minetest.sound_play("vacuum_hiss", {pos = pos, gain = 0.5})

				minetest.add_particlespawner(
	                                12, --amount
	                                4, --time
	                                {x=pos.x-0.95, y=pos.y-0.95, z=pos.z-0.95},
	                                {x=pos.x+0.95, y=pos.y+0.95, z=pos.z+0.95},
	                                {x=-1.2, y=-1.2, z=-1.2},
	                                {x=1.2, y=1.2, z=1.2},
	                                {x=0,y=0,z=0},
	                                {x=0,y=0,z=0},
	                                0.5,
	                                1,
	                                1,
	                                2,
	                                false,
	                                "bubble.png"
	                        )

			end

			update_infotext(meta)
		end
	end
})



-- initial airpump step
minetest.register_abm({
        label = "airpump seed",
	nodenames = {"vacuum:airpump"},
	neighbors = {"vacuum:vacuum"},
	interval = 1,
	chance = 1,
	action = function(pos)
		local meta = minetest.get_meta(pos)
		if vacuum.airpump_active(meta) then
			-- seed initial air
			local node = minetest.find_node_near(pos, 1, {"vacuum:vacuum"})

			if node ~= nil then
				minetest.set_node(node, {name = "air"})
			end
		end
	end
})

minetest.register_craft({
	output = "vacuum:airpump",
	recipe = {
		{"default:steel_ingot", "default:mese_block", "default:steel_ingot"},
		{"default:diamond", "default:glass", "default:steel_ingot"},
		{"default:steel_ingot", "default:steelblock", "default:steel_ingot"},
	},
})
