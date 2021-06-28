--[[
	digiterms mod for Minetest - Digilines monitors using Display API / Font API
	(c) Pierre-Yves Rollo

	This file is part of digiterms.

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

local cathodic_node_box = {
	type = "fixed",
	fixed = {
		{-8/16, 8/16, -8/16, 8/16, 7/16, -7/16},
		{-8/16, -8/16, -8/16, 8/16, -5/16, -7/16},
		{-8/16, 7/16, -8/16, -7/16, -5/16, -7/16},
		{7/16, 7/16, -8/16, 8/16, -5/16, -7/16},
		{-8/16, -8/16, -7/16, 8/16, 8/16, 1/16},
		{-6/16, 5/16, 1/16, 6/16, -8/16, 8/16}
	}
}
local cathodic_collision_box = {
	type = "fixed",
	fixed = {
		{-8/16, -8/16, -8/16, 8/16, 8/16, 1/16},
		{-6/16, 5/16, 1/16, 6/16, -8/16, 8/16}
	}
}

local lcd_node_box = {
	type = "fixed",
	fixed = {
		{-7/16, 8/16, 13/32, 7/16, 7/16, 7/16},
		{-7/16, -13/32, 13/32, 7/16, -8/16, 7/16},
		{-8/16, 8/16, 13/32, -7/16, -8/16, 7/16},
		{7/16, 8/16, 13/32, 8/16, -8/16, 7/16},
		{-8/16, -8/16, 7/16, 8/16, 8/16, 8/16},
	}
}

local lcd_collision_box = {
	type = "fixed",
	fixed = {
		{-8/16, -8/16, 13/32, 8/16, 8/16, 8/16},
	}
}

digiterms.register_monitor('digiterms:lcd_monitor', {
	description = "LCD monitor",
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = false,
	drawtype = "nodebox",
	groups = {oddly_breakable_by_hand = 3},
	node_box = lcd_node_box,
	collision_box = lcd_collision_box,
	selection_box = lcd_collision_box,
	display_entities = {
		["digiterms:screen"] = {
				on_display_update = font_api.on_display_update,
				depth = 7/16 - display_api.entity_spacing,
				top = -1/128, right = 1/128,
				size = { x = 12/16, y = 12/16 },
				columns = 12, lines = 6,
				color = "#203020", font_name = digiterms.font, halign="left", valing="top",
		},
	},
}, {
	tiles = { "digiterms_lcd_sides.png", "digiterms_lcd_sides.png",
						"digiterms_lcd_sides.png", "digiterms_lcd_sides.png",
						"digiterms_lcd_back.png",  "digiterms_lcd_front.png" },
}, {
	tiles = { "digiterms_lcd_sides.png", "digiterms_lcd_sides.png",
						"digiterms_lcd_sides.png", "digiterms_lcd_sides.png",
						"digiterms_lcd_back.png",  "digiterms_lcd_front_off.png" },
})
digiterms.register_monitor('digiterms:cathodic_beige_monitor', {
	description = "Beige cathodic monitor with amber screen",
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = false,
	drawtype = "nodebox",
	groups = {oddly_breakable_by_hand = 3},
	node_box = cathodic_node_box,
	collision_box = cathodic_collision_box,
	selection_box = cathodic_collision_box,
	display_entities = {
		["digiterms:screen"] = {
				on_display_update = font_api.on_display_update,
				depth = -7/16 - display_api.entity_spacing,
				top = -1/16,
				size = { x = 23/32, y = 10/16 },
				columns = 20, lines = 6,
				color = "#FFA000", font_name = digiterms.font, halign="left", valing="top",
		},
	},
}, {
	tiles = { "digiterms_beige_top.png",   "digiterms_beige_bottom.png",
						"digiterms_beige_sides.png", "digiterms_beige_sides.png^[transformFX]",
						"digiterms_beige_back.png",  "digiterms_beige_front.png",},
}, {
	tiles = { "digiterms_beige_top.png",   "digiterms_beige_bottom.png",
						"digiterms_beige_sides.png", "digiterms_beige_sides.png^[transformFX]",
						"digiterms_beige_back.png",  "digiterms_beige_front_off.png",},
})
minetest.register_alias('digiterms:cathodic_amber_monitor', 'digiterms:cathodic_beige_monitor')
minetest.register_alias('digiterms:cathodic_amber_monitor_off', 'digiterms:cathodic_beige_monitor_off')

digiterms.register_monitor('digiterms:cathodic_white_monitor', {
	description = "White cathodic monitor with green screen",
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = false,
	drawtype = "nodebox",
	groups = {oddly_breakable_by_hand = 3},
	node_box = cathodic_node_box,
	collision_box = cathodic_collision_box,
	selection_box = cathodic_collision_box,
	display_entities = {
		["digiterms:screen"] = {
				on_display_update = font_api.on_display_update,
				depth = -7/16 - display_api.entity_spacing,
				top = -1/16,
				size = { x = 23/32, y = 10/16 },
				columns = 20, lines = 6,
				color = "#00FF00", font_name = digiterms.font, halign="left", valing="top",
		},
	},
}, {
	tiles = { "digiterms_white_top.png",   "digiterms_white_bottom.png",
						"digiterms_white_sides.png", "digiterms_white_sides.png^[transformFX]",
						"digiterms_white_back.png",  "digiterms_white_front.png",},
}, {
	tiles = { "digiterms_white_top.png", "digiterms_white_bottom.png",
						"digiterms_white_sides.png", "digiterms_white_sides.png^[transformFX]",
						"digiterms_white_back.png", "digiterms_white_front_off.png",},
})
minetest.register_alias('digiterms:cathodic_green_monitor', 'digiterms:cathodic_white_monitor')
minetest.register_alias('digiterms:cathodic_green_monitor_off', 'digiterms:cathodic_white_monitor_off')

digiterms.register_monitor('digiterms:cathodic_black_monitor', {
	description = "Black cathodic monitor with white screen",
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = false,
	drawtype = "nodebox",
	groups = {oddly_breakable_by_hand = 3},
	node_box = cathodic_node_box,
	collision_box = cathodic_collision_box,
	selection_box = cathodic_collision_box,
	display_entities = {
		["digiterms:screen"] = {
				on_display_update = font_api.on_display_update,
				depth = -7/16 - display_api.entity_spacing,
				top = -1/16,
				size = { x = 23/32, y = 10/16 },
				columns = 20, lines = 6,
				color = "#D0D0D0", font_name = digiterms.font, halign="left", valing="top",
		},
	},
}, {
	tiles = { "digiterms_black_top.png",   "digiterms_black_bottom.png",
						"digiterms_black_sides.png", "digiterms_black_sides.png^[transformFX]",
						"digiterms_black_back.png",  "digiterms_black_front.png",},
}, {
	tiles = { "digiterms_black_top.png", "digiterms_black_bottom.png",
						"digiterms_black_sides.png", "digiterms_black_sides.png^[transformFX]",
						"digiterms_black_back.png", "digiterms_black_front_off.png",},
})

-- KEYBOARDS

local keyboard_on_rightclick = function(pos, node, player, itemstack, pointed_thing)
	if not minetest.is_player(player) then
		return
	end
	local name = player:get_player_name()
	local context = digiterms.get_player_context(name)
	context.formname = 'digiterms:keyboard'
	context.pos = pos

	local owned = not minetest.is_protected(context.pos, name)
	local protected = minetest.is_protected(context.pos, '')
	local meta = minetest.get_meta(pos)
	local channel = meta:get_string('channel')
	local public = meta:get_string('public')

	if owned then
		local fs = "size[8,5]"..
			default.gui_bg..default.gui_bg_img..default.gui_slots..
			"field[1,1;3,1;channel;Channel;"..channel.."]"..
			"field[1,3;6.5,1;text;Type text:;]"..
			"field_close_on_enter[text;true]button_exit[2.5,4;3,1;send;Send]"
		if protected then
			fs = fs.."checkbox[4,0.6;public;Public keyboard;"..public.."]"
		end
		minetest.show_formspec(name, context.formname, fs)
	else
		if public == 'true' and channel ~= '' then
			minetest.show_formspec(name, context.formname, "size[8,3]"..
				default.gui_bg..default.gui_bg_img..default.gui_slots..
				"field[1,1;6.5,1;text;Type text:;]"..
				"field_close_on_enter[text;true]button_exit[2.5,2;3,1;send;Send]")
		end
	end
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
		if formname ~= 'digiterms:keyboard' or not minetest.is_player(player) then
			return
		end
		local name = player:get_player_name()
		local context = digiterms.get_player_context(name)
		if context.formname ~= formname then
			return
		end

		local owned = not minetest.is_protected(context.pos, name)
		local protected = minetest.is_protected(context.pos, '')
		local meta = minetest.get_meta(context.pos)
		if owned then
			if fields.channel ~= nil and fields.channel ~= '' then
				meta:set_string("channel", fields.channel)
			end
			if fields.public ~= nil and protected then
				meta:set_string("public", fields.public)
			end
		end

		local channel = meta:get_string("channel")

		if fields.text and channel ~= '' and
			(owned or meta:get_string("public") == 'true') then
			digiline:receptor_send(context.pos, digiline.rules.default, channel, fields.text)
		end
		return true
	end)


minetest.register_node('digiterms:beige_keyboard', {
	description = "Beige keyboard",
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = false,
	tiles = { "digiterms_beige_keyboard_top.png",   "digiterms_beige_keyboard_bottom.png",
						"digiterms_beige_keyboard_sides.png", "digiterms_beige_keyboard_sides.png",
						"digiterms_beige_keyboard_sides.png", "digiterms_beige_keyboard_sides.png",},
	drawtype = "nodebox",
	groups = {oddly_breakable_by_hand = 3},
	node_box = {
		type = "fixed",
		fixed = {
			{-8/16,  -8/16, -1/16, 8/16, -6/16, 7/16},
			{-7/16,  -12/32, 0, 7/16, -11/32, 6/16},
		}
	},
	on_rightclick = keyboard_on_rightclick,
	digiline =
	{
		receptor = {}
	},
})

minetest.register_node('digiterms:white_keyboard', {
	description = "White keyboard",
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = false,
	tiles = { "digiterms_white_keyboard_top.png",   "digiterms_white_keyboard_bottom.png",
						"digiterms_white_keyboard_sides.png", "digiterms_white_keyboard_sides.png",
						"digiterms_white_keyboard_sides.png", "digiterms_white_keyboard_sides.png",},
	drawtype = "nodebox",
	groups = {oddly_breakable_by_hand = 3},
	node_box = {
		type = "fixed",
		fixed = {
			{-8/16,  -8/16, -1/16, 8/16, -6/16, 7/16},
			{-7/16,  -12/32, 0, 7/16, -11/32, 6/16},
		}
	},
	on_rightclick = keyboard_on_rightclick,
	digiline =
	{
		receptor = {}
	},
})

minetest.register_node('digiterms:black_keyboard', {
	description = "Black keyboard",
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = false,
	tiles = { "digiterms_black_keyboard_top.png",   "digiterms_black_keyboard_bottom.png",
						"digiterms_black_keyboard_sides.png", "digiterms_black_keyboard_sides.png",
						"digiterms_black_keyboard_sides.png", "digiterms_black_keyboard_sides.png",},
	drawtype = "nodebox",
	groups = {oddly_breakable_by_hand = 3},
	node_box = {
		type = "fixed",
		fixed = {
			{-8/16,  -8/16, -1/16, 8/16, -6/16, 7/16},
			{-7/16,  -12/32, 0, 7/16, -11/32, 6/16},
		}
	},
	on_rightclick = keyboard_on_rightclick,
	digiline =
	{
		receptor = {}
	},
})
