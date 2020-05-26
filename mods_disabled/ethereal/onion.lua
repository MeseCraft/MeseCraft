
local S = ethereal.intllib

-- wild onion
minetest.register_craftitem("ethereal:wild_onion_plant", {
	description = S("Wild Onion"),
	inventory_image = "wild_onion.png",
	wield_image = "wild_onion.png",
	groups = {food_onion = 1, flammable = 2},
	on_place = function(itemstack, placer, pointed_thing)
		return farming.place_seed(itemstack, placer, pointed_thing, "ethereal:wild_onion_1")
	end,
	on_use = minetest.item_eat(2),
})

-- Define Onion growth stages
local crop_def = {
	drawtype = "plantlike",
	tiles = {"ethereal_wild_onion_1.png"},
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	drop = "",
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, -5/16, 0.5}
	},
	groups = {
		snappy = 3, flammable = 2, plant = 1, attached_node = 1,
		growing = 1, not_in_creative_inventory = 1
	},
	sounds = default.node_sound_leaves_defaults(),
}

--stage 1
minetest.register_node("ethereal:onion_1", table.copy(crop_def))

--stage 2
crop_def.tiles = {"ethereal_wild_onion_2.png"}
minetest.register_node("ethereal:onion_2", table.copy(crop_def))

--stage 3
crop_def.tiles = {"ethereal_wild_onion_3.png"}
minetest.register_node("ethereal:onion_3", table.copy(crop_def))

--stage 4
crop_def.tiles = {"ethereal_wild_onion_4.png"}
crop_def.drop = {
	items = {
		{items = {"ethereal:wild_onion_plant"}, rarity = 1},
		{items = {"ethereal:wild_onion_plant 2"}, rarity = 3},
	}
}
minetest.register_node("ethereal:onion_4", table.copy(crop_def))

--stage 5
crop_def.tiles = {"ethereal_wild_onion_5.png"}
crop_def.groups.growing = 0
crop_def.drop = {
	items = {
		{items = {"ethereal:wild_onion_plant 2"}, rarity = 1},
		{items = {"ethereal:wild_onion_plant 3"}, rarity = 2},
	}
}
minetest.register_node("ethereal:onion_5", table.copy(crop_def))

-- growing routine if farming redo isn't present
if not farming or not farming.mod or farming.mod ~= "redo" then

minetest.register_abm({
	label = "Ethereal grow onion",
	nodenames = {"ethereal:onion_1", "ethereal:onion_2", "ethereal:onion_3", "ethereal:onion_4"},
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

		node.name = "ethereal:onion_" .. tonumber(num + 1)

		minetest.swap_node(pos, node)
	end
})

end -- END IF
