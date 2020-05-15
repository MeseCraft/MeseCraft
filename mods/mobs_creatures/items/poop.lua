-- I've removed the abm's and player poop functionality entirely and just kept the items.
-- Plans: Add poop from animals that can be used for compost, biofuel, and fertilizer.
-- Credit to the pooper mod for these.

-- Register Nodes

minetest.register_node("mobs_creatures:poop_pile", {
	description = "Pile of Poop",
	tiles = {"mobs_creatures_items_poop_pile.png"},
	groups = {crumbly = 3, soil = 1, falling_node = 1},
	drop = "mobs_creatures:poop_turd" .. " 4",
	sounds = default.node_sound_dirt_defaults(),
})


-- Register Crafts

minetest.register_craftitem("mobs_creatures:poop_turd", {
	description = "Poop",
	inventory_image = "mobs_creatures_items_poop_turd.png",
	on_use = minetest.item_eat(1)
})

minetest.register_craft({
	output = "mobs_creatures:poop_pile",
	recipe = {
		{"", "mobs_creatures:poop_turd", ""},
		{"mobs_creatures:poop_turd", "mobs_creatures:poop_turd", "mobs_creatures:poop_turd"}
	}
})
