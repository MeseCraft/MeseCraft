
-- protector placement tool (thanks to Shara for code and idea)

local S = protector.intllib

-- get protection radius
local r = tonumber(minetest.settings:get("protector_radius")) or 5

minetest.register_craftitem("protector:tool", {
	description = S("Protector Placer Tool (stand near protector, face direction and use)"),
	inventory_image = "protector_display.png^protector_logo.png",
	stack_max = 1,

	on_use = function(itemstack, user, pointed_thing)

		local name = user:get_player_name()

		-- check for protector near player (2 block radius)
		local pos = user:get_pos()
		local pp = minetest.find_nodes_in_area(
			vector.subtract(pos, 2), vector.add(pos, 2),
			{"protector:protect", "protector:protect2"})

		if #pp == 0 then return end -- none found

		pos = pp[1] -- take position of first protector found

		-- get members on protector
		local meta = minetest.get_meta(pos)
		local members = meta:get_string("members") or ""

		-- get direction player is facing
		local dir = minetest.dir_to_facedir( user:get_look_dir() )
		local vec = {x = 0, y = 0, z = 0}
		local gap = (r * 2) + 1
		local pit =  user:get_look_pitch()

		-- set placement coords
		if pit > 1.2 then
			vec.y = gap -- up
		elseif pit < -1.2 then
			vec.y = -gap -- down
		elseif dir == 0 then
			vec.z = gap -- north
		elseif dir == 1 then
			vec.x = gap -- east
		elseif dir == 2 then
			vec.z = -gap -- south
		elseif dir == 3 then
			vec.x = -gap -- west
		end

		-- new position
		pos.x = pos.x + vec.x
		pos.y = pos.y + vec.y
		pos.z = pos.z + vec.z

		-- does placing a protector overlap existing area
		if not protector.can_dig(r * 2, pos, user:get_player_name(), true, 3) then

			minetest.chat_send_player(name,
				S("Overlaps into above players protected area"))

			return
		end

		-- does a protector already exist ?
		if #minetest.find_nodes_in_area(
			vector.subtract(pos, 1), vector.add(pos, 1),
			{"protector:protect", "protector:protect2"}) > 0 then

			minetest.chat_send_player(name, S("Protector already in place!"))

			return
		end

		-- do we have protectors to use ?
		local nod
		local inv = user:get_inventory()

		if not inv:contains_item("main", "protector:protect")
		and not inv:contains_item("main", "protector:protect2") then

			minetest.chat_send_player(name,
				S("No protectors available to place!"))

			return
		end

		-- take protector (block first then logo)
		if inv:contains_item("main", "protector:protect") then

			inv:remove_item("main", "protector:protect")
			nod = "protector:protect"

		elseif inv:contains_item("main", "protector:protect2") then

			inv:remove_item("main", "protector:protect2")
			nod = "protector:protect2"
		end

		-- do not replace containers with inventory space
		local inv = minetest.get_inventory({type = "node", pos = pos})

		if inv then
			minetest.chat_send_player(name,
				S("Cannot place protector, container at") ..
					" " .. minetest.pos_to_string(pos))
			return
		end

		-- protection check for other mods like Areas
		if minetest.is_protected(pos, name) then
			minetest.chat_send_player(name,
				S("Cannot place protector, already protected at") ..
				" " .. minetest.pos_to_string(pos))
			return
		end

		-- place protector
		minetest.set_node(pos, {name = nod, param2 = 1})

		-- set protector metadata
		local meta = minetest.get_meta(pos)

		meta:set_string("owner", name)
		meta:set_string("infotext", "Protection (owned by " .. name .. ")")

		-- copy members across if holding sneak when using tool
		if user:get_player_control().sneak then
			meta:set_string("members", members)
		else
			meta:set_string("members", "")
		end

		minetest.chat_send_player(name,
				S("Protector placed at") ..
				" " ..  minetest.pos_to_string(pos))

	end,
})

-- tool recipe
minetest.register_craft({
	output = "protector:tool",
	recipe = {
		{"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"},
		{"default:steel_ingot", "protector:protect", "default:steel_ingot"},
		{"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"},
	}
})
