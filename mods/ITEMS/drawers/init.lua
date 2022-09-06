--[[
Minetest Mod Storage Drawers - A Mod adding storage drawers

Copyright (C) 2017-2020 Linus Jahn <lnj@kaidan.im>

MIT License

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]

-- Load support for intllib.
local MP = core.get_modpath(core.get_current_modname())
local S, NS = dofile(MP.."/intllib.lua")

drawers = {}
drawers.drawer_visuals = {}

drawers.WOOD_ITEMSTRING = "group:wood"
if core.get_modpath("default") and default then
	drawers.WOOD_SOUNDS = default.node_sound_wood_defaults()
	drawers.CHEST_ITEMSTRING = "default:chest"
elseif core.get_modpath("mcl_core") and mcl_core then -- MineClone 2
	drawers.CHEST_ITEMSTRING = "mcl_chests:chest"
	if core.get_modpath("mcl_sounds") and mcl_sounds then
		drawers.WOOD_SOUNDS = mcl_sounds.node_sound_wood_defaults()
	end
else
	drawers.CHEST_ITEMSTRING = "chest"
end


drawers.enable_1x1 = not core.settings:get_bool("drawers_disable_1x1")
drawers.enable_1x2 = not core.settings:get_bool("drawers_disable_1x2")
drawers.enable_2x2 = not core.settings:get_bool("drawers_disable_2x2")

drawers.CONTROLLER_RANGE = 14

--
-- GUI
--

drawers.gui_bg = "bgcolor[#080808BB;true]"
drawers.gui_slots = "listcolors[#00000069;#5A5A5A;#141318;#30434C;#FFF]"
if (core.get_modpath("mcl_core")) and mcl_core then -- MCL2
	drawers.gui_bg_img = "background[5,5;1,1;crafting_creative_bg.png;true]"
else
	drawers.gui_bg_img = "background[5,5;1,1;gui_formbg.png;true]"
end

--
-- Load API
--

dofile(MP .. "/lua/helpers.lua")
dofile(MP .. "/lua/visual.lua")
dofile(MP .. "/lua/api.lua")
dofile(MP .. "/lua/controller.lua")


--
-- Register drawers
--

if core.get_modpath("default") and default then
	drawers.register_drawer("drawers:wood", {
		description = S("Wooden"),
		tiles1 = drawers.node_tiles_front_other("drawers_wood_front_1.png",
			"drawers_wood.png"),
		tiles2 = drawers.node_tiles_front_other("drawers_wood_front_2.png",
			"drawers_wood.png"),
		tiles4 = drawers.node_tiles_front_other("drawers_wood_front_4.png",
			"drawers_wood.png"),
		groups = {choppy = 3, oddly_breakable_by_hand = 2},
		sounds = drawers.WOOD_SOUNDS,
		drawer_stack_max_factor = 32, -- 4 * 8 normal chest size
		material = drawers.WOOD_ITEMSTRING
	})
end


--
-- Register drawer upgrades
--

if core.get_modpath("default") and default then
	drawers.register_drawer_upgrade("drawers:upgrade_steel", {
		description = S("Steel Drawer Upgrade (x2)"),
		inventory_image = "drawers_upgrade_steel.png",
		groups = {drawer_upgrade = 100},
		recipe_item = "default:steel_ingot"
	})

	drawers.register_drawer_upgrade("drawers:upgrade_gold", {
		description = S("Gold Drawer Upgrade (x3)"),
		inventory_image = "drawers_upgrade_gold.png",
		groups = {drawer_upgrade = 200},
		recipe_item = "default:gold_ingot"
	})

	drawers.register_drawer_upgrade("drawers:upgrade_obsidian", {
		description = S("Obsidian Drawer Upgrade (x4)"),
		inventory_image = "drawers_upgrade_obsidian.png",
		groups = {drawer_upgrade = 300},
		recipe_item = "default:obsidian"
	})

	drawers.register_drawer_upgrade("drawers:upgrade_diamond", {
		description = S("Diamond Drawer Upgrade (x8)"),
		inventory_image = "drawers_upgrade_diamond.png",
		groups = {drawer_upgrade = 700},
		recipe_item = "default:diamond"
	})
end

if core.get_modpath("moreores") then
	drawers.register_drawer_upgrade("drawers:upgrade_mithril", {
		description = S("Mithril Drawer Upgrade (x13)"),
		inventory_image = "drawers_upgrade_mithril.png",
		groups = {drawer_upgrade = 1200},
		recipe_item = "moreores:mithril_ingot"
	})
end

--
-- Register drawer upgrade template
--

core.register_craftitem("drawers:upgrade_template", {
	description = S("Drawer Upgrade Template"),
	inventory_image = "drawers_upgrade_template.png"
})

core.register_craft({
	output = "drawers:upgrade_template 4",
	recipe = {
		{"group:stick", "group:stick", "group:stick"},
		{"group:stick", "group:drawer", "group:stick"},
		{"group:stick", "group:stick", "group:stick"}
	}
})

