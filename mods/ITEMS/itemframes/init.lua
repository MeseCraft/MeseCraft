
screwdriver = screwdriver or {}

local tmp = {}
local max_objs = tonumber(minetest.settings:get("max_objects_per_block")) or 49

-- item entity

minetest.register_entity("itemframes:item",{
	hp_max = 1,
	visual = "wielditem",
	visual_size = {x = 0.33, y = 0.33},
	collisionbox = {0, 0, 0, 0, 0, 0},
	physical = false,
	textures = {"air"},

	on_activate = function(self, staticdata)

		if not self then
			self.object:remove()
			return
		end

		if tmp.nodename ~= nil
		and tmp.texture ~= nil then

			self.nodename = tmp.nodename
			tmp.nodename = nil
			self.texture = tmp.texture
			tmp.texture = nil
		else
			if staticdata ~= nil
			and staticdata ~= "" then

				local data = staticdata:split(';')

				if data and data[1] and data[2] then

					self.nodename = data[1]
					self.texture = data[2]
				end
			end
		end

		if self.texture ~= nil then
			self.object:set_properties({textures = {self.texture}})
		end

		if self.nodename == "itemframes:pedestal" then
			self.object:set_properties({automatic_rotate = 1})
		end

	end,

	get_staticdata = function(self)

		if self.nodename ~= nil
		and self.texture ~= nil then
			return self.nodename .. ';' .. self.texture
		end

		return ""
	end,
})

-- helper table

local facedir = {}

facedir[0] = {x = 0, y = 0, z = 1}
facedir[1] = {x = 1, y = 0, z = 0}
facedir[2] = {x = 0, y = 0, z = -1}
facedir[3] = {x = -1, y = 0, z = 0}

-- remove entities

local remove_item = function(pos, nodename)

	local ypos = 0

	if nodename == "itemframes:pedestal" then
		ypos = 1
	end

	local objs = minetest.get_objects_inside_radius({
			x = pos.x, y = pos.y + ypos, z = pos.z}, 0.5)

	if objs then

		for _, obj in pairs(objs) do

			if obj and obj:get_luaentity()
			and obj:get_luaentity().name == "itemframes:item" then
				obj:remove()
			end
		end
	end
end

-- update entity

local update_item = function(pos, node)

	remove_item(pos, node.name)

	local meta = minetest.get_meta(pos)

	if not meta then return end

	if meta:get_string("item") ~= "" then

		if node.name == "itemframes:frame" then

			local posad = facedir[node.param2]

			if not posad then return end

			pos.x = pos.x + posad.x * 6.5 / 16
			pos.y = pos.y + posad.y * 6.5 / 16
			pos.z = pos.z + posad.z * 6.5 / 16

		elseif node.name == "itemframes:pedestal" then

			pos.y = pos.y + 12 / 16 + 0.33
		end

		tmp.nodename = node.name
		tmp.texture = ItemStack(meta:get_string("item")):get_name()

		local e = minetest.add_entity(pos,"itemframes:item")

		if node.name == "itemframes:frame" then

			--local yaw = math.pi * 2 - node.param2 * math.pi / 2
			local yaw = 6.28 - node.param2 * 1.57

			e:set_yaw(yaw)
		end
	end
end

-- remove entity and drop as item

local drop_item = function(pos, nodename, metadata)

	local meta = metadata or minetest.get_meta(pos)

	if not meta then return end

	local item = meta:get_string("item")

	meta:set_string("item", "")

	if item ~= "" then

		remove_item(pos, nodename)

		if nodename == "itemframes:pedestal" then
			pos.y = pos.y + 1
		end

		minetest.add_item(pos, item)
	end
end

-- itemframe node and recipe

minetest.register_node("itemframes:frame",{
	description = "Item frame",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, 7/16, 0.5, 0.5, 0.5}
	},
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, 7/16, 0.5, 0.5, 0.5}
	},
	tiles = {"itemframes_frame.png"},
	inventory_image = "itemframes_frame.png",
	wield_image = "itemframes_frame.png",
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	groups = {choppy = 2, dig_immediate = 2, flammable = 2},
	legacy_wallmounted = true,
	sounds = default.node_sound_defaults(),
	on_rotate = screwdriver.disallow,

	after_place_node = function(pos, placer, itemstack)

		local meta = minetest.get_meta(pos)

		meta:set_string("infotext","Item frame (right-click to add or remove item)")
	end,

	on_rightclick = function(pos, node, clicker, itemstack)

		if not itemstack
		or minetest.is_protected(pos, clicker:get_player_name()) then
			return
		end

		local meta = minetest.get_meta(pos)

		if not meta then return end

		if meta:get_string("item") ~= "" then

			drop_item(pos, node.name, meta)
		else
			local s = itemstack:take_item()

			meta:set_string("item", s:to_string())

			update_item(pos, node)

			return itemstack
		end
	end,

	on_destruct = function(pos)
		drop_item(pos, "itemframes:frame")
	end,

	on_punch = function(pos, node, puncher)
		update_item(pos, node)
	end,

	on_blast = function(pos, intensity)

		drop_item(pos, "itemframes:frame")

		minetest.add_item(pos, {name = "itemframes:frame"})

		minetest.remove_node(pos)
	end,

	on_burn = function(pos)

		drop_item(pos, "itemframes:frame")

		minetest.remove_node(pos)
	end,
})

minetest.register_craft({
	output = "itemframes:frame",
	recipe = {
		{"default:stick", "default:stick", "default:stick"},
		{"default:stick", "default:paper", "default:stick"},
		{"default:stick", "default:stick", "default:stick"},
	}
})

-- pedestal node and recipe

minetest.register_node("itemframes:pedestal",{
	description = "Pedestal",
	drawtype = "nodebox",
	node_box = {
		type = "fixed", fixed = {
			{-7/16, -8/16, -7/16, 7/16, -7/16, 7/16}, -- bottom plate
			{-6/16, -7/16, -6/16, 6/16, -6/16, 6/16}, -- bottom plate (upper)
			{-0.25, -6/16, -0.25, 0.25, 11/16, 0.25}, -- pillar
			{-7/16, 11/16, -7/16, 7/16, 12/16, 7/16}, -- top plate
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {-7/16, -0.5, -7/16, 7/16, 12/16, 7/16}
	},
	tiles = {"itemframes_pedestal.png"},
	paramtype = "light",
	groups = {cracky = 3},
	sounds = default.node_sound_defaults(),
	on_rotate = screwdriver.disallow,

	after_place_node = function(pos, placer, itemstack)

		local meta = minetest.get_meta(pos)

		meta:set_string("infotext","Pedestal (right-click to add or remove item)")
	end,

	on_rightclick = function(pos, node, clicker, itemstack)

		if not itemstack
		or minetest.is_protected(pos, clicker:get_player_name()) then
			return
		end

		local meta = minetest.get_meta(pos)

		if not meta then return end

		if meta:get_string("item") ~= "" then

			drop_item(pos, node.name, meta)
		else

			local s = itemstack:take_item()

			meta:set_string("item", s:to_string())

			update_item(pos, node)

			return itemstack
		end
	end,

	on_destruct = function(pos)
		drop_item(pos, "itemframes:pedestal")
	end,

	on_punch = function(pos, node, puncher)
		update_item(pos, node)
	end,

	on_blast = function(pos, intensity)

		drop_item(pos, "itemframes:pedestal")

		minetest.add_item(pos, {name = "itemframes:pedestal"})

		minetest.remove_node(pos)
	end,
})

minetest.register_craft({
	output = "itemframes:pedestal",
	recipe = {
		{"default:stone", "default:stone", "default:stone"},
		{"", "default:stone", ""},
		{"default:stone", "default:stone", "default:stone"},
	}
})

-- automatically restore entities lost from frames/pedestals
-- due to /clearobjects or similar

minetest.register_abm({
	nodenames = {"itemframes:frame", "itemframes:pedestal"},
	interval = 25,
	chance = 1,
	catch_up = false,

	action = function(pos, node, active_object_count, active_object_count_wider)

		if active_object_count >= max_objs then
			return
		end

		local num

		if node.name == "itemframes:frame" then
			num = #minetest.get_objects_inside_radius(pos, 0.5)

		elseif node.name == "itemframes:pedestal" then

			pos.y = pos.y + 1
			num = #minetest.get_objects_inside_radius(pos, 0.5)
			pos.y = pos.y - 1
		end

		if num > 0 then
			return
		end

		update_item(pos, node)
	end
})

-- stop mesecon pistons from pushing itemframe and pedestals

if minetest.get_modpath("mesecons_mvps") then
	mesecon.register_mvps_stopper("itemframes:frame")
	mesecon.register_mvps_stopper("itemframes:pedestal")
end
