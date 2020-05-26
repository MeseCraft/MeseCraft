
local S = ethereal.intllib

-- Strawberry (can also be planted as seed)
minetest.register_craftitem("ethereal:strawberry", {
	description = S("Strawberry"),
	inventory_image = "strawberry.png",
	wield_image = "strawberry.png",
	groups = {food_strawberry = 1, food_berry = 1, flammable = 2},
	on_place = function(itemstack, placer, pointed_thing)
		return farming.place_seed(itemstack, placer, pointed_thing, "ethereal:strawberry_1")
	end,
	on_use = minetest.item_eat(1),
})

-- Define Strawberry Bush growth stages
local crop_def = {
	drawtype = "plantlike",
	tiles = {"strawberry_1.png"},
	paramtype = "light",
	sunlight_propagates = true,
	waving = 1,
	walkable = false,
	buildable_to = true,
	drop = "",
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, -5/16, 0.5}
	},
	groups = {
		snappy = 3, flammable = 2, plant = 1, attached_node = 1,
		not_in_creative_inventory = 1, growing = 1
	},
	sounds = default.node_sound_leaves_defaults(),
}

--stage 1
minetest.register_node("ethereal:strawberry_1", table.copy(crop_def))

-- stage 2
crop_def.tiles = {"strawberry_2.png"}
minetest.register_node("ethereal:strawberry_2", table.copy(crop_def))

-- stage 3
crop_def.tiles = {"strawberry_3.png"}
minetest.register_node("ethereal:strawberry_3", table.copy(crop_def))

-- stage 4
crop_def.tiles = {"strawberry_4.png"}
minetest.register_node("ethereal:strawberry_4", table.copy(crop_def))

-- stage 5
crop_def.tiles = {"strawberry_5.png"}
minetest.register_node("ethereal:strawberry_5", table.copy(crop_def))

-- stage 6
crop_def.tiles = {"strawberry_6.png"}
crop_def.drop = {
	items = {
		{items = {"ethereal:strawberry 1"},rarity = 2},
		{items = {"ethereal:strawberry 2"},rarity = 3},
	}
}
minetest.register_node("ethereal:strawberry_6", table.copy(crop_def))

-- stage 7
crop_def.tiles = {"strawberry_7.png"}
crop_def.drop = {
	items = {
		{items = {"ethereal:strawberry 1"},rarity = 1},
		{items = {"ethereal:strawberry 2"},rarity = 3},
	}
}
minetest.register_node("ethereal:strawberry_7", table.copy(crop_def))

-- stage 8
crop_def.tiles = {"strawberry_8.png"}
crop_def.groups.growing = 0
crop_def.drop = {
	items = {
		{items = {"ethereal:strawberry 2"},rarity = 1},
		{items = {"ethereal:strawberry 3"},rarity = 3},
	}
}
minetest.register_node("ethereal:strawberry_8", table.copy(crop_def))

-- growing routine if farming redo isn't present
if not farming or not farming.mod or farming.mod ~= "redo" then

minetest.register_abm({
	label = "Ethereal grow strawberry",
	nodenames = {
		"ethereal:strawberry_1", "ethereal:strawberry_2", "ethereal:strawberry_3",
		"ethereal:strawberry_4", "ethereal:strawberry_5", "ethereal:strawberry_6",
		"ethereal:strawberry_7"
	},
	neighbors = {"farming:soil_wet"},
	interval = 9,
	chance = 20,
	catch_up = false,
	action = function(pos, node)

		-- are we on wet soil?
		pos.y = pos.y - 1
		if minetest.get_item_group(minetest.get_node(pos).name, "soil") < 3 then
			return
		end
		pos.y = pos.y + 1
		
		-- do we have enough light?
		local light = minetest.get_node_light(pos)

		if not light
		or light < 13 then
			return
		end
		
		-- grow to next stage
		local num = node.name:split("_")[2]

		node.name = "ethereal:strawberry_" .. tonumber(num + 1)

		minetest.swap_node(pos, node)
	end
})

end -- END IF
