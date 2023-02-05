--Bathroom--
minetest.register_node("ma_pops_furniture:bath_faucet", {
   description = "Bathroom Faucet",
   tiles = {
		"ma_pops_furniture_knob_top.png",
		"ma_pops_furniture_knob_bottom.png",
		"ma_pops_furniture_knob_right.png",
		"ma_pops_furniture_knob_left.png",
		"ma_pops_furniture_knob_back.png",
		"ma_pops_furniture_knob_front.png"
	},
   drawtype = "nodebox",
   paramtype = "light",
   paramtype2 = "facedir",
   groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
   node_box = {
       type = "fixed",
       fixed = {
			{-0.0625, -0.5, 0.3125, 0.0625, -0.1875, 0.4375},
			{-0.0625, -0.1875, 0.125, 0.0625, -0.125, 0.4375}, 
			{0.125, -0.25, 0.25, 0.25, -0.0625, 0.4375},
			{-0.25, -0.25, 0.25, -0.125, -0.0625, 0.4375},
			{-0.0625, -0.25, 0.125, 0.0625, -0.125, 0.1875},
			{-0.125, -0.1875, 0.3125, 0.125, -0.125, 0.375},
       },
   }
})

minetest.register_node("ma_pops_furniture:toilet_paper_roll_dispenser", {
   description = "Toilet Paper Roll Dispenser",
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

minetest.register_node('ma_pops_furniture:toilet_open', {
	description = 'Toilet',
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
			{-.35, 0, .2, .35, .5, .5},
			}
		},
	collision_box = {
		fixed = {
			{-.35, -.5, -.35, .35, 0, .5}, -- Right, Bottom, Back, Left, Top, Front
			{-.35, 0, .2, .35, .5, .5},
			}
		},
	on_rightclick = ma_pops_furniture.sit,
	on_punch = function (pos, node, puncher)
		node.name = "ma_pops_furniture:toilet_close"
		minetest.set_node(pos, node)
	end,
})

minetest.register_node('ma_pops_furniture:toilet_close', {
	description = 'Toilet',
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
			{-.35, -.5, -.35, .35, 0, .5}, -- Right, Bottom, Back, Left, Top, Front
			{-.35, 0, .2, .35, .5, .5},
			}
		},
	collision_box = {
		fixed = {
			{-.35, -.5, -.35, .35, 0, .5}, -- Right, Bottom, Back, Left, Top, Front
			{-.35, 0, .2, .35, .5, .5},
			}
		},
	on_rightclick = ma_pops_furniture.sit,
	on_punch = function (pos, node, puncher)
		node.name = "ma_pops_furniture:toilet_open"
		minetest.set_node(pos, node)
	end,
})

minetest.register_node("ma_pops_furniture:br_sink", {
   description = "Sink (Bathroom)",
   tiles = {
		"ma_pops_furniture_hw_top.png",
		"ma_pops_furniture_hw_bottom.png",
		"ma_pops_furniture_hw_right.png",
		"ma_pops_furniture_hw_left.png",
		"ma_pops_furniture_hw_back.png",
		"ma_pops_furniture_hw_front.png"
	},
   drawtype = "nodebox",
   paramtype = "light",
   paramtype2 = "facedir",
   groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
   node_box = {
       type = "fixed",
       fixed = {
         {-0.4375, 0.25, -0.3125, 0.4375, 0.5, 0.5},
		 {-0.125, -0.5, 0.125, 0.125, 0.25, 0.4375},
       },
   }
})

minetest.register_node("ma_pops_furniture:mirror_closed", {
   description = "Mirror",
   tiles = {
		"ma_pops_furniture_mirror_top.png",
		"ma_pops_furniture_mirror_bottom.png",
		"ma_pops_furniture_mirror_right.png",
		"ma_pops_furniture_mirror_left.png",
		"default_wood.png",
		"ma_pops_furniture_mirror_front.png"
	},
   drawtype = "nodebox",
   paramtype = "light",
   paramtype2 = "facedir",
   groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
   on_punch = function(pos, node, puncher)
		minetest.env:add_node(pos, {name = "ma_pops_furniture:mirror", param2 = node.param2})
		ma_pops_furniture.window_operate( pos, "ma_pops_furniture:mirror_closed", "ma_pops_furniture:mirror" );
		end,
   node_box = {
       type = "fixed",
       fixed = {
			{-0.4375, -0.375, 0.3125, 0.4375, 0.5, 0.5},
			{0, -0.375, 0.25, 0.4375, 0.5, 0.3125},
			{-0.4375, -0.375, 0.25, 2.98023e-008, 0.5, 0.3125},
       },
   }
})

minetest.register_node("ma_pops_furniture:mirror", {
   description = "Mirror (Open)",
   tiles = {
		"ma_pops_furniture_mirror_open_top.png",
		"ma_pops_furniture_mirror_open_bottom.png",
		"ma_pops_furniture_mirror_open_right.png",
		"ma_pops_furniture_mirror_open_left.png",
		"ma_pops_furniture_mirror_front.png",
		"ma_pops_furniture_mirror_open_front.png"
	},
   drawtype = "nodebox",
   paramtype = "light",
   paramtype2 = "facedir",
   drop = "ma_pops_furniture:mirror_closed",
   groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, not_in_creative_inventory = 1},
   on_punch = function(pos, node, puncher)
		minetest.env:add_node(pos, {name = "ma_pops_furniture:mirror_closed", param2 = node.param2})
		ma_pops_furniture.window_operate( pos, "ma_pops_furniture:mirror", "ma_pops_furniture:mirror_closed" );
		end,
		on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		local inv = meta:get_inventory()
		inv:set_size('main', 8*4)
		inv:set_size('storage', 4*4)
		meta:set_string('formspec',
			'size [9,10]'..
			'bgcolor[#080808BB;true]'..
			'list[context;storage;3,1.5;3,3;]'..
			'list[current_player;main;0.5,6.5;8,4;]'..
			'listring[]')
	end,
	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos);
		local inv = meta:get_inventory()
		return inv:is_empty('storage') and inv:is_empty('storage1')
	end,
   node_box = {
       type = "fixed",
       fixed = {
			{-0.4375, -0.375, 0.3125, 0.4375, 0.5, 0.5},
			{0.4375, -0.375, -0.125, 0.5, 0.5, 0.3125},
			{-0.5, -0.375, -0.125, -0.4375, 0.5, 0.3125},
       },
   }
})

minetest.register_node("ma_pops_furniture:shower_base", {
   description = "Shower Base",
   tiles = {
		"ma_pops_furniture_showbas_top.png",
		"ma_pops_furniture_showbas_top.png",
		"ma_pops_furniture_showbas_sides.png",
		"ma_pops_furniture_showbas_sides.png",
		"ma_pops_furniture_showbas_sides.png",
		"ma_pops_furniture_showbas_sides.png"
	},
   drawtype = "nodebox",
   paramtype = "light",
   paramtype2 = "facedir",
   groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
   node_box = {
       type = "fixed",
       fixed = {
          {-0.4375, -0.5, -0.4375, 0.4375, -0.4375, 0.4375}, 
		  {0.4375, -0.5, -0.5, 0.5, -0.3125, 0.5}, 
		  {-0.5, -0.5, 0.4375, 0.5, -0.3125, 0.5},
		  {-0.5, -0.5, -0.5, -0.4375, -0.3125, 0.5}, 
		  {-0.5, -0.5, -0.5, 0.5, -0.3125, -0.4375}, 
		  {-0.125, -0.5, 0.125, 0.125, -0.375, 0.375},
       }
    },
})

minetest.register_node("ma_pops_furniture:shower_top", {
   description = "Shower Head",
   tiles = {
		"ma_pops_furniture_shk_top.png",
		"ma_pops_furniture_shk_bottom.png",
		"ma_pops_furniture_shk_right.png",
		"ma_pops_furniture_shk_left.png",
		"ma_pops_furniture_shk_back.png",
		"ma_pops_furniture_shk_front.png"
	},
   drawtype = "nodebox",
   paramtype = "light",
   paramtype2 = "facedir",
   groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
   node_box = {
       type = "fixed",
       fixed = {
          {-0.25, -0.5, 0.4375, 0.25, 0.5, 0.5},
		  {-0.125, 0.3125, -0.1875, 0.125, 0.4375, 0.25},
		  {-0.1875, -0.25, 0.375, -0.125, -0.1875, 0.4375},
		  {0.125, -0.25, 0.375, 0.1875, -0.1875, 0.4375},
		  {-0.1875, -0.25, 0.3125, -0.125, -0.0625, 0.375}, 
		  {0.125, -0.25, 0.3125, 0.1875, -0.0625, 0.375}, 
		  {-0.0625, 0.375, 0.25, 0.0625, 0.4375, 0.4375}, 
        },
    }
})

--Kitchen/Dining Room--
minetest.register_node("ma_pops_furniture:dw", {
	description= "Dishwasher",
	tiles = {
		"ma_pops_furniture_dw_top.png",
		"ma_pops_furniture_dw_bottom.png",
		"ma_pops_furniture_dw_left.png",
		"ma_pops_furniture_dw_right.png",
		"ma_pops_furniture_dw_back.png",
		"ma_pops_furniture_dw_front.png"
	},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {choppy = 2, oddly_breakable_by_hand = 2, furniture = 1},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.4375, -0.5, -0.4375, 0.4375, -0.4375, 0.4375}, 
			{-0.5, -0.4375, -0.4375, 0.5, 0.5, 0.5}, 
			{-0.5, 0.3125, -0.5, 0.5, 0.5, -0.4375}, 
			{-0.4375, -0.4375, -0.5, 0.4375, 0.25, 0.5}, 
		}
	}
})

minetest.register_node("ma_pops_furniture:oven_overhead", {
	description= "Oven Overhead",
	tiles = {
		"ma_pops_furniture_camp_top.png",
		"ma_pops_furniture_camp_bottom.png",
		"ma_pops_furniture_camp_left.png",
		"ma_pops_furniture_camp_right.png",
		"ma_pops_furniture_camp_back.png",
		"ma_pops_furniture_camp_front.png"
	},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {choppy = 2, oddly_breakable_by_hand = 2, furniture = 1},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.4375, 0.4375, -0.4375, 0.4375, 0.5, 0.4375}, 
			{-0.5, 0.25, -0.5, 0.5, 0.4375, 0.5}, 
		}
	}
})

minetest.register_node("ma_pops_furniture:microwave", {
   description = "Microwave",
   tiles = {
		"ma_pops_furniture_mw_top.png",
		"ma_pops_furniture_mw_bottom.png",
		"ma_pops_furniture_mw_right.png",
		"ma_pops_furniture_mw_left.png",
		"ma_pops_furniture_mw_back.png",
		"ma_pops_furniture_mw_front.png"
	},
   drawtype = "nodebox",
   paramtype = "light",
   paramtype2 = "facedir",
   groups = {choppy = 2, oddly_breakable_by_hand = 2, furniture = 1},
   node_box = {
       type = "fixed",
       fixed = {
           {-0.4375, -0.4375, -0.3125, 0.4375, 0.0625, 0.3125},
			{-0.375, -0.5, -0.25, 0.375, -0.4375, 0.25}, 
       },
   }
})

minetest.register_node("ma_pops_furniture:coffee_maker", {
	description = "Coffee Maker",
	tiles = {
		"ma_pops_furniture_cof_top.png",
		"ma_pops_furniture_cof_bottom.png",
		"ma_pops_furniture_cof_right.png",
		"ma_pops_furniture_cof_left.png",
		"ma_pops_furniture_cof_back.png",
		"ma_pops_furniture_cof_front.png"
	},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {choppy = 2, oddly_breakable_by_hand = 2, furniture = 1},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.4375, -0.5, -0.0625, 0, -0.4375, 0.4375},
			{-0.4375, -0.5, 0.3125, 0, 0.1875, 0.4375}, 
			{-0.4375, -0.0625, 0, 0, 0.25, 0.4375}, 
			{-0.375, -0.4375, 0, -0.0625, -0.125, 0.25}, 
			{-0.25, -0.375, -0.125, -0.1875, -0.1875, 0.0625}, 
		}
	}
})

minetest.register_node("ma_pops_furniture:toaster", {
   description = "Toaster",
   tiles = {
		"ma_pops_furniture_toas_top.png",
		"ma_pops_furniture_toas_bottom.png",
		"ma_pops_furniture_toas_right.png",
		"ma_pops_furniture_toas_left.png",
		"ma_pops_furniture_toas_back.png",
		"ma_pops_furniture_toas_front.png"
	},
   drawtype = "nodebox",
   paramtype = "light",
   paramtype2 = "facedir",
   groups = {choppy = 2, oddly_breakable_by_hand = 2, furniture = 1},
   node_box = {
       type = "fixed",
       fixed = {
           {-0.375, -0.5, 0, 0.375, -0.0625, 0.3125},
		   {-0.4375, -0.1875, 0.0625, -0.375, -0.125, 0.25},
       },
   }
})

minetest.register_node("ma_pops_furniture:kitchen_faucet", {
   description = "Kitchen Faucet",
   tiles = {
		"ma_pops_furniture_grif_top.png",
		"ma_pops_furniture_grif_sides.png",
		"ma_pops_furniture_grif_sides.png",
		"ma_pops_furniture_grif_sides.png",
		"ma_pops_furniture_grif_sides.png",
		"ma_pops_furniture_grif_sides.png"
	},
   drawtype = "nodebox",
   paramtype = "light",
   paramtype2 = "facedir",
   groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
   node_box = {
       type = "fixed",
       fixed = {
			{-0.0625, -0.5, 0.375, 0.0625, -0.1875, 0.4375},
			{-0.0625, -0.1875, 0.0625, 0.0625, -0.125, 0.4375},
			{-0.0625, -0.25, 0.0625, 0.0625, -0.1875, 0.125},
			{0.125, -0.5, 0.3125, 0.25, -0.375, 0.4375},
			{-0.25, -0.5, 0.3125, -0.125, -0.375, 0.4375},
       },
   }
})

minetest.register_node("ma_pops_furniture:fridge", {
	description= "Fridge",
	tiles = {
		"ma_pops_furniture_fridge_top.png",
		"ma_pops_furniture_fridge_bottom.png",
		"ma_pops_furniture_fridge_right.png",
		"ma_pops_furniture_fridge_left.png",
		"ma_pops_furniture_fridge_back.png",
		"ma_pops_furniture_fridge_front.png"
	},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {choppy = 2, oddly_breakable_by_hand = 2, furniture = 1},
		on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		local inv = meta:get_inventory()
		inv:set_size('main', 8*4)
		inv:set_size('storage', 6*4)
		meta:set_string('formspec',
			'size [9,10]'..
			default.gui_bg..
			default.gui_bg_img..
			default.gui_slots..
			'bgcolor[#080808BB;true]'..
			'list[context;storage;1.5,1;6,4;]'..
			'list[current_player;main;0.5,6;8,4;]'..
			'listring[]')
	end,
	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos);
		local inv = meta:get_inventory()
		return inv:is_empty('storage') and inv:is_empty('storage1')
	end,
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.3125, 0.5, 0.5, 0.5}, -- NodeBox1
			{-0.5, -0.4375, -0.375, 0.4375, 0.5, -0.3125}, -- NodeBox2
			{0.3125, -0.25, -0.5, 0.375, 0.25, -0.4375}, -- NodeBox6
			{0.3125, -0.25, -0.4375, 0.375, -0.1875, -0.375}, -- NodeBox7
			{0.3125, 0.1875, -0.4375, 0.375, 0.25, -0.375}, -- NodeBox8
		}
	}
})

--Living Room--
local chair2_table = { --name, color, colorize(hex or color name:intensity(1-255))
{'Black', 'black', 'black:225'},
{'Blue', 'blue', 'blue:225'},
{'Brown', 'brown', 'brown:225'},
{'Cyan', 'cyan', 'cyan:200'},
{'Dark Green', 'dark_green', 'green:225'},
{'Dark Grey', 'dark_grey', 'black:200'},
{'Green', 'green', '#32cd32:150'},
{'Grey', 'grey', 'black:100'},
{'Magenta', 'magenta', 'magenta:200'},
{'Orange', 'orange', 'orange:225'},
{'Pink', 'pink', 'pink:225'},
{'Red', 'red', 'red:225'},
{'Violet', 'violet', 'violet:225'},
{'White', 'white', 'white:1'},
{'Yellow', 'yellow', 'yellow:225'},
}

for i in ipairs (chair2_table) do
    local name = chair2_table[i][1]
    local color = chair2_table[i][2]
    local hex = chair2_table[i][3]

local cb = "^([combine:16x16:0,0=ma_pops_furniture_cb.png^[mask:ma_pops_furniture_mask.png)"
local cf = "^([combine:16x16:0,0=ma_pops_furniture_cf.png^[mask:ma_pops_furniture_mask.png)"

minetest.register_node("ma_pops_furniture:chair2_"..color, {
    description = name.." Arm Chair",
    tiles = {"wool_"..color..".png","wool_"..color..".png"..cb,"wool_"..color..".png"..cf,"wool_"..color..".png"..cf,"wool_"..color..".png"..cf,"wool_"..color..".png"..cf,},
    drawtype = "nodebox",
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, furniture = 1, fall_damage_add_percent=-80, bouncy=80},
	sounds = {wood = {name="furn_bouncy", gain=0.8}},
    on_rightclick = ma_pops_furniture.sit,
    node_box = {
        type = "fixed",
        fixed = {
            {-0.4, -0.5, -0.4, -0.3, -0.4, -0.3},
            {-0.4, -0.5, 0.4, -0.3, -0.4, 0.3},
            {0.4, -0.5, 0.4, 0.3, -0.4, 0.3},
            {0.4, -0.5, -0.4, 0.3, -0.4, -0.3},
            -----------------------------------
            {-0.450, -0.4, -0.450, 0.450, 0.1, 0.450},
            {-0.5, 0.1, -0.5, -0.3, 0.3, 0.0},
            {0.5, 0.1, -0.5, 0.3, 0.3, 0.0},
            {0.450, 0.1, -0.0, -0.450, 0.5, 0.450},
        },
    }
})
end

--Outside--
minetest.register_node('ma_pops_furniture:birdbath', {
	description = 'Birdbath',
	drawtype = 'mesh',
	mesh = 'FM_birdbath.obj',
	tiles = {{name='default_stone.png'},{name='default_water_source_animated.png', animation={type='vertical_frames', aspect_w=16, aspect_h=16, length=2.0}}},
	groups = {cracky=2, oddly_breakable_by_hand=5, furniture=1},
	paramtype = 'light',
	paramtype2 = 'facedir',
	sounds = default.node_sound_stone_defaults(),
})
