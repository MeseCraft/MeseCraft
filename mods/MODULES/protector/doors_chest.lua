
-- Since the doors mod has changed in the latest daily builds I have taken the
-- WTFPL licenced code from the old doors mod and included an edited version
-- within this mod for local use.

local S = protector.intllib
local F = minetest.formspec_escape

-- MineClone2 support
local mcl = not minetest.registered_items["default:steel_ingot"]

-- Registers a door
function register_door(name, def)
	def.groups.not_in_creative_inventory = 1

	local box = {{-0.5, -0.5, -0.5, 0.5, 0.5, -0.5+1.5/16}}

	def.node_box_bottom = box
	def.node_box_top = box
	def.selection_box_bottom = box
	def.selection_box_top = box
	def.sound_close_door  = "doors_door_close"
	def.sound_open_door = "doors_door_open"

	minetest.register_craftitem(name, {
		description = def.description,
		inventory_image = def.inventory_image,

		on_place = function(itemstack, placer, pointed_thing)
			if not pointed_thing.type == "node" then
				return itemstack
			end

			local ptu = pointed_thing.under
			local nu = minetest.get_node(ptu)
			if minetest.registered_nodes[nu.name]
			and minetest.registered_nodes[nu.name].on_rightclick then
				return minetest.registered_nodes[nu.name].on_rightclick(ptu, nu, placer, itemstack)
			end

			local pt = pointed_thing.above
			local pt2 = {x=pt.x, y=pt.y, z=pt.z}
			pt2.y = pt2.y+1
			if
				not minetest.registered_nodes[minetest.get_node(pt).name].buildable_to or
				not minetest.registered_nodes[minetest.get_node(pt2).name].buildable_to or
				not placer or
				not placer:is_player()
			then
				return itemstack
			end

			if minetest.is_protected(pt, placer:get_player_name()) or
					minetest.is_protected(pt2, placer:get_player_name()) then
				minetest.record_protection_violation(pt, placer:get_player_name())
				return itemstack
			end

			local p2 = minetest.dir_to_facedir(placer:get_look_dir())
			local pt3 = {x=pt.x, y=pt.y, z=pt.z}
			if p2 == 0 then
				pt3.x = pt3.x-1
			elseif p2 == 1 then
				pt3.z = pt3.z+1
			elseif p2 == 2 then
				pt3.x = pt3.x+1
			elseif p2 == 3 then
				pt3.z = pt3.z-1
			end
			if minetest.get_item_group(minetest.get_node(pt3).name, "door") == 0 then
				minetest.set_node(pt, {name=name.."_b_1", param2=p2})
				minetest.set_node(pt2, {name=name.."_t_1", param2=p2})
			else
				minetest.set_node(pt, {name=name.."_b_2", param2=p2})
				minetest.set_node(pt2, {name=name.."_t_2", param2=p2})
				minetest.get_meta(pt):set_int("right", 1)
				minetest.get_meta(pt2):set_int("right", 1)
			end

			if not minetest.settings:get_bool("creative_mode") then
				itemstack:take_item()
			end
			return itemstack
		end,
	})

	local tt = def.tiles_top
	local tb = def.tiles_bottom

	local function after_dig_node(pos, name, digger)
		local node = minetest.get_node(pos)
		if node.name == name then
			minetest.node_dig(pos, node, digger)
		end
	end

	local function on_rightclick(pos, dir, check_name, replace, replace_dir, params)
		pos.y = pos.y+dir
		if minetest.get_node(pos).name ~= check_name then
			return
		end
		local p2 = minetest.get_node(pos).param2
		p2 = params[p2+1]

		minetest.swap_node(pos, {name=replace_dir, param2=p2})

		pos.y = pos.y-dir
		minetest.swap_node(pos, {name=replace, param2=p2})

		local snd_1 = def.sound_close_door
		local snd_2 = def.sound_open_door
		if params[1] == 3 then
			snd_1 = def.sound_open_door
			snd_2 = def.sound_close_door
		end

		if minetest.get_meta(pos):get_int("right") ~= 0 then
			minetest.sound_play(snd_1, {pos = pos, gain = 0.3, max_hear_distance = 10})
		else
			minetest.sound_play(snd_2, {pos = pos, gain = 0.3, max_hear_distance = 10})
		end
	end

	local function on_rotate(pos, node, dir, user, check_name, mode, new_param2)

		if mode ~= screwdriver.ROTATE_FACE then
			return false
		end

		pos.y = pos.y + dir
		if not minetest.get_node(pos).name == check_name then
			return false
		end
		if minetest.is_protected(pos, user:get_player_name()) then
			minetest.record_protection_violation(pos, user:get_player_name())
			return false
		end

		local node2 = minetest.get_node(pos)
		node2.param2 = (node2.param2 + 1) % 4
		minetest.swap_node(pos, node2)

		pos.y = pos.y - dir
		node.param2 = (node.param2 + 1) % 4
		minetest.swap_node(pos, node)
		return true
	end

	minetest.register_node(name.."_b_1", {
		tiles = {tb[2], tb[2], tb[2], tb[2], tb[1], tb[1].."^[transformfx"},
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		drop = name,
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = def.node_box_bottom
		},
		selection_box = {
			type = "fixed",
			fixed = def.selection_box_bottom
		},
		groups = def.groups,

		after_dig_node = function(pos, oldnode, oldmetadata, digger)
			pos.y = pos.y+1
			after_dig_node(pos, name.."_t_1", digger)
		end,

		on_rightclick = function(pos, node, clicker)
			if not minetest.is_protected(pos, clicker:get_player_name()) then
				on_rightclick(pos, 1, name.."_t_1", name.."_b_2", name.."_t_2", {1,2,3,0})
			end
		end,

		on_rotate = function(pos, node, user, mode, new_param2)
			return on_rotate(pos, node, 1, user, name.."_t_1", mode)
		end,

		sounds = def.sounds,
		sunlight_propagates = def.sunlight,
		on_blast = function() end,
	})

	minetest.register_node(name.."_t_1", {
		tiles = {tt[2], tt[2], tt[2], tt[2], tt[1], tt[1].."^[transformfx"},
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		drop = "",
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = def.node_box_top
		},
		selection_box = {
			type = "fixed",
			fixed = def.selection_box_top
		},
		groups = def.groups,

		after_dig_node = function(pos, oldnode, oldmetadata, digger)
			pos.y = pos.y-1
			after_dig_node(pos, name.."_b_1", digger)
		end,

		on_rightclick = function(pos, node, clicker)
			if not minetest.is_protected(pos, clicker:get_player_name()) then
				on_rightclick(pos, -1, name.."_b_1", name.."_t_2", name.."_b_2", {1,2,3,0})
			end
		end,

		on_rotate = function(pos, node, user, mode, new_param2)
			return on_rotate(pos, node, -1, user, name.."_b_1", mode)
		end,

		sounds = def.sounds,
		sunlight_propagates = def.sunlight,
		on_blast = function() end,
	})

	minetest.register_node(name.."_b_2", {
		tiles = {tb[2], tb[2], tb[2], tb[2], tb[1].."^[transformfx", tb[1]},
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		drop = name,
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = def.node_box_bottom
		},
		selection_box = {
			type = "fixed",
			fixed = def.selection_box_bottom
		},
		groups = def.groups,

		after_dig_node = function(pos, oldnode, oldmetadata, digger)
			pos.y = pos.y+1
			after_dig_node(pos, name.."_t_2", digger)
		end,

		on_rightclick = function(pos, node, clicker)
			if not minetest.is_protected(pos, clicker:get_player_name()) then
				on_rightclick(pos, 1, name.."_t_2", name.."_b_1", name.."_t_1", {3,0,1,2})
			end
		end,

		on_rotate = function(pos, node, user, mode, new_param2)
			return on_rotate(pos, node, 1, user, name.."_t_2", mode)
		end,

		sounds = def.sounds,
		sunlight_propagates = def.sunlight,
		on_blast = function() end,
	})

	minetest.register_node(name.."_t_2", {
		tiles = {tt[2], tt[2], tt[2], tt[2], tt[1].."^[transformfx", tt[1]},
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		drop = "",
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = def.node_box_top
		},
		selection_box = {
			type = "fixed",
			fixed = def.selection_box_top
		},
		groups = def.groups,

		after_dig_node = function(pos, oldnode, oldmetadata, digger)
			pos.y = pos.y-1
			after_dig_node(pos, name.."_b_2", digger)
		end,

		on_rightclick = function(pos, node, clicker)
			if not minetest.is_protected(pos, clicker:get_player_name()) then
				on_rightclick(pos, -1, name.."_b_2", name.."_t_1", name.."_b_1", {3,0,1,2})
			end
		end,

		on_rotate = function(pos, node, user, mode, new_param2)
			return on_rotate(pos, node, -1, user, name.."_b_2", mode)
		end,

		sounds = def.sounds,
		sunlight_propagates = def.sunlight,
		on_blast = function() end,
	})

end

-- Protected Wooden Door

local name = "protector:door_wood"

register_door(name, {
	description = S("Protected Wooden Door"),
	inventory_image = "doors_wood.png^protector_logo.png",
	groups = {
		snappy = 1, choppy = 2, oddly_breakable_by_hand = 2,
		unbreakable = 1, --door = 1
	},
	tiles_bottom = {"doors_wood_b.png^protector_logo.png", "doors_brown.png"},
	tiles_top = {"doors_wood_a.png", "doors_brown.png"},
	sounds = default.node_sound_wood_defaults(),
	sunlight = false,
})

if mcl then
minetest.register_craft({
	output = name,
	recipe = {
		{"mcl_doors:wooden_door", "mcl_core:gold_ingot"}
	}
})
else
minetest.register_craft({
	output = name,
	recipe = {
		{"group:wood", "group:wood"},
		{"group:wood", "default:copper_ingot"},
		{"group:wood", "group:wood"}
	}
})

minetest.register_craft({
	output = name,
	recipe = {
		{"doors:door_wood", "default:copper_ingot"}
	}
})
end

-- Protected Steel Door

local name = "protector:door_steel"

register_door(name, {
	description = S("Protected Steel Door"),
	inventory_image = "doors_steel.png^protector_logo.png",
	groups = {
		snappy = 1, bendy = 2, cracky = 1,
		level = 2, unbreakable = 1, -- door = 1
	},
	tiles_bottom = {"doors_steel_b.png^protector_logo.png", "doors_grey.png"},
	tiles_top = {"doors_steel_a.png", "doors_grey.png"},
	sounds = default.node_sound_wood_defaults(),
	sunlight = false,
})

if mcl then
minetest.register_craft({
	output = name,
	recipe = {
		{"mcl_doors:iron_door", "mcl_core:gold_ingot"}
	}
})
else
minetest.register_craft({
	output = name,
	recipe = {
		{"default:steel_ingot", "default:steel_ingot"},
		{"default:steel_ingot", "default:copper_ingot"},
		{"default:steel_ingot", "default:steel_ingot"}
	}
})

minetest.register_craft({
	output = name,
	recipe = {
		{"doors:door_steel", "default:copper_ingot"}
	}
})
end

----trapdoor----

function register_trapdoor(name, def)
	local name_closed = name
	local name_opened = name.."_open"

	def.on_rightclick = function (pos, node, clicker, itemstack, pointed_thing)
		if minetest.is_protected(pos, clicker:get_player_name()) then
			return
		end
		local newname = node.name == name_closed and name_opened or name_closed
		local sound = false
		if node.name == name_closed then sound = "doors_door_open" end
		if node.name == name_opened then sound = "doors_door_close" end
		if sound then
			minetest.sound_play(sound, {pos = pos, gain = 0.3, max_hear_distance = 10})
		end
		minetest.swap_node(pos, {name = newname, param1 = node.param1, param2 = node.param2})
	end

	-- Common trapdoor configuration
	def.drawtype = "nodebox"
	def.paramtype = "light"
	def.paramtype2 = "facedir"
	def.is_ground_content = false

	local def_opened = table.copy(def)
	local def_closed = table.copy(def)

	def_closed.node_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, -6/16, 0.5}
	}
	def_closed.selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, -6/16, 0.5}
	}
	def_closed.tiles = { def.tile_front, def.tile_front, def.tile_side, def.tile_side,
		def.tile_side, def.tile_side }

	def_opened.node_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, 6/16, 0.5, 0.5, 0.5}
	}
	def_opened.selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, 6/16, 0.5, 0.5, 0.5}
	}
	def_opened.tiles = { def.tile_side, def.tile_side,
			def.tile_side .. "^[transform3",
			def.tile_side .. "^[transform1",
			def.tile_front, def.tile_front }

	def_opened.drop = name_closed
	def_opened.groups.not_in_creative_inventory = 1

	minetest.register_node(name_opened, def_opened)
	minetest.register_node(name_closed, def_closed)
end

-- Protected Wooden Trapdoor

register_trapdoor("protector:trapdoor", {
	description = S("Protected Trapdoor"),
	inventory_image = "doors_trapdoor.png^protector_logo.png",
	wield_image = "doors_trapdoor.png^protector_logo.png",
	tile_front = "doors_trapdoor.png^protector_logo.png",
	tile_side = "doors_trapdoor_side.png",
	groups = {
		snappy = 1, choppy = 2, oddly_breakable_by_hand = 2,
		unbreakable = 1, --door = 1
	},
	sounds = default.node_sound_wood_defaults(),
})

if mcl then
minetest.register_craft({
	output = "protector:trapdoor",
	recipe = {
		{"mcl_doors:trapdoor", "mcl_core:gold_ingot"}
	}
})
else
minetest.register_craft({
	output = "protector:trapdoor 2",
	recipe = {
		{"group:wood", "default:copper_ingot", "group:wood"},
		{"group:wood", "group:wood", "group:wood"},
	}
})

minetest.register_craft({
	output = "protector:trapdoor",
	recipe = {
		{"doors:trapdoor", "default:copper_ingot"}
	}
})
end

-- Protected Steel Trapdoor

register_trapdoor("protector:trapdoor_steel", {
	description = S("Protected Steel Trapdoor"),
	inventory_image = "doors_trapdoor_steel.png^protector_logo.png",
	wield_image = "doors_trapdoor_steel.png^protector_logo.png",
	tile_front = "doors_trapdoor_steel.png^protector_logo.png",
	tile_side = "doors_trapdoor_steel_side.png",
	groups = {
		snappy = 1, bendy = 2, cracky = 1, melty = 2, level = 2,
		unbreakable = 1, --door = 1
	},
	sounds = default.node_sound_wood_defaults(),
})

if mcl then
minetest.register_craft({
	output = "protector:trapdoor_steel",
	recipe = {
		{"mcl_doors:iron_trapdoor", "mcl_core:gold_ingot"}
	}
})
else
minetest.register_craft({
	output = "protector:trapdoor_steel",
	recipe = {
		{"default:copper_ingot", "default:steel_ingot"},
		{"default:steel_ingot", "default:steel_ingot"},
	}
})

minetest.register_craft({
	output = "protector:trapdoor_steel",
	recipe = {
		{"doors:trapdoor_steel", "default:copper_ingot"}
	}
})
end

-- Protected Chest

minetest.register_node("protector:chest", {
	description = S("Protected Chest"),
	tiles = {
		"default_chest_top.png", "default_chest_top.png",
		"default_chest_side.png", "default_chest_side.png",
		"default_chest_side.png", "default_chest_front.png^protector_logo.png"
	},
	paramtype2 = "facedir",
	groups = {choppy = 2, oddly_breakable_by_hand = 2, unbreakable = 1},
	legacy_facedir_simple = true,
	is_ground_content = false,
	sounds = default.node_sound_wood_defaults(),

	on_construct = function(pos)

		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()

		meta:set_string("infotext", S("Protected Chest"))
		meta:set_string("name", "")
		inv:set_size("main", 8 * 4)
	end,

	can_dig = function(pos,player)

		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()

		if inv:is_empty("main") then

			if not minetest.is_protected(pos, player:get_player_name()) then
				return true
			end
		end
	end,

	on_metadata_inventory_put = function(pos, listname, index, stack, player)

		minetest.log("action", player:get_player_name() ..
			" moves stuff to protected chest at " ..
			minetest.pos_to_string(pos))
	end,

	on_metadata_inventory_take = function(pos, listname, index, stack, player)

		minetest.log("action", player:get_player_name() ..
			" takes stuff from protected chest at " ..
			minetest.pos_to_string(pos))
	end,

	on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)

		minetest.log("action", player:get_player_name() ..
			" moves stuff inside protected chest at " ..
			minetest.pos_to_string(pos))
	end,

	allow_metadata_inventory_put = function(pos, listname, index, stack, player)

		if minetest.is_protected(pos, player:get_player_name()) then
			return 0
		end

		return stack:get_count()
	end,

	allow_metadata_inventory_take = function(pos, listname, index, stack, player)

		if minetest.is_protected(pos, player:get_player_name()) then
			return 0
		end

		return stack:get_count()
	end,

	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)

		if minetest.is_protected(pos, player:get_player_name()) then
			return 0
		end

		return count
	end,

	on_rightclick = function(pos, node, clicker)

		if minetest.is_protected(pos, clicker:get_player_name()) then
			return
		end

		local meta = minetest.get_meta(pos)

		if not meta then
			return
		end

		local spos = pos.x .. "," .. pos.y .. "," ..pos.z
		local formspec = "size[8,9]"
--			.. default.gui_bg
--			.. default.gui_bg_img
--			.. default.gui_slots
			.. "list[nodemeta:".. spos .. ";main;0,0.3;8,4;]"
			.. "button[0,4.5;2,0.25;toup;" .. F(S("To Chest")) .. "]"
			.. "field[2.3,4.8;4,0.25;chestname;;"
			.. meta:get_string("name") .. "]"
			.. "button[6,4.5;2,0.25;todn;" .. F(S("To Inventory")) .. "]"
			.. "list[current_player;main;0,5;8,1;]"
			.. "list[current_player;main;0,6.08;8,3;8]"
			.. "listring[nodemeta:" .. spos .. ";main]"
			.. "listring[current_player;main]"

			minetest.show_formspec(
				clicker:get_player_name(),
				"protector:chest_" .. minetest.pos_to_string(pos),
				formspec)
	end,

	on_blast = function() end,
})

-- Protected Chest formspec buttons

minetest.register_on_player_receive_fields(function(player, formname, fields)

	if string.sub(formname, 0, string.len("protector:chest_")) ~= "protector:chest_" then
		return
	end

	local pos_s = string.sub(formname,string.len("protector:chest_") + 1)
	local pos = minetest.string_to_pos(pos_s)

	if minetest.is_protected(pos, player:get_player_name()) then
		return
	end

	local meta = minetest.get_meta(pos) ; if not meta then return end
	local chest_inv = meta:get_inventory() ; if not chest_inv then return end
	local player_inv = player:get_inventory()
	local leftover

	if fields.toup then

		-- copy contents of players inventory to chest
		for i, v in ipairs(player_inv:get_list("main") or {}) do

			if chest_inv:room_for_item("main", v) then

				leftover = chest_inv:add_item("main", v)

				player_inv:remove_item("main", v)

				if leftover
				and not leftover:is_empty() then
					player_inv:add_item("main", v)
				end
			end
		end

	elseif fields.todn then

		-- copy contents of chest to players inventory
		for i, v in ipairs(chest_inv:get_list("main") or {}) do

			if player_inv:room_for_item("main", v) then

				leftover = player_inv:add_item("main", v)

				chest_inv:remove_item("main", v)

				if leftover
				and not leftover:is_empty() then
					chest_inv:add_item("main", v)
				end
			end
		end

	elseif fields.chestname then

		-- change chest infotext to display name
		if fields.chestname ~= "" then

			meta:set_string("name", fields.chestname)
			meta:set_string("infotext",
				S("Protected Chest (@1)", fields.chestname))
		else
			meta:set_string("infotext", S("Protected Chest"))
		end

	end
end)

-- Protected Chest recipes

if mcl then
minetest.register_craft({
	output = "protector:chest",
	recipe = {
		{"mcl_chests:chest", "mcl_core:gold_ingot"},
	}
})
else
minetest.register_craft({
	output = "protector:chest",
	recipe = {
		{"group:wood", "group:wood", "group:wood"},
		{"group:wood", "default:copper_ingot", "group:wood"},
		{"group:wood", "group:wood", "group:wood"},
	}
})

minetest.register_craft({
	output = "protector:chest",
	recipe = {
		{"default:chest", "default:copper_ingot"},
	}
})
end
