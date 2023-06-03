

armor:register_armor("mesecraft_spacesuit:helmet", {
	description = "Spacesuit Helmet",
	inventory_image = "mesecraft_spacesuit_inv_helmet.png",
	groups = {armor_head=5, armor_heal=1, armor_use=mesecraft_spacesuit.armor_use, not_repaired_by_anvil=1},
	wear = 0,
	wear_represents = "mesecraft_spacesuit_wear",
})

minetest.register_tool("mesecraft_spacesuit:chestplate", {
	description = "Spacesuit Chestplate",
	inventory_image = "mesecraft_spacesuit_inv_chestplate.png",
	groups = {armor_torso=8, armor_heal=1, armor_use=mesecraft_spacesuit.armor_use, not_repaired_by_anvil=1},
	wear = 0,
	wear_represents = "mesecraft_spacesuit_wear",
})

minetest.register_tool("mesecraft_spacesuit:pants", {
	description = "Spacesuit Pants",
	inventory_image = "mesecraft_spacesuit_inv_pants.png",
	groups = {armor_legs=7, armor_heal=1, armor_use=mesecraft_spacesuit.armor_use, not_repaired_by_anvil=1},
	wear = 0,
	wear_represents = "mesecraft_spacesuit_wear",
})

minetest.register_tool("mesecraft_spacesuit:boots", {
	description = "Spacesuit Boots",
	inventory_image = "mesecraft_spacesuit_inv_boots.png",
	groups = {armor_feet=4, armor_heal=1, armor_use=mesecraft_spacesuit.armor_use, not_repaired_by_anvil=1},
	wear = 0,
	wear_represents = "mesecraft_spacesuit_wear",
})
