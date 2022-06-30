local has_technic = minetest.get_modpath("technic")

minetest.register_node("jumpdrive:engine", {
	description = "Jumpdrive",

	tiles = {"jumpdrive.png"},

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
		connect_sides = {bottom = 1}
	},

	connects_to = {"group:technic_hv_cable"},
	connect_sides = {"bottom", "top", "left", "right", "front", "back"},

	light_source = 13,
	groups = {
		cracky = 3,
		oddly_breakable_by_hand = 3,
		tubedevice = 1,
		tubedevice_receiver = 1,
		technic_machine = 1,
		technic_hv = 1
	},

	sounds = default.node_sound_glass_defaults(),

	digiline = {
		receptor = {action = function() end},
		effector = {
			action = jumpdrive.digiline_effector
		},
	},

	after_place_node = function(pos, placer)
		local meta = minetest.get_meta(pos)
		meta:set_string("owner", placer:get_player_name() or "")
		-- default digiline channel
		meta:set_string("channel", "jumpdrive")
	end,

	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_int("x", pos.x)
		meta:set_int("y", pos.y)
		meta:set_int("z", pos.z)
		meta:set_int("radius", 5)
		meta:set_int("powerstorage", 0)
		jumpdrive.migrate_engine_meta(pos, meta)

		meta:set_int("HV_EU_input", 0)
		meta:set_int("HV_EU_demand", 0)

		jumpdrive.update_formspec(meta, pos)
	end,

	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos);
		local inv = meta:get_inventory()
		local name = player:get_player_name()

		return inv:is_empty("main") and
			inv:is_empty("upgrade") and
			not minetest.is_protected(pos, name)
	end,

	on_timer = function(pos, elapsed)
		local meta = minetest.get_meta(pos)

		local store = meta:get_int("powerstorage")
		local max_store = meta:get_int("max_powerstorage")

		if store >= max_store then
			-- internal store is full
			return true
		end

		local inv = meta:get_inventory()
		for i=1, inv:get_size("main") do
			local stack = inv:get_stack("main", i)
			if not stack:is_empty() then
				local burn_value = jumpdrive.fuel.get_value(stack:get_name())
				if burn_value > 0 then
					local store_space = max_store - store
					local fuel_value = burn_value * stack:get_count()
					if fuel_value > store_space then
						stack:set_count(stack:get_count() - math.ceil(store_space / burn_value))
						store = max_store
					else
						stack:clear()
						store = store + fuel_value
					end
					inv:set_stack("main", i, stack)
				end
			end
		end
		meta:set_int("powerstorage", store)

		if not has_technic then
			jumpdrive.update_infotext(meta, pos)
		end

		-- restart timer
		return true
	end,

	technic_run = jumpdrive.technic_run,

	on_receive_fields = function(pos, formname, fields, sender)

		local meta = minetest.get_meta(pos);
		jumpdrive.migrate_engine_meta(pos, meta)

		if not sender then
			return
		end

		if minetest.is_protected(pos, sender:get_player_name()) then
			-- not allowed
			return
		end

		if fields.read_book then
			jumpdrive.read_from_book(pos)
			jumpdrive.update_formspec(meta, pos)
			return
		end

		if fields.reset then
			jumpdrive.reset_coordinates(pos)
			jumpdrive.update_formspec(meta, pos)
			return
		end

		if fields.write_book then
			jumpdrive.write_to_book(pos, sender)
			return
		end

		if fields.set_digiline_channel and fields.digiline_channel then
			meta:set_string("channel", fields.digiline_channel)
			jumpdrive.update_formspec(meta, pos)
			return
		end

		local x = tonumber(fields.x);
		local y = tonumber(fields.y);
		local z = tonumber(fields.z);
		local radius = tonumber(fields.radius);

		if x == nil or y == nil or z == nil or radius == nil or radius < 1 then
			return
		end

		local max_radius = jumpdrive.config.max_radius

		if radius > max_radius then
			minetest.chat_send_player(sender:get_player_name(), "Invalid jump: max-radius=" .. max_radius)
			return
		end

		-- update coords
		meta:set_int("x", jumpdrive.sanitize_coord(x))
		meta:set_int("y", jumpdrive.sanitize_coord(y))
		meta:set_int("z", jumpdrive.sanitize_coord(z))
		meta:set_int("radius", radius)
		jumpdrive.update_formspec(meta, pos)

		if fields.jump then
			local success, msg = jumpdrive.execute_jump(pos, sender)
			if success then
				local time_millis = math.floor(msg / 1000)
				minetest.chat_send_player(sender:get_player_name(), "Jump executed in " .. time_millis .. " ms")
			else
				minetest.chat_send_player(sender:get_player_name(), msg)
			end
		end

		if fields.show then
			local success, msg = jumpdrive.simulate_jump(pos, sender, true)
			if not success then
				minetest.chat_send_player(sender:get_player_name(), msg)
				return
			end
			minetest.chat_send_player(sender:get_player_name(), "Simulation successful")
		end

	end,

	-- inventory protection
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

	-- upgrade re-calculation
	on_metadata_inventory_put = function(pos, listname)
		if listname == "upgrade" then
			jumpdrive.upgrade.calculate(pos)
		end
	end,

	on_metadata_inventory_take = function(pos, listname)
		if listname == "upgrade" then
			jumpdrive.upgrade.calculate(pos)
		end
	end,

	on_punch = function(pos, node, puncher)

		if minetest.is_protected(pos, puncher:get_player_name()) then
			return
		end

		local meta = minetest.get_meta(pos);
		local radius = meta:get_int("radius")

		jumpdrive.show_marker(pos, radius, "green")
	end
})

if minetest.get_modpath("technic") then
	technic.register_machine("HV", "jumpdrive:engine", technic.receiver)
end
