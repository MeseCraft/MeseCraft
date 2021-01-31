
local S = ethereal.intllib

-- Firethorn (poisonous when eaten raw, must be crushed and washed in flowing water 1st)
minetest.register_node("ethereal:firethorn", {
	description = S("Firethorn Shrub"),
	drawtype = "plantlike",
	tiles = {"ethereal_firethorn.png"},
	inventory_image = "ethereal_firethorn.png",
	wield_image = "ethereal_firethorn.png",
	paramtype = "light",
	sunlight_propagates = true,
	waving = 1,
	walkable = false,
	buildable_to = true,
	groups = {snappy = 3, flora = 1, attached_node = 1},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-5 / 16, -0.5, -5 / 16, 5 / 16, 4 / 16, 5 / 16},
	},
})

-- Fire Flower
minetest.register_node("ethereal:fire_flower", {
	description = S("Fire Flower"),
	drawtype = "plantlike",
	tiles = { "ethereal_fire_flower.png" },
	inventory_image = "ethereal_fire_flower.png",
	wield_image = "ethereal_fire_flower.png",
	paramtype = "light",
	light_source = 5,
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	damage_per_second = 2,
	groups = {snappy = 1, oddly_breakable_by_hand = 3, igniter = 2},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-5 / 16, -0.5, -5 / 16, 5 / 16, 1 / 2, 5 / 16},
	},

	on_punch = function(pos, node, puncher)

		puncher:punch(puncher, 1.0, {
			full_punch_interval = 1.0,
			damage_groups = {fleshy = 2}
		}, nil)
	end,
})

minetest.register_craft({
	type = "fuel",
	recipe = "ethereal:fire_flower",
	burntime = 20,
})

-- Fire Dust
minetest.register_craftitem("ethereal:fire_dust", {
	description = S("Fire Dust"),
	inventory_image = "fire_dust.png",
})

minetest.register_craft({
	output = "ethereal:fire_dust 2",
	recipe = {
		{"ethereal:fire_flower"},
	}
})

minetest.register_craft({
	type = "fuel",
	recipe = "ethereal:fire_dust",
	burntime = 10,
})

-- vines
minetest.register_node("ethereal:vine", {
	description = S("Vine"),
	drawtype = "signlike",
	tiles = {"vine.png"},
	inventory_image = "vine.png",
	wield_image = "vine.png",
	paramtype = "light",
	paramtype2 = "wallmounted",
	walkable = false,
	climbable = true,
	is_ground_content = false,
	selection_box = {
		type = "wallmounted",
	},
	groups = {choppy = 3, oddly_breakable_by_hand = 1, flammable = 2},
	legacy_wallmounted = true,
	sounds = default.node_sound_leaves_defaults(),
})

minetest.register_craft({
	output = "ethereal:vine 2",
	recipe = {
		{"group:leaves", "", "group:leaves"},
		{"", "group:leaves", ""},
		{"group:leaves", "", "group:leaves"},
	}
})

-- light strings (glowing vine)
minetest.register_node("ethereal:lightstring", {
	description = S("Light String Vine"),
	drawtype = "signlike",
	tiles = {"lightstring.png"},
	inventory_image = "lightstring.png",
	wield_image = "lightstring.png",
	paramtype = "light",
	paramtype2 = "wallmounted",
	light_source = 10,
	walkable = false,
	climbable = true,
	is_ground_content = false,
	selection_box = {
		type = "wallmounted",
	},
	groups = {choppy = 3, oddly_breakable_by_hand = 1, flammable = 2},
	legacy_wallmounted = true,
	sounds = default.node_sound_leaves_defaults(),
})

minetest.register_craft({
	output = "ethereal:lightstring 8",
	recipe = {
		{"ethereal:vine", "ethereal:vine", "ethereal:vine"},
		{"ethereal:vine", "ethereal:fire_dust", "ethereal:vine"},
		{"ethereal:vine", "ethereal:vine", "ethereal:vine"},
	},
})

-- Fern (boston)
minetest.register_node("ethereal:fern", {
	description = S("Fern"),
	drawtype = "plantlike",
	visual_scale = 1.4,
	tiles = {"fern.png"},
	inventory_image = "fern.png",
	wield_image = "fern.png",
	paramtype = "light",
	sunlight_propagates = true,
	waving = 1,
	walkable = false,
	buildable_to = true,
	drop = {
		max_items = 1,
		items = {
			{items = {"ethereal:fern_tubers"}, rarity = 6},
			{items = {"ethereal:fern"}}
		}
	},
	groups = {snappy = 3, flora = 1, attached_node = 1, flammable = 2},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-5 / 16, -0.5, -5 / 16, 5 / 16, 0.67, 5 / 16},
	},
})

-- Boston Ferns sometimes drop edible Tubers (heals 1/2 heart when eaten)
minetest.register_craftitem("ethereal:fern_tubers", {
	description = S("Fern Tubers"),
	inventory_image = "fern_tubers.png",
	groups = {food_tuber = 1, flammable = 2},
	on_use = minetest.item_eat(1),
})

-- Red Shrub (not flammable)
minetest.register_node("ethereal:dry_shrub", {
	description = S("Fiery Dry Shrub"),
	drawtype = "plantlike",
	tiles = {"ethereal_dry_shrub.png"},
	inventory_image = "ethereal_dry_shrub.png",
	wield_image = "ethereal_dry_shrub.png",
	paramtype = "light",
	sunlight_propagates = true,
	waving = 1,
	walkable = false,
	buildable_to = true,
	groups = {snappy = 3, flora = 1, attached_node = 1},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-5 / 16, -0.5, -5 / 16, 5 / 16, 4 / 16, 5 / 16},
	},
})

-- Grey Shrub (not Flammable - too cold to burn)
minetest.register_node("ethereal:snowygrass", {
	description = S("Snowy Grass"),
	drawtype = "plantlike",
	visual_scale = 0.9,
	tiles = {"ethereal_snowygrass.png"},
	inventory_image = "ethereal_snowygrass.png",
	wield_image = "ethereal_snowygrass.png",
	paramtype = "light",
	sunlight_propagates = true,
	waving = 1,
	walkable = false,
	buildable_to = true,
	groups = {snappy = 3, flora = 1, attached_node = 1},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-5 / 16, -0.5, -5 / 16, 5 / 16, 5 / 16, 5 / 16},
	},
})

-- Crystal Shrub (not Flammable - too cold to burn)
minetest.register_node("ethereal:crystalgrass", {
	description = S("Crystal Grass"),
	drawtype = "plantlike",
	visual_scale = 0.9,
	tiles = {"ethereal_crystalgrass.png"},
	inventory_image = "ethereal_crystalgrass.png",
	wield_image = "ethereal_crystalgrass.png",
	paramtype = "light",
	sunlight_propagates = true,
	waving = 1,
	walkable = false,
	buildable_to = true,
	groups = {snappy = 3, flora = 1, attached_node = 1},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-5 / 16, -0.5, -5 / 16, 5 / 16, 5 / 16, 5 / 16},
	},
})

-- Define Moss Types (Has grass textures on all sides)
local add_moss = function(typ, descr, texture, receipe_item)

	minetest.register_node("ethereal:" .. typ .. "_moss", {
		description = S(descr .. " Moss"),
		tiles = {texture},
		groups = {crumbly = 3},
		sounds = default.node_sound_dirt_defaults({
			footstep = {name = "default_grass_footstep", gain = 0.4}})
	})

	minetest.register_craft({
		type = "shapeless",
		output = "ethereal:"..typ.."_moss",
		recipe = {"default:dirt", receipe_item }
	})
end

add_moss( "crystal", "Crystal", "ethereal_grass_crystal_top.png", "ethereal:frost_leaves")
add_moss( "mushroom", "Mushroom", "ethereal_grass_mushroom_top.png", "ethereal:mushroom")
add_moss( "fiery", "Fiery", "ethereal_grass_fiery_top.png", "ethereal:dry_shrub")
add_moss( "gray", "Gray", "ethereal_grass_gray_top.png", "ethereal:snowygrass")
add_moss( "green", "Green", "default_grass.png", "default:jungleleaves")

-- Illuminated Cave Shrooms (Red, Green and Blue)
minetest.register_node("ethereal:illumishroom", {
	description = S("Red Illumishroom"),
	drawtype = "plantlike",
	tiles = { "illumishroom.png" },
	inventory_image = "illumishroom.png",
	wield_image = "illumishroom.png",
	paramtype = "light",
	light_source = 5,
	sunlight_propagates = true,
	walkable = false,
	groups = {dig_immediate = 3, attached_node = 1, flammable = 3},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-6 / 16, -0.5, -6 / 16, 6 / 16, 0.47, 6 / 16},
	},
})

minetest.register_node("ethereal:illumishroom2", {
	description = S("Green Illumishroom"),
	drawtype = "plantlike",
	tiles = { "illumishroom2.png" },
	inventory_image = "illumishroom2.png",
	wield_image = "illumishroom2.png",
	paramtype = "light",
	light_source = 5,
	sunlight_propagates = true,
	walkable = false,
	groups = {dig_immediate = 3, attached_node = 1, flammable = 3},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-6 / 16, -0.5, -6 / 16, 6 / 16, 0.47, 6 / 16},
	},
})

minetest.register_node("ethereal:illumishroom3", {
	description = S("Cyan Illumishroom"),
	drawtype = "plantlike",
	tiles = { "illumishroom3.png" },
	inventory_image = "illumishroom3.png",
	wield_image = "illumishroom3.png",
	paramtype = "light",
	light_source = 5,
	sunlight_propagates = true,
	walkable = false,
	groups = {dig_immediate = 3, attached_node = 1, flammable = 3},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-6 / 16, -0.5, -6 / 16, 6 / 16, 0.47, 6 / 16},
	},
})
