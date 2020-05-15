-- internationalization boilerplate
local MP = minetest.get_modpath(minetest.get_current_modname())
local S, NS = dofile(MP.."/intllib.lua")

local named_waypoints_path = minetest.get_modpath("named_waypoints")

local invulnerable = df_underworld_items.config.invulnerable_slade and not minetest.settings:get_bool("creative_mode")

local can_dig
if invulnerable then
	can_dig = function(pos, player)
		return minetest.check_player_privs(player, "server")
	end
end

local slade_groups = {stone=1, level=3, slade=1, pit_plasma_resistant=1, mese_radiation_shield=1, cracky = 3, not_in_creative_inventory=1}
if invulnerable then
	slade_groups.immortal = 1
end


-- Ensures that the node is functioning correctly
local ensure_meta = function(pos)
    local meta = minetest.get_meta(pos)
	if not meta:contains("key") then
		local inv = meta:get_inventory()
		inv:set_size("main", 8)
		local next_seed = math.random() * 2^21
		math.randomseed(pos.x + pos.z^16)
		-- Key is consistent with location
		local key = {math.random(0,7), math.random(0,7), math.random(0,7), math.random(0,7), math.random(0,7), math.random(0,7),math.random(0,7), math.random(0,7)}
		math.randomseed(next_seed)
		meta:set_string("key", minetest.serialize(key))
		meta:mark_as_private("key")
	end
	
	local timer = minetest.get_node_timer(pos)
	if not timer:is_started() then
		timer:start(4)
	end
end

local colour_groups = {
	"color_black",	-- 0
	"color_red",	-- 1
	"color_orange",	-- 2
	"color_yellow",	-- 3
	"color_green",	-- 4
	"color_blue",	-- 5
	"color_violet",	-- 6
	"color_white"}	-- 7

local test_key = function(pos)
    local meta = minetest.get_meta(pos)
	if not meta:contains("key") then
		return false
	end
		
	local keystring = meta:get_string("key")
	local key = minetest.deserialize(keystring)
	local inv = meta:get_inventory()
	
	for offset = 0, 7 do
		local valid
		for i = 0, 7 do
			valid = true
			local keyval = (i + offset) % 8 + 1
			local key_group = colour_groups[key[keyval]+1]
			local item = inv:get_stack("main", i+1)
			if minetest.get_item_group(item:get_name(), key_group) == 0 then
				valid = false
				break
			end
		end
		if valid then
			local unlocked = meta:get_int("unlocked")
			if unlocked == 0 then
				meta:set_int("unlocked", 1)
			end
			return true
		end
	end
	meta:set_int("unlocked", 0)
	return false
end


--We were a powerful culture.
--This place is not a place of honor.
--No esteemed deed is commemorated here.
--What is here is dangerous and repulsive.
--This message is a warning about danger.
--The danger is still present.
--The danger is unleashed if you disturb this place.
--This place is best shunned and left uninhabited.

local formspec_prefix = "df_underworld_items_puzzle_seal:"
local get_formspec = function(pos, unlocked)
	local formspec = 
		"size[8,8]"
		.."image[0,0;2.5,4;dfcaverns_puzzle_inscription_background.png^dfcaverns_puzzle_inscription_1.png]"
		.."image[5.8,0;2.5,4;dfcaverns_puzzle_inscription_background.png^[transformR180^dfcaverns_puzzle_inscription_2.png]"
		.."container[2.25,0]"
		.."list[nodemeta:"..pos.x..","..pos.y..","..pos.z..";main;0.25,0.25;1,1;0]"
		.."list[nodemeta:"..pos.x..","..pos.y..","..pos.z..";main;1.25,0;1,1;1]"
		.."list[nodemeta:"..pos.x..","..pos.y..","..pos.z..";main;2.25,0.25;1,1;2]"
		.."list[nodemeta:"..pos.x..","..pos.y..","..pos.z..";main;2.5,1.25;1,1;3]"
		.."list[nodemeta:"..pos.x..","..pos.y..","..pos.z..";main;2.25,2.25;1,1;4]"
		.."list[nodemeta:"..pos.x..","..pos.y..","..pos.z..";main;1.25,2.5;1,1;5]"
		.."list[nodemeta:"..pos.x..","..pos.y..","..pos.z..";main;0.25,2.25;1,1;6]"
		.."list[nodemeta:"..pos.x..","..pos.y..","..pos.z..";main;0,1.25;1,1;7]"
	if unlocked then
		formspec = formspec .. "image_button[1.25,1.25;1,1;dfcaverns_seal.png;open;"..S("Turn").."]"
	else
		formspec = formspec .. "image[1.25,1.25;1,1;dfcaverns_seal.png]"
	end
	
	formspec = formspec
		.."container_end[]"
--		.."container[5,0.5]"
--		.."box[0,0;1,5;#0A0000]box[0.1,0.1;0.8,4.8;#000000]box[0.1," .. 0.1 + 4.8*completion ..";0.8,".. 4.8*completion ..";#FFCC22]"
--		.."container_end[]"
		.."container[0,4]list[current_player;main;0,0;8,1;]listring[]"
		.."list[current_player;main;0,1.25;8,3;8]container_end[]"
	return formspec
end
local refresh_formspec = function(pos, player)
	local player_name = player:get_player_name()
	local unlocked = test_key(pos)
	local formspec = get_formspec(pos, unlocked)
	minetest.show_formspec(player_name, formspec_prefix..minetest.pos_to_string(pos), formspec)
end

local show_key = function(pos, index)
    minetest.sound_play("dfcaverns_seal_key", {
        pos = pos,
        gain = 0.125,
        max_hear_distance = 32,
    })
    local meta = minetest.get_meta(pos)
	local keystring = meta:get_string("key")
	local key = minetest.deserialize(keystring)
	--minetest.chat_send_all(keystring)
	local minpos = vector.add(pos, {x=-1, y=1, z=-1})
	local maxpos = vector.add(pos, {x=1, y=3, z=1})
	minetest.add_particlespawner({
		amount = key[index+1],
		time = 0.5,
		minpos = minpos,
		maxpos = maxpos,
		minvel = {x=-0.25, y=0, z=-0.25},
		maxvel = {x=0.25, y=0.25, z=0.25},
		minacc = {x=0, y=0, z=0},
		maxacc = {x=0, y=0, z=0},
		minexptime = 3,
		maxexptime = 3,
		minsize = 1,
		maxsize = 1,
		texture = "dfcaverns_puzzle_particle.png",
		glow = 8,
	})
end

local show_unlocked = function(pos, global)
	-- Plays globally. This is deliberate.
	if global then
		minetest.sound_play("dfcaverns_seal_unlocked", {})
	else
		minetest.sound_play("dfcaverns_seal_unlocked", {pos = pos, max_hear_distance = 128,})
	end
	minetest.add_particle({
		pos = pos,
		velocity = {x=0, y=1, z=0},
		expirationtime = 30,
		size = 20,
		texture = "dfcaverns_seal.png^[invert:rgb^[brighten",
		glow = 15,
--		vertical = true,
	})
end

local puzzle_seal_def = {
	description = S("Slade Puzzle Seal"),
	_doc_items_longdesc = nil,
	_doc_items_usagehelp = nil,
	drawtype = "mesh",
	mesh = "underworld_seal.obj",
	tiles = {"dfcaverns_slade_block.png", "dfcaverns_slade_block.png^dfcaverns_seal.png", "dfcaverns_slade_block.png^(dfcaverns_inscription_1.png^[opacity:128)"},
	paramtype = "light",
	paramtype2 = "facedir",
	light_source = 8,
	groups = slade_groups,
	sounds = default.node_sound_stone_defaults({ footstep = { name = "bedrock2_step", gain = 1 } }),
	selection_box = {
		type = "fixed",
		fixed = {-0.625, -0.625, -0.625, 0.625, 0.625, 0.625},
	},
	collision_box = {
		type = "fixed",
		fixed = {-0.625, -0.625, -0.625, 0.625, 0.625, 0.625},
	},
	is_ground_content = false,
	can_dig = can_dig,
	on_blast = function() end,
	on_rotate = function() return false end,
	on_construct = function(pos)
	    ensure_meta(pos)
	end,
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		ensure_meta(pos)
		refresh_formspec(pos, clicker)
	end,
	on_timer = function(pos, elapsed)	
		local meta = minetest.get_meta(pos)
		local unlocked = meta:get_int("unlocked")
		if unlocked > 0 then
			meta:set_int("unlocked", unlocked + 1)
			show_unlocked(pos, unlocked <= 13)
		else
			local index = meta:get_int("key_index")
			show_key(pos, index)
			meta:set_int("key_index", (index+1) % 8)
		end
		minetest.get_node_timer(pos):start(4)
	end,
	on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		refresh_formspec(pos, player)
	end,
	on_metadata_inventory_put = function(pos, listname, index, stack, player)
		refresh_formspec(pos, player)
	end,
	on_metadata_inventory_take = function(pos, listname, index, stack, player)
		refresh_formspec(pos, player)
	end,
}


minetest.register_node("df_underworld_items:puzzle_seal", puzzle_seal_def)

--------------------------------------------------------------------------------
-- Once the seal is opened, it turns into this and digs its way down through the slade.

local digging_seal_def = {
	description = S("Active Slade Breacher"),
	_doc_items_longdesc = nil,
	_doc_items_usagehelp = nil,
	drawtype = "mesh",
	mesh = "underworld_seal.obj",
	tiles = {"dfcaverns_pit_plasma_static.png", "dfcaverns_pit_plasma_static.png^dfcaverns_seal.png", "dfcaverns_pit_plasma_static.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	light_source = default.LIGHT_MAX,
	groups = {immortal=1, stone=1, level=3, slade=1, pit_plasma_resistant=1, mese_radiation_shield=1, not_in_creative_inventory=1},
	sounds = default.node_sound_stone_defaults({ footstep = { name = "bedrock2_step", gain = 1 } }),
	selection_box = {
		type = "fixed",
		fixed = {-0.625, -0.625, -0.625, 0.625, 0.625, 0.625},
	},
	collision_box = {
		type = "fixed",
		fixed = {-0.625, -0.625, -0.625, 0.625, 0.625, 0.625},
	},
	is_ground_content = false,
	can_dig = can_dig,
	on_blast = function() end,
	on_rotate = function() return false end,
	on_construct = function(pos)
		minetest.get_node_timer(pos):start(0)
	end,
	on_timer = function(pos, elapsed)
		local node = minetest.get_node(pos)
		local below_node = minetest.get_node({x=pos.x, y=pos.y-1, z=pos.z})
		if below_node.name == "ignore" then
			-- map's not loaded below, try again later
			minetest.get_node_timer(pos):start(4)
			return
		end

		minetest.sound_play("dfcaverns_massive_digging", {
			pos = pos,
			gain = 1.0,
			max_hear_distance = 32,
		})
		
		local minpos = vector.add(pos, {x=0, y=-1, z=0})
		minetest.add_particlespawner({
			amount = 100,
			time = 4,
			minpos = minpos,
			maxpos = minpos,
			minvel = {x=-5, y=0, z=-5},
			maxvel = {x=5, y=20, z=5},
			minacc = {x=0, y=-10, z=0},
			maxacc = {x=0, y=-10, z=0},
			minexptime = 5,
			maxexptime = 15,
			minsize = 1,
			maxsize = 5,
			texture = "dfcaverns_glowpit_particle.png",
			collisiondetection = true,
			collision_removal = true,
			glow = 15,
		})
		
		if minetest.get_item_group(below_node.name, "slade") == 0 then
			tnt.boom({x=pos.x, y=pos.y-2, z=pos.z}, {radius=3})
			minetest.set_node(pos, {name="default:lava_source"})
			return
		end
		
		local rot = node.param2
		if rot == 0 then
			minetest.place_schematic({x=pos.x-3, y=pos.y-2, z=pos.z-3}, df_underworld_items.seal_stair_schem, 0, {}, true)
			node.param2 = 1
		elseif rot == 1 then
			minetest.place_schematic({x=pos.x-3, y=pos.y-2, z=pos.z-3}, df_underworld_items.seal_stair_schem, 90, {}, true)
			node.param2 = 2
		elseif rot == 2 then
			minetest.place_schematic({x=pos.x-3, y=pos.y-2, z=pos.z-3}, df_underworld_items.seal_stair_schem, 180, {}, true)
			node.param2 = 3
		elseif rot == 3 then
			minetest.place_schematic({x=pos.x-3, y=pos.y-2, z=pos.z-3}, df_underworld_items.seal_stair_schem, 270, {}, true)
			node.param2 = 0
		else
			tnt.boom(pos, {radius=3})
			minetest.set_node(pos, {name="default:lava_source"})
			return
		end
		minetest.set_node(pos, {name="air"})
		local newpos = {x=pos.x, y=pos.y-2, z=pos.z}
		minetest.set_node(newpos, node)
		minetest.get_node_timer(newpos):start(4)
	end,
}

minetest.register_node("df_underworld_items:digging_seal", digging_seal_def)

local prefix_len = string.len(formspec_prefix)
minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname:sub(1,prefix_len) ~= formspec_prefix or not fields.open then
		return
	end
	local pos_string = formname:sub(prefix_len+1)	
	local pos = minetest.string_to_pos(pos_string)
	if test_key(pos) then
		if named_waypoints_path then
			named_waypoints.update_waypoint("puzzle_seals", pos, {name=S("Breach in the Slade"), color=0xFA264F, player=player:get_player_name()})
		end
		minetest.log("action", "[df_underworld_items] " .. player:get_player_name() .. " triggered a puzzle seal at " .. pos_string)
		minetest.set_node(pos, {name="df_underworld_items:digging_seal", param2 = math.random(1,4)-1})
		minetest.get_node_timer(pos):start(4)
		minetest.close_formspec(player:get_player_name(), formname)
	end
end)

-------------------------------------------------------------------------------------------------

local inscription_block_def = {
	description = S("Inscribed Slade Block"),
	_doc_items_longdesc = nil,
	_doc_items_usagehelp = nil,
	tiles = {
		"dfcaverns_slade_block.png",
		"dfcaverns_slade_block.png",
		"dfcaverns_slade_block.png^(dfcaverns_inscription_1.png^[opacity:128)",
		"dfcaverns_slade_block.png^(dfcaverns_inscription_2.png^[opacity:128)",
		"dfcaverns_slade_block.png^(dfcaverns_inscription_3.png^[opacity:128)",
		"dfcaverns_slade_block.png^(dfcaverns_inscription_4.png^[opacity:128)",
	},
	paramtype2 = "facedir",
	groups = slade_groups,
	sounds = default.node_sound_stone_defaults({ footstep = { name = "bedrock2_step", gain = 1 } }),
	is_ground_content = false,
	can_dig = can_dig,
	on_blast = function() end,
	on_rotate = function() return false end,
}

minetest.register_node("df_underworld_items:inscription_block", inscription_block_def)


local capstone_def = {
	description = S("Slade Capstone"),
	_doc_items_longdesc = nil,
	_doc_items_usagehelp = nil,
	drawtype = "mesh",
	mesh = "underworld_capstone.obj",
	tiles = {
		"dfcaverns_slade_block.png",
		"dfcaverns_slade_block.png"
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, 0, 0.5},
			{-0.25, 0, -0.25, 0.25, 0.5, 0.25},
		},
	},
	collision_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, 0, 0.5},
			{-0.25, 0, -0.25, 0.25, 0.5, 0.25},
		},
	},
	paramtype = "light",
	paramtype2 = "facedir",
	groups = slade_groups,
	light_source = 8,
	sounds = default.node_sound_stone_defaults({ footstep = { name = "bedrock2_step", gain = 1 } }),
	is_ground_content = false,
	can_dig = can_dig,
	on_blast = function() end,
	on_rotate = function() return false end,
}

minetest.register_node("df_underworld_items:slade_capstone", capstone_def)

-----------------------------------------------------------------------------------------
-- Schematics

local n1 = { name = "df_underworld_items:slade_block" }
local n5 = { name = "default:meselamp" }
local n6 = { name = "air", prob = 0 } -- ceiling pieces to leave in place
local n8 = { name = "df_underworld_items:puzzle_seal" }
local n3 = { name = "air"}
local n2 = n3
local n4 = n3
local n7 = n3
local n9 = n3
local n10 = n1
local n11 = n3

local n12 = { name = "df_underworld_items:inscription_block", param2 = 0 }
local n13 = { name = "df_underworld_items:inscription_block", param2 = 1 }
local n14 = { name = "df_underworld_items:inscription_block", param2 = 2 }
local n15 = { name = "df_underworld_items:inscription_block", param2 = 3 }
local n16 = { name = "df_underworld_items:slade_capstone"}

if minetest.get_modpath("stairs") then
	local stair_groups = {level = 3, mese_radiation_shield=1, pit_plasma_resistant=1, slade=1, cracky = 3}
	if invulnerable then
		stair_groups.immortal = 1
	end

	stairs.register_stair_and_slab(
		"slade_block",
		"df_underworld_items:slade_block",
		stair_groups,
		{"dfcaverns_slade_block.png"},
		S("Slade Block Stair"),
		S("Slade Block Slab"),
		default.node_sound_stone_defaults({ footstep = { name = "bedrock2_step", gain = 1 } })
	)
	
	if invulnerable then
		for name, def in pairs(minetest.registered_nodes) do
			if name:sub(1,7) == "stairs:" and name:sub(-11) == "slade_block" then
				minetest.override_item(name, {can_dig = can_dig})
			end
		end
	end
	
	n2 = { name = "stairs:stair_slade_block", param2 = 3 }
	n4 = { name = "stairs:stair_slade_block", param2 = 1 }
	n7 = { name = "stairs:stair_slade_block", param2 = 2 }
	n9 = { name = "stairs:stair_slade_block" }
	n10 = { name = "stairs:slab_slade_block", param2 = 21 }
	n11 = { name = "stairs:slab_slade_block", param2 = 1 }
end

df_underworld_items.seal_temple_schem = {
	size = {y = 6, x = 7, z = 7},
	data = {
		n15, n2, n3, n3, n3, n4, n14, n14, n3, n3, n3, n3, n3, n15, n13, n3, n3, 
		n3, n3, n3, n13, n16, n3, n3, n3, n3, n3, n16, n6, n6, n6, n6, n6, n6, 
		n6, n6, n6, n6, n6, n6, n6, n6, n7, n3, n3, n3, n3, n3, n7, n3, n3, 
		n3, n3, n3, n3, n3, n3, n3, n3, n3, n3, n3, n3, n3, n3, n3, n3, n3, 
		n3, n3, n6, n3, n3, n3, n3, n3, n6, n6, n6, n6, n6, n6, n6, n6, n3, 
		n3, n3, n3, n3, n3, n3, n3, n3, n3, n3, n3, n3, n3, n3, n3, n3, n3, 
		n3, n3, n3, n3, n3, n3, n3, n3, n3, n3, n6, n3, n3, n3, n3, n3, n6, 
		n6, n6, n3, n3, n3, n6, n6, n3, n3, n3, n8, n3, n3, n3, n3, n3, n3, 
		n3, n3, n3, n3, n3, n3, n3, n3, n3, n3, n3, n3, n3, n3, n3, n3, n3, 
		n3, n6, n3, n3, n3, n3, n3, n6, n6, n6, n3, n3, n3, n6, n6, n3, n3, 
		n3, n3, n3, n3, n3, n3, n3, n3, n3, n3, n3, n3, n3, n3, n3, n3, n3, 
		n3, n3, n3, n3, n3, n3, n3, n3, n3, n6, n3, n3, n3, n3, n3, n6, n6, 
		n6, n3, n3, n3, n6, n6, n9, n3, n3, n3, n3, n3, n9, n3, n3, n3, n3, 
		n3, n3, n3, n3, n3, n3, n3, n3, n3, n3, n3, n3, n3, n3, n3, n3, n3, 
		n6, n3, n3, n3, n3, n3, n6, n6, n6, n6, n6, n6, n6, n6, n12, n2, n3, 
		n3, n3, n4, n12, n14, n3, n3, n3, n3, n3, n15, n13, n3, n3, n3, n3, n3, 
		n12, n16, n3, n3, n3, n3, n3, n16, n6, n6, n6, n6, n6, n6, n6, n6, n6, 
		n6, n6, n6, n6, n6, 
	}
}

df_underworld_items.seal_stair_schem = {
	size = {y = 2, x = 7, z = 7},
	data = {
		n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n10, 
		n3, n3, n3, n1, n1, n3, n11, n1, n10, n3, n1, n1, n11, n3, n3, n3, n3, 
		n1, n1, n3, n3, n3, n3, n3, n1, n1, n3, n3, n3, n3, n3, n1, n1, n3, 
		n3, n3, n3, n3, n1, n1, n3, n3, n3, n3, n3, n1, n1, n3, n3, n3, n3, 
		n3, n1, n1, n3, n3, n3, n3, n3, n1, n1, n3, n3, n3, n3, n3, n1, n1, 
		n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, n1, 
	}
}