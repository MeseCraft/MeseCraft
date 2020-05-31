
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

minetest.register_node("crops:pumpkin_seed", {
	description = S("Pumpkin seed"),
	inventory_image = "crops_pumpkin_seed.png",
	wield_image = "crops_pumpkin_seed.png",
	tiles = { "crops_pumpkin_plant_1.png" },
	drawtype = "plantlike",
	waving = 1,
	sunlight_propagates = false,
	use_texture_alpha = true,
	walkable = false,
	paramtype = "light",
	node_placement_prediction = "crops:pumpkin_plant_1",
	groups = { snappy=3,flammable=3,flora=1,attached_node=1 },

	on_place = function(itemstack, placer, pointed_thing)
		local under = minetest.get_node(pointed_thing.under)
		if minetest.get_item_group(under.name, "soil") <= 1 then
			return
		end
		crops.plant(pointed_thing.above, {name="crops:pumpkin_plant_1"})
		if not minetest.settings:get_bool("creative_mode") then
			itemstack:take_item()
		end
		return itemstack
	end
})

for stage = 1, 6 do
minetest.register_node("crops:pumpkin_plant_" .. stage , {
	description = S("Pumpkin plant"),
	tiles = { "crops_pumpkin_plant_" .. stage .. ".png" },
	drawtype = "plantlike",
	waving = 1,
	sunlight_propagates = true,
	use_texture_alpha = true,
	walkable = false,
	paramtype = "light",
	groups = { snappy=3, flammable=3, flora=1, attached_node=1, not_in_creative_inventory=1 },
	drop = "crops:pumpkin_seed",
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5,  0.5, -0.5 + (((math.min(stage, 4)) + 1) / 5), 0.5}
	}
})
end

minetest.register_node("crops:pumpkin_plant_5_attached", {
	visual = "mesh",
	mesh = "crops_plant_extra_face.obj",
	description = S("Pumpkin plant"),
	tiles = { "crops_pumpkin_stem.png", "crops_pumpkin_plant_4.png" },
	drawtype = "mesh",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	use_texture_alpha = true,
	walkable = false,
	paramtype = "light",
	groups = { snappy=3, flammable=3, flora=1, attached_node=1, not_in_creative_inventory=1 },
	drop = "crops:pumpkin_seed",
	sounds = default.node_sound_leaves_defaults(),
})


minetest.register_craftitem("crops:roasted_pumpkin", {
	description = S("Roasted pumpkin"),
	inventory_image = "crops_roasted_pumpkin.png",
	on_use = minetest.item_eat(2)
})

minetest.register_craft({
	type = "shapeless",
	output = "crops:pumpkin_seed",
	recipe = { "crops:pumpkin" }
})

minetest.register_craft({
	type = "cooking",
	output = "crops:roasted_pumpkin",
	recipe = "crops:pumpkin"
})

--
-- the pumpkin "block"
--
minetest.register_node("crops:pumpkin", {
	description = S("Pumpkin"),
	tiles = {
		"crops_pumpkin_top.png",
		"crops_pumpkin_bottom.png",
		"crops_pumpkin.png"
	},
	sunlight_propagates = false,
	use_texture_alpha = false,
	walkable = true,
	groups = { snappy=3, flammable=3, oddly_breakable_by_hand=2 },
	paramtype2 = "facedir",
	sounds = default.node_sound_wood_defaults({
		dig = { name = "default_dig_oddly_breakable_by_hand" },
		dug = { name = "default_dig_choppy" }
	}),
	after_dig_node = function(pos, node)
		for face = 1, 4 do
			local s = { x = pos.x + faces[face].x, y = pos.y, z = pos.z + faces[face].z }
			local n = minetest.get_node(s)
			if n.name == "crops:pumpkin_plant_5_attached" then
				-- make sure it was actually attached to this stem
				if n.param2 == faces[face].o then
					minetest.swap_node(s, { name = "crops:pumpkin_plant_4" })
				end
			end
		end
	end
})

--
-- grows a plant to mature size
--
minetest.register_abm({
	nodenames = { "crops:pumpkin_plant_1", "crops:pumpkin_plant_2", "crops:pumpkin_plant_3","crops:pumpkin_plant_4" },
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
-- grows a pumpkin
--
minetest.register_abm({
	nodenames = { "crops:pumpkin_plant_5" },
	neighbors = { "group:soil" },
	interval = crops.settings.interval,
	chance = crops.settings.chance,
	action = function(pos, node, active_object_count, active_object_count_wider)
		if not crops.can_grow(pos) then
			return
		end
		for face = 1, 4 do
			local t = { x = pos.x + faces[face].x, y = pos.y, z = pos.z + faces[face].z }
			if minetest.get_node(t).name == "crops:pumpkin" then
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
			minetest.set_node(t, {name = "crops:pumpkin", param2 = faces[r].m})

			local meta = minetest.get_meta(pos)
			local ttl = meta:get_int("crops_pumpkin_ttl")
			local damage = meta:get_int("crops_damage")
			if ttl == 0 then
				-- damage 0   - regrows 3-4
				-- damage 50  - drops 1-2
				-- damage 100 - drops 0-1
				ttl = math.random(3 - (3 * (damage / 100)), 4 - (3 * (damage / 100)))
			end
			if ttl > 1 then
				minetest.swap_node(pos, {name = "crops:pumpkin_plant_5_attached", param2 = faces[r].r})
				meta:set_int("crops_pumpkin_ttl", ttl - 1)
			else
				crops.die(pos)
			end
			local water = meta:get_int("crops_water")
			-- growing a pumpkin costs 25 water!
			meta:set_int("crops_water", math.max(0, water - 25))
		end
	end
})

--
-- return a pumpkin to a normal one if there is no pumpkin attached, so it can
-- grow a new pumpkin again
--
minetest.register_abm({
	nodenames = { "crops:pumpkin_plant_5_attached" },
	interval = crops.settings.interval,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		for face = 1, 4 do
			local t = { x = pos.x + faces[face].x, y = pos.y, z = pos.z + faces[face].z }
			if minetest.get_node(t).name == "crops:pumpkin" then
				return
			end
		end
		local meta = minetest.get_meta(pos)
		local ttl = meta:get_int("crops_pumpkin_ttl")
		if ttl > 1 then
			minetest.swap_node(pos, { name = "crops:pumpkin_plant_4" })
			meta:set_int("crops_pumpkin_ttl", ttl)
		else
			crops.die(pos)
		end
	end
})

crops.pumpkin_die = function(pos)
	minetest.set_node(pos, { name = "crops:pumpkin_plant_6" })
end

local properties = {
	die = crops.pumpkin_die,
	waterstart = 40,
	wateruse = 1,
	night = 5,
	soak = 80,
	soak_damage = 90,
	wither = 10,
	wither_damage = 5,
}

crops.register({ name = "crops:pumpkin_plant_1", properties = properties })
crops.register({ name = "crops:pumpkin_plant_2", properties = properties })
crops.register({ name = "crops:pumpkin_plant_3", properties = properties })
crops.register({ name = "crops:pumpkin_plant_4", properties = properties })
crops.register({ name = "crops:pumpkin_plant_5", properties = properties })
crops.register({ name = "crops:pumpkin_plant_5_attached", properties = properties })
