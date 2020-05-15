local leafwalk = false
local leaftype = "allfaces_optional"

-- default apple tree leaves
minetest.override_item("default:leaves", {
	drawtype = leaftype,
	visual_scale = 1.4,
	inventory_image = "default_leaves.png",
	wield_image = "default_leaves.png",
	walkable = leafwalk,
})

-- default jungle tree leaves
minetest.override_item("default:jungleleaves", {
	drawtype = leaftype,
	visual_scale = 1.4,
	inventory_image = "default_jungleleaves.png",
	wield_image = "default_jungleleaves.png",
	walkable = leafwalk,
})

-- default pine tree leaves
minetest.override_item("default:pine_needles", {
	drawtype = leaftype,
	visual_scale = 1.4,
	inventory_image = "default_pine_needles.png",
	wield_image = "default_pine_needles.png",
	walkable = leafwalk,
	drop = {
		max_items = 1,
		items = {
			{items = {"default:pine_sapling"}, rarity = 20},
			{items = {"default:pine_needles"}}
		}
	},
})

-- default acacia tree leaves
minetest.override_item("default:acacia_leaves", {
	drawtype = leaftype,
	inventory_image = "default_acacia_leaves.png",
	wield_image = "default_acacia_leaves.png",
	visual_scale = 1.4,
	walkable = leafwalk,
})

-- default aspen tree leaves
minetest.override_item("default:aspen_leaves", {
	drawtype = leaftype,
	inventory_image = "default_aspen_leaves.png",
	wield_image = "default_aspen_leaves.png",
	visual_scale = 1.4,
	walkable = leafwalk,
})
