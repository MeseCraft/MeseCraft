--[[
More Blocks: redefinitions of default stuff

Copyright © 2011-2019 Hugo Locurcio and contributors.
Licensed under the zlib license. See LICENSE.md for more information.
--]]

-- Redefinitions of some default crafting recipes:

minetest.register_craft({
	output = "default:ladder 4",
	recipe = {
		{"default:stick", "", "default:stick"},
		{"default:stick", "default:stick", "default:stick"},
		{"default:stick", "", "default:stick"},
	}
})

minetest.clear_craft({
	recipe = {
		{"default:papyrus", "default:papyrus", "default:papyrus"}
	}
})
minetest.register_craft({
	output = "default:paper 4",
	recipe = {
		{"default:papyrus", "default:papyrus", "default:papyrus"},
	}
})

minetest.register_craft({
	output = "default:rail 24",
	recipe = {
		{"default:steel_ingot", "", "default:steel_ingot"},
		{"default:steel_ingot", "default:stick", "default:steel_ingot"},
		{"default:steel_ingot", "", "default:steel_ingot"},
	}
})

minetest.register_craft({
	type = "toolrepair",
	additional_wear = -0.10, -- Tool repair buff (10% bonus instead of 2%).
})
