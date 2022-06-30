

jumpdrive.write_to_book = function(pos, sender)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()

	if inv:contains_item("main", {name="default:book", count=1}) then
		local stack = inv:remove_item("main", {name="default:book", count=1})

		local new_stack = ItemStack("default:book_written")

		local data = {}

		data.owner = sender:get_player_name()
		data.title = "Jumpdrive coordinates"
		data.description = "Jumpdrive coordiates"
		data.text = minetest.serialize(jumpdrive.get_meta_pos(pos))
		data.page = 1
		data.page_max = 1

		new_stack:get_meta():from_table({ fields = data })

		if inv:room_for_item("main", new_stack) then
			-- put written book back
			inv:add_item("main", new_stack)
		else
			-- put back old stack
			inv:add_item("main", stack)
		end

	end

end

jumpdrive.read_from_book = function(pos)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	local player_name = meta:get_string("owner")

	if inv:contains_item("main", {name="default:book_written", count=1}) then
		local stack = inv:remove_item("main", {name="default:book_written", count=1})
		local stackMeta = stack:get_meta()

		local text = stackMeta:get_string("text")
		local data = minetest.deserialize(text)

		if data == nil then
			-- put book back, it may contain other information
			inv:add_item("main", stack)
			-- alert player
			if nil ~= player_name then
				minetest.chat_send_player(player_name, "Invalid data")
			end
			return
		end

		local x = tonumber(data.x)
		local y = tonumber(data.y)
		local z = tonumber(data.z)

		if x == nil or y == nil or z == nil then
			-- put book back, it may contain other information
			inv:add_item("main", stack)
			-- alert player
			if nil ~= player_name then
				minetest.chat_send_player(player_name, "Invalid coordinates")
			end
			return
		end

		meta:set_int("x", jumpdrive.sanitize_coord(x))
		meta:set_int("y", jumpdrive.sanitize_coord(y))
		meta:set_int("z", jumpdrive.sanitize_coord(z))

		-- put book back
		inv:add_item("main", stack)
	elseif inv:contains_item("main", {name="missions:wand_position", count=1}) then
		local stack = inv:remove_item("main", {name="missions:wand_position", count=1})
		local stackMeta = stack:get_meta()

		local text = stackMeta:get_string("pos")
		local target_pos = minetest.string_to_pos(text)

		if nil == target_pos then
			-- put wand back, I don't see a way to corrupt a wand atm
			inv:add_item("main", stack)
			return
		end

		local x = target_pos.x
		local y = target_pos.y
		local z = target_pos.z

		if x == nil or y == nil or z == nil then
			-- put wand back, I don't see a way to corrupt a wand atm
			inv:add_item("main", stack)
			return
		end

		meta:set_int("x", jumpdrive.sanitize_coord(x))
		meta:set_int("y", jumpdrive.sanitize_coord(y))
		meta:set_int("z", jumpdrive.sanitize_coord(z))

		-- put wand back
		inv:add_item("main", stack)
	end
end
