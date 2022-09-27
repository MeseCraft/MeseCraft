screwdriver = screwdriver or {}

-- Register the television
minetest.register_node("mesecraft_television:television", {
	description = "Television",
	light_source = 11,
	groups = {cracky=3, oddly_breakable_by_hand=2},
	on_rotate = screwdriver.rotate_simple,
	tiles = {"mesecraft_television_left.png^[transformR270",
		 "mesecraft_television_left.png^[transformR90",
		 "mesecraft_television_left.png^[transformFX",
		 "mesecraft_television_left.png", "mesecraft_television_back.png",
		{name="mesecraft_television_front_animated.png",
		 animation = {type="vertical_frames", length=80.0}} }
})

-- Craft the television
minetest.register_craft({
	output = "mesecraft_television:television",
	recipe = {
		{"default:steel_ingot", "default:copper_ingot", "default:steel_ingot"},
		{"default:steel_ingot", "default:glass", "default:steel_ingot"},
		{"default:steel_ingot", "default:copper_ingot", "default:steel_ingot"}
	}
})
