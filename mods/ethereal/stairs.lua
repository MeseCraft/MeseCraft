
local S = ethereal.intllib

-- Stairs Redo
if stairs and stairs.mod and stairs.mod == "redo" then

stairs.register_all("blue_marble_tile", "ethereal:blue_marble_tile",
	{cracky = 1},
	{"ethereal_blue_marble_tile.png"},
	S("Blue Marble Tile"),
	default.node_sound_stone_defaults())

stairs.register_all("crystal_block", "ethereal:crystal_block",
	{cracky = 1, level = 2, puts_out_fire = 1, cools_lava = 1},
	{"crystal_block.png"},
	S("Crystal Block"),
	default.node_sound_glass_defaults())

stairs.register_all("icebrick", "ethereal:icebrick",
	{cracky = 3, puts_out_fire = 1, cools_lava = 1},
	{"brick_ice.png"},
	S("Ice Brick"),
	default.node_sound_glass_defaults())

stairs.register_all("snowbrick", "ethereal:snowbrick",
	{crumbly = 3, puts_out_fire = 1, cools_lava = 1},
	{"brick_snow.png"},
	S("Snow Brick"),
	default.node_sound_dirt_defaults({
		footstep = {name = "default_snow_footstep", gain = 0.25},
		dug = {name = "default_snow_footstep", gain = 0.75},
	}))

stairs.register_all("dry_dirt", "ethereal:dry_dirt",
	{crumbly = 3},
	{"ethereal_dry_dirt.png"},
	S("Dried Dirt"),
	default.node_sound_dirt_defaults())

stairs.register_all("mushroom_trunk", "ethereal:mushroom_trunk",
	{choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
	{"mushroom_trunk.png"},
	S("Mushroom Trunk"),
	default.node_sound_wood_defaults())

stairs.register_all("mushroom", "ethereal:mushroom",
	{choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
	{"mushroom_block.png"},
	S("Mushroom Top"),
	default.node_sound_wood_defaults())

stairs.register_all("frost_wood", "ethereal:frost_wood",
	{choppy = 2, oddly_breakable_by_hand = 1, put_out_fire = 1},
	{"frost_wood.png"},
	S("Frost Wood"),
	default.node_sound_wood_defaults())

stairs.register_all("yellow_wood", "ethereal:yellow_wood",
	{choppy = 2, oddly_breakable_by_hand = 1, put_out_fire = 1},
	{"yellow_wood.png"},
	S("Healing Wood"),
	default.node_sound_wood_defaults())

stairs.register_all("palm_wood", "ethereal:palm_wood",
	{choppy = 2, oddly_breakable_by_hand = 1, flammable = 3},
	{"moretrees_palm_wood.png"},
	S("Palm Wood"),
	default.node_sound_wood_defaults())

stairs.register_all("birch_wood", "ethereal:birch_wood",
	{choppy = 2, oddly_breakable_by_hand = 1, flammable = 3},
	{"moretrees_birch_wood.png"},
	S("Birch Wood"),
	default.node_sound_wood_defaults())

stairs.register_all("banana_wood", "ethereal:banana_wood",
	{choppy = 2, oddly_breakable_by_hand = 1, flammable = 3},
	{"banana_wood.png"},
	S("Banana Wood"),
	default.node_sound_wood_defaults())

stairs.register_all("willow_wood", "ethereal:willow_wood",
	{choppy = 2, oddly_breakable_by_hand = 1, flammable = 3},
	{"willow_wood.png"},
	S("Willow Wood"),
	default.node_sound_wood_defaults())

stairs.register_all("redwood_wood", "ethereal:redwood_wood",
	{choppy = 2, oddly_breakable_by_hand = 1, flammable = 3},
	{"redwood_wood.png"},
	S("Redwood"),
	default.node_sound_wood_defaults())

stairs.register_all("bamboo_wood", "ethereal:bamboo_block",
	{snappy = 3, choppy = 2, oddly_breakable_by_hand = 1, flammable = 3},
	{"bamboo_floor.png"},
	S("Bamboo"),
	default.node_sound_wood_defaults())

stairs.register_all("sakura_wood", "ethereal:sakura_wood",
	{choppy = 2, oddly_breakable_by_hand = 1, flammable = 3},
	{"ethereal_sakura_wood.png"},
	S("Sakura Wood"),
	default.node_sound_wood_defaults())

stairs.register_all("olive_wood", "ethereal:olive_wood",
	{choppy = 2, oddly_breakable_by_hand = 1, flammable = 3},
	{"olive_wood.png"},
	S("Olive Wood"),
	default.node_sound_wood_defaults())

-- Stairs Plus (in More Blocks)
elseif minetest.global_exists("stairsplus") then

stairsplus:register_all("ethereal", "blue_marble_tile", "ethereal:blue_marble_tile", {
	description = S("Blue Marble Tile"),
	tiles = {"ethereal_blue_marble_tile.png"},
	groups = {cracky = 1},
	sounds = default.node_sound_stone_defaults(),
})

stairsplus:register_all("ethereal", "crystal_block", "ethereal:crystal_block", {
	description = S("Crystal block"),
	tiles = {"crystal_block.png"},
	groups = {cracky = 1, falling_node = 1, puts_out_fire = 1, cools_lava = 1},
	sounds = default.node_sound_glass_defaults(),
})

stairsplus:register_all("ethereal", "icebrick", "ethereal:icebrick", {
	description = S("Ice Brick"),
	tiles = {"brick_ice.png"},
	groups = {cracky = 3, puts_out_fire = 1, cools_lava = 1},
	sounds = default.node_sound_glass_defaults(),
})

stairsplus:register_all("ethereal", "snowbrick", "ethereal:snowbrick", {
	description = S("Snow Brick"),
	tiles = {"brick_snow.png"},
	groups = {crumbly = 3, puts_out_fire = 1, cools_lava = 1},
	sounds = default.node_sound_dirt_defaults({
		footstep = {name = "default_snow_footstep", gain = 0.25},
		dug = {name = "default_snow_footstep", gain = 0.75},
	})
})

stairsplus:register_all("ethereal", "dry_dirt", "ethereal:dry_dirt", {
	description = S("Dried Dirt"),
	tiles = {"ethereal_dry_dirt.png"},
	groups = {crumbly = 3},
	sounds = default.node_sound_dirt_defaults(),
})

stairsplus:register_all("ethereal", "mushroom_trunk", "ethereal:mushroom_trunk", {
	description = S("Mushroom Trunk"),
	tiles = {"mushroom_trunk.png"},
	groups = {choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
	sounds = default.node_sound_wood_defaults(),
})

stairsplus:register_all("ethereal", "mushroom", "ethereal:mushroom", {
	description = S("Mushroom Top"),
	tiles = {"mushroom_block.png"},
	groups = {choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
	sounds = default.node_sound_wood_defaults(),
})

stairsplus:register_all("ethereal", "frost_wood", "ethereal:frost_wood", {
	description = S("Frost Wood"),
	tiles = {"frost_wood.png"},
	groups = {choppy = 2, oddly_breakable_by_hand = 1, put_out_fire = 1},
	sounds = default.node_sound_wood_defaults(),
})

stairsplus:register_all("ethereal", "yellow_wood", "ethereal:yellow_wood", {
	description = S("Healing Wood"),
	tiles = {"yellow_wood.png"},
	groups = {choppy = 2, oddly_breakable_by_hand = 1, put_out_fire = 1},
	sounds = default.node_sound_wood_defaults(),
})

stairsplus:register_all("ethereal", "palm_wood", "ethereal:palm_wood", {
	description = S("Palm Wood"),
	tiles = {"moretrees_palm_wood.png"},
	groups = {choppy = 2, oddly_breakable_by_hand = 1, flammable = 3},
	sounds = default.node_sound_wood_defaults(),
})

stairsplus:register_all("ethereal", "birch_wood", "ethereal:birch_wood", {
	description = S("Birch Wood"),
	tiles = {"moretrees_birch_wood.png"},
	groups = {choppy = 2, oddly_breakable_by_hand = 1, flammable = 3},
	sounds = default.node_sound_wood_defaults(),
})

stairsplus:register_all("ethereal", "banana_wood", "ethereal:banana_wood", {
	description = S("Banana Wood"),
	tiles = {"banana_wood.png"},
	groups = {choppy = 2, oddly_breakable_by_hand = 1, flammable = 3},
	sounds = default.node_sound_wood_defaults(),
})

stairsplus:register_all("ethereal", "willow_wood", "ethereal:willow_wood", {
	description = S("Willow Wood"),
	tiles = {"willow_wood.png"},
	groups = {choppy = 2, oddly_breakable_by_hand = 1, flammable = 3},
	sounds = default.node_sound_wood_defaults(),
})

stairsplus:register_all("ethereal", "redwood_wood", "ethereal:redwood_wood", {
	description = S("Redwood"),
	tiles = {"redwood_wood.png"},
	groups = {choppy = 2, oddly_breakable_by_hand = 1, flammable = 3},
	sounds = default.node_sound_wood_defaults(),
})

stairsplus:register_all("ethereal", "bamboo_wood", "ethereal:bamboo_block", {
	description = S("Bamboo"),
	tiles = {"bamboo_floor.png"},
	groups = {snappy = 3, choppy = 2, oddly_breakable_by_hand = 1, flammable = 3},
	sounds = default.node_sound_wood_defaults(),
})

stairsplus:register_all("ethereal", "sakura_wood", "ethereal:sakura_wood", {
	description = S("Sakura"),
	tiles = {"ethereal_sakura_wood.png"},
	groups = {choppy = 2, oddly_breakable_by_hand = 1, flammable = 3},
	sounds = default.node_sound_wood_defaults(),
})

stairsplus:register_all("ethereal", "olive_wood", "ethereal:olive_wood", {
	description = S("Olive"),
	tiles = {"olive_wood.png"},
	groups = {choppy = 2, oddly_breakable_by_hand = 1, flammable = 3},
	sounds = default.node_sound_wood_defaults(),
})

-- Default Stairs
else

stairs.register_stair_and_slab("blue_marble_tile", "ethereal:blue_marble_tile",
	{cracky = 1},
	{"ethereal_blue_marble_tile.png"},
	S("Blue Marble Tile Stair"),
	S("Blue Marble Tile Slab"),
	default.node_sound_stone_defaults())

stairs.register_stair_and_slab("crystal_block", "ethereal:crystal_block",
	{cracky = 1, level = 2, puts_out_fire = 1, cools_lava = 1},
	{"crystal_block.png"},
	S("Crystal Block Stair"),
	S("Crystal Block Slab"),
	default.node_sound_glass_defaults())

stairs.register_stair_and_slab("icebrick", "ethereal:icebrick",
	{cracky = 3, puts_out_fire = 1, cools_lava = 1},
	{"brick_ice.png"},
	S("Ice Brick Stair"),
	S("Ice Brick Slab"),
	default.node_sound_glass_defaults())

stairs.register_stair_and_slab("snowbrick", "ethereal:snowbrick",
	{crumbly = 3, puts_out_fire = 1, cools_lava = 1},
	{"brick_snow.png"},
	S("Snow Brick Stair"),
	S("Snow Brick Slab"),
	default.node_sound_dirt_defaults({
		footstep = {name = "default_snow_footstep", gain = 0.15},
		dug = {name = "default_snow_footstep", gain = 0.2},
		dig = {name = "default_snow_footstep", gain = 0.2}
	}))

stairs.register_stair_and_slab("dry_dirt", "ethereal:dry_dirt",
	{crumbly = 3},
	{"ethereal_dry_dirt.png"},
	S("Dried Dirt Stair"),
	S("Dried Dirt Slab"),
	default.node_sound_dirt_defaults())

stairs.register_stair_and_slab("mushroom_trunk", "ethereal:mushroom_trunk",
	{choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
	{"mushroom_trunk.png"},
	S("Mushroom Trunk Stair"),
	S("Mushroom Trunk Slab"),
	default.node_sound_wood_defaults())

stairs.register_stair_and_slab("mushroom", "ethereal:mushroom",
	{choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
	{"mushroom_block.png"},
	S("Mushroom Top Stair"),
	S("Mushroom Top Slab"),
	default.node_sound_wood_defaults())

stairs.register_stair_and_slab("frost_wood", "ethereal:frost_wood",
	{choppy = 2, oddly_breakable_by_hand = 1, put_out_fire = 1},
	{"frost_wood.png"},
	S("Frost Wood Stair"),
	S("Frost Wood Slab"),
	default.node_sound_wood_defaults())

stairs.register_stair_and_slab("yellow_wood", "ethereal:yellow_wood",
	{choppy = 2, oddly_breakable_by_hand = 1, put_out_fire = 1},
	{"yellow_wood.png"},
	S("Healing Wood Stair"),
	S("Healing Wood Slab"),
	default.node_sound_wood_defaults())

stairs.register_stair_and_slab("palm_wood", "ethereal:palm_wood",
	{choppy = 2, oddly_breakable_by_hand = 1, flammable = 3},
	{"moretrees_palm_wood.png"},
	S("Palm Wood Stair"),
	S("Palm Wood Slab"),
	default.node_sound_wood_defaults())

stairs.register_stair_and_slab("birch_wood", "ethereal:birch_wood",
	{choppy = 2, oddly_breakable_by_hand = 1, flammable = 3},
	{"moretrees_birch_wood.png"},
	"Birch Wood Stair",
	"Birch Wood Slab",
	default.node_sound_wood_defaults())

stairs.register_stair_and_slab("banana_wood", "ethereal:banana_wood",
	{choppy = 2, oddly_breakable_by_hand = 1, flammable = 3},
	{"banana_wood.png"},
	S("Banana Wood Stair"),
	S("Banana Wood Slab"),
	default.node_sound_wood_defaults())

stairs.register_stair_and_slab("willow_wood", "ethereal:willow_wood",
	{choppy = 2, oddly_breakable_by_hand = 1, flammable = 3},
	{"willow_wood.png"},
	S("Willow Wood Stair"),
	S("Willow Wood Slab"),
	default.node_sound_wood_defaults())

stairs.register_stair_and_slab("redwood_wood", "ethereal:redwood_wood",
	{choppy = 2, oddly_breakable_by_hand = 1, flammable = 3},
	{"redwood_wood.png"},
	S("Redwood stair"),
	S("Redwood Slab"),
	default.node_sound_wood_defaults())

stairs.register_stair_and_slab("bamboo_wood", "ethereal:bamboo_block",
	{snappy = 3, choppy = 2, oddly_breakable_by_hand = 1, flammable = 3},
	{"bamboo_floor.png"},
	S("Bamboo stair"),
	S("Bamboo Slab"),
	default.node_sound_wood_defaults())

stairs.register_stair_and_slab("sakura_wood", "ethereal:sakura_wood",
	{choppy = 2, oddly_breakable_by_hand = 1, flammable = 3},
	{"ethereal_sakura_wood.png"},
	S("Sakura Wood Stair"),
	S("Sakura Wood Slab"),
	default.node_sound_wood_defaults())

stairs.register_stair_and_slab("olive_wood", "ethereal:olive_wood",
	{choppy = 2, oddly_breakable_by_hand = 1, flammable = 3},
	{"olive_wood.png"},
	S("Olive Wood Stair"),
	S("Olive Wood Slab"),
	default.node_sound_wood_defaults())

end
