ts_workshop = {}

function ts_workshop.register_workshop(mod, name, def)
	if not ts_workshop[mod] then
		ts_workshop[mod] = {}
	end
	if not ts_workshop[mod][name] then
		ts_workshop[mod][name] = {}
	end

	ts_workshop[mod][name].enough_supply = def.enough_supply
	ts_workshop[mod][name].remove_supply_raw = def.remove_supply
	ts_workshop[mod][name].update_formspec_raw = def.update_formspec
	ts_workshop[mod][name].update_inventory_raw = def.update_inventory

	ts_workshop[mod][name].remove_supply = function(pos, selection)
		ts_workshop[mod][name].remove_supply_raw(pos, selection)
		ts_workshop[mod][name].update_inventory(pos)
	end

	ts_workshop[mod][name].start = function(pos)
		local node = minetest.get_node(pos)
		if not (mod and name) then
			mod, name = minetest.get_node(pos).name:match("([^:]+):([^:]+)")
		end
		if node.name ~= mod .. ":" .. name or not ts_workshop[mod][name] then
			return
		end

		local meta = minetest.get_meta(pos)
		if meta:get_string("working_on") ~= "" then
			return
		end

		local selection = meta:get_string("selection")
		if selection and selection ~= "" then
			if not ts_workshop[mod][name].enough_supply(pos, selection) then
				return
			end
		else
			return
		end

		local inv = meta:get_inventory()
		if not inv:room_for_item("output", { name = selection, count = 1 }) then
			return
		end

		meta:set_string("working_on", selection)
		meta:set_int("progress", 0)

		ts_workshop[mod][name].remove_supply(pos, selection)

		ts_workshop[mod][name].step(pos)
	end

	ts_workshop[mod][name].step = function(pos)
		local node = minetest.get_node(pos)
		if not (mod and name) then
			mod, name = minetest.get_node(pos).name:match("([^:]+):([^:]+)")
		end
		if node.name ~= mod .. ":" .. name or not ts_workshop[mod][name] then
			return
		end

		local meta = minetest.get_meta(pos)
		local working_on = meta:get_string("working_on")
		if working_on == "" then
			return
		end


		local progress = meta:get_int("progress")
		progress = progress + 1

		local duration = 10
		if minetest.registered_items[working_on] and
				minetest.registered_items[working_on].workshop_duration then
			duration = minetest.registered_items[working_on].workshop_duration
		end

		if progress < duration then
			meta:set_int("progress", progress)
			local timer = minetest.get_node_timer(pos)
			timer:start(0.2)
		else
			meta:set_int("progress", 0)
			progress = 0
			local inv = meta:get_inventory()
			inv:add_item("output", working_on)
			meta:set_string("working_on", "")
			ts_workshop[mod][name].start(pos)
		end

		ts_workshop[mod][name].update_formspec(pos)
	end

	ts_workshop[mod][name].update_formspec = function(pos)
		if not (mod and name) then
			mod, name = minetest.get_node(pos).name:match("([^:]+):([^:]+)")
		end
		local node = minetest.get_node(pos)
		if node.name ~= mod .. ":" .. name or not ts_workshop[mod][name] then
			return
		end
		ts_workshop[mod][name].update_formspec_raw(pos)
	end

	ts_workshop[mod][name].update_inventory = function(pos)
		if not (mod and name) then
			mod, name = minetest.get_node(pos).name:match("([^:]+):([^:]+)")
		end
		local node = minetest.get_node(pos)
		if node.name ~= mod .. ":" .. name or not ts_workshop[mod][name] then
			return
		end
		ts_workshop[mod][name].update_inventory_raw(pos)
		ts_workshop[mod][name].update_formspec(pos)
		ts_workshop[mod][name].start(pos)
	end

	ts_workshop[mod][name].on_receive_fields = function(pos, formname, fields, sender)
		def.on_receive_fields(pos, formname, fields, sender)
		ts_workshop[mod][name].update_inventory(pos)
	end

	ts_workshop[mod][name].on_construct = function(pos)
		def.on_construct(pos)
		if not (mod and name) then
			mod, name = minetest.get_node(pos).name:match("([^:]+):([^:]+)")
		end
		ts_workshop[mod][name].update_inventory(pos)
	end

	ts_workshop[mod][name].allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		return def.allow_metadata_inventory_move(pos, from_list, from_index, to_list, to_index, count, player)
	end

	ts_workshop[mod][name].allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		return def.allow_metadata_inventory_put(pos, listname, index, stack, player)
	end

	ts_workshop[mod][name].allow_metadata_inventory_take = function(pos, listname, index, stack, player)
		return def.allow_metadata_inventory_take(pos, listname, index, stack, player)
	end

	ts_workshop[mod][name].on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		if not (mod and name) then
			mod, name = minetest.get_node(pos).name:match("([^:]+):([^:]+)")
		end
		ts_workshop[mod][name].update_inventory(pos)
	end

	ts_workshop[mod][name].on_metadata_inventory_put = function(pos, listname, index, stack, player)
		if not (mod and name) then
			mod, name = minetest.get_node(pos).name:match("([^:]+):([^:]+)")
		end
		ts_workshop[mod][name].update_inventory(pos)
	end

	ts_workshop[mod][name].on_metadata_inventory_take = function(pos, listname, index, stack, player)
		if not (mod and name) then
			mod, name = minetest.get_node(pos).name:match("([^:]+):([^:]+)")
		end
		ts_workshop[mod][name].update_inventory(pos)
	end

	ts_workshop[mod][name].can_dig = function(pos, player)
		return def.can_dig(pos, player)
	end

	local ndef = table.copy(def)
	ndef.on_receive_fields = ts_workshop[mod][name].on_receive_fields
	ndef.on_construct = ts_workshop[mod][name].on_construct
	ndef.allow_metadata_inventory_move = ts_workshop[mod][name].allow_metadata_inventory_move
	ndef.allow_metadata_inventory_put = ts_workshop[mod][name].allow_metadata_inventory_put
	ndef.allow_metadata_inventory_take = ts_workshop[mod][name].allow_metadata_inventory_take
	ndef.on_metadata_inventory_move = ts_workshop[mod][name].on_metadata_inventory_move
	ndef.on_metadata_inventory_put = ts_workshop[mod][name].on_metadata_inventory_put
	ndef.on_metadata_inventory_take = ts_workshop[mod][name].on_metadata_inventory_take
	ndef.can_dig = ts_workshop[mod][name].can_dig
	ndef.on_timer = function(pos, elapsed)
		if not (mod and name) then
			mod, name = minetest.get_node(pos).name:match("([^:]+):([^:]+)")
		end
		ts_workshop[mod][name].step(pos)
	end

	minetest.register_node(mod .. ":" .. name, ndef)
end