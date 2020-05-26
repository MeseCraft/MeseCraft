local rc = laptop.recipe_compat -- Recipe items from other mods

----------------------------
---------PROCESSORS---------
----------------------------

minetest.register_craftitem("laptop:cpu_c6", {
	description = 'Ziram c6 Processor',
	inventory_image = "laptop_cpu_c6.png",
})

minetest.register_craft({
	output = 'laptop:cpu_c6',
	recipe = {
		{'', '', ''},
		{rc.silicon, rc.gates_diode, rc.tin},
		{rc.gates_and, rc.gates_or, rc.gates_nand},
	}
})

minetest.register_craftitem("laptop:cpu_d75a", {
	description = 'Interlink D75A Processor',
	inventory_image = "laptop_cpu_d75a.png",
})

minetest.register_craft({
	output = 'laptop:cpu_d75a',
	recipe = {
		{rc.silicon, rc.silicon, rc.silicon},
		{rc.gates_xor, rc.copper, rc.gates_nand},
		{rc.fpga, rc.programmer, rc.fpga},
	}
})

minetest.register_craftitem("laptop:cpu_jetcore", {
	description = 'Interlink jetCore Processor',
	inventory_image = "laptop_cpu_jetcore.png",
})

minetest.register_craft({
	output = 'laptop:cpu_jetcore',
	recipe = {
		{rc.silicon, rc.silicon, rc.silicon},
		{rc.fiber, rc.gold, rc.delayer},
		{rc.fpga, rc.controller, rc.programmer},
	}
})

minetest.register_craftitem("laptop:cpu_65536", {
	description = 'Transpose 65536 Processor',
	inventory_image = "laptop_cpu_65536.png",
})

minetest.register_craft({
	output = 'laptop:cpu_65536',
	recipe = {
		{'', '', ''},
		{rc.silicon, rc.copper, rc.silicon},
		{rc.gates_not, rc.fpga, rc.delayer},
	}
})

minetest.register_craftitem("laptop:bat", {
	description = 'Battery',
	inventory_image = "laptop_bat.png",
})

minetest.register_craft({
	output = 'laptop:bat',
	recipe = {
		{rc.steel, rc.steel, rc.steel},
		{rc.steel, rc.gates_diode, rc.steel},
		{rc.steel, rc.steel, rc.steel},
	}
})

minetest.register_craftitem("laptop:case", {
	description = 'Case',
	inventory_image = "laptop_case.png",
})

minetest.register_craft({
	output = 'laptop:case',
	recipe = {
		{rc.steel, rc.steel, rc.steel},
		{rc.steel, '', rc.steel},
		{rc.steel, rc.steel, rc.steel},
	}
})

minetest.register_craftitem("laptop:crt", {
	description = 'CRT Screen',
	inventory_image = "laptop_crt.png",
})

minetest.register_craft({
	output = 'laptop:crt',
	recipe = {
		{rc.glass, rc.glass, rc.glass},
		{rc.light_red , rc.light_green, rc.light_blue},
		{rc.steel, rc.controller, rc.steel},
	}
})

minetest.register_craftitem("laptop:crt_amber", {
	description = 'Amber CRT Screen',
	inventory_image = "laptop_crt_amber.png",
})

minetest.register_craft({
	output = 'laptop:crt_amber',
	recipe = {
		{rc.glass, 'dye:orange', rc.glass},
		{rc.light_red , rc.light_green, rc.light_blue},
		{rc.steel, rc.controller, rc.steel},
	}
})

minetest.register_craftitem("laptop:crt_green", {
	description = 'Green CRT Screen',
	inventory_image = "laptop_crt_green.png",
})

minetest.register_craft({
	output = 'laptop:crt_green',
	recipe = {
		{rc.glass, 'dye:green', rc.glass},
		{rc.light_red , rc.light_green, rc.light_blue},
		{rc.steel, rc.controller, rc.steel},
	}
})

minetest.register_craftitem("laptop:lcd", {
	description = 'LCD Screen',
	inventory_image = "laptop_lcd.png",
})

minetest.register_craft({
	output = 'laptop:lcd',
	recipe = {
		{rc.light_red , rc.light_green, rc.light_blue},
		{'dye:black', rc.controller, 'dye:black'},
		{rc.steel, rc.diamond, rc.steel},
	}
})

minetest.register_craftitem("laptop:gpu", {
	description = 'GPU',
	inventory_image = "laptop_gpu.png",
})

minetest.register_craft({
	output = 'laptop:gpu',
	recipe = {
		{rc.steel, rc.steel, rc.steel},
		{rc.steel, rc.fpga, rc.steel},
		{rc.steel, rc.steel, rc.steel},
	}
})

minetest.register_craftitem("laptop:HDD", {
	description = 'Hard Drive',
	inventory_image = "laptop_harddrive.png",
})

minetest.register_craft({
	output = 'laptop:HDD',
	recipe = {
		{rc.steel, rc.steel, rc.steel},
		{rc.steel, rc.controller, rc.steel},
		{rc.steel, rc.steel, rc.steel},
	}
})

minetest.register_craftitem("laptop:motherboard", {
	description = 'Motherboard',
	inventory_image = "laptop_motherboard.png",
})

minetest.register_craft({
	output = 'laptop:motherboard',
	recipe = {
		{rc.controller, rc.fpga, rc.gates_nand},
		{'dye:dark_green', 'dye:dark_green', 'dye:dark_green'},
		{rc.steel, rc.steel, rc.steel},
	}
})

minetest.register_craftitem("laptop:fan", {
	description = 'Fan',
	inventory_image = "laptop_fan.png",
})

minetest.register_craft({
	output = 'laptop:fan',
	recipe = {
		{'', rc.steel, ''},
		{rc.steel, rc.steel, rc.steel},
		{'', rc.steel, ''},
	}
})

minetest.register_craftitem("laptop:psu", {
	description = 'PSU',
	inventory_image = "laptop_psu.png",
})

minetest.register_craft({
	output = 'laptop:psu',
	recipe = {
		{rc.steel, rc.steel, rc.steel},
		{rc.controller, rc.fpga, 'laptop:fan'},
		{rc.steel, rc.steel, rc.steel},
	}
})

minetest.register_craftitem("laptop:floppy", {
	description = 'High density floppy',
	inventory_image = "laptop_diskette.png",
	groups = {laptop_removable_floppy = 1},
	stack_max = 1,
})

minetest.register_craft({
	output = 'laptop:floppy',
	recipe = {
		{rc.steel, rc.steel, rc.steel},
		{rc.steel, rc.programmer, rc.steel},
		{rc.steel, rc.steel, rc.steel},
	}
})

minetest.register_craftitem("laptop:usbstick", {
	description = 'USB storage stick',
	inventory_image = "laptop_usb.png",
	groups = {laptop_removable_usb = 1},
	stack_max = 1,
})

minetest.register_craft({
	output = 'laptop:usbstick',
	recipe = {
		{'', rc.steel, ''},
		{'', rc.programmer, ''},
		{'', rc.steel, ''},
	}
})

minetest.register_craftitem("laptop:printed_paper", {
	description = 'Printed paper',
	inventory_image = "laptop_printed_paper.png",
	groups = {not_in_creative_inventory = 1},
	stack_max = 1,
	on_use = function(itemstack, user)
		local meta = itemstack:get_meta()
		local data = meta:to_table().fields
		local formspec = "size[8,8]" .. default.gui_bg .. default.gui_bg_img ..
				"label[0,0;" .. minetest.formspec_escape(data.title or "unnamed") ..
				" by " .. (data.author or "unknown") .. " from " .. os.date("%c", data.timestamp) .. "]"..
				"textarea[0.5,1;7.5,7;;" ..
				minetest.formspec_escape(data.text or "test text") .. ";]"
	minetest.show_formspec(user:get_player_name(), "laptop:printed_paper", formspec)
	return itemstack
	end

})
