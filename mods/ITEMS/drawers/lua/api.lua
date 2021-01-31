--[[
Minetest Mod Storage Drawers - A Mod adding storage drawers

Copyright (C) 2017-2019 Linus Jahn <lnj@kaidan.im>
Copyright (C) 2016 Mango Tango <mtango688@gmail.com>

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

drawers.node_box_simple = {
	{-0.5, -0.5, -0.4375, 0.5, 0.5, 0.5},
	{-0.5, -0.5, -0.5, -0.4375, 0.5, -0.4375},
	{0.4375, -0.5, -0.5, 0.5, 0.5, -0.4375},
	{-0.4375, 0.4375, -0.5, 0.4375, 0.5, -0.4375},
	{-0.4375, -0.5, -0.5, 0.4375, -0.4375, -0.4375},
}

drawers.drawer_formspec = "size[9,7]" ..
	"list[context;upgrades;2,0.5;5,1;]" ..
	"list[current_player;main;0,3;9,4;]" ..
	drawers.gui_bg ..
	drawers.gui_bg_img ..
	drawers.gui_slots ..
	drawers.get_upgrade_slots_bg(2, 0.5)

-- construct drawer
function drawers.drawer_on_construct(pos)
	local node = core.get_node(pos)
	local ndef = core.registered_nodes[node.name]
	local drawerType = ndef.groups.drawer

	local base_stack_max = core.nodedef_default.stack_max or 99
	local stack_max_factor = ndef.drawer_stack_max_factor or 24 -- 3x8
	stack_max_factor = math.floor(stack_max_factor / drawerType) -- drawerType => number of drawers in node

	-- meta
	local meta = core.get_meta(pos)

	local i = 1
	while i <= drawerType do
		local vid = i
		-- 1x1 drawers don't have numbers in the meta fields
		if drawerType == 1 then vid = "" end
		meta:set_string("name"..vid, "")
		meta:set_int("count"..vid, 0)
		meta:set_int("max_count"..vid, base_stack_max * stack_max_factor)
		meta:set_int("base_stack_max"..vid, base_stack_max)
		meta:set_string("entity_infotext"..vid, drawers.gen_info_text(S("Empty"), 0,
			stack_max_factor, base_stack_max))
		meta:set_int("stack_max_factor"..vid, stack_max_factor)

		i = i + 1
	end

	-- spawn all visuals
	drawers.spawn_visuals(pos)

	-- create drawer upgrade inventory
	meta:get_inventory():set_size("upgrades", 5)

	-- set the formspec
	meta:set_string("formspec", drawers.drawer_formspec)
end

-- destruct drawer
function drawers.drawer_on_destruct(pos)
	drawers.remove_visuals(pos)

	-- clean up visual cache
	if drawers.drawer_visuals[core.serialize(pos)] then
		drawers.drawer_visuals[core.serialize(pos)] = nil
	end
end

-- drop all items
function drawers.drawer_on_dig(pos, node, player)
	local drawerType = 1
	if core.registered_nodes[node.name] then
		drawerType = core.registered_nodes[node.name].groups.drawer
	end
	if core.is_protected(pos,player:get_player_name()) then
	   core.record_protection_violation(pos,player:get_player_name())
	   return 0
	end
	local meta = core.get_meta(pos)

	local k = 1
	while k <= drawerType do
		-- don't add a number in meta fields for 1x1 drawers
		local vid = tostring(k)
		if drawerType == 1 then vid = "" end
		local count = meta:get_int("count"..vid)
		local name = meta:get_string("name"..vid)

		-- drop the items
		local stack_max = ItemStack(name):get_stack_max()

		local j = math.floor(count / stack_max) + 1
		local i = 1
		while i <= j do
			local rndpos = drawers.randomize_pos(pos)
			if not (i == j) then
				core.add_item(rndpos, name .. " " .. stack_max)
			else
				core.add_item(rndpos, name .. " " .. count % stack_max)
			end
			i = i + 1
		end
		k = k + 1
	end

	-- drop all drawer upgrades
	local upgrades = meta:get_inventory():get_list("upgrades")
	if upgrades then
		for _,itemStack in pairs(upgrades) do
			if itemStack:get_count() > 0 then
				local rndpos = drawers.randomize_pos(pos)
				core.add_item(rndpos, itemStack:get_name())
			end
		end
	end

	-- remove node
	core.node_dig(pos, node, player)
end

function drawers.drawer_allow_metadata_inventory_put(pos, listname, index, stack, player)
	if core.is_protected(pos,player:get_player_name()) then
	   core.record_protection_violation(pos,player:get_player_name())
	   return 0
	end
	if listname ~= "upgrades" then
		return 0
	end
	if stack:get_count() > 1 then
		return 0
	end
	if core.get_item_group(stack:get_name(), "drawer_upgrade") < 1 then
		return 0
	end
	return 1
end

function drawers.add_drawer_upgrade(pos, listname, index, stack, player)
	-- only do anything if adding to upgrades
	if listname ~= "upgrades" then return end

	drawers.update_drawer_upgrades(pos)
end

function drawers.remove_drawer_upgrade(pos, listname, index, stack, player)
	-- only do anything if adding to upgrades
	if listname ~= "upgrades" then return end

	drawers.update_drawer_upgrades(pos)
end

function drawers.drawer_insert_object(pos, node, stack, direction)
	local drawer_visuals = drawers.drawer_visuals[core.serialize(pos)]
	if not drawer_visuals then return stack end

	-- first try to insert in the correct slot (if there are already items)
	local leftover = stack
	for _, visual in pairs(drawer_visuals) do
		if visual.itemName == stack:get_name() then
			leftover = visual:try_insert_stack(leftover, true)
		end
	end

	-- if there's still something left, also use other slots
	if leftover:get_count() > 0 then
		for _, visual in pairs(drawer_visuals) do
			leftover = visual:try_insert_stack(leftover, true)
		end
	end
	return leftover
end

function drawers.drawer_can_insert_object(pos, node, stack, direction)
   	local drawer_visuals = drawers.drawer_visuals[core.serialize(pos)]
	if not drawer_visuals then return false end


	for _, visual in pairs(drawer_visuals) do
	   if visual.itemName == "" or (visual.itemName == stack:get_name() and visual.count ~= visual.maxCount) then
	      return true
	   end
	end
	return false
end

function drawers.register_drawer(name, def)
	def.description = def.description or S("Wooden")
	def.drawtype = "nodebox"
	def.node_box = {type = "fixed", fixed = drawers.node_box_simple}
	def.collision_box = {type = "regular"}
	def.selection_box = {type = "fixed", fixed = drawers.node_box_simple}
	def.paramtype = "light"
	def.paramtype2 = "facedir"
	def.legacy_facedir_simple = true
	def.groups = def.groups or {}
	def.drawer_stack_max_factor = def.drawer_stack_max_factor or 24

	-- events
	def.on_construct = drawers.drawer_on_construct
	def.on_destruct = drawers.drawer_on_destruct
	def.on_dig = drawers.drawer_on_dig
	def.allow_metadata_inventory_put = drawers.drawer_allow_metadata_inventory_put
	def.allow_metadata_inventory_take = drawers.drawer_allow_metadata_inventory_put
	def.on_metadata_inventory_put = drawers.add_drawer_upgrade
	def.on_metadata_inventory_take = drawers.remove_drawer_upgrade

	if minetest.get_modpath("screwdriver") and screwdriver then
		def.on_rotate = def.on_rotate or screwdriver.disallow
	end

	if minetest.get_modpath("pipeworks") and pipeworks then
		def.groups.tubedevice = 1
		def.groups.tubedevice_receiver = 1
		def.tube = def.tube or {}
		def.tube.insert_object = def.tube.insert_object or
		   drawers.drawer_insert_object
		def.tube.can_insert = def.tube.can_insert or
		   drawers.drawer_can_insert_object

		def.tube.connect_sides = {left = 1, right = 1, back = 1, top = 1,
			bottom = 1}
		def.after_place_node = pipeworks.after_place
		def.after_dig_node = pipeworks.after_dig
	end

	if drawers.enable_1x1 then
		-- normal drawer 1x1 = 1
		local def1 = table.copy(def)
		def1.description = S("@1 Drawer", def.description)
		def1.tiles = def.tiles or def.tiles1
		def1.tiles1 = nil
		def1.tiles2 = nil
		def1.tiles4 = nil
		def1.groups.drawer = 1
		core.register_node(name .. "1", def1)
		core.register_alias(name, name .. "1") -- 1x1 drawer is the default one
	end

	if drawers.enable_1x2 then
		-- 1x2 = 2
		local def2 = table.copy(def)
		def2.description = S("@1 Drawers (1x2)", def.description)
		def2.tiles = def.tiles2
		def2.tiles1 = nil
		def2.tiles2 = nil
		def2.tiles4 = nil
		def2.groups.drawer = 2
		core.register_node(name .. "2", def2)
	end

	if drawers.enable_2x2 then
		-- 2x2 = 4
		local def4 = table.copy(def)
		def4.description = S("@1 Drawers (2x2)", def.description)
		def4.tiles = def.tiles4
		def4.tiles1 = nil
		def4.tiles2 = nil
		def4.tiles4 = nil
		def4.groups.drawer = 4
		core.register_node(name .. "4", def4)
	end

	if (not def.no_craft) and def.material then
		if drawers.enable_1x1 then
			core.register_craft({
				output = name .. "1",
				recipe = {
					{def.material, def.material, def.material},
					{    "", drawers.CHEST_ITEMSTRING,  ""   },
					{def.material, def.material, def.material}
				}
			})
		end
		if drawers.enable_1x2 then
			core.register_craft({
				output = name .. "2 2",
				recipe = {
					{def.material, drawers.CHEST_ITEMSTRING, def.material},
					{def.material,       def.material,       def.material},
					{def.material, drawers.CHEST_ITEMSTRING, def.material}
				}
			})
		end
		if drawers.enable_2x2 then
			core.register_craft({
				output = name .. "4 4",
				recipe = {
					{drawers.CHEST_ITEMSTRING, def.material, drawers.CHEST_ITEMSTRING},
					{      def.material,       def.material,       def.material      },
					{drawers.CHEST_ITEMSTRING, def.material, drawers.CHEST_ITEMSTRING}
				}
			})
		end
	end
end

function drawers.register_drawer_upgrade(name, def)
	def.groups = def.groups or {}
	def.groups.drawer_upgrade = def.groups.drawer_upgrade or 100
	def.inventory_image = def.inventory_image or "drawers_upgrade_template.png"
	def.stack_max = 1

	local recipe_item = def.recipe_item or "air"
	def.recipe_item = nil

	core.register_craftitem(name, def)

	if not def.no_craft then
		core.register_craft({
			output = name,
			recipe = {
				{recipe_item, "group:stick", recipe_item},
				{"group:stick", "drawers:upgrade_template", "group:stick"},
				{recipe_item, "group:stick", recipe_item}
			}
		})
	end
end
