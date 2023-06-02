-- I've removed the abm's and player poop functionality entirely and just kept the items.
-- Plans: Add poop from animals that can be used for compost, biofuel, and fertilizer.
-- Credit to the pooper mod for these.

-- Register Nodes

minetest.register_node("mesecraft_mobs:poop_pile", {
	description = "Pile of Poop",
	tiles = {"mesecraft_mobs_items_poop_pile.png"},
	groups = {crumbly = 3, soil = 1, falling_node = 1},
	drop = "mesecraft_mobs:poop_turd" .. " 4",
	sounds = default.node_sound_dirt_defaults(),
})


-- Register Crafts

minetest.register_craftitem("mesecraft_mobs:poop_turd", {
	description = "Poop",
	inventory_image = "mesecraft_mobs_items_poop_turd.png",
	on_use = minetest.item_eat(1)
})

minetest.register_craft({
	output = "mesecraft_mobs:poop_pile",
	recipe = {
		{"", "mesecraft_mobs:poop_turd", ""},
		{"mesecraft_mobs:poop_turd", "mesecraft_mobs:poop_turd", "mesecraft_mobs:poop_turd"}
	}
})
