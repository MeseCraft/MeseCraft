
-- default support (for use with MineClone2 and other [games]
default = default or {
	node_sound_stone_defaults = function(table) end,
	node_sound_wood_defaults = function(table) end,
	gui_bg = "",
	gui_bg_img = "",
	gui_slots = "",
}

-- Load support for intllib.
local MP = minetest.get_modpath(minetest.get_current_modname())
local F = minetest.formspec_escape
local S = minetest.get_translator and minetest.get_translator("protector") or
		dofile(MP .. "/intllib.lua")

-- Load support for factions
local factions_available = minetest.global_exists("factions")

protector = {
	mod = "redo",
	modpath = MP,
	intllib = S
}

local protector_max_share_count = 12
-- get minetest.conf settings
local protector_radius = tonumber(minetest.settings:get("protector_radius")) or 5
local protector_flip = minetest.settings:get_bool("protector_flip") or false
local protector_hurt = tonumber(minetest.settings:get("protector_hurt")) or 0
local protector_spawn = tonumber(minetest.settings:get("protector_spawn")
	or minetest.settings:get("protector_pvp_spawn")) or 0
local protector_show = tonumber(minetest.settings:get("protector_show_interval")) or 5
local protector_recipe = minetest.settings:get_bool("protector_recipe") ~= false
local protector_msg = minetest.settings:get_bool("protector_msg") ~= false

-- radius limiter (minetest cannot handle node volume of more than 4096000)
if protector_radius > 22 then protector_radius = 22 end


-- get static spawn position
local statspawn = minetest.string_to_pos(minetest.settings:get("static_spawnpoint"))
		or {x = 0, y = 2, z = 0}


-- return list of members as a table
local get_member_list = function(meta)

	return meta:get_string("members"):split(" ")
end


-- write member list table in protector meta as string
local set_member_list = function(meta, list)

	meta:set_string("members", table.concat(list, " "))
end


-- check for owner name
local is_owner = function(meta, name)

	return name == meta:get_string("owner")
end


-- check for member name
-- check for member name
local is_member = function (meta, name)

	if factions_available
	and meta:get_int("faction_members") == 1 then

		if factions.version == nil then

			-- backward compatibility
			if factions.get_player_faction(name) ~= nil
			and factions.get_player_faction(meta:get_string("owner")) ==
					factions.get_player_faction(name) then
				return true
			end
		else
			-- is member if player and owner share at least one faction
			local owner_factions = factions.get_player_factions(name)
            local owner = meta:get_string("owner")
            if owner_factions ~= nil and owner_factions ~= false then

                for _, f in ipairs(owner_factions) do

                    if factions.player_is_in_faction(f, owner) then
                        return true
                    end
                end
            end
		end
	end

	for _, n in pairs(get_member_list(meta)) do

		if n == name then
			return true
		end
	end

	return false
end


-- add player name to table as member
local add_member = function(meta, name)

	-- Constant (20) defined by player.h
	if name:len() > 25 then
		return
	end

	-- does name already exist?
	if is_owner(meta, name)
	or is_member(meta, name) then
		return
	end

	local list = get_member_list(meta)

	if #list >= protector_max_share_count then
		return
	end

	table.insert(list, name)

	set_member_list(meta, list)
end


-- remove player name from table
local del_member = function(meta, name)

	local list = get_member_list(meta)

	for i, n in pairs(list) do

		if n == name then
			table.remove(list, i)
			break
		end
	end

	set_member_list(meta, list)
end


-- protector interface
local protector_formspec = function(meta)

	local formspec = "size[8,7]"
		.. default.gui_bg
		.. default.gui_bg_img
		.. default.gui_slots
		.. "label[2.5,0;" .. F(S("-- Protector interface --")) .. "]"
		.. "label[0,1;" .. F(S("PUNCH node to show protected area")) .. "]"
		.. "label[0,2;" .. F(S("Members:")) .. "]"
		.. "button_exit[2.5,6.2;3,0.5;close_me;" .. F(S("Close")) .. "]"
		.. "field_close_on_enter[protector_add_member;false]"

	local members = get_member_list(meta)
	local npp = protector_max_share_count -- max users added to protector list
	local i = 0
	local checkbox_faction = false

	-- Display the checkbox only if the owner is member of at least 1 faction
	if factions_available then

		if factions.version == nil then

			-- backward compatibility
			if factions.get_player_faction(meta:get_string("owner")) then
				checkbox_faction = true
			end
		else
	            if factions.get_player_factions(meta:get_string("owner")) ~= nil then
	                if next(factions.get_player_factions(meta:get_string("owner"))) then
	                    checkbox_faction = true
	                end
	            end
		end
	end
	if checkbox_faction then

		formspec = formspec .. "checkbox[0,5;faction_members;"
			.. F(S("Allow faction access"))
			.. ";" .. (meta:get_int("faction_members") == 1 and
					"true" or "false") .. "]"

		if npp > 8 then
			npp = 8
		end
	end

	for n = 1, #members do

		if i < npp then

			-- show username
			formspec = formspec .. "button[" .. (i % 4 * 2)
			.. "," .. math.floor(i / 4 + 3)
			.. ";1.5,.5;protector_member;" .. F(members[n]) .. "]"

			-- username remove button
			.. "button[" .. (i % 4 * 2 + 1.25) .. ","
			.. math.floor(i / 4 + 3)
			.. ";.75,.5;protector_del_member_" .. F(members[n]) .. ";X]"
		end

		i = i + 1
	end

	if i < npp then

		-- user name entry field
		formspec = formspec .. "field[" .. (i % 4 * 2 + 1 / 3) .. ","
		.. (math.floor(i / 4 + 3) + 1 / 3)
		.. ";1.433,.5;protector_add_member;;]"

		-- username add button
		.."button[" .. (i % 4 * 2 + 1.25) .. ","
		.. math.floor(i / 4 + 3) .. ";.75,.5;protector_submit;+]"

	end

	return formspec
end


-- check if pos is inside a protected spawn area
local inside_spawn = function(pos, radius)

	if protector_spawn <= 0 then
		return false
	end

	if pos.x < statspawn.x + radius
	and pos.x > statspawn.x - radius
	and pos.y < statspawn.y + radius
	and pos.y > statspawn.y - radius
	and pos.z < statspawn.z + radius
	and pos.z > statspawn.z - radius then

		return true
	end

	return false
end


-- show protection message if enabled
local show_msg = function(player, msg)

	-- if messages disabled or no player name provided
	if protector_msg == false or not player or player == "" then
		return
	end

	minetest.chat_send_player(player, msg)
end


-- Infolevel:
-- 0 for no info
-- 1 for "This area is owned by <owner> !" if you can't dig
-- 2 for "This area is owned by <owner>.
-- 3 for checking protector overlaps

protector.can_dig = function(r, pos, digger, onlyowner, infolevel)

	if not digger or not pos then
		return false
	end

	-- protector_bypass privileged users can override protection
	if infolevel == 1
	and minetest.check_player_privs(digger, {protection_bypass = true}) then
		return true
	end

	-- infolevel 3 is only used to bypass priv check, change to 1 now
	if infolevel == 3 then infolevel = 1 end

	-- is spawn area protected ?
	if inside_spawn(pos, protector_spawn) then

		show_msg(digger,
			S("Spawn @1 has been protected up to a @2 block radius.",
				minetest.pos_to_string(statspawn), protector_spawn))

		return false
	end

	-- find the protector nodes
	local pos = minetest.find_nodes_in_area(
		{x = pos.x - r, y = pos.y - r, z = pos.z - r},
		{x = pos.x + r, y = pos.y + r, z = pos.z + r},
		{"protector:protect", "protector:protect2", "protector:protect_hidden"})

	local meta, owner, members

	for n = 1, #pos do

		meta = minetest.get_meta(pos[n])
		owner = meta:get_string("owner") or ""
		members = meta:get_string("members") or ""

		-- node change and digger isn't owner
		if infolevel == 1 and owner ~= digger then

			-- and you aren't on the member list
			if onlyowner or not is_member(meta, digger) then

				show_msg(digger,
					S("This area is owned by @1", owner) .. "!")

				return false
			end
		end

		-- when using protector as tool, show protector information
		if infolevel == 2 then

			minetest.chat_send_player(digger,
				S("This area is owned by @1", owner) .. ".")

			minetest.chat_send_player(digger,
				S("Protection located at: @1", minetest.pos_to_string(pos[n])))

			if members ~= "" then

				minetest.chat_send_player(digger, S("Members: @1.", members))
			end

			return false
		end

	end

	-- show when you can build on unprotected area
	if infolevel == 2 then

		if #pos < 1 then

			minetest.chat_send_player(digger, S("This area is not protected."))
		end

		minetest.chat_send_player(digger, S("You can build here."))
	end

	return true
end


local old_is_protected = minetest.is_protected

-- check for protected area, return true if protected and digger isn't on list
function minetest.is_protected(pos, digger)

	digger = digger or "" -- nil check

	-- is area protected against digger?
	if not protector.can_dig(protector_radius, pos, digger, false, 1) then

		local player = minetest.get_player_by_name(digger)

		if player and player:is_player() then

			-- hurt player if protection violated
			if protector_hurt > 0 and player:get_hp() > 0 then

				-- This delay fixes item duplication bug (thanks luk3yx)
				minetest.after(0.1, function()
					player:set_hp(player:get_hp() - protector_hurt)
				end)
			end

			-- flip player when protection violated
			if protector_flip then

				-- yaw + 180°
				local yaw = player:get_look_horizontal() + math.pi

				if yaw > 2 * math.pi then
					yaw = yaw - 2 * math.pi
				end

				player:set_look_horizontal(yaw)

				-- invert pitch
				player:set_look_vertical(-player:get_look_vertical())

				-- if digging below player, move up to avoid falling through hole
				local pla_pos = player:get_pos()

				if pos.y < pla_pos.y then

					player:set_pos({
						x = pla_pos.x,
						y = pla_pos.y + 0.8,
						z = pla_pos.z
					})
				end
			end
		end

		return true
	end

	-- otherwise can dig or place
	return old_is_protected(pos, digger)
end


-- make sure protection block doesn't overlap another protector's area
local check_overlap = function(itemstack, placer, pointed_thing)

	if pointed_thing.type ~= "node" then
		return itemstack
	end

	local pos = pointed_thing.above
	local name = placer:get_player_name()

	-- make sure protector doesn't overlap onto protected spawn area
	if inside_spawn(pos, protector_spawn + protector_radius) then

		minetest.chat_send_player(name,
			S("Spawn @1 has been protected up to a @2 block radius.",
			minetest.pos_to_string(statspawn), protector_spawn))

		return itemstack
	end

	-- make sure protector doesn't overlap any other player's area
	if not protector.can_dig(protector_radius * 2, pos, name, true, 3) then

		minetest.chat_send_player(name,
			S("Overlaps into above players protected area"))

		return itemstack
	end

	return minetest.item_place(itemstack, placer, pointed_thing)

end


-- temporary pos store
local player_pos = {}

-- protection node
minetest.register_node("protector:protect", {
	description = S("Protection Block") .. " (" .. S("USE for area check") .. ")",
	drawtype = "nodebox",
	tiles = {
		"default_stone.png^protector_overlay.png",
		"default_stone.png^protector_overlay.png",
		"default_stone.png^protector_overlay.png^protector_logo.png"
	},
	sounds = default.node_sound_stone_defaults(),
	groups = {dig_immediate = 2, unbreakable = 1},
	is_ground_content = false,
	paramtype = "light",
	light_source = 4,

	node_box = {
		type = "fixed",
		fixed = {
			{-0.5 ,-0.5, -0.5, 0.5, 0.5, 0.5},
		}
	},

	on_place = check_overlap,

	after_place_node = function(pos, placer)

		local meta = minetest.get_meta(pos)

		meta:set_string("owner", placer:get_player_name() or "")
		meta:set_string("members", "")
		meta:set_string("infotext",
				S("Protection (owned by @1)", meta:get_string("owner")))
	end,

	on_use = function(itemstack, user, pointed_thing)

		if pointed_thing.type ~= "node" then
			return
		end

		protector.can_dig(protector_radius, pointed_thing.under,
				user:get_player_name(), false, 2)
	end,

	on_rightclick = function(pos, node, clicker, itemstack)

		local meta = minetest.get_meta(pos)
		local name = clicker:get_player_name()

		if meta
		and protector.can_dig(1, pos, name, true, 1) then

			player_pos[name] = pos

			minetest.show_formspec(name, "protector:node", protector_formspec(meta))
		end
	end,

	on_punch = function(pos, node, puncher)

		if minetest.is_protected(pos, puncher:get_player_name()) then
			return
		end

		minetest.add_entity(pos, "protector:display")
	end,

	can_dig = function(pos, player)

		return player and protector.can_dig(1, pos, player:get_player_name(), true, 1)
	end,

	on_blast = function() end,

	after_destruct = function(pos, oldnode)
		local objects = minetest.get_objects_inside_radius(pos, 0.5)
		for _, v in ipairs(objects) do
			if v:get_luaentity().name == "protector:display" then
				v:remove()
			end
		end
	end,
})

-- default recipe and alternative for MineClone2
if protector_recipe then
	if minetest.registered_items["default:stone"] then
	minetest.register_craft({
		output = "protector:protect",
		recipe = {
			{"default:stone", "default:stone", "default:stone"},
			{"default:stone", "default:gold_ingot", "default:stone"},
			{"default:stone", "default:stone", "default:stone"},
		}
	})
	else
	minetest.register_craft({
		output = "protector:protect",
		recipe = {
			{"mcl_core:stone", "mcl_core:stone", "mcl_core:stone"},
			{"mcl_core:stone", "mcl_core:gold_ingot", "mcl_core:stone"},
			{"mcl_core:stone", "mcl_core:stone", "mcl_core:stone"},
		}
	})
	end
end

-- protection logo
minetest.register_node("protector:protect2", {
	description = S("Protection Logo") .. " (" .. S("USE for area check") .. ")",
	tiles = {"protector_logo.png"},
	wield_image = "protector_logo.png",
	inventory_image = "protector_logo.png",
	sounds = default.node_sound_stone_defaults(),
	groups = {dig_immediate = 2, unbreakable = 1},
	paramtype = "light",
	paramtype2 = "wallmounted",
	legacy_wallmounted = true,
	light_source = 4,
	drawtype = "nodebox",
	sunlight_propagates = true,
	walkable = true,
	node_box = {
		type = "wallmounted",
		wall_top    = {-0.375, 0.4375, -0.5, 0.375, 0.5, 0.5},
		wall_bottom = {-0.375, -0.5, -0.5, 0.375, -0.4375, 0.5},
		wall_side   = {-0.5, -0.5, -0.375, -0.4375, 0.5, 0.375},
	},
	selection_box = {type = "wallmounted"},

	on_place = check_overlap,

	after_place_node = function(pos, placer)

		local meta = minetest.get_meta(pos)

		meta:set_string("owner", placer:get_player_name() or "")
		meta:set_string("members", "")
		meta:set_string("infotext",
				S("Protection (owned by @1)", meta:get_string("owner")))
	end,

	on_use = function(itemstack, user, pointed_thing)

		if pointed_thing.type ~= "node" then
			return
		end

		protector.can_dig(protector_radius, pointed_thing.under,
				user:get_player_name(), false, 2)
	end,

	on_rightclick = function(pos, node, clicker, itemstack)

		local meta = minetest.get_meta(pos)
		local name = clicker:get_player_name()

		if meta
		and protector.can_dig(1, pos, name, true, 1) then

			player_pos[name] = pos

			minetest.show_formspec(name, "protector:node", protector_formspec(meta))
		end
	end,

	on_punch = function(pos, node, puncher)

		if minetest.is_protected(pos, puncher:get_player_name()) then
			return
		end

		minetest.add_entity(pos, "protector:display")
	end,

	can_dig = function(pos, player)

		return player and protector.can_dig(1, pos, player:get_player_name(), true, 1)
	end,

	on_blast = function() end,

	after_destruct = function(pos, oldnode)
		local objects = minetest.get_objects_inside_radius(pos, 0.5)
		for _, v in ipairs(objects) do
        	if v ~= nil then
            	if v:get_luaentity() ~= nil then
                	if v:get_luaentity().name ~= nil then
                        if v:get_luaentity().name == "protector:display" then
                            v:remove()
                        end
                    end
                end
            end
	end
	end,
})

-- recipes to switch between protectors
minetest.register_craft({
	type = "shapeless",
	output = "protector:protect",
	recipe = {"protector:protect2"}
})

minetest.register_craft({
	type = "shapeless",
	output = "protector:protect2",
	recipe = {"protector:protect"}
})


-- check formspec buttons or when name entered
minetest.register_on_player_receive_fields(function(player, formname, fields)

	if formname ~= "protector:node" then
		return
	end

	local name = player:get_player_name()
	local pos = player_pos[name]

	if not name or not pos then
		return
	end

	local add_member_input = fields.protector_add_member

	-- reset formspec until close button pressed
	if (fields.close_me or fields.quit)
	and (not add_member_input or add_member_input == "") then
		player_pos[name] = nil
		return
	end

	-- only owner can add names
	if not protector.can_dig(1, pos, player:get_player_name(), true, 1) then
		return
	end

	-- are we adding member to a protection node ? (csm protection)
	local nod = minetest.get_node(pos).name

	if nod ~= "protector:protect"
	and nod ~= "protector:protect2" then
		player_pos[name] = nil
		return
	end

	local meta = minetest.get_meta(pos)

	if not meta then
		return
	end

	-- add faction members
	if factions_available then
		meta:set_int("faction_members", fields.faction_members == "true" and 1 or 0)
	end

	-- add member [+]
	if add_member_input then

		for _, i in pairs(add_member_input:split(" ")) do
			add_member(meta, i)
		end
	end

	-- remove member [x]
	for field, value in pairs(fields) do

		if string.sub(field, 0,
			string.len("protector_del_member_")) == "protector_del_member_" then

			del_member(meta,
				string.sub(field,string.len("protector_del_member_") + 1))
		end
	end

	minetest.show_formspec(name, formname, protector_formspec(meta))
end)


-- display entity shown when protector node is punched
minetest.register_entity("protector:display", {
	physical = false,
	collisionbox = {0, 0, 0, 0, 0, 0},
	visual = "wielditem",
	-- wielditem seems to be scaled to 1.5 times original node size
	visual_size = {x = 0.67, y = 0.67},
	textures = {"protector:display_node"},
	timer = 0,
	glow = 10,

	on_step = function(self, dtime)

		self.timer = self.timer + dtime

		-- remove after set number of seconds
		if self.timer > protector_show then
			self.object:remove()
		end
	end,
})


-- Display-zone node, Do NOT place the display as a node,
-- it is made to be used as an entity (see above)

local x = protector_radius
minetest.register_node("protector:display_node", {
	tiles = {"protector_display.png"},
	use_texture_alpha = "clip",
	walkable = false,
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			-- sides
			{-(x+.55), -(x+.55), -(x+.55), -(x+.45), (x+.55), (x+.55)},
			{-(x+.55), -(x+.55), (x+.45), (x+.55), (x+.55), (x+.55)},
			{(x+.45), -(x+.55), -(x+.55), (x+.55), (x+.55), (x+.55)},
			{-(x+.55), -(x+.55), -(x+.55), (x+.55), (x+.55), -(x+.45)},
			-- top
			{-(x+.55), (x+.45), -(x+.55), (x+.55), (x+.55), (x+.55)},
			-- bottom
			{-(x+.55), -(x+.55), -(x+.55), (x+.55), -(x+.45), (x+.55)},
			-- middle (surround protector)
			{-.55,-.55,-.55, .55,.55,.55},
		},
	},
	selection_box = {
		type = "regular",
	},
	paramtype = "light",
	groups = {dig_immediate = 3, not_in_creative_inventory = 1},
	drop = "",
})


dofile(MP .. "/doors_chest.lua")
dofile(MP .. "/pvp.lua")
dofile(MP .. "/admin.lua")
dofile(MP .. "/tool.lua")
dofile(MP .. "/hud.lua")
dofile(MP .. "/lucky_block.lua")


-- stop mesecon pistons from pushing protectors
if minetest.get_modpath("mesecons_mvps") then
	mesecon.register_mvps_stopper("protector:protect")
	mesecon.register_mvps_stopper("protector:protect2")
	mesecon.register_mvps_stopper("protector:chest")
end


print (S("[MOD] Protector Redo loaded"))
