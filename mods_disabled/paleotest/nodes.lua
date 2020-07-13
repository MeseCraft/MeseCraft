-- Nodes

--Fossil Blocks
minetest.register_node("paleotest:desert_fossil_block", {
	description = "Desert Fossil Block",
	tiles = {"default_desert_stone.png^paleotest_fossil_desert_overlay.png"},
	groups = {cracky = 2, not_in_creative_inventory=1},
	drop = 'paleotest:fossil',
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("paleotest:fossil_block", {
	description = "Fossil Block",
	tiles = {"default_stone.png^paleotest_fossil_overlay.png"},
	groups = {cracky = 2, not_in_creative_inventory=1},
	drop = 'paleotest:fossil',
	sounds = default.node_sound_stone_defaults(),
})

-- Electric Fence Wire
default.register_fence_rail("paleotest:dinosaur_fence", {
	description = "Electrified Fence Wire",
	texture = "default_steel_block.png",
	inventory_image = "default_fence_rail_overlay.png^default_steel_block.png^" ..
				"default_fence_rail_overlay.png^[makealpha:255,126,126",
	wield_image = "default_fence_rail_overlay.png^default_steel_block.png^" ..
				"default_fence_rail_overlay.png^[makealpha:255,126,126",
	material = "default:steelblock",
	connects_to = { "group:wall", "group:fence" },
	groups = {cracky = 1, level = 2},
	damage_per_second = 9,
	sounds = default.node_sound_metal_defaults()
})

walls.register("paleotest:steel", "Steel Wall", {"default_steel_block.png"},
		"default:steelblock", default.node_sound_metal_defaults())

-- Cyad Plant
minetest.register_node("paleotest:Cycad", {
	description = ("Cycad"),
	drawtype = "plantlike",
	visual_scale = 3.0,
	tiles = {"paleotest_cycad.png"},
	inventory_image = "paleotest_cycad.png",
	wield_image = "paleotest_cycad.png",
	paramtype = "light",
	paramtype2 = "meshoptions",
	place_param2 = 2,
	sunlight_propagates = true,
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-4 / 16, -0.5, -4 / 16, 4 / 16, 7 / 16, 4 / 16}
	},
	groups = {snappy = 2, flammable = 2},
	sounds = default.node_sound_leaves_defaults(),

})

-- Horsetails Underwater plant
minetest.register_node("paleotest:Horsetails", {
	description = ("Horsetails"),
	drawtype = "plantlike",
	waving = 1,
	visual_scale = 3.0,
	tiles = {"paleotest_horsetails.png"},
	inventory_image = "paleotest_horsetails.png",
	wield_image = "paleotest_horsetails.png",
	paramtype = "light",
	paramtype2 = "meshoptions",
	place_param2 = 3,
	sunlight_propagates = true,
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-4 / 16, -0.5, -4 / 16, 4 / 16, 7 / 16, 4 / 16}
	},
	groups = {snappy = 2, flammable = 2},
	sounds = default.node_sound_leaves_defaults(),

})