
-- add compatibility for ethereal nodes already in default game or name changed
minetest.register_alias("ethereal:acacia_trunk", "default:acacia_tree")
minetest.register_alias("ethereal:acacia_wood", "default:acacia_wood")

minetest.register_alias("ethereal:fence_acacia", "default:fence_acacia_wood")
minetest.register_alias("ethereal:fence_junglewood", "default:fence_junglewood")
minetest.register_alias("ethereal:fence_pine", "default:fence_pine_wood")

minetest.register_alias("ethereal:acacia_leaves", "default:acacia_leaves")
minetest.register_alias("ethereal:pineleaves", "default:pine_needles")

minetest.register_alias("ethereal:mushroom_craftingitem", "flowers:mushroom_brown")
minetest.register_alias("ethereal:mushroom_plant", "flowers:mushroom_brown")
minetest.register_alias("ethereal:mushroom_soup_cooked", "ethereal:mushroom_soup")
minetest.register_alias("ethereal:mushroom_1", "flowers:mushroom_brown")
minetest.register_alias("ethereal:mushroom_2", "flowers:mushroom_brown")
minetest.register_alias("ethereal:mushroom_3", "flowers:mushroom_brown")
minetest.register_alias("ethereal:mushroom_4", "flowers:mushroom_brown")

minetest.register_alias("ethereal:strawberry_bush", "ethereal:strawberry_7")
minetest.register_alias("ethereal:seed_strawberry", "ethereal:strawberry")

for i = 1, 5 do
	minetest.register_alias("ethereal:wild_onion_"..i, "ethereal:onion_"..i)
end

minetest.register_alias("ethereal:onion_7", "ethereal:onion_4")
minetest.register_alias("ethereal:onion_8", "ethereal:onion_5")
minetest.register_alias("ethereal:wild_onion_7", "ethereal:onion_4")
minetest.register_alias("ethereal:wild_onion_8", "ethereal:onion_5")
minetest.register_alias("ethereal:wild_onion_craftingitem", "ethereal:wild_onion_plant")

minetest.register_alias("ethereal:hearty_stew_cooked", "ethereal:hearty_stew")

minetest.register_alias("ethereal:obsidian_brick", "default:obsidianbrick")

minetest.register_alias("ethereal:crystal_topped_dirt", "ethereal:crystal_dirt")
minetest.register_alias("ethereal:fiery_dirt_top", "ethereal:fiery_dirt")
minetest.register_alias("ethereal:gray_dirt_top", "ethereal:gray_dirt")
minetest.register_alias("ethereal:green_dirt_top", "default;dirt_with_grass")

minetest.register_alias("ethereal:tree_sapling", "default:sapling")
minetest.register_alias("ethereal:jungle_tree_sapling", "default:junglesapling")
minetest.register_alias("ethereal:acacia_sapling", "default:acacia_sapling")
minetest.register_alias("ethereal:pine_tree_sapling", "default:pine_sapling")
