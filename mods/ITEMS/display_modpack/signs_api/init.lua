--[[
    signs mod for Minetest - Various signs with text displayed on
    (c) Pierre-Yves Rollo

    This file is part of signs.

    signs is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    signs is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with signs.  If not, see <http://www.gnu.org/licenses/>.
--]]

signs_api = {}
signs_api.name = minetest.get_current_modname()
signs_api.path = minetest.get_modpath(signs_api.name)

-- Load support for intllib.
local S, NS = dofile(signs_api.path.."/intllib.lua")
signs_api.intllib = S
local F = function(...) return minetest.formspec_escape(S(...)) end

function signs_api.set_display_text(pos, text, font)
	local meta = minetest.get_meta(pos)
	meta:set_string("display_text", text)
	if text and text ~= "" then
		meta:set_string("infotext", "\""..text.."\"")
	else
		meta:set_string("infotext", "")
	end
	if font then
		meta:set_string("font", font)
	end
	display_api.update_entities(pos)
end

function signs_api.set_formspec(pos)
	local meta = minetest.get_meta(pos)
	local ndef = minetest.registered_nodes[minetest.get_node(pos).name]
	if ndef and ndef.display_entities
	   and ndef.display_entities["signs:display_text"] then
		local maxlines = ndef.display_entities["signs:display_text"].maxlines
		local fs, y

		if maxlines == 1 then
			fs = "field[0.5,0.7;5.5,1;display_text;"..F("Text")..
				";${display_text}]"
			y = 1.2
		else
			local extralabel = ""
			if maxlines then
				extralabel = F(" (first %s lines only)"):format(maxlines)
			end

			fs = "textarea[0.5,0.7;5.5,2;display_text;"..F("Text")..""..
					extralabel..";${display_text}]"
			y = 2.4
		end

		fs = fs.."button[1,"..y..";2,1;font;"..F("Font").."]"
		fs = fs.."button_exit[3,"..y..";2,1;ok;"..F("Write").."]"
		y = y + 0.8
		fs = "size[6,"..y.."]"..default.gui_bg..
			default.gui_bg_img..default.gui_slots..fs

		meta:set_string("formspec", fs)
	end
end

function signs_api.on_receive_fields(pos, formname, fields, player)
	if not minetest.is_protected(pos, player:get_player_name()) then
		if fields and (fields.ok or fields.key_enter) then
			signs_api.set_display_text(pos, fields.display_text)
		end
		if fields and (fields.font) then
			signs_api.set_display_text(pos, fields.display_text)
			font_api.show_font_list(player, pos)
		end
	end
end

-- On place callback for direction signs
-- (chooses which sign according to look direction)
function signs_api.on_place_direction(itemstack, placer, pointed_thing)
	local name = itemstack:get_name()
	local ndef = minetest.registered_nodes[name]
	local restriction = display_api.is_rotation_restricted()

	local bdir = {
		x = pointed_thing.under.x - pointed_thing.above.x,
		y = pointed_thing.under.y - pointed_thing.above.y,
		z = pointed_thing.under.z - pointed_thing.above.z}

	local pdir = placer:get_look_dir()

	local ndir, test

	if ndef.paramtype2 == "facedir" then
		-- If legacy mode, only accept upright nodes
		if restriction and bdir.x == 0 and bdir.z == 0 then
			-- Ceiling or floor pointed (facedir chosen from player dir)
			ndir = minetest.dir_to_facedir({x=pdir.x, y=0, z=pdir.z})
		else
			-- Wall pointed or no rotation restriction
			ndir = minetest.dir_to_facedir(bdir, not restriction)
		end

		test = { [0]=-pdir.x, pdir.z, pdir.x, -pdir.z, -pdir.x, [8]=pdir.x }
	end

	if ndef.paramtype2 == "wallmounted" then
		ndir = minetest.dir_to_wallmounted(bdir)
		-- If legacy mode, only accept upright nodes
		if restriction and (ndir == 0 or ndir == 1) then
			ndir = minetest.dir_to_wallmounted({x=pdir.x, y=0, z=pdir.z})
		end

		test = { [0]=-pdir.x, -pdir.x, pdir.z, -pdir.z, -pdir.x, pdir.x}
	end

	-- Only for direction signs
	-- TODO:Maybe improve ground and ceiling placement in every directions
	if ndef.signs_other_dir then
		if test[ndir] > 0 then
			itemstack:set_name(ndef.signs_other_dir)
		end
		itemstack = minetest.item_place(itemstack, placer, pointed_thing, ndir)
		itemstack:set_name(name)

		return itemstack
	else
		return minetest.item_place(itemstack, placer, pointed_thing, ndir)
	end
end

-- Handles screwdriver rotation
-- (see "if" block below for rotation restriction mode).
signs_api.on_rotate = function(pos, node, player, mode, new_param2)
	-- If rotation mode is 1 and sign is directional, swap direction between
	-- each rotation.
	if mode == 1 then
		local ndef = minetest.registered_nodes[node.name]
		if ndef.signs_other_dir then
			-- Switch direction
			node = {name = ndef.signs_other_dir,
				param1 = node.param1, param2 = node.param2}
			minetest.swap_node(pos, node)
			display_api.update_entities(pos)
			-- Rotate only if not "main" sign
			-- TODO:Improve detection of "main" direction sign
			if ndef.groups and ndef.groups.not_in_creative_inventory then
				return display_api.on_rotate(pos, node, player, mode, new_param2)
			else
				return true
			end
		end
	end
	return display_api.on_rotate(pos, node, player, mode, new_param2)
end

-- Legacy mode with rotation restriction
-- TODO:When MT < 5.0 no more in use, to be removed
if display_api.is_rotation_restricted() then
	signs_api.on_rotate = function(pos, node, player, mode, new_param2)
		-- If rotation mode is 2 and sign is directional, swap direction.
		-- Otherwise use display_api's on_rotate function.
		if mode == 2 then
			local ndef = minetest.registered_nodes[node.name]
			if ndef.signs_other_dir then
				minetest.swap_node(pos, {name = ndef.signs_other_dir,
					param1 = node.param1, param2 = node.param2})
				display_api.update_entities(pos)
				return true
			end
		end
		return display_api.on_rotate(pos, node, player, mode, new_param2)
	end
end

function signs_api.register_sign(mod, name, model)
	-- Default fields
	local fields = {
		sunlight_propagates = true,
		paramtype = "light",
		paramtype2 = "facedir",
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {-model.width/2, -model.height/2, 0.5,
					 model.width/2, model.height/2, 0.5 - model.depth},
		},
		groups = {choppy=2, dig_immediate=2, not_blocking_trains=1, display_api=1},
		sounds = default.node_sound_defaults(),
		display_entities = {
			["signs:display_text"] = {
					on_display_update = font_api.on_display_update,
					depth = 0.5 - display_api.entity_spacing - model.depth,
					size = { x = model.width, y = model.height },
					aspect_ratio = 1/2,
					maxlines = 1,
			},

		},
		on_place = display_api.on_place,
		on_construct = 	function(pos)
				local ndef = minetest.registered_nodes[minetest.get_node(pos).name]
				local meta = minetest.get_meta(pos)
				meta:set_string("font", ndef.display_entities.font_name or
				                        font_api.get_default_font_name())
				signs_api.set_formspec(pos)
				display_api.on_construct(pos)
			end,
		on_destruct = display_api.on_destruct,
		on_rotate = signs_api.on_rotate,
		on_receive_fields =  signs_api.on_receive_fields,
		on_punch = function(pos, node, player, pointed_thing)
				signs_api.set_formspec(pos)
				display_api.update_entities(pos)
			end,
	}

	-- Node fields override
	for key, value in pairs(model.node_fields) do
		if key == "groups" then
			for key2, value2 in pairs(value) do
				fields[key][key2] = value2
			end
		else
			fields[key] = value
		end
	end

	if not fields.wield_image then fields.wield_image = fields.inventory_image end

	-- Entity fields override
	for key, value in pairs(model.entity_fields) do
		fields.display_entities["signs:display_text"][key] = value
	end

	minetest.register_node(mod..":"..name, fields)
end

-- Text entity for all signs
display_api.register_display_entity("signs:display_text")
