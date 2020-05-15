-- internationalization boilerplate
local MP = minetest.get_modpath(minetest.get_current_modname())
local S, NS = dofile(MP.."/intllib.lua")

local register_cooking_recipes = function(def)
	local prefix = def.prefix
	local item = def.item
	local replacements = def.replacements
	minetest.register_craftitem("df_farming:"..item.."_simple_meal", {
		description = def.simple.name,
		_doc_items_longdesc = df_farming.doc.simple_meal_desc,
		_doc_items_usagehelp = df_farming.doc.simple_meal_usage,
		inventory_image = def.simple.image,
		sound = def.simple.sound,
		on_use = minetest.item_eat(4),
		groups = {food = 4},
	})
	minetest.register_craftitem("df_farming:"..item.."_medium_meal", {
		description = def.medium.name,
		_doc_items_longdesc = df_farming.doc.medium_meal_desc,
		_doc_items_usagehelp = df_farming.doc.medium_meal_usage,
		inventory_image = def.medium.image,
		sound = def.medium.sound,
		on_use = minetest.item_eat(6),
		groups = {food = 6},
	})
	minetest.register_craftitem("df_farming:"..item.."_complex_meal", {
		description = def.complex.name,
		_doc_items_longdesc = df_farming.doc.complex_meal_desc,
		_doc_items_usagehelp = df_farming.doc.complex_meal_usage,
		inventory_image = def.complex.image,
		sound = def.complex.sound,
		on_use = minetest.item_eat(8),
		groups = {food = 8},
	})
	
	minetest.register_alias("dfcaverns:"..item.."_biscuit", "df_farming:"..item.."_simple_meal")
	minetest.register_alias("dfcaverns:"..item.."_stew", "df_farming:"..item.."_medium_meal")
	minetest.register_alias("dfcaverns:"..item.."_roast", "df_farming:"..item.."_complex_meal")
	minetest.register_alias("df_farming:"..item.."_biscuit", "df_farming:"..item.."_simple_meal")
	minetest.register_alias("df_farming:"..item.."_stew", "df_farming:"..item.."_medium_meal")
	minetest.register_alias("df_farming:"..item.."_roast", "df_farming:"..item.."_complex_meal")
	
	minetest.register_craft({
		type = "shapeless",
		output = "df_farming:"..item.."_simple_meal",
		recipe = {"group:dfcaverns_cookable", prefix..":"..item},
		replacements = replacements
	})
	minetest.register_craft({
		type = "shapeless",
		output = "df_farming:"..item.."_medium_meal",
		recipe = {"group:dfcaverns_cookable", "group:dfcaverns_cookable", prefix..":"..item},
		replacements = replacements
	})
	minetest.register_craft({
		type = "shapeless",
		output = "df_farming:"..item.."_complex_meal",
		recipe = {"group:dfcaverns_cookable", "group:dfcaverns_cookable", "group:dfcaverns_cookable", prefix..":"..item},
		replacements = replacements
	})
end


--{
--	prefix =,
--	item =,
--	replacements =,
--	simple = {name = , image = , sound = },
--	medium = {name = , image = , sound = },
--	complex = {name = , image = , sound = },
--}

local chomp = {eat = {name = "df_farming_chomp_crunch", gain = 1.0}}
local crisp = {eat = {name = "df_farming_crisp_chew", gain = 1.0}}
local gummy = {eat = {name = "df_farming_gummy_chew", gain = 1.0}}
local mushy = {eat = {name = "df_farming_mushy_chew", gain = 1.0}}
local soft = {eat = {name = "df_farming_soft_chew", gain = 1.0}}

register_cooking_recipes({prefix="df_farming", item="cave_flour",
	simple =  {name=S("Cave Wheat Flour Biscuit"), image="dfcaverns_prepared_food08x16.png", sound = crisp},
	medium =  {name=S("Cave Wheat Flour Bun"), image="dfcaverns_prepared_food11x16.png", sound = mushy},
	complex = {name=S("Cave Wheat Flour Pancake"), image="dfcaverns_prepared_food07x16.png", sound = mushy},
})
register_cooking_recipes({prefix="df_farming", item="cave_wheat_seed",
	simple =  {name=S("Cave Wheat Seed Loaf"), image="dfcaverns_prepared_food17x16.png", sound = crisp},
	medium =  {name=S("Cave Wheat Seed Puffs"), image="dfcaverns_prepared_food33x16.png", sound = soft},
	complex = {name=S("Cave Wheat Seed Risotto"), image="dfcaverns_prepared_food14x16.png", sound = gummy},
})
register_cooking_recipes({prefix="df_farming", item="sweet_pod_seed",
	simple =  {name=S("Sweet Pod Spore Dumplings"), image="dfcaverns_prepared_food09x16.png", sound = mushy},
	medium =  {name=S("Sweet Pod Spore Single Crust Pie"), image="dfcaverns_prepared_food05x16.png", sound = mushy},
	complex = {name=S("Sweet Pod Spore Brule"), image="dfcaverns_prepared_food22x16.png", sound = soft},
})
register_cooking_recipes({prefix="df_farming", item="sugar",
	simple =  {name=S("Sweet Pod Sugar Cookie"), image="dfcaverns_prepared_food02x16.png", sound = crisp},
	medium =  {name=S("Sweet Pod Sugar Gingerbread"), image="dfcaverns_prepared_food21x16.png", sound = chomp},
	complex = {name=S("Sweet Pod Sugar Roll"), image="dfcaverns_prepared_food25x16.png", sound = crisp},
})
register_cooking_recipes({prefix="group", item="plump_helmet",
	simple =  {name=S("Plump Helmet Mince"), image="dfcaverns_prepared_food15x16.png", sound = mushy},
	medium =  {name=S("Plump Helmet Stalk Sausage"), image="dfcaverns_prepared_food18x16.png", sound = gummy},
	complex = {name=S("Plump Helmet Roast"), image="dfcaverns_prepared_food04x16.png", sound = mushy},
})
register_cooking_recipes({prefix="df_farming", item="plump_helmet_spawn",
	simple =  {name=S("Plump Helmet Spawn Soup"), image="dfcaverns_prepared_food10x16.png", sound = gummy},
	medium =  {name=S("Plump Helmet Spawn Jambalaya"), image="dfcaverns_prepared_food01x16.png", sound = soft},
	complex = {name=S("Plump Helmet Sprout Stew"), image="dfcaverns_prepared_food26x16.png", sound = gummy},
})
register_cooking_recipes({prefix="df_farming", item="quarry_bush_leaves",
	simple =  {name=S("Quarry Bush Leaf Spicy Bun"), image="dfcaverns_prepared_food23x16.png", sound = soft},
	medium =  {name=S("Quarry Bush Leaf Croissant"), image="dfcaverns_prepared_food29x16.png", sound = soft},
	complex = {name=S("Stuffed Quarry Bush Leaf"), image="dfcaverns_prepared_food27x16.png", sound = chomp},
})
register_cooking_recipes({prefix="df_farming", item="quarry_bush_seed",
	simple =  {name=S("Rock Nut Bread"), image="dfcaverns_prepared_food16x16.png", sound = soft},
	medium =  {name=S("Rock Nut Cookie"), image="dfcaverns_prepared_food07x16.png", sound = chomp},
	complex = {name=S("Rock Nut Cake"), image="dfcaverns_prepared_food03x16.png", sound = soft},
})
register_cooking_recipes({prefix="df_farming", item="dimple_cup_seed",
	simple =  {name=S("Dimple Cup Spore Flatbread"), image="dfcaverns_prepared_food12x16.png", sound = crisp},
	medium =  {name=S("Dimple Cup Spore Scone"), image="dfcaverns_prepared_food32x16.png", sound = chomp},
	complex = {name=S("Dimple Cup Spore Roll"), image="dfcaverns_prepared_food31x16.png", sound = soft},
})
register_cooking_recipes({prefix="df_farming", item="pig_tail_seed",
	simple =  {name=S("Pig Tail Spore Sandwich"), image="dfcaverns_prepared_food20x16.png", sound = soft},
	medium = {name=S("Pig Tail Spore Tofu"), image="dfcaverns_prepared_food30x16.png", sound = gummy},
	complex =  {name=S("Pig Tail Spore Casserole"), image="dfcaverns_prepared_food34x16.png", sound = mushy},
})
register_cooking_recipes({prefix="df_farming", item="dwarven_syrup_bucket", replacements={{"df_farming:dwarven_syrup_bucket", "bucket:bucket_empty"}},
	simple =  {name=S("Dwarven Syrup Taffy"), image="dfcaverns_prepared_food19x16.png", sound = gummy},
	medium =  {name=S("Dwarven Syrup Jellies"), image="dfcaverns_prepared_food06x16.png", sound = gummy},
	complex = {name=S("Dwarven Syrup Delight"), image="dfcaverns_prepared_food24x16.png", sound = mushy},
})

-- dfcaverns_prepared_food28 is currently unused
-- dfcaverns_prepared_food13 is used for dwarven bread