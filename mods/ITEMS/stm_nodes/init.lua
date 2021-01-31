minetest.register_node("stm_nodes:tin_roof", {
	description = "Corrugated Tin Roof",
	tiles = {
		"stm_nodes_corrugated_tin.png",
		"stm_nodes_corrugated_tin.png",
		"stm_nodes_tin.png",
	},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, -0.375, -0.4375, 0.5}, -- NodeBox6
			{-0.375, -0.4375, -0.5, -0.25, -0.375, 0.5}, -- NodeBox7
			{-0.375, -0.4375, -0.5, -0.25, -0.375, 0.5}, -- NodeBox8
			{-0.25, -0.5, -0.5, -0.125, -0.4375, 0.5}, -- NodeBox9
			{-0.125, -0.4375, -0.5, 0, -0.375, 0.5}, -- NodeBox10
			{0, -0.5, -0.5, 0.125, -0.4375, 0.5}, -- NodeBox11
			{0.125, -0.4375, -0.5, 0.25, -0.375, 0.5}, -- NodeBox12
			{0.25, -0.5, -0.5, 0.375, -0.4375, 0.5}, -- NodeBox13
			{0.375, -0.4375, -0.5, 0.5, -0.375, 0.5}, -- NodeBox14
		}
	},
	sounds = default.node_sound_metal_defaults(),
	groups = {cracky=1},
	on_place = minetest.rotate_node
})

minetest.register_craft({
        output = 'stm_nodes:tin_roof 4',
        recipe = {
                {'', '', ''},
                {'', '', ''},
                {'default:tin_ingot', 'default:tin_ingot', 'default:tin_ingot'},
        }
})


minetest.register_node("stm_nodes:rusty_tin_roof", {
	description = "Rusty Corrugated Tin Roof",
	tiles = {
		"stm_nodes_rusty_corrugated_tin.png",
		"stm_nodes_rusty_corrugated_tin.png",
		"stm_nodes_rusty_corrugated_tin.png",
	},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, -0.375, -0.4375, 0.5}, -- NodeBox6
			{-0.375, -0.4375, -0.5, -0.25, -0.375, 0.5}, -- NodeBox7
			{-0.375, -0.4375, -0.5, -0.25, -0.375, 0.5}, -- NodeBox8
			{-0.25, -0.5, -0.5, -0.125, -0.4375, 0.5}, -- NodeBox9
			{-0.125, -0.4375, -0.5, 0, -0.375, 0.5}, -- NodeBox10
			{0, -0.5, -0.5, 0.125, -0.4375, 0.5}, -- NodeBox11
			{0.125, -0.4375, -0.5, 0.25, -0.375, 0.5}, -- NodeBox12
			{0.25, -0.5, -0.5, 0.375, -0.4375, 0.5}, -- NodeBox13
			{0.375, -0.4375, -0.5, 0.5, -0.375, 0.5}, -- NodeBox14
		}
	},
	sounds = default.node_sound_metal_defaults(),
	groups = {cracky=1},
	on_place = minetest.rotate_node
})

minetest.register_craft({
        output = 'stm_nodes:rusty_tin_roof 4',
        recipe = {
                {'', '', ''},
                {'', '', ''},
                {'default:tin_ingot', 'default:tin_ingot', ''},
        }
})

