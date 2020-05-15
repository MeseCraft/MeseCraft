--Define Rainbow shield
minetest.register_tool("rainbow_ore:rainbow_ore_shield", {
	description = "Rainbow Shield",
	inventory_image = "rainbow_ore_shield_inv.png",
	groups = {armor_shield=20, armor_heal=17, armor_use=40, armor_fire=1},
	wear = 0,
})


--Define Rainbow shield crafting recipe
minetest.register_craft({
	output = "rainbow_ore:rainbow_ore_shield",
	recipe = {
		{"rainbow_ore:rainbow_ore_ingot", "rainbow_ore:rainbow_ore_ingot", "rainbow_ore:rainbow_ore_ingot"},
		{"rainbow_ore:rainbow_ore_ingot", "rainbow_ore:rainbow_ore_ingot", "rainbow_ore:rainbow_ore_ingot"},
		{"", "rainbow_ore:rainbow_ore_ingot", ""},
	},
})