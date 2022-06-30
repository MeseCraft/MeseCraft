
laptop.node_config = {}

local function on_construct(pos)
	laptop.mtos_cache:free(pos)
	local mtos = laptop.os_get(pos)
	local node = minetest.get_node(pos)
	local hwdef = laptop.node_config[node.name]
	if hwdef.custom_theme then -- initial only
		mtos:set_theme(hwdef.custom_theme)
	end
	if hwdef.hw_state then
		mtos[hwdef.hw_state](mtos)
	else
		mtos:power_off()
	end
end

local function on_punch(pos, node, puncher)
	local mtos = laptop.os_get(pos)

	local punch_item = puncher:get_wielded_item()
	local is_compatible = false
	if punch_item then
		local def = punch_item:get_definition()
		for group, _ in pairs(def.groups) do
			if mtos.bdev:is_hw_capability(group) then
				is_compatible = true
			end
		end
	end

	if is_compatible then
		local slot = mtos.bdev:get_removable_disk()
		-- swap
		puncher:set_wielded_item(slot.stack)
		-- reload OS
		slot:reload(punch_item)
		laptop.mtos_cache:sync_and_free(mtos)
		for k,v in pairs(laptop.os_get(mtos.pos)) do
			mtos[k] = v
		end
		mtos:pass_to_app("punched_by_removable", true, puncher, punch_item)
		return
	end

	local hwdef = laptop.node_config[node.name]
	if hwdef.next_node then
		local hwdef_next = laptop.node_config[hwdef.next_node]
		if hwdef_next.hw_state then
			mtos[hwdef_next.hw_state](mtos, hwdef.next_node)
		else
			mtos:swap_node(hwdef.next_node)
			mtos:save()
		end
	end
end

local function on_receive_fields(pos, formname, fields, sender)
	local mtos = laptop.os_get(pos)
	mtos:pass_to_app("receive_fields_func", true, sender, fields)
end

local function allow_metadata_inventory_move(pos, from_list, from_index, to_list, to_index, count, player)
	local mtos = laptop.os_get(pos)
	return mtos:pass_to_app("allow_metadata_inventory_move", false, player, from_list, from_index, to_list, to_index, count) or 0
end

local function allow_metadata_inventory_put(pos, listname, index, stack, player)
	local mtos = laptop.os_get(pos)
	local def = stack:get_definition()
	local allowed_stacksize = 0
	if def then
		for group, _ in pairs(def.groups) do
			if mtos.bdev:is_hw_capability(group) then
				allowed_stacksize = 1
			end
		end
	end
	return mtos:pass_to_app("allow_metadata_inventory_put", false, player, listname, index, stack) or allowed_stacksize
end

local function allow_metadata_inventory_take(pos, listname, index, stack, player)
	local mtos = laptop.os_get(pos)
	return mtos:pass_to_app("allow_metadata_inventory_take", false, player, listname, index, stack) or 1 -- by default removal allowed
end

local function on_metadata_inventory_move(pos, from_list, from_index, to_list, to_index, count, player)
	local mtos = laptop.os_get(pos)
	mtos:pass_to_app("on_metadata_inventory_move", true, player, from_list, from_index, to_list, to_index, count)
end

local function on_metadata_inventory_put(pos, listname, index, stack, player)
	local mtos = laptop.os_get(pos)
	mtos:pass_to_app("on_metadata_inventory_put", true, player, listname, index, stack)
end

local function on_metadata_inventory_take(pos, listname, index, stack, player)
	local mtos = laptop.os_get(pos)
	mtos:pass_to_app("on_metadata_inventory_take", true, player, listname, index, stack)
end

local function on_timer(pos, elapsed)
	local mtos = laptop.os_get(pos)
	return mtos:pass_to_app("on_timer", true, nil, elapsed)
end

local function after_place_node(pos, placer, itemstack, pointed_thing)
	local save = minetest.deserialize(itemstack:get_meta():get_string("laptop_metadata"))
	if not save then
		return
	end

	-- Backwards compatibility code
	if not save.ram_disk and not save.hard_disk then
		laptop.mtos_cache:free(pos)
		local meta = minetest.get_meta(pos)
		meta:from_table({fields = save.fields})
		for invname, inv in pairs(save.invlist) do
			meta:get_inventory():set_list(invname, inv)
		end
		itemstack:clear()
		return
	end
	-- Backwards compatibility code end

	local mtos = laptop.os_get(pos)
	mtos.bdev.ram_disk = save.ram_disk or mtos.bdev.ram_disk
	mtos.bdev.hard_disk = save.hard_disk or mtos.bdev.hard_disk

	if save.removable_disk then
		local removable = mtos.bdev:get_removable_disk()
		removable:reload(ItemStack(save.removable_disk))
	end

	mtos.bdev:sync()
	itemstack:clear()
end

local function preserve_metadata(pos, oldnode, oldmetadata, drops)
	local mtos = laptop.os_get(pos)
	if not mtos then
		return
	end

	laptop.mtos_cache:sync_and_free(mtos)

	local removable = mtos.bdev:get_removable_disk()

	local save = {
		laptop_ram = mtos.bdev:get_ram_disk(),
		hard_disk = mtos.bdev:get_hard_disk(),
		removable_disk = removable.stack and removable.stack:to_string()
	}

	local item_name = minetest.registered_items[oldnode.name].drop or oldnode.name
	for _, stack in pairs(drops) do
		if stack:get_name() == item_name then
			stack:get_meta():set_string("laptop_metadata", minetest.serialize(save))
		end
	end
end

function laptop.register_hardware(name, hwdef)
	local default_nodename = name.."_"..hwdef.sequence[1]
	for idx, variant in ipairs(hwdef.sequence) do
		local nodename = name.."_"..variant
		local def = table.copy(hwdef.node_defs[variant])
		def.description = hwdef.description

		-- drop the item visible in inventory
		if def.groups then
			def.groups = table.copy(def.groups)
		else
			def.groups = {choppy=2, oddly_breakably_by_hand=2,  dig_immediate = 2}
		end
		if nodename ~= default_nodename then
			def.drop = default_nodename
			def.groups.not_in_creative_inventory = 1
		end
		if def.paramtype2 == "colorfacedir" and not def.palette then
			def.palette = "unifieddyes_palette_redviolets.png" --TODO: Replace by own laptop specific PNG file
		end

		-- needed to transfer content to item if place or dig laptop
		def.stack_max = 1
		def.after_place_node = after_place_node
		def.preserve_metadata = preserve_metadata
		def.on_punch = on_punch
		def.on_construct = on_construct
		def.on_receive_fields = on_receive_fields
		def.allow_metadata_inventory_move = allow_metadata_inventory_move
		def.allow_metadata_inventory_put = allow_metadata_inventory_put
		def.allow_metadata_inventory_take = allow_metadata_inventory_take
		def.on_metadata_inventory_move = on_metadata_inventory_move
		def.on_metadata_inventory_put = on_metadata_inventory_put
		def.on_metadata_inventory_take = on_metadata_inventory_take
		def.on_timer = on_timer
		minetest.register_node(nodename, def)

		-- set node configuration for hooks
		local merged_hwdef = table.copy(hwdef)
		merged_hwdef.name = name
		merged_hwdef.nodename = nodename
		for k,v in pairs(hwdef.node_defs[variant]) do
			merged_hwdef[k] = v
		end
		local next_seq = hwdef.sequence[idx+1] or hwdef.sequence[1]
		local next_node = name.."_"..next_seq
		if next_node ~= nodename then
			merged_hwdef.next_node = next_node
		end

		-- Defaults
		merged_hwdef.hw_capabilities =  merged_hwdef.hw_capabilities or {"hdd", "floppy", "usb", "net", "liveboot"}
		laptop.node_config[nodename] = merged_hwdef
	end
end

