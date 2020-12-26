
local S = ethereal.intllib

-- set leaftype (value inside init.lua)
local leaftype = "plantlike"
local leafscale = 1.4

if ethereal.leaftype ~= 0 then
	leaftype = "allfaces_optional"
	leafscale = 1.0
end

-- default apple tree leaves
minetest.override_item("default:leaves", {
	drawtype = leaftype,
	visual_scale = leafscale,
	inventory_image = "default_leaves.png",
	wield_image = "default_leaves.png",
	walkable = ethereal.leafwalk,
})

-- ability to craft big tree sapling
minetest.register_craft({
	recipe = {{"default:sapling", "default:sapling",  "default:sapling"}},
	output = "ethereal:big_tree_sapling"
})

-- default jungle tree leaves
minetest.override_item("default:jungleleaves", {
	drawtype = leaftype,
	visual_scale = leafscale,
	inventory_image = "default_jungleleaves.png",
	wield_image = "default_jungleleaves.png",
	walkable = ethereal.leafwalk,
})

-- default pine tree leaves
minetest.override_item("default:pine_needles", {
	drawtype = leaftype,
	visual_scale = leafscale,
	inventory_image = "default_pine_needles.png",
	wield_image = "default_pine_needles.png",
	walkable = ethereal.leafwalk,
	drop = {
		max_items = 1,
		items = {
			{items = {"default:pine_sapling"}, rarity = 20},
			{items = {"ethereal:pine_nuts"}, rarity = 5},
			{items = {"default:pine_needles"}}
		}
	},
})

-- default acacia tree leaves
minetest.override_item("default:acacia_leaves", {
	drawtype = leaftype,
	inventory_image = "default_acacia_leaves.png",
	wield_image = "default_acacia_leaves.png",
	visual_scale = leafscale,
	walkable = ethereal.leafwalk,
})

-- default aspen tree leaves
minetest.override_item("default:aspen_leaves", {
	drawtype = leaftype,
	inventory_image = "default_aspen_leaves.png",
	wield_image = "default_aspen_leaves.png",
	visual_scale = leafscale,
	walkable = ethereal.leafwalk,
})

-- willow twig
minetest.register_node("ethereal:willow_twig", {
	description = S("Willow Twig"),
	drawtype = "plantlike",
	tiles = {"willow_twig.png"},
	inventory_image = "willow_twig.png",
	wield_image = "willow_twig.png",
	paramtype = "light",
	walkable = ethereal.leafwalk,
	visual_scale = leafscale,
	waving = 1,
	groups = {snappy = 3, leafdecay = 3, leaves = 1, flammable = 2},
	drop = {
		max_items = 1,
		items = {
			{items = {"ethereal:willow_sapling"}, rarity = 50},
			{items = {"ethereal:willow_twig"}}
		}
	},
	sounds = default.node_sound_leaves_defaults(),
	after_place_node = default.after_place_leaves,
})

-- redwood leaves
minetest.register_node("ethereal:redwood_leaves", {
	description = S("Redwood Leaves"),
	drawtype = leaftype,
	visual_scale = leafscale,
	tiles = {"redwood_leaves.png"},
	inventory_image = "redwood_leaves.png",
	wield_image = "redwood_leaves.png",
	paramtype = "light",
	walkable = ethereal.leafwalk,
	waving = 1,
	groups = {snappy = 3, leafdecay = 3, leaves = 1, flammable = 2},
	drop = {
		max_items = 1,
		items = {
			{items = {"ethereal:redwood_sapling"}, rarity = 50},
			{items = {"ethereal:redwood_leaves"}}
		}
	},
	sounds = default.node_sound_leaves_defaults(),
	after_place_node = default.after_place_leaves,
})

-- orange tree leaves
minetest.register_node("ethereal:orange_leaves", {
	description = S("Orange Leaves"),
	drawtype = leaftype,
	visual_scale = leafscale,
	tiles = {"orange_leaves.png"},
	inventory_image = "orange_leaves.png",
	wield_image = "orange_leaves.png",
	paramtype = "light",
	walkable = ethereal.leafwalk,
	waving = 1,
	groups = {snappy = 3, leafdecay = 3, leaves = 1, flammable = 2},
	drop = {
		max_items = 1,
		items = {
			{items = {"ethereal:orange_tree_sapling"}, rarity = 15},
			{items = {"ethereal:orange_leaves"}}
		}
	},
	sounds = default.node_sound_leaves_defaults(),
	after_place_node = default.after_place_leaves,
})

-- banana tree leaves
minetest.register_node("ethereal:bananaleaves", {
	description = S("Banana Leaves"),
	drawtype = leaftype,
	visual_scale = leafscale,
	tiles = {"banana_leaf.png"},
	inventory_image = "banana_leaf.png",
	wield_image = "banana_leaf.png",
	paramtype = "light",
	walkable = ethereal.leafwalk,
	waving = 1,
	groups = {snappy = 3, leafdecay = 3, leaves = 1, flammable = 2},
	drop = {
		max_items = 1,
		items = {
			{items = {"ethereal:banana_tree_sapling"}, rarity = 10},
			{items = {"ethereal:bananaleaves"}}
		}
	},
	sounds = default.node_sound_leaves_defaults(),
	after_place_node = default.after_place_leaves,
})

-- healing tree leaves
minetest.register_node("ethereal:yellowleaves", {
	description = S("Healing Tree Leaves"),
	drawtype = leaftype,
	visual_scale = leafscale,
	tiles = {"yellow_leaves.png"},
	inventory_image = "yellow_leaves.png",
	wield_image = "yellow_leaves.png",
	paramtype = "light",
	walkable = ethereal.leafwalk,
	waving = 1,
	groups = {snappy = 3, leafdecay = 3, leaves = 1},
	drop = {
		max_items = 1,
		items = {
			{items = {"ethereal:yellow_tree_sapling"}, rarity = 50},
			{items = {"ethereal:yellowleaves"}}
		}
	},
	-- one leaf heals half a heart when eaten
	on_use = minetest.item_eat(1),
	sounds = default.node_sound_leaves_defaults(),
	after_place_node = default.after_place_leaves,
	light_source = 9,
})

-- palm tree leaves
minetest.register_node("ethereal:palmleaves", {
	description = S("Palm Leaves"),
	drawtype = leaftype,
	visual_scale = leafscale,
	tiles = {"moretrees_palm_leaves.png"},
	inventory_image = "moretrees_palm_leaves.png",
	wield_image = "moretrees_palm_leaves.png",
	paramtype = "light",
	walkable = ethereal.leafwalk,
	waving = 1,
	groups = {snappy = 3, leafdecay = 3, leaves = 1, flammable = 2},
	drop = {
		max_items = 1,
		items = {
			{items = {"ethereal:palm_sapling"}, rarity = 10},
			{items = {"ethereal:palmleaves"}}
		}
	},
	sounds = default.node_sound_leaves_defaults(),
	after_place_node = default.after_place_leaves,
})

-- birch tree leaves
minetest.register_node("ethereal:birch_leaves", {
	description = S("Birch Leaves"),
	drawtype = leaftype,
	visual_scale = leafscale,
	tiles = {"moretrees_birch_leaves.png"},
	inventory_image = "moretrees_birch_leaves.png",
	wield_image = "moretrees_birch_leaves.png",
	paramtype = "light",
	walkable = ethereal.leafwalk,
	waving = 1,
	groups = {snappy = 3, leafdecay = 3, leaves = 1, flammable = 2},
	drop = {
		max_items = 1,
		items = {
			{items = {"ethereal:birch_sapling"}, rarity = 20},
			{items = {"ethereal:birch_leaves"}}
		}
	},
	sounds = default.node_sound_leaves_defaults(),
	after_place_node = default.after_place_leaves,
})

-- frost tree leaves
minetest.register_node("ethereal:frost_leaves", {
	description = S("Frost Leaves"),
	drawtype = leaftype,
	visual_scale = leafscale,
	tiles = {"ethereal_frost_leaves.png"},
	inventory_image = "ethereal_frost_leaves.png",
	wield_image = "ethereal_frost_leaves.png",
	paramtype = "light",
	walkable = ethereal.leafwalk,
	waving = 1,
	groups = {snappy = 3, leafdecay = 3, leaves = 1, puts_out_fire = 1},
	drop = {
		max_items = 1,
		items = {
			{items = {"ethereal:frost_tree_sapling"}, rarity = 15},
			{items = {"ethereal:frost_leaves"}}
		}
	},
	light_source = 9,
	sounds = default.node_sound_leaves_defaults(),
	after_place_node = default.after_place_leaves,
})

-- bamboo stalk leaves
minetest.register_node("ethereal:bamboo_leaves", {
	description = S("Bamboo Leaves"),
	drawtype = leaftype,
	visual_scale = leafscale,
	tiles = {"bamboo_leaves.png"},
	inventory_image = "bamboo_leaves.png",
	wield_image = "bamboo_leaves.png",
	paramtype = "light",
	walkable = ethereal.leafwalk,
	waving = 1,
	groups = {snappy = 3, leafdecay = 3, leaves = 1, flammable = 2},
	drop = {
		max_items = 1,
		items = {
			{items = {"ethereal:bamboo_sprout"}, rarity = 10},
			{items = {"ethereal:bamboo_leaves"}}
		}
	},
	sounds = default.node_sound_leaves_defaults(),
	after_place_node = default.after_place_leaves,
})

-- sakura leaves
minetest.register_node("ethereal:sakura_leaves", {
	description = S("Sakura Leaves"),
	drawtype = leaftype,
	visual_scale = leafscale,
	tiles = {"ethereal_sakura_leaves.png"},
	inventory_image = "ethereal_sakura_leaves.png",
	wield_image = "ethereal_sakura_leaves.png",
	paramtype = "light",
	walkable = ethereal.leafwalk,
	waving = 1,
	groups = {snappy = 3, leafdecay = 3, leaves = 1, flammable = 2},
	drop = {
		max_items = 1,
		items = {
			{items = {"ethereal:sakura_sapling"}, rarity = 30},
			{items = {"ethereal:sakura_leaves"}}
		}
	},
	sounds = default.node_sound_leaves_defaults(),
	after_place_node = default.after_place_leaves,
})

minetest.register_node("ethereal:sakura_leaves2", {
	description = S("Sakura Leaves"),
	drawtype = leaftype,
	visual_scale = leafscale,
	tiles = {"ethereal_sakura_leaves2.png"},
	inventory_image = "ethereal_sakura_leaves2.png",
	wield_image = "ethereal_sakura_leaves2.png",
	paramtype = "light",
	walkable = ethereal.leafwalk,
	waving = 1,
	groups = {snappy = 3, leafdecay = 3, leaves = 1, flammable = 2},
	drop = {
		max_items = 1,
		items = {
			{items = {"ethereal:sakura_sapling"}, rarity = 30},
			{items = {"ethereal:sakura_leaves2"}}
		}
	},
	sounds = default.node_sound_leaves_defaults(),
	after_place_node = default.after_place_leaves,
})

-- lemon tree leaves
minetest.register_node("ethereal:lemon_leaves", {
	description = S("Lemon Tree Leaves"),
	drawtype = leaftype,
	visual_scale = leafscale,
	tiles = {"lemon_leaves.png"},
	inventory_image = "lemon_leaves.png",
	wield_image = "lemon_leaves.png",
	paramtype = "light",
	walkable = ethereal.leafwalk,
	waving = 1,
	groups = {snappy = 3, leafdecay = 3, leaves = 1, flammable = 2},
	drop = {
		max_items = 1,
		items = {
			{items = {"ethereal:lemon_tree_sapling"}, rarity = 25},
			{items = {"ethereal:lemon_leaves"}}
		}
	},
	sounds = default.node_sound_leaves_defaults(),
	after_place_node = default.after_place_leaves,
})

-- olive tree leaves
minetest.register_node("ethereal:olive_leaves", {
	description = S("Olive Tree Leaves"),
	drawtype = leaftype,
	visual_scale = leafscale,
	tiles = {"olive_leaves.png"},
	inventory_image = "olive_leaves.png",
	wield_image = "olive_leaves.png",
	paramtype = "light",
	walkable = ethereal.leafwalk,
	waving = 1,
	groups = {snappy = 3, leafdecay = 3, leaves = 1, flammable = 2},
	drop = {
		max_items = 1,
		items = {
			{items = {"ethereal:olive_tree_sapling"}, rarity = 25},
			{items = {"ethereal:olive_leaves"}}
		}
	},
	sounds = default.node_sound_leaves_defaults(),
	after_place_node = default.after_place_leaves,
})

-- mushroom tops
minetest.register_node("ethereal:mushroom", {
	description = S("Mushroom Cap"),
	tiles = {"mushroom_block.png"},
	groups = {choppy = 2, oddly_breakable_by_hand = 1, flammable = 2, leafdecay = 3},
	drop = {
		max_items = 1,
		items = {
			{items = {"ethereal:mushroom_sapling"}, rarity = 20},
			{items = {"ethereal:mushroom"}}
		}
	},
	sounds = default.node_sound_wood_defaults(),
})

minetest.register_craft({
	type = "fuel",
	recipe = "ethereal:mushroom",
	burntime = 10,
})

-- mushroom pore (spongelike material found inside giant shrooms)
minetest.register_node("ethereal:mushroom_pore", {
	description = S("Mushroom Pore"),
	tiles = {"mushroom_pore.png"},
	groups = {
		snappy = 3, cracky = 3, choppy = 3, oddly_breakable_by_hand = 3,
		flammable = 2, disable_jump = 1, fall_damage_add_percent = -100,
		leafdecay = 3
	},
	sounds = default.node_sound_dirt_defaults(),
})

minetest.register_craft({
	type = "fuel",
	recipe = "ethereal:mushroom_pore",
	burntime = 3,
})

-- hedge block
minetest.register_node("ethereal:bush", {
	description = S("Bush"),
	tiles = {"ethereal_bush.png"},
	walkable = true,
	groups = {snappy = 3, flammable = 2},
	sounds = default.node_sound_leaves_defaults(),
})

minetest.register_craft({
	output = "ethereal:bush",
	recipe = {
		{"group:leaves", "group:leaves", "group:leaves"},
		{"group:leaves", "ethereal:bamboo_leaves", "group:leaves"},
		{"group:leaves", "group:leaves", "group:leaves"},
	}
})

minetest.register_craft({
	type = "fuel",
	recipe = "ethereal:bush",
	burntime = 1,
})

-- bush block #2
minetest.register_node("ethereal:bush2", {
	drawtype = "allfaces_optional",
	description = S("Bush #2"),
	tiles = {"default_aspen_leaves.png"},
	paramtype = "light",
	walkable = true,
	groups = {snappy = 3, flammable = 2},
	sounds = default.node_sound_leaves_defaults(),
})

minetest.register_craft({
	output = "ethereal:bush2",
	recipe = {
		{"group:leaves", "group:leaves", "group:leaves"},
		{"group:leaves", "default:aspen_leaves", "group:leaves"},
		{"group:leaves", "group:leaves", "group:leaves"},
	}
})

minetest.register_craft({
	type = "fuel",
	recipe = "ethereal:bush2",
	burntime = 1,
})

-- bush block #3
minetest.register_node("ethereal:bush3", {
	drawtype = "allfaces_optional",
	description = S("Bush #3"),
	tiles = {"default_pine_needles.png"},
	paramtype = "light",
	walkable = true,
	groups = {snappy = 3, flammable = 2},
	sounds = default.node_sound_leaves_defaults(),
})

minetest.register_craft({
	output = "ethereal:bush3",
	recipe = {
		{"group:leaves", "group:leaves", "group:leaves"},
		{"group:leaves", "default:pine_needles", "group:leaves"},
		{"group:leaves", "group:leaves", "group:leaves"},
	}
})

minetest.register_craft({
	type = "fuel",
	recipe = "ethereal:bush3",
	burntime = 1,
})

-- compatibility check for new mt version with leafdecay function
if minetest.registered_nodes["default:dirt_with_rainforest_litter"] then

default.register_leafdecay({
	trunks = {"default:tree"},
	leaves = {
		"default:apple", "default:leaves",
		"ethereal:orange", "ethereal:orange_leaves",
		"ethereal:lemon", "ethereal:lemon_leaves",
		"ethereal:vine"
	},
	radius = 3
})

default.register_leafdecay({
	trunks = {"ethereal:willow_trunk"},
	leaves = {"ethereal:willow_twig"},
	radius = 3
})

default.register_leafdecay({
	trunks = {"ethereal:redwood_trunk"},
	leaves = {"ethereal:redwood_leaves"},
	radius = 3
})

default.register_leafdecay({
	trunks = {"ethereal:frost_tree"},
	leaves = {"ethereal:frost_leaves"},
	radius = 3
})

default.register_leafdecay({
	trunks = {"ethereal:yellow_trunk"},
	leaves = {"ethereal:yellowleaves", "ethereal:golden_apple"},
	radius = 3
})

default.register_leafdecay({
	trunks = {"ethereal:palm_trunk"},
	leaves = {"ethereal:palmleaves", "ethereal:coconut"},
	radius = 3
})

default.register_leafdecay({
	trunks = {"ethereal:banana_trunk"},
	leaves = {"ethereal:bananaleaves", "ethereal:banana", "ethereal:banana_bunch"},
	radius = 3
})

default.register_leafdecay({
	trunks = {"ethereal:birch_trunk"},
	leaves = {"ethereal:birch_leaves"},
	radius = 3
})

default.register_leafdecay({
	trunks = {"ethereal:bamboo"},
	leaves = {"ethereal:bamboo_leaves"},
	radius = 2
})

default.register_leafdecay({
	trunks = {"ethereal:sakura_trunk"},
	leaves = {"ethereal:sakura_leaves", "ethereal:sakura_leaves2"},
	radius = 3
})

default.register_leafdecay({
	trunks = {"ethereal:olive_trunk"},
	leaves = {"ethereal:olive_leaves", "ethereal:olive"},
	radius = 3
})

default.register_leafdecay({
	trunks = {"ethereal:mushroom_trunk"},
	leaves = {"ethereal:mushroom", "ethereal:mushroom_pore"},
	radius = 3
})
end
