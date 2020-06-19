minetest.register_node("decoblocks:bamboo_fence", {
	description = "Bamboo Fence",
	tiles = {
		"decoblocks_bamboo_fence_top.png",
		"decoblocks_bamboo_fence_top.png",
		"decoblocks_bamboo_fence.png",
	},
	inventory_image = "default_fence_overlay.png^decoblocks_bamboo.png^default_fence_overlay.png^[makealpha:255,126,126",
	wield_image = "default_fence_overlay.png^decoblocks_bamboo.png^default_fence_overlay.png^[makealpha:255,126,126",
	drawtype = "nodebox",
	paramtype = "light",
	connects_to = {"group:fence", "group:wood", "group:choppy", "group:stone"},
	node_box = {
		type = "connected",
		fixed = {
			{-0.125, -0.5, -0.125, 0.125, 0.5, 0.125}, -- NodeBox1
		},
		connect_back = {
			{-0.125, -0.5, -0.125, 0.125, 0.5, 0.125}, -- NodeBox1
			{-0.0625, 0.25, -0.0625, 0.0625, 0.375, 0.5}, -- NodeBox2
			{-0.0625, -0.0625, -0.0625, 0.0625, 0.0625, 0.5}, -- NodeBox3
			{-0.0625, -0.375, -0.0625, 0.0625, -0.25, 0.5}, -- NodeBox4
		},
		connect_front = {
			{-0.125, -0.5, -0.125, 0.125, 0.5, 0.125}, -- NodeBox1
			{-0.0625, 0.25, -0.5, 0.0625, 0.375, 0.0625}, -- NodeBox2
			{-0.0625, -0.0625, -0.5, 0.0625, 0.0625, 0.0625}, -- NodeBox3
			{-0.0625, -0.375, -0.5, 0.0625, -0.25, 0.0625}, -- NodeBox4
		},
		connect_left = {
			{-0.125, -0.5, -0.125, 0.125, 0.5, 0.125}, -- NodeBox1
			{-0.5, 0.25, -0.0625, 0.0625, 0.375, 0.0625}, -- NodeBox2
			{-0.5, -0.0625, -0.0625, 0.0625, 0.0625, 0.0625}, -- NodeBox3
			{-0.5, -0.375, -0.0625, 0.0625, -0.25, 0.0625}, -- NodeBox4
		},
		connect_right = {
			{-0.125, -0.5, -0.125, 0.125, 0.5, 0.125}, -- NodeBox1
			{0, 0.25, -0.0625, 0.5, 0.375, 0.0625}, -- NodeBox2
			{0, -0.0625, -0.0625, 0.5, 0.0625, 0.0625}, -- NodeBox3
			{0, -0.375, -0.0625, 0.5, -0.25, 0.0625}, -- NodeBox4
		}
	},
	groups = {choppy=1, oddly_breakable_by_hand=1, fence=1},
	sounds = default.node_sound_wood_defaults()
})

minetest.register_node("decoblocks:scarecrow", {
	description = "Scarecrow",
	drawtype = "mesh",
	mesh = "scarecrow.obj",
	paramtype2 = "facedir",
	tiles = {
		"decoblocks_scarecrow.png",
	},
	visual_scale = 0.5,
	wield_image = "decoblocks_scarecrow_item.png",
	wield_scale = {x=1.0, y=1.0, z=1.0},
	paramtype = "light",
	selection_box = {
		type = "fixed",
		fixed = {-0.3, -0.5, -0.3, 0.3, 1, 0.3}
	},
	collision_box = {
		type = "fixed",
		fixed = {-0.3, -0.5, -0.3, 0.3, 1, 0.3}
	},
	inventory_image = "decoblocks_scarecrow_item.png",
	groups = {choppy = 1, oddly_breakable_by_hand = 1},
	sounds = default.node_sound_wood_defaults()
})


minetest.register_node("decoblocks:spikes", {
	description = "Spikes",
	drawtype = "firelike",
	tiles = {
		"decoblocks_spikes.png"
	},
	wield_image = "decoblocks_spikes.png",
	inventory_image = "decoblocks_spikes.png",
	groups = {cracky=3},
	paramtype = "light",
	walkable = false,
	damage_per_second = 3,
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, -0.3, 0.5}
	},
	collision_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, -0.2, 0.5}
	}
})

minetest.register_node("decoblocks:paper_lantern", {
	description = "Paper Lantern",
	tiles = {"decoblocks_paper_lantern_top.png", "decoblocks_paper_lantern_top.png", "decoblocks_paper_lantern.png"},
	paramtype = "light",
	light_source = 13,
	is_ground_content = false,
		groups = {snappy = 2, choppy = 2, oddly_breakable_by_hand = 3,
				flammable = 3, wool = 1},
		sounds = default.node_sound_defaults(),
})
