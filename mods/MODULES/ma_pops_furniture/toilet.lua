local S = ma_pops_furniture.intllib

--Toilet and Toilet Paper Dispenser--
minetest.register_node('ma_pops_furniture:toilet_open', {
	description = S('Toilet'),
	drawtype = 'mesh',
	mesh = 'FM_toilet_open.obj',
	tiles = {{name='default_coral_skeleton.png'},{name='default_wood.png'}},
	groups = {choppy=2, oddly_breakably_by_hand=2, furniture=1, not_in_creative_inventory=1},
	--inventory_image = 'fm_chair_stone.png',
	paramtype = 'light',
	paramtype2 = 'facedir',
	sounds = default.node_sound_wood_defaults(),
	selection_box = {
		type = 'fixed',
		fixed = {
			{-.35, -.5, -.35, .35, 0, .5}, -- Right, Bottom, Back, Left, Top, Front
			{-.35, 0, .15, .35, .5, .5},
			}
		},
	collision_box = {
		fixed = {
			{-.35, -.5, -.35, .35, 0, .5}, -- Right, Bottom, Back, Left, Top, Front
			{-.35, 0, .15, .35, .5, .5},
			}
		},
	drop = 'ma_pops_furniture:toilet_close',
	on_rightclick = ma_pops_furniture.sit,
	can_dig = ma_pops_furniture.cannot_dig_while_sitting,
	on_blast = ma_pops_furniture.unsit_on_blast,
	on_punch = function (pos, node, puncher)
		node.name = "ma_pops_furniture:toilet_close"
		minetest.set_node(pos, node)
	end,
})

minetest.register_node('ma_pops_furniture:toilet_close', {
	description = S('Toilet'),
	drawtype = 'mesh',
	mesh = 'FM_toilet_close.obj',
	tiles = {{name='default_coral_skeleton.png'},{name='default_wood.png'}},
	groups = {choppy=2, oddly_breakably_by_hand=2, furniture=1},
	paramtype = 'light',
	paramtype2 = 'facedir',
	sounds = default.node_sound_wood_defaults(),
	selection_box = {
		type = 'fixed',
		fixed = {
			{-.35, -.5, -.35, .35, .1, .5}, -- Right, Bottom, Back, Left, Top, Front
			{-.35, .1, .25, .35, .5, .5},
			}
		},
	collision_box = {
		fixed = {
			{-.35, -.5, -.35, .35, .1, .5}, -- Right, Bottom, Back, Left, Top, Front
			{-.35, .1, .25, .35, .5, .5},
			}
		},
	on_rightclick = ma_pops_furniture.sit,
	can_dig = ma_pops_furniture.cannot_dig_while_sitting,
	on_blast = ma_pops_furniture.unsit_on_blast,
	on_punch = function (pos, node, puncher)
		node.name = "ma_pops_furniture:toilet_open"
		minetest.set_node(pos, node)
	end,
})

minetest.register_craft({
	output = 'ma_pops_furniture:toilet_close',
	recipe = {
	{'','','default:steel_ingot',},
	{'default:steel_ingot','stairs:slab_wood','default:steel_ingot',},
	{'default:steel_ingot','mesecraft_bucket:bucket_water','default:steel_ingot',},
	}
})

minetest.register_node("ma_pops_furniture:toilet_paper_roll_dispenser", {
   description = S("Toilet Paper Roll Dispenser"),
   tiles = {
		"ma_pops_furniture_tp_top.png",
		"ma_pops_furniture_tp_bottom.png",
		"ma_pops_furniture_tp_right.png",
		"ma_pops_furniture_tp_left.png",
		"ma_pops_furniture_tp_back.png",
		"ma_pops_furniture_tp_front.png"
	},
   drawtype = "nodebox",
   paramtype = "light",
   paramtype2 = "facedir",
   groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
   node_box = {
       type = "fixed",
       fixed = {
          {-0.3125, -0.1875, 0.4375, 0.3125, 0.125, 0.5},
		  {-0.1875, -0.125, 0.25, 0.1875, 0.0625, 0.4375},
		  {-0.25, -0.0625, 0.3125, 0.25, 0, 0.5},
       },
   }
})

minetest.register_craft({
	output = 'ma_pops_furniture:toilet_paper_roll_dispenser',
	recipe = {
	{'default:stone','default:stone','default:stone',},
	{'default:paper','default:water_source','default:paper',},
	{'','default:paper','',},
	}
})
