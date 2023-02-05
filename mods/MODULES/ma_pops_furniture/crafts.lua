--changed bathroom_faucet to bath_faucet and added craft
minetest.register_craft({
	output = 'ma_pops_furniture:bath_faucet',
	recipe = {
	{'default:steel_ingot','default:steel_ingot','default:steel_ingot',},
	{'default:steel_ingot','','mesecraft_bucket:bucket_water',},
	{'default:steel_ingot','','',},
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
--added craft
minetest.register_craft({
	output = 'ma_pops_furniture:toilet_close',
	recipe = {
	{'','','default:steel_ingot',},
	{'default:steel_ingot','stairs:slab_wood','default:steel_ingot',},
	{'default:steel_ingot','mesecraft_bucket:bucket_water','default:steel_ingot',},
	}
})
--added craft
minetest.register_craft({
	output = 'ma_pops_furniture:br_sink',
	recipe = {
	{'default:steel_ingot','','default:steel_ingot',},
	{'','default:steel_ingot','',},
	{'','default:steel_ingot','',},
	}
})

minetest.register_craft({
	output = 'ma_pops_furniture:mirror_closed',
	recipe = {
	{'default:steel_ingot','default:steel_ingot','default:steel_ingot',},
	{'default:glass','default:glass','default:glass',},
	{'default:steel_ingot','default:steel_ingot','default:steel_ingot',},
	}
})
--added craft
minetest.register_craft({
	output = 'ma_pops_furniture:shower_base',
	recipe = {
	{'','','',},
	{'','','',},
	{'default:steel_ingot','mesecraft_bucket:bucket_empty','default:steel_ingot',},
	}
})
--added craft
minetest.register_craft({
	output = 'ma_pops_furniture:shower_top',
	recipe = {
	{'','default:steel_ingot','',},
	{'default:steel_ingot','mesecraft_bucket:bucket_water','default:steel_ingot',},
	{'default:steel_ingot','','default:steel_ingot',},
	}
})

--added craft
minetest.register_craft({
	output = 'ma_pops_furniture:dw',
	recipe = {
	{'default:steel_ingot','default:steel_ingot','default:steel_ingot',},
	{'default:steel_ingot','mesecraft_bucket:bucket_water','default:steel_ingot',},
	{'default:steel_ingot','default:mese_crystal','default:steel_ingot',},
	}
})

minetest.register_craft({
	output = 'ma_pops_furniture:oven',
	recipe = {
	{'default:steel_ingot','default:mese','default:steel_ingot',},
	{'default:steel_ingot','default:furnace','default:steel_ingot',},
	{'default:steel_ingot','default:mese','default:steel_ingot',},
	}
})
--added craft
minetest.register_craft({
	output = 'ma_pops_furniture:oven_overhead',
	recipe = {
	{'default:steel_ingot','default:mese_crystal_fragment','default:steel_ingot',},
	{'','','',},
	{'','','',},
	}
})

minetest.register_craft({
	output = 'ma_pops_furniture:microwave',
	recipe = {
	{'','','',},
	{"default:steel_ingot", "default:mese", "default:steel_ingot"},
	{'default:steel_ingot','default:furnace','default:steel_ingot',},
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
--added craft
minetest.register_craft({
	output = 'ma_pops_furniture:toaster',
	recipe = {
	{'','','',},
	{'default:steel_ingot','default:mese_crystal','default:steel_ingot',},
	{'default:steel_ingot','default:steel_ingot','default:steel_ingot',},
	}
})
--added craft
minetest.register_craft({
	output = 'ma_pops_furniture:kitchen_faucet',
	recipe = {
	{'default:steel_ingot','default:steel_ingot','default:steel_ingot',},
	{'default:steel_ingot','','default:steel_ingot',},
	{'default:steel_ingot','','',},
	}
})

--added craft
minetest.register_craft({
	output = 'ma_pops_furniture:fridge',
	recipe = {
	{'default:steel_ingot','default:steel_ingot','default:steel_ingot',},
	{'default:steel_ingot','default:snow','default:steel_ingot',},
	{'default:steel_ingot','default:steel_ingot','default:steel_ingot',},
	}
})
--added craft
minetest.register_craft({
	output = 'ma_pops_furniture:freezer',
	recipe = {
	{'default:steel_ingot','default:mese_crystal','default:steel_ingot',},
	{'default:steel_ingot','default:ice','default:steel_ingot',},
	{'default:steel_ingot','default:mese_crystal','default:steel_ingot',},
	}
})

local chair2_table = { --color
{'black'},
{'blue'},
{'brown'},
{'cyan'},
{'dark_green'},
{'dark_grey'},
{'green'},
{'grey'},
{'magenta'},
{'orange'},
{'pink'},
{'red'},
{'violet'},
{'yellow'},
}

for i in ipairs (chair2_table) do
	local color = chair2_table[i][1]
	
minetest.register_craft({
	output = 'ma_pops_furniture:chair2_'..color,
	recipe = {
	{'wool:'..color, 'wool:'..color, 'wool:'..color, },
	{'wool:'..color, 'wool:'..color, 'wool:'..color, },
	{'group:wood', '', 'group:wood', },
	}
})

minetest.register_craft({
	output = 'ma_pops_furniture:chair2_'..color,
	recipe = {
	{'ma_pops_furniture:chair2_white', 'dye:'..color}
	}
})

minetest.register_craft({
	output = 'ma_pops_furniture:chair2_white',
	recipe = {
	{'ma_pops_furniture:chair2_'..color, 'dye:white'}
	}
})

minetest.register_craft({
	output = 'ma_pops_furniture:chair2_black',
	recipe = {
	{'ma_pops_furniture:chair2_'..color, 'dye:black'}
	}
})

minetest.register_craft({
	output = 'ma_pops_furniture:chair2_blue',
	recipe = {
	{'ma_pops_furniture:chair2_'..color, 'dye:blue'}
	}
})

minetest.register_craft({
	output = 'ma_pops_furniture:chair2_brown',
	recipe = {
	{'ma_pops_furniture:chair2_'..color, 'dye:brown'}
	}
})

minetest.register_craft({
	output = 'ma_pops_furniture:chair2_cyan',
	recipe = {
	{'ma_pops_furniture:chair2_'..color, 'dye:cyan'}
	}
})

minetest.register_craft({
	output = 'ma_pops_furniture:chair2_dark_grey',
	recipe = {
	{'ma_pops_furniture:chair2_'..color, 'dye:dark_grey'}
	}
})

minetest.register_craft({
	output = 'ma_pops_furniture:chair2_grey',
	recipe = {
	{'ma_pops_furniture:chair2_'..color, 'dye:grey'}
	}
})

minetest.register_craft({
	output = 'ma_pops_furniture:chair2_green',
	recipe = {
	{'ma_pops_furniture:chair2_'..color, 'dye:green'}
	}
})

minetest.register_craft({
	output = 'ma_pops_furniture:chair2_magenta',
	recipe = {
	{'ma_pops_furniture:chair2_'..color, 'dye:magenta'}
	}
})

minetest.register_craft({
	output = 'ma_pops_furniture:chair2_orange',
	recipe = {
	{'ma_pops_furniture:chair2_'..color, 'dye:orange'}
	}
})

minetest.register_craft({
	output = 'ma_pops_furniture:chair2_pink',
	recipe = {
	{'ma_pops_furniture:chair2_'..color, 'dye:pink'}
	}
})

minetest.register_craft({
	output = 'ma_pops_furniture:chair2_red',
	recipe = {
	{'ma_pops_furniture:chair2_'..color, 'dye:red'}
	}
})

minetest.register_craft({
	output = 'ma_pops_furniture:chair2_violet',
	recipe = {
	{'ma_pops_furniture:chair2_'..color, 'dye:violet'}
	}
})

minetest.register_craft({
	output = 'ma_pops_furniture:chair2_yellow',
	recipe = {
	{'ma_pops_furniture:chair2_'..color, 'dye:yellow'}
	}
})
end

minetest.register_craft({
	output = 'ma_pops_furniture:chair2_white',
	recipe = {
	{'wool:white', 'wool:white', 'wool:white', },
	{'wool:white', 'wool:white', 'wool:white', },
	{'group:wood', '', 'group:wood', },
	}
})

--added craft
minetest.register_craft({
	output = 'ma_pops_furniture:birdbath',
	recipe = {
	{'','','',},
	{'default:steel_ingot','mesecraft_bucket:bucket_water','default:steel_ingot',},
	{'','default:steel_ingot','',},
	}
})

