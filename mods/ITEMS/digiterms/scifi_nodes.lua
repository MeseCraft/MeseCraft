--[[
    font_api mod for Minetest - Library to add font display capability
    to display_api mod.
    (c) Pierre-Yves Rollo

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
--]]

digiterms.register_monitor("digiterms:scifi_glassscreen", {
  description = "Digiline glassscreen",
	paramtype = "light",
	paramtype2 = "facedir",
  use_texture_alpha = true,
	sunlight_propagates = true,
  light_source = 15,
  tiles = {
    "digiterms_scifi_glscrn.png",
    "digiterms_scifi_glscrn.png",
    "digiterms_scifi_glscrn.png",
    "digiterms_scifi_glscrn.png",
    "digiterms_scifi_glscrn.png",
    "digiterms_scifi_glscrn.png",
  },
  drawtype = "nodebox",
  node_box = {
    type = "fixed",
    fixed = {
      {-0.4375, -0.5, -0.125, 0.4375, -0.1875, 0.0625}, -- NodeBox1
      {-0.375, -0.5, -0.0625, 0.375, 0.5, 0}, -- NodeBox10
    }
  },
  sounds = default.node_sound_glass_defaults(),
	groups = {choppy = 1, oddly_breakable_by_hand = 1},
	display_entities = {
		["digiterms:screen"] = {
				on_display_update = font_api.on_display_update,
				depth = -1/32,
				top = -5/32,
				size = { x = 23/32, y = 10/16 },
				columns = 20, lines = 4,
				color = "#76EDCD", font_name = digiterms.font, halign="left", valing="top",
		},
	},
})

digiterms.register_monitor("digiterms:scifi_widescreen", {
	description = "Digiline widescreen",
	tiles = {
		"scifi_nodes_black.png",
		"scifi_nodes_black.png",
		"scifi_nodes_black.png",
		"scifi_nodes_black.png",
		"scifi_nodes_black.png",
		"digiterms_scifi_widescreen.png"
	},
	drawtype = "nodebox",
	paramtype = "light",
	light_source = 5,
	paramtype2 = "facedir",
	sunlight_propagates = true,
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.3125, 0.4375, 0.375, 0.3125, 0.5}, -- NodeBox1
			{-0.5, -0.375, 0.375, -0.375, 0.375, 0.5}, -- NodeBox2
			{0.375, -0.375, 0.375, 0.5, 0.375, 0.5}, -- NodeBox3
			{-0.3125, 0.25, 0.375, 0.3125, 0.375, 0.5}, -- NodeBox4
			{-0.3125, -0.375, 0.375, 0.25, -0.25, 0.5}, -- NodeBox5
			{-0.5, -0.3125, 0.375, 0.5, -0.25, 0.5}, -- NodeBox6
			{-0.5, 0.25, 0.375, 0.5, 0.3125, 0.5}, -- NodeBox7
		}
	},
	groups = {cracky=1, oddly_breakable_by_hand=1},
  display_entities = {
		["digiterms:screen"] = {
				on_display_update = font_api.on_display_update,
        depth = 7/16 - display_api.entity_spacing,
				size = { x = 11/16, y = 8/16 },
				columns = 12, lines = 2,
        color = "#72ba9a", font_name = digiterms.font, halign="left", valing="top",
		},
	},
})

digiterms.register_monitor("digiterms:scifi_tallscreen", {
	description = "Digiline tallscreen",
	tiles = {
		"scifi_nodes_black.png",
		"scifi_nodes_black.png",
		"scifi_nodes_black.png",
		"scifi_nodes_black.png",
		"scifi_nodes_black.png",
		"digiterms_scifi_tallscreen.png"
	},
	drawtype = "nodebox",
	light_source = 5,
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	node_box = {
		type = "fixed",
		fixed = {
			{-0.3125, -0.375, 0.4375, 0.3125, 0.375, 0.5}, -- NodeBox1
			{-0.375, 0.375, 0.375, 0.375, 0.5, 0.5}, -- NodeBox2
			{-0.375, -0.5, 0.375, 0.375, -0.375, 0.5}, -- NodeBox3
			{0.25, -0.3125, 0.375, 0.375, 0.3125, 0.5}, -- NodeBox4
			{-0.375, -0.25, 0.375, -0.25, 0.3125, 0.5}, -- NodeBox5
			{-0.3125, -0.5, 0.375, -0.25, 0.5, 0.5}, -- NodeBox6
			{0.25, -0.5, 0.375, 0.3125, 0.5, 0.5}, -- NodeBox7
		}
	},
	groups = {cracky=1, oddly_breakable_by_hand=1},
  display_entities = {
    ["digiterms:screen"] = {
        on_display_update = font_api.on_display_update,
        depth = 7/16 - display_api.entity_spacing,
        size = { x = 7/16, y = 12/16 },
        columns = 8, lines = 3,
        color = "#72ba9a", font_name = digiterms.font, halign="left", valing="top",
    },
  },
})

digiterms.register_monitor("digiterms:scifi_keysmonitor", {
	description = "Digiline keyboard and monitor",
	tiles = {
		"scifi_nodes_keyboard.png",
		"scifi_nodes_black.png",
		"scifi_nodes_black.png",
		"scifi_nodes_black.png",
		"scifi_nodes_black.png",
		"digiterms_scifi_monitor.png"
	},
	drawtype = "nodebox",
	paramtype = "light",
	sunlight_propagates = true,
	paramtype2 = "facedir",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.4375, 0.5, -0.4375, -0.0625}, -- NodeBox1
			{-0.125, -0.5, 0.375, 0.125, 0.0625, 0.4375}, -- NodeBox2
			{-0.25, -0.5, 0.125, 0.25, -0.4375, 0.5}, -- NodeBox3
			{-0.5, -0.3125, 0.25, 0.5, 0.5, 0.375}, -- NodeBox4
		}
	},
	groups = {cracky=1, oddly_breakable_by_hand=1},
  display_entities = {
		["digiterms:screen"] = {
				on_display_update = font_api.on_display_update,
				depth = 4/16 - display_api.entity_spacing,
				top = -5/32,
				size = { x = 10/16, y = 7/16 },
				columns = 16, lines = 3,
				color = "#B4F1EC", font_name = digiterms.font, halign="left", valing="top",
		},
	},
})
