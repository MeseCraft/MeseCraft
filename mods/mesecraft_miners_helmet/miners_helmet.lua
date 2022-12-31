-- A piece of armor that is a light source

armor:register_armor('mesecraft_miners_helmet:miners_helmet', {
	description = "Miner's Helmet",
	texture = "miners_helmet.png",
	preview = "miners_helmet_preview.png",
	inventory_image = "miners_helmet_inv.png",
	groups = {armor_head=1, armor_heal=0, armor_use=250},
	armor_groups = {fleshy=1},
	damage_groups = {cracky=2, snappy=2, choppy=2, crumbly=3, level=2},
	light_source = 13,
})

local lamp = "default:meselamp"
local v = "default:gold_ingot"
minetest.register_craft({
	output = "mesecraft_miners_helmet:miners_helmet",
	recipe = {
		{v, lamp, v},
		{v, "", v},
		{"", "", ""},
		},
	})
