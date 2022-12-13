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

-- GUI
function drawers.get_upgrade_slots_bg(x,y)
	local out = ""
	for i = 0, 4, 1 do
		out = out .."image["..x+i..","..y..";1,1;drawers_upgrade_slot_bg.png]"
	end
	return out
end

function drawers.gen_info_text(basename, count, factor, stack_max)
	local maxCount = stack_max * factor
	local percent = count / maxCount * 100
	-- round the number (float -> int)
	percent = math.floor(percent + 0.5)

	if count == 0 then
		return S("@1 (@2% full)", basename, tostring(percent))
	else
		return S("@1 @2 (@3% full)", tostring(count), basename, tostring(percent))
	end
end

function drawers.get_inv_image(name)
	local texture = "blank.png"
	local def = core.registered_items[name]
	if not def then return end

	if def.inventory_image and #def.inventory_image > 0 then
		texture = def.inventory_image
	else
		if not def.tiles then return texture end
		local tiles = table.copy(def.tiles)

		for k,v in pairs(tiles) do
			if type(v) == "table" then
				tiles[k] = v.name
			end
		end

		-- tiles: up, down, right, left, back, front
		-- inventorycube: up, front, right
		if #tiles <= 2 then
			texture = core.inventorycube(tiles[1], tiles[1], tiles[1])
		elseif #tiles <= 5 then
			texture = core.inventorycube(tiles[1], tiles[3], tiles[3])
		else -- full tileset
			texture = core.inventorycube(tiles[1], tiles[6], tiles[3])
		end
	end

	return texture
end

function drawers.spawn_visuals(pos)
	local node = core.get_node(pos)
	local ndef = core.registered_nodes[node.name]
	local drawerType = ndef.groups.drawer

	-- data for the new visual
	drawers.last_drawer_pos = pos
	drawers.last_drawer_type = drawerType

	if drawerType == 1 then -- 1x1 drawer
		drawers.last_visual_id = ""
		drawers.last_texture = drawers.get_inv_image(core.get_meta(pos):get_string("name"))

		local bdir = core.facedir_to_dir(node.param2)
		local fdir = vector.new(-bdir.x, 0, -bdir.z)
		local pos2 = vector.add(pos, vector.multiply(fdir, 0.45))

		local obj = core.add_entity(pos2, "drawers:visual")
		if not obj then return end

		if bdir.x < 0 then obj:set_yaw(0.5 * math.pi) end
		if bdir.z < 0 then obj:set_yaw(math.pi) end
		if bdir.x > 0 then obj:set_yaw(1.5 * math.pi) end

		drawers.last_texture = nil
	elseif drawerType == 2 then
		local bdir = core.facedir_to_dir(node.param2)

		local fdir1
		local fdir2
		if node.param2 == 2 or node.param2 == 0 then
			fdir1 = vector.new(-bdir.x, 0.5, -bdir.z)
			fdir2 = vector.new(-bdir.x, -0.5, -bdir.z)
		else
			fdir1 = vector.new(-bdir.x, 0.5, -bdir.z)
			fdir2 = vector.new(-bdir.x, -0.5, -bdir.z)
		end

		local objs = {}

		drawers.last_visual_id = 1
		drawers.last_texture = drawers.get_inv_image(core.get_meta(pos):get_string("name1"))
		local pos1 = vector.add(pos, vector.multiply(fdir1, 0.45))
		objs[1] = core.add_entity(pos1, "drawers:visual")

		drawers.last_visual_id = 2
		drawers.last_texture = drawers.get_inv_image(core.get_meta(pos):get_string("name2"))
		local pos2 = vector.add(pos, vector.multiply(fdir2, 0.45))
		objs[2] = core.add_entity(pos2, "drawers:visual")

		for i,obj in pairs(objs) do
			if bdir.x < 0 then obj:set_yaw(0.5 * math.pi) end
			if bdir.z < 0 then obj:set_yaw(math.pi) end
			if bdir.x > 0 then obj:set_yaw(1.5 * math.pi) end
		end
	else -- 2x2 drawer
		local bdir = core.facedir_to_dir(node.param2)

		local fdir1
		local fdir2
		local fdir3
		local fdir4
		if node.param2 == 2 then
			fdir1 = vector.new(-bdir.x + 0.5, 0.5, -bdir.z)
			fdir2 = vector.new(-bdir.x - 0.5, 0.5, -bdir.z)
			fdir3 = vector.new(-bdir.x + 0.5, -0.5, -bdir.z)
			fdir4 = vector.new(-bdir.x - 0.5, -0.5, -bdir.z)
		elseif node.param2 == 0 then
			fdir1 = vector.new(-bdir.x - 0.5, 0.5, -bdir.z)
			fdir2 = vector.new(-bdir.x + 0.5, 0.5, -bdir.z)
			fdir3 = vector.new(-bdir.x - 0.5, -0.5, -bdir.z)
			fdir4 = vector.new(-bdir.x + 0.5, -0.5, -bdir.z)
		elseif node.param2 == 1 then
			fdir1 = vector.new(-bdir.x, 0.5, -bdir.z + 0.5)
			fdir2 = vector.new(-bdir.x, 0.5, -bdir.z - 0.5)
			fdir3 = vector.new(-bdir.x, -0.5, -bdir.z + 0.5)
			fdir4 = vector.new(-bdir.x, -0.5, -bdir.z - 0.5)
		else
			fdir1 = vector.new(-bdir.x, 0.5, -bdir.z - 0.5)
			fdir2 = vector.new(-bdir.x, 0.5, -bdir.z + 0.5)
			fdir3 = vector.new(-bdir.x, -0.5, -bdir.z - 0.5)
			fdir4 = vector.new(-bdir.x, -0.5, -bdir.z + 0.5)
		end

		local objs = {}

		drawers.last_visual_id = 1
		drawers.last_texture = drawers.get_inv_image(core.get_meta(pos):get_string("name1"))
		local pos1 = vector.add(pos, vector.multiply(fdir1, 0.45))
		objs[1] = core.add_entity(pos1, "drawers:visual")

		drawers.last_visual_id = 2
		drawers.last_texture = drawers.get_inv_image(core.get_meta(pos):get_string("name2"))
		local pos2 = vector.add(pos, vector.multiply(fdir2, 0.45))
		objs[2] = core.add_entity(pos2, "drawers:visual")

		drawers.last_visual_id = 3
		drawers.last_texture = drawers.get_inv_image(core.get_meta(pos):get_string("name3"))
		local pos3 = vector.add(pos, vector.multiply(fdir3, 0.45))
		objs[3] = core.add_entity(pos3, "drawers:visual")

		drawers.last_visual_id = 4
		drawers.last_texture = drawers.get_inv_image(core.get_meta(pos):get_string("name4"))
		local pos4 = vector.add(pos, vector.multiply(fdir4, 0.45))
		objs[4] = core.add_entity(pos4, "drawers:visual")


		for i,obj in pairs(objs) do
			if bdir.x < 0 then obj:set_yaw(0.5 * math.pi) end
			if bdir.z < 0 then obj:set_yaw(math.pi) end
			if bdir.x > 0 then obj:set_yaw(1.5 * math.pi) end
		end
	end
end

function drawers.remove_visuals(pos)
	local objs = core.get_objects_inside_radius(pos, 0.56)
	if not objs then return end

	for _, obj in pairs(objs) do
		if obj and obj:get_luaentity() and
				obj:get_luaentity().name == "drawers:visual" then
			obj:remove()
		end
	end
end

--[[
	Returns the visual object for the visualid of the drawer at pos.

	visualid can be: "", "1", "2", ... or 1, 2, ...
]]
function drawers.get_visual(pos, visualid)
	local drawer_visuals = drawers.drawer_visuals[core.hash_node_position(pos)]
	if not drawer_visuals then
		return nil
	end

	-- not a real index (starts with 1)
	local index = tonumber(visualid)
	if visualid == "" then
		index = 1
	end

	return drawer_visuals[index]
end

function drawers.update_drawer_upgrades(pos)
	local node = core.get_node(pos)
	local ndef = core.registered_nodes[node.name]
	local drawerType = ndef.groups.drawer

	-- default number of slots/stacks
	local stackMaxFactor = ndef.drawer_stack_max_factor

	-- storage percent with all upgrades
	local storagePercent = 100

	-- get info of all upgrades
	local inventory = core.get_meta(pos):get_inventory():get_list("upgrades")
	for _,itemStack in pairs(inventory) do
		local iname = itemStack:get_name()
		local idef = core.registered_items[iname]
		local addPercent = idef.groups.drawer_upgrade or 0

		storagePercent = storagePercent + addPercent
	end

	--						i.e.: 150% / 100 => 1.50
	stackMaxFactor = math.floor(stackMaxFactor * (storagePercent / 100))
	-- calculate stack_max factor for a single drawer
	stackMaxFactor = stackMaxFactor / drawerType

	-- set the new stack max factor in all visuals
	local drawer_visuals = drawers.drawer_visuals[core.hash_node_position(pos)]
	if not drawer_visuals then return end

	for _,visual in pairs(drawer_visuals) do
		visual:setStackMaxFactor(stackMaxFactor)
	end
end

function drawers.randomize_pos(pos)
	local rndpos = table.copy(pos)
	local x = math.random(-50, 50) * 0.01
	local z = math.random(-50, 50) * 0.01
	rndpos.x = rndpos.x + x
	rndpos.y = rndpos.y + 0.25
	rndpos.z = rndpos.z + z
	return rndpos
end

function drawers.node_tiles_front_other(front, other)
	return {other, other, other, other, other, front}
end
