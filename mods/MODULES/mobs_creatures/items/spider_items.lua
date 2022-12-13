-- todo: uses for silk.

-- Spiderweb item.
minetest.register_node("mobs_creatures:spiderweb", {
	description = "Spiderweb",
	drawtype = "plantlike",
	visual_scale = 1.2,
	tiles = {"mobs_creatures_items_spiderweb.png"},
	inventory_image = "mobs_creatures_items_spiderweb.png",
	paramtype = "light",
	liquid_viscosity = 20,
	liquidtype = "source",
	liquid_alternative_flowing = "mobs:spiderweb",
	liquid_alternative_source = "mobs:spiderweb",
	liquid_renewable = false,
	liquid_range = 0,
	walkable = false,
	pointable = true,
	diggable = true,
	buildable_to = false,
	drop = "mobs_creatures:spiderweb",
	groups = {snappy = 1, disable_jump = 1},
	sounds = default.node_sound_leaves_defaults(),
})

-- Spider Silk item.
minetest.register_craftitem("mobs_creatures:silk", {
	description = "Silk",
	inventory_image = "mobs_creatures_items_spider_silk.png",
	groups = {flammable = 2},
})

-- Make silk from spiderweb.
 minetest.register_craft({
	output = "mobs_creatures:silk",
	recipe = {
		{"mobs_creatures:spiderweb", "mobs_creatures:spiderweb", "mobs_creatures:spiderweb"},
		{"mobs_creatures:spiderweb", "default:stick", "mobs_creatures:spiderweb"},
		{"mobs_creatures:spiderweb", "mobs_creatures:spiderweb", "mobs_creatures:spiderweb"},
	}
})
-- Furnace Recipe for Spiderweb.
minetest.register_craft({
        type = "fuel",
        recipe = "mob_creatures:spiderweb",
        burntime = 1,
})

-- Furnace Recipe for Silk
minetest.register_craft({
	type = "fuel",
	recipe = "mob_creatures:silk",
	burntime = 1,
})
