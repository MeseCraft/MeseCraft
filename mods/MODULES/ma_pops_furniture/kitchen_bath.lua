local S = ma_pops_furniture.intllib

--All manner of water using items, divided by room--

--Bathroom--
minetest.register_node("ma_pops_furniture:bath_faucet", {
   description = S("Bathroom Faucet"),
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

minetest.register_craft({
	output = 'ma_pops_furniture:bath_faucet',
	recipe = {
	{'default:steel_ingot','default:steel_ingot','default:steel_ingot',},
	{'default:steel_ingot','','mesecraft_bucket:bucket_water',},
	{'default:steel_ingot','','',},
	}
})

minetest.register_node("ma_pops_furniture:br_sink", {
   description = S("Sink (Bathroom)"),
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

minetest.register_craft({
	output = 'ma_pops_furniture:br_sink',
	recipe = {
	{'default:steel_ingot','','default:steel_ingot',},
	{'','default:steel_ingot','',},
	{'','default:steel_ingot','',},
	}
})

minetest.register_node("ma_pops_furniture:shower_base", {
   description = S("Shower Base"),
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

minetest.register_craft({
	output = 'ma_pops_furniture:shower_base',
	recipe = {
	{'','','',},
	{'','','',},
	{'default:steel_ingot','mesecraft_bucket:bucket_empty','default:steel_ingot',},
	}
})

minetest.register_craft({
	output = 'ma_pops_furniture:shower_top',
	recipe = {
	{'','default:steel_ingot','',},
	{'default:steel_ingot','mesecraft_bucket:bucket_water','default:steel_ingot',},
	{'default:steel_ingot','','default:steel_ingot',},
	}
})

minetest.register_node("ma_pops_furniture:shower_top", {
   description = S("Shower Head"),
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
	description= S("Dishwasher"),
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

minetest.register_craft({
	output = 'ma_pops_furniture:dw',
	recipe = {
	{'default:steel_ingot','default:steel_ingot','default:steel_ingot',},
	{'default:steel_ingot','mesecraft_bucket:bucket_water','default:steel_ingot',},
	{'default:steel_ingot','default:mese_crystal','default:steel_ingot',},
	}
})

minetest.register_node("ma_pops_furniture:coffee_maker", {
	description = S("Coffee Maker"),
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

minetest.register_craft({
	output = 'ma_pops_furniture:coffee_maker',
	recipe = {
	{'default:steel_ingot','default:steel_ingot','default:steel_ingot',},
	{'default:steel_ingot','default:copper_ingot','default:steel_ingot',},
	{'','default:glass','',},
	}
})

minetest.register_node("ma_pops_furniture:kitchen_faucet", {
   description = S("Kitchen Faucet"),
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

minetest.register_craft({
	output = 'ma_pops_furniture:kitchen_faucet',
	recipe = {
	{'default:steel_ingot','default:steel_ingot','default:steel_ingot',},
	{'default:steel_ingot','','default:steel_ingot',},
	{'default:steel_ingot','','',},
	}
})

--Outside--
minetest.register_node('ma_pops_furniture:birdbath', {
	description = S('Birdbath'),
	drawtype = 'mesh',
	mesh = 'FM_birdbath.obj',
	tiles = {{name='default_stone.png'},{name='default_water_source_animated.png', animation={type='vertical_frames', aspect_w=16, aspect_h=16, length=2.0}}},
	groups = {cracky=2, oddly_breakable_by_hand=5, furniture=1},
	paramtype = 'light',
	paramtype2 = 'facedir',
	sounds = default.node_sound_stone_defaults(),
})

if thirsty and thirsty.config and thirsty.config.node_drinkable then
	thirsty.config.node_drinkable['ma_pops_furniture:birdbath'] = true
end

minetest.register_craft({
	output = 'ma_pops_furniture:birdbath',
	recipe = {
	{'','','',},
	{'default:steel_ingot','mesecraft_bucket:bucket_water','default:steel_ingot',},
	{'','default:steel_ingot','',},
	}
})
