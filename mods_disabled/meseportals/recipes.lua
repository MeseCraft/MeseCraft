local OB = "default:obsidian"
local MC = "default:mese_crystal"
local MB = "default:mese_block"
local DI = "default:diamond"
local MC = "default:mese_crystal"
local GL = "default:obsidian_glass"
local LV = "bucket:bucket_lava"
local TC = "meseportals:tesseract_crystal"
local PS = "meseportals:portal_segment"

minetest.register_craft({
	output = "meseportals:tesseract_crystal",
	recipe = {
		{DI, MC, DI},
		{MC, OB, MC},
		{DI, MC, DI},
	}
})

minetest.register_craft({
	output = "meseportals:portal_segment",
	recipe = {
		{OB, OB, OB},
		{MB, LV, MB},
		{OB, OB, OB},
	},
	replacements = {{"bucket:bucket_lava", "bucket:bucket_empty"}}
})

minetest.register_craft({
	output = "meseportals:portalnode_off",
	recipe = {
		{PS, TC, PS},
		{TC, "", TC},
		{PS, TC, PS},
	}
})

minetest.register_craft({
	output = "meseportals:unlinked_portal_controller",
	recipe = {
		{GL, GL, GL},
		{GL, TC, GL},
		{GL, GL, GL},
	}
})