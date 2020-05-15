-- The general item pool encompasses items that any bag can give and is the largest
-- The other pools are items exclusive to those bag colors
-- The general item pool MUST contain at least 1 item or else the bags won't give any items
ff_goodie_bags.general_item_pool = {}
ff_goodie_bags.blue_item_pool = {}
ff_goodie_bags.red_item_pool = {}
ff_goodie_bags.green_item_pool = {}
ff_goodie_bags.orange_item_pool = {}
local settings = Settings(minetest.get_modpath("ff_goodie_bags") .. "/ff_goodie_bags.conf")

if settings:get("ff_goodie_bags_beds") and minetest.get_modpath("beds") then
	table.insert(ff_goodie_bags.general_item_pool, "beds:fancy_bed")
	table.insert(ff_goodie_bags.general_item_pool, "beds:bed")
end

if settings:get("ff_goodie_bags_bucket") and minetest.get_modpath("bucket") then
	table.insert(ff_goodie_bags.general_item_pool, "bucket:bucket_empty")
	table.insert(ff_goodie_bags.blue_item_pool, "bucket:bucket_water")
	table.insert(ff_goodie_bags.red_item_pool, "bucket:bucket_lava")
end

if settings:get("ff_goodie_bags_carts") and minetest.get_modpath("carts") then
	table.insert(ff_goodie_bags.general_item_pool, "carts:rail")
	table.insert(ff_goodie_bags.general_item_pool, "carts:powerrail")
	table.insert(ff_goodie_bags.general_item_pool, "carts:brakerail")
end

if settings:get("ff_goodie_bags_default") and minetest.get_modpath("default") then
	table.insert(ff_goodie_bags.general_item_pool, "default:stick")
	table.insert(ff_goodie_bags.general_item_pool, "default:paper")
	table.insert(ff_goodie_bags.general_item_pool, "default:book")
	table.insert(ff_goodie_bags.red_item_pool, "default:coal_lump")
	table.insert(ff_goodie_bags.general_item_pool, "default:iron_lump")
	table.insert(ff_goodie_bags.general_item_pool, "default:copper_lump")
	table.insert(ff_goodie_bags.general_item_pool, "default:tin_lump")
	table.insert(ff_goodie_bags.general_item_pool, "default:mese_crystal")
	table.insert(ff_goodie_bags.general_item_pool, "default:gold_lump")
	table.insert(ff_goodie_bags.general_item_pool, "default:diamond")
	table.insert(ff_goodie_bags.general_item_pool, "default:clay_lump")
	table.insert(ff_goodie_bags.general_item_pool, "default:steel_ingot")
	table.insert(ff_goodie_bags.general_item_pool, "default:copper_ingot")
	table.insert(ff_goodie_bags.general_item_pool, "default:tin_ingot")
	table.insert(ff_goodie_bags.general_item_pool, "default:bronze_ingot")
	table.insert(ff_goodie_bags.general_item_pool, "default:gold_ingot")
	table.insert(ff_goodie_bags.general_item_pool, "default:mese_crystal_fragment")
	table.insert(ff_goodie_bags.general_item_pool, "default:clay_brick")
	table.insert(ff_goodie_bags.general_item_pool, "default:obsidian_shard")
	table.insert(ff_goodie_bags.general_item_pool, "default:flint")
	table.insert(ff_goodie_bags.general_item_pool, "default:stone")
	table.insert(ff_goodie_bags.general_item_pool, "default:cobble")
	table.insert(ff_goodie_bags.general_item_pool, "default:stonebrick")
	table.insert(ff_goodie_bags.general_item_pool, "default:stone_block")
	table.insert(ff_goodie_bags.general_item_pool, "default:mossycobble")
	table.insert(ff_goodie_bags.general_item_pool, "default:desert_stone")
	table.insert(ff_goodie_bags.general_item_pool, "default:desert_cobble")
	table.insert(ff_goodie_bags.general_item_pool, "default:desert_stonebrick")
	table.insert(ff_goodie_bags.general_item_pool, "default:desert_stone_block")
	table.insert(ff_goodie_bags.general_item_pool, "default:sandstone")
	table.insert(ff_goodie_bags.general_item_pool, "default:sandstonebrick")
	table.insert(ff_goodie_bags.general_item_pool, "default:sandstone_block")
	table.insert(ff_goodie_bags.general_item_pool, "default:desert_sandstone")
	table.insert(ff_goodie_bags.general_item_pool, "default:desert_sandstone_brick")
	table.insert(ff_goodie_bags.general_item_pool, "default:desert_sandstone_block")
	table.insert(ff_goodie_bags.general_item_pool, "default:silver_sandstone")
	table.insert(ff_goodie_bags.general_item_pool, "default:silver_sandstone_brick")
	table.insert(ff_goodie_bags.general_item_pool, "default:silver_sandstone_block")
	table.insert(ff_goodie_bags.general_item_pool, "default:obsidian")
	table.insert(ff_goodie_bags.general_item_pool, "default:obsidianbrick")
	table.insert(ff_goodie_bags.general_item_pool, "default:obsidian_block")
	table.insert(ff_goodie_bags.general_item_pool, "default:dirt")
	table.insert(ff_goodie_bags.general_item_pool, "default:dirt_with_grass")
	table.insert(ff_goodie_bags.general_item_pool, "default:dirt_with_grass_footsteps")
	table.insert(ff_goodie_bags.general_item_pool, "default:dirt_with_dry_grass")
	table.insert(ff_goodie_bags.general_item_pool, "default:dirt_with_snow")
	table.insert(ff_goodie_bags.general_item_pool, "default:dirt_with_rainforest_litter")
	table.insert(ff_goodie_bags.general_item_pool, "default:sand")
	table.insert(ff_goodie_bags.general_item_pool, "default:desert_sand")
	table.insert(ff_goodie_bags.general_item_pool, "default:silver_sand")
	table.insert(ff_goodie_bags.general_item_pool, "default:gravel")
	table.insert(ff_goodie_bags.general_item_pool, "default:clay")
	table.insert(ff_goodie_bags.general_item_pool, "default:snow")
	table.insert(ff_goodie_bags.general_item_pool, "default:snowblock")
	table.insert(ff_goodie_bags.blue_item_pool, "default:ice")
	table.insert(ff_goodie_bags.general_item_pool, "default:tree")
	table.insert(ff_goodie_bags.general_item_pool, "default:wood")
	table.insert(ff_goodie_bags.general_item_pool, "default:leaves")
	table.insert(ff_goodie_bags.general_item_pool, "default:sapling")
	table.insert(ff_goodie_bags.general_item_pool, "default:apple")
	table.insert(ff_goodie_bags.general_item_pool, "default:jungletree")
	table.insert(ff_goodie_bags.general_item_pool, "default:junglewood")
	table.insert(ff_goodie_bags.general_item_pool, "default:jungleleaves")
	table.insert(ff_goodie_bags.general_item_pool, "default:junglesapling")
	table.insert(ff_goodie_bags.general_item_pool, "default:pine_tree")
	table.insert(ff_goodie_bags.general_item_pool, "default:pine_wood")
	table.insert(ff_goodie_bags.general_item_pool, "default:pine_needles")
	table.insert(ff_goodie_bags.general_item_pool, "default:pine_sapling")
	table.insert(ff_goodie_bags.general_item_pool, "default:acacia_tree")
	table.insert(ff_goodie_bags.general_item_pool, "default:acacia_wood")
	table.insert(ff_goodie_bags.general_item_pool, "default:acacia_leaves")
	table.insert(ff_goodie_bags.general_item_pool, "default:acacia_sapling")
	table.insert(ff_goodie_bags.general_item_pool, "default:aspen_tree")
	table.insert(ff_goodie_bags.general_item_pool, "default:aspen_wood")
	table.insert(ff_goodie_bags.general_item_pool, "default:aspen_leaves")
	table.insert(ff_goodie_bags.general_item_pool, "default:aspen_sapling")
	table.insert(ff_goodie_bags.general_item_pool, "default:coalblock")
	table.insert(ff_goodie_bags.general_item_pool, "default:steelblock")
	table.insert(ff_goodie_bags.general_item_pool, "default:copperblock")
	table.insert(ff_goodie_bags.general_item_pool, "default:tinblock")
	table.insert(ff_goodie_bags.general_item_pool, "default:bronzeblock")
	table.insert(ff_goodie_bags.general_item_pool, "default:goldblock")
	table.insert(ff_goodie_bags.general_item_pool, "default:mese")
	table.insert(ff_goodie_bags.general_item_pool, "default:diamondblock")
	table.insert(ff_goodie_bags.green_item_pool, "default:cactus")
	table.insert(ff_goodie_bags.green_item_pool, "default:papyrus")
	table.insert(ff_goodie_bags.general_item_pool, "default:dry_shrub")
	table.insert(ff_goodie_bags.general_item_pool, "default:junglegrass")
	table.insert(ff_goodie_bags.general_item_pool, "default:grass_1")
	table.insert(ff_goodie_bags.general_item_pool, "default:dry_grass_1")
	table.insert(ff_goodie_bags.general_item_pool, "default:bush_stem")
	table.insert(ff_goodie_bags.general_item_pool, "default:bush_leaves")
	table.insert(ff_goodie_bags.general_item_pool, "default:bush_sapling")
	table.insert(ff_goodie_bags.general_item_pool, "default:acacia_bush_stem")
	table.insert(ff_goodie_bags.general_item_pool, "default:acacia_bush_leaves")
	table.insert(ff_goodie_bags.general_item_pool, "default:acacia_bush_sapling")
	table.insert(ff_goodie_bags.orange_item_pool, "default:coral_brown")
	table.insert(ff_goodie_bags.orange_item_pool, "default:coral_orange")
	table.insert(ff_goodie_bags.general_item_pool, "default:chest")
	table.insert(ff_goodie_bags.general_item_pool, "default:bookshelf")
	table.insert(ff_goodie_bags.general_item_pool, "default:sign_wall_wood")
	table.insert(ff_goodie_bags.general_item_pool, "default:sign_wall_steel")
	table.insert(ff_goodie_bags.general_item_pool, "default:ladder_wood")
	table.insert(ff_goodie_bags.general_item_pool, "default:ladder_steel")
	table.insert(ff_goodie_bags.general_item_pool, "default:fence_wood")
	table.insert(ff_goodie_bags.general_item_pool, "default:fence_acacia_wood")
	table.insert(ff_goodie_bags.general_item_pool, "default:fence_junglewood")
	table.insert(ff_goodie_bags.general_item_pool, "default:fence_pine_wood")
	table.insert(ff_goodie_bags.general_item_pool, "default:fence_aspen_wood")
	table.insert(ff_goodie_bags.general_item_pool, "default:glass")
	table.insert(ff_goodie_bags.general_item_pool, "default:obsidian_glass")
	table.insert(ff_goodie_bags.general_item_pool, "default:meselamp")
	table.insert(ff_goodie_bags.general_item_pool, "default:mese_post_light")
	table.insert(ff_goodie_bags.general_item_pool, "default:pick_wood")
	table.insert(ff_goodie_bags.general_item_pool, "default:pick_stone")
	table.insert(ff_goodie_bags.general_item_pool, "default:pick_steel")
	table.insert(ff_goodie_bags.general_item_pool, "default:pick_bronze")
	table.insert(ff_goodie_bags.general_item_pool, "default:pick_mese")
	table.insert(ff_goodie_bags.general_item_pool, "default:pick_diamond")
	table.insert(ff_goodie_bags.general_item_pool, "default:shovel_wood")
	table.insert(ff_goodie_bags.general_item_pool, "default:shovel_stone")
	table.insert(ff_goodie_bags.general_item_pool, "default:shovel_steel")
	table.insert(ff_goodie_bags.general_item_pool, "default:shovel_bronze")
	table.insert(ff_goodie_bags.general_item_pool, "default:shovel_mese")
	table.insert(ff_goodie_bags.general_item_pool, "default:shovel_diamond")
	table.insert(ff_goodie_bags.general_item_pool, "default:axe_wood")
	table.insert(ff_goodie_bags.general_item_pool, "default:axe_stone")
	table.insert(ff_goodie_bags.general_item_pool, "default:axe_steel")
	table.insert(ff_goodie_bags.general_item_pool, "default:axe_bronze")
	table.insert(ff_goodie_bags.general_item_pool, "default:axe_mese")
	table.insert(ff_goodie_bags.general_item_pool, "default:axe_diamond")
	table.insert(ff_goodie_bags.general_item_pool, "default:sword_wood")
	table.insert(ff_goodie_bags.general_item_pool, "default:sword_stone")
	table.insert(ff_goodie_bags.general_item_pool, "default:sword_steel")
	table.insert(ff_goodie_bags.general_item_pool, "default:sword_bronze")
	table.insert(ff_goodie_bags.general_item_pool, "default:sword_mese")
	table.insert(ff_goodie_bags.general_item_pool, "default:sword_diamond")
	table.insert(ff_goodie_bags.general_item_pool, "default:torch")
	table.insert(ff_goodie_bags.general_item_pool, "default:furnace")
end

if settings:get("ff_goodie_bags_doors") and minetest.get_modpath("doors") then
	table.insert(ff_goodie_bags.general_item_pool, "doors:door_wood")
	table.insert(ff_goodie_bags.general_item_pool, "doors:door_steel")
	table.insert(ff_goodie_bags.general_item_pool, "doors:door_glass")
	table.insert(ff_goodie_bags.general_item_pool, "doors:door_obsidian_glass")
	table.insert(ff_goodie_bags.general_item_pool, "doors:trapdoor")
	table.insert(ff_goodie_bags.general_item_pool, "doors:trapdoor_steel")
end

if settings:get("ff_goodie_bags_dye") and minetest.get_modpath("dye") then
	table.insert(ff_goodie_bags.red_item_pool, "dye:red")
	table.insert(ff_goodie_bags.general_item_pool, "dye:black")
	table.insert(ff_goodie_bags.general_item_pool, "dye:yellow")
	table.insert(ff_goodie_bags.green_item_pool, "dye:green")
	table.insert(ff_goodie_bags.blue_item_pool, "dye:blue")
	table.insert(ff_goodie_bags.general_item_pool, "dye:white")
	table.insert(ff_goodie_bags.general_item_pool, "dye:violet")
	table.insert(ff_goodie_bags.orange_item_pool, "dye:orange")
	table.insert(ff_goodie_bags.general_item_pool, "dye:cyan")
	table.insert(ff_goodie_bags.general_item_pool, "dye:dark_green")
	table.insert(ff_goodie_bags.general_item_pool, "dye:brown")
end

if settings:get("ff_goodie_bags_fire") and minetest.get_modpath("fire") then
	table.insert(ff_goodie_bags.general_item_pool, "fire:flint_and_steel")
end

if settings:get("ff_goodie_bags_flowers") and minetest.get_modpath("flowers") then
	table.insert(ff_goodie_bags.red_item_pool, "flowers:rose")
	table.insert(ff_goodie_bags.general_item_pool, "flowers:tulip")
	table.insert(ff_goodie_bags.general_item_pool, "flowers:dandelion_yellow")
	table.insert(ff_goodie_bags.general_item_pool, "flowers:geranium")
	table.insert(ff_goodie_bags.blue_item_pool, "flowers:viola")
	table.insert(ff_goodie_bags.general_item_pool, "flowers:dandelion_white")
	table.insert(ff_goodie_bags.general_item_pool, "flowers:mushroom_red")
	table.insert(ff_goodie_bags.orange_item_pool, "flowers:mushroom_brown")
	table.insert(ff_goodie_bags.green_item_pool, "flowers:waterlily")	
end

if settings:get("ff_goodie_bags_tnt") and minetest.get_modpath("tnt") then
	table.insert(ff_goodie_bags.general_item_pool, "tnt:gunpowder")
	table.insert(ff_goodie_bags.general_item_pool, "tnt:tnt")
end

if settings:get("ff_goodie_bags_vessels") and minetest.get_modpath("vessels") then
	table.insert(ff_goodie_bags.general_item_pool, "vessels:shelf")
	table.insert(ff_goodie_bags.general_item_pool, "vessels:glass_bottle")
	table.insert(ff_goodie_bags.general_item_pool, "vessels:drinking_glass")
	table.insert(ff_goodie_bags.general_item_pool, "vessels:steel_bottle")
	table.insert(ff_goodie_bags.general_item_pool, "vessels:glass_fragments")
end

if settings:get("ff_goodie_bags_wool") and minetest.get_modpath("wool") then
	table.insert(ff_goodie_bags.general_item_pool, "wool:white")
	table.insert(ff_goodie_bags.general_item_pool, "wool:grey")
	table.insert(ff_goodie_bags.general_item_pool, "wool:black")
	table.insert(ff_goodie_bags.red_item_pool, "wool:red")
	table.insert(ff_goodie_bags.general_item_pool, "wool:yellow")
	table.insert(ff_goodie_bags.green_item_pool, "wool:green")
	table.insert(ff_goodie_bags.general_item_pool, "wool:cyan")
	table.insert(ff_goodie_bags.blue_item_pool, "wool:blue")
	table.insert(ff_goodie_bags.general_item_pool, "wool:magenta")
	table.insert(ff_goodie_bags.orange_item_pool, "wool:orange")
	table.insert(ff_goodie_bags.general_item_pool, "wool:violet")
	table.insert(ff_goodie_bags.general_item_pool, "wool:brown")
	table.insert(ff_goodie_bags.general_item_pool, "wool:pink")
	table.insert(ff_goodie_bags.general_item_pool, "wool:dark_grey")
	table.insert(ff_goodie_bags.general_item_pool, "wool:dark_green")
end

-- Specific drops for Floating Factories sub game only
-- Overrides all other drops
-- Also serves as an example how other sub games, servers, etc can set their own goodies
if minetest.get_modpath("floating_factories") and minetest.get_modpath("default") and minetest.get_modpath("dye") and minetest.get_modpath("bonemeal") and minetest.get_modpath("farming") and farming and farming.mod and farming.mod == "redo" and minetest.get_modpath("carts") and minetest.get_modpath("vessels") and minetest.get_modpath("floating_anchor") and minetest.get_modpath("ma_pops_furniture") and minetest.get_modpath("jukebox") then
	ff_goodie_bags.general_item_pool = {"default:torch", "default:stick", "default:dirt", "default:cobble", "default:lava_source", "dye:black", "dye:yellow", "dye:white", "dye:violet", "dye:cyan", "dye:dark_green", "dye:brown", "bonemeal:mulch", "default:apple", "farming:donut_chocolate", "floating_anchor:floating_anchor_item", "vessels:glass_bottle", "doors:door_wood", "carts:rail"}
	
	ff_goodie_bags.blue_item_pool = {"dye:blue", "ma_pops_furniture:chair_pine_wood", "ma_pops_furniture:chair2_blue", "ma_pops_furniture:br_sink 1", "ma_pops_furniture:freezer", "jukebox:disc_5"}
	
	ff_goodie_bags.red_item_pool = {"dye:red", "ma_pops_furniture:smoke_detector", "ma_pops_furniture:chair2_red", "jukebox:disc_6"}
	
	ff_goodie_bags.green_item_pool = {"dye:green", "ma_pops_furniture:sofa_green", "ma_pops_furniture:chair2_green", "ma_pops_furniture:birdbath", "default:cactus", "default:papyrus", "jukebox:disc_7"}
	
	ff_goodie_bags.orange_item_pool = {"dye:orange", "ma_pops_furniture:chair2_orange", "ma_pops_furniture:sofa_orange", "ma_pops_furniture:grill", "jukebox:disc_8"}
end
