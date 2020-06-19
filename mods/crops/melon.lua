
--[[

Copyright (C) 2015 - Auke Kok <sofar@foo-projects.org>

"crops" is free software; you can redistribute it and/or modify
it under the terms of the GNU Lesser General Public License as
published by the Free Software Foundation; either version 2.1
of the license, or (at your option) any later version.

--]]

-- Intllib
local S = crops.intllib

local faces = {
	[1] = { x = -1, z = 0, r = 3, o = 1, m = 14 },
	[2] = { x = 1, z = 0, r = 1, o = 3,  m = 16 },
	[3] = { x = 0, z = -1, r = 2, o = 0, m = 5  },
	[4] = { x = 0, z = 1, r = 0, o = 2,  m = 11 }
}

minetest.register_node("crops:melon_seed", {
	description = S("Melon seed"),
	inventory_image = "crops_melon_seed.png",
	wield_image = "crops_melon_seed.png",
	tiles = { "crops_melon_plant_1.png" },
	drawtype = "plantlike",
	waving = 1,
	sunlight_propagates = false,
	use_texture_alpha = true,
	walkable = false,
	paramtype = "light",
	node_placement_prediction = "crops:melon_plant_1",
	groups = { snappy=3,flammable=3,flora=1,attached_node=1 },

	on_place = function(itemstack, placer, pointed_thing)
		local under = minetest.get_node(pointed_thing.under)
		if minetest.get_item_group(under.name, "soil") <= 1 then
			return
		end
		crops.plant(pointed_thing.above, {name="crops:melon_plant_1"})
		if not minetest.settings:get_bool("creative_mode") then
			itemstack:take_item()
		end
		return itemstack
	end
})

for stage = 1, 6 do
minetest.register_node("crops:melon_plant_" .. stage , {
	description = S("Melon plant"),
	tiles = { "crops_melon_plant_" .. stage .. ".png" },
	drawtype = "plantlike",
	waving = 1,
	sunlight_propagates = true,
	use_texture_alpha = true,
	walkable = false,
	paramtype = "light",
	groups = { snappy=3, flammable=3, flora=1, attached_node=1, not_in_creative_inventory=1 },
	drop = "crops:melon_seed",
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5,  0.5, -0.5 + (((math.min(stage, 4)) + 1) / 5), 0.5}
	}
})
end

minetest.register_node("crops:melon_plant_5_attached", {
	visual = "mesh",
	mesh = "crops_plant_extra_face.obj",
	description = S("Melon plant"),
	tiles = { "crops_melon_stem.png", "crops_melon_plant_4.png" },
	drawtype = "mesh",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	use_texture_alpha = true,
	walkable = false,
	paramtype = "light",
	groups = { snappy=3, flammable=3, flora=1, attached_node=1, not_in_creative_inventory=1 },
	drop = "crops:melon_seed",
	sounds = default.node_sound_leaves_defaults(),
})


minetest.register_craftitem("crops:melon_slice", {
	description = S("Melon slice"),
	inventory_image = "crops_melon_slice.png",
	on_use = minetest.item_eat(1)
})

minetest.register_craft({
	type = "shapeless",
	output = "crops:melon_seed",
	recipe = { "crops:melon_slice" }
})

--
-- the melon "block"
--
minetest.register_node("crops:melon", {
	description = S("Melon"),
	tiles = {
		"crops_melon_top.png",
		"crops_melon_bottom.png",
		"crops_melon.png",
	},
	sunlight_propagates = false,
	use_texture_alpha = false,
	walkable = true,
	groups = { snappy=3, flammable=3, oddly_breakable_by_hand=2 },
	paramtype2 = "facedir",
	drop = {},
	sounds = default.node_sound_wood_defaults({
		dig = { name = "default_dig_oddly_breakable_by_hand" },
		dug = { name = "default_dig_choppy" }
	}),
	on_dig = function(pos, node, digger)
		for face = 1, 4 do
			local s = { x = pos.x + faces[face].x, y = pos.y, z = pos.z + faces[face].z }
			local n = minetest.get_node(s)
			if n.name == "crops:melon_plant_5_attached" then
				-- make sure it was actually attached to this stem
				if n.param2 == faces[face].o then
					minetest.swap_node(s, { name = "crops:melon_plant_4" })
				end
			end
		end
		local meta = minetest.get_meta(pos)
		local damage = meta:get_int("crops_damage")
		local drops = {}
		--   0 dmg - 3-5
		--  50 dmg - 2-3
		-- 100 dmg - 1-1
		for i = 1,math.random(3 - (2 * (damage / 100)), 5 - (4 * (damage / 100))) do
			table.insert(drops, ('crops:melon_slice'))
		end
		core.handle_node_drops(pos, drops, digger)
		minetest.remove_node(pos)
	end
})

--
-- grows a plant to mature size
--
minetest.register_abm({
	nodenames = { "crops:melon_plant_1", "crops:melon_plant_2", "crops:melon_plant_3","crops:melon_plant_4" },
	neighbors = { "group:soil" },
	interval = crops.settings.interval,
	chance = crops.settings.chance,
	action = function(pos, node, active_object_count, active_object_count_wider)
		if not crops.can_grow(pos) then
			return
		end
		local n = string.gsub(node.name, "4", "5")
		n = string.gsub(n, "3", "4")
		n = string.gsub(n, "2", "3")
		n = string.gsub(n, "1", "2")
		minetest.swap_node(pos, { name = n })
	end
})

--
-- grows a melon
--
minetest.register_abm({
	nodenames = { "crops:melon_plant_5" },
	neighbors = { "group:soil" },
	interval = crops.settings.interval,
	chance = crops.settings.chance,
	action = function(pos, node, active_object_count, active_object_count_wider)
		if not crops.can_grow(pos) then
			return
		end
		for face = 1, 4 do
			local t = { x = pos.x + faces[face].x, y = pos.y, z = pos.z + faces[face].z }
			if minetest.get_node(t).name == "crops:melon" then
				return
			end
		end
		local r = math.random(1, 4)
		local t = { x = pos.x + faces[r].x, y = pos.y, z = pos.z + faces[r].z }
		local n = minetest.get_node(t)
		if n.name == "ignore" then
			return
		end

		if minetest.registered_nodes[minetest.get_node({ x = t.x, y = t.y - 1, z = t.z }).name].walkable == false then
			return
		end

		if minetest.registered_nodes[n.name].drawtype == "plantlike" or
		   minetest.registered_nodes[n.name].groups.flora == 1 or
		   n.name == "air" then
			minetest.swap_node(pos, {name = "crops:melon_plant_5_attached", param2 = faces[r].r})
			minetest.set_node(t, {name = "crops:melon", param2 = faces[r].m})
			local meta = minetest.get_meta(pos)
			local damage = meta:get_int("crops_damage")
			local water = meta:get_int("crops_water")
			-- growing a melon costs 25 water!
			meta:set_int("crops_water", math.max(0, water - 25))
			meta = minetest.get_meta(t)
			-- reflect plants' damage in the melon yield
			meta:set_int("crops_damage", damage)
		end
	end
})

--
-- return a melon to a normal one if there is no melon attached, so it can
-- grow a new melon again
--
minetest.register_abm({
	nodenames = { "crops:melon_plant_5_attached" },
	interval = crops.settings.interval,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		for face = 1, 4 do
			local t = { x = pos.x + faces[face].x, y = pos.y, z = pos.z + faces[face].z }
			if minetest.get_node(t).name == "crops:melon" then
				return
			end
		end
		minetest.swap_node(pos, {name = "crops:melon_plant_4" })
	end
})

crops.melon_die = function(pos)
	minetest.set_node(pos, { name = "crops:melon_plant_6" })
end

local properties = {
	die = crops.melon_die,
	waterstart = 20,
	wateruse = 1,
	night = 5,
	soak = 80,
	soak_damage = 90,
	wither = 20,
	wither_damage = 10,
}

crops.register({ name = "crops:melon_plant_1", properties = properties })
crops.register({ name = "crops:melon_plant_2", properties = properties })
crops.register({ name = "crops:melon_plant_3", properties = properties })
crops.register({ name = "crops:melon_plant_4", properties = properties })
crops.register({ name = "crops:melon_plant_5", properties = properties })
crops.register({ name = "crops:melon_plant_5_attached", properties = properties })
