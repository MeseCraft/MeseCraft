local S = minetest.get_translator(minetest.get_current_modname())

local bucket_empty = df_dependencies.node_name_bucket_empty

local chomp = {eat = {name = "df_farming_chomp_crunch", gain = 1.0}}
local crisp = {eat = {name = "df_farming_crisp_chew", gain = 1.0}}
local gummy = {eat = {name = "df_farming_gummy_chew", gain = 1.0}}
local mushy = {eat = {name = "df_farming_mushy_chew", gain = 1.0}}
local soft = {eat = {name = "df_farming_soft_chew", gain = 1.0}}

local recipes = {
{recipe = {"df_farming:cave_flour", "df_farming:cave_wheat_seed"}, name=S("Cave Wheat Flour Biscuit"), image="dfcaverns_prepared_food08x16.png", sound = crisp},
{recipe = {"df_farming:cave_flour", "df_farming:cave_wheat_seed", "group:sugar"}, name=S("Cave Wheat Flour Bun"), image="dfcaverns_prepared_food11x16.png", sound = mushy},
{recipe = {"df_farming:cave_flour", "group:food_flour", "df_farming:cave_wheat_seed", "df_farming:plump_helmet_spawn"}, name=S("Cave Wheat Flour Pancake"), image="dfcaverns_prepared_food07x16.png", sound = mushy},
{recipe = {"df_farming:cave_wheat_seed", "group:plump_helmet"}, name=S("Cave Wheat Seed Loaf"), image="dfcaverns_prepared_food17x16.png", sound = crisp},
{recipe = {"df_farming:cave_wheat_seed", "df_farming:cave_wheat_seed", "group:sugar"}, name=S("Cave Wheat Seed Puffs"), image="dfcaverns_prepared_food33x16.png", sound = soft},
{recipe = {"df_farming:cave_wheat_seed", "df_farming:cave_wheat_seed", "df_farming:pig_tail_seed", "df_farming:plump_helmet_spawn"}, name=S("Cave Wheat Seed Risotto"), image="dfcaverns_prepared_food14x16.png", sound = gummy},
{recipe = {"df_farming:sweet_pod_seed", "group:food_flour"}, name=S("Sweet Pod Spore Dumplings"), image="dfcaverns_prepared_food09x16.png", sound = mushy},
{recipe = {"df_farming:sweet_pod_seed", "group:food_flour", "group:sugar"}, name=S("Sweet Pod Spore Single Crust Pie"), image="dfcaverns_prepared_food05x16.png", sound = mushy},
{recipe = {"df_farming:sweet_pod_seed", "group:sugar", "group:food_flour", "df_farming:dwarven_syrup_bucket"}, replacements={{"df_farming:dwarven_syrup_bucket", bucket_empty}}, name=S("Sweet Pod Spore Brule"), image="dfcaverns_prepared_food22x16.png", sound = soft},
{recipe = {"df_farming:sugar", "group:food_flour"}, name=S("Sweet Pod Sugar Cookie"), image="dfcaverns_prepared_food02x16.png", sound = crisp},
{recipe = {"df_farming:sugar", "group:food_flour", "df_farming:quarry_bush_leaves"}, name=S("Sweet Pod Sugar Gingerbread"), image="dfcaverns_prepared_food21x16.png", sound = chomp},
{recipe = {"df_farming:sugar", "group:sugar", "group:food_flour", "group:food_flour"}, name=S("Sweet Pod Sugar Roll"), image="dfcaverns_prepared_food25x16.png", sound = crisp},
{recipe = {"group:plump_helmet", "group:plump_helmet"}, name=S("Plump Helmet Mince"), image="dfcaverns_prepared_food15x16.png", sound = mushy},
{recipe = {"group:plump_helmet", "group:plump_helmet", "df_farming:quarry_bush_leaves"}, name=S("Plump Helmet Stalk Sausage"), image="dfcaverns_prepared_food18x16.png", sound = gummy},
{recipe = {"group:plump_helmet", "group:food_flour", "df_farming:plump_helmet_spawn", "df_farming:quarry_bush_leaves"}, name=S("Plump Helmet Roast"), image="dfcaverns_prepared_food04x16.png", sound = mushy},
{recipe = {"df_farming:plump_helmet_spawn", "group:plump_helmet"}, name=S("Plump Helmet Spawn Soup"), image="dfcaverns_prepared_food10x16.png", sound = gummy},
{recipe = {"df_farming:plump_helmet_spawn", "df_farming:quarry_bush_seed", "group:plump_helmet"}, name=S("Plump Helmet Spawn Jambalaya"), image="dfcaverns_prepared_food01x16.png", sound = soft},
{recipe = {"df_farming:plump_helmet_spawn", "df_farming:plump_helmet_spawn", "group:plump_helmet", "group:plump_helmet"}, name=S("Plump Helmet Sprout Stew"), image="dfcaverns_prepared_food26x16.png", sound = gummy},
{recipe = {"df_farming:quarry_bush_leaves", "df_farming:cave_bread"}, name=S("Quarry Bush Leaf Spicy Bun"), image="dfcaverns_prepared_food23x16.png", sound = soft},
{recipe = {"df_farming:quarry_bush_leaves", "group:food_flour", "group:plump_helmet"}, name=S("Quarry Bush Leaf Croissant"), image="dfcaverns_prepared_food29x16.png", sound = soft},
{recipe = {"df_farming:quarry_bush_leaves", "group:plump_helmet", "group:plump_helmet", "group:plump_helmet"}, name=S("Stuffed Quarry Bush Leaf"), image="dfcaverns_prepared_food27x16.png", sound = chomp},
{recipe = {"df_farming:quarry_bush_seed", "df_farming:cave_bread"}, name=S("Rock Nut Bread"), image="dfcaverns_prepared_food16x16.png", sound = soft},
{recipe = {"df_farming:quarry_bush_seed", "group:food_flour", "group:sugar"}, name=S("Rock Nut Cookie"), image="dfcaverns_prepared_food07x16.png", sound = chomp},
{recipe = {"df_farming:quarry_bush_seed", "group:sugar", "df_farming:sweet_pod_seed", "group:food_flour"}, name=S("Rock Nut Cake"), image="dfcaverns_prepared_food03x16.png", sound = soft},
{recipe = {"df_farming:dimple_cup_seed", "group:food_flour"}, name=S("Dimple Cup Spore Flatbread"), image="dfcaverns_prepared_food12x16.png", sound = crisp},
{recipe = {"df_farming:dimple_cup_seed", "group:food_flour", "group:sugar"}, name=S("Dimple Cup Spore Scone"), image="dfcaverns_prepared_food32x16.png", sound = chomp},
{recipe = {"df_farming:dimple_cup_seed", "df_farming:sweet_pod_seed", "df_farming:quarry_bush_seed", "group:food_flour"}, name=S("Dimple Cup Spore Roll"), image="dfcaverns_prepared_food31x16.png", sound = soft},
{recipe = {"df_farming:pig_tail_seed", "df_farming:cave_bread"}, name=S("Pig Tail Spore Sandwich"), image="dfcaverns_prepared_food20x16.png", sound = soft},
{recipe = {"df_farming:pig_tail_seed", "df_farming:pig_tail_seed", "df_farming:dwarven_syrup_bucket"}, name=S("Pig Tail Spore Tofu"), replacements={{"df_farming:dwarven_syrup_bucket", bucket_empty}}, image="dfcaverns_prepared_food30x16.png", sound = gummy},
{recipe = {"df_farming:pig_tail_seed", "df_farming:sweet_pod_seed", "group:food_flour", "group:food_flour"}, name=S("Pig Tail Spore Casserole"), image="dfcaverns_prepared_food34x16.png", sound = mushy},
{recipe = {"df_farming:dwarven_syrup_bucket", "df_farming:dwarven_syrup_bucket"}, replacements={{"df_farming:dwarven_syrup_bucket", bucket_empty}, {"df_farming:dwarven_syrup_bucket", bucket_empty}}, name=S("Dwarven Syrup Taffy"), image="dfcaverns_prepared_food19x16.png", sound = gummy},
{recipe = {"df_farming:dwarven_syrup_bucket", "group:sugar", "group:plump_helmet"}, replacements={{"df_farming:dwarven_syrup_bucket", bucket_empty}}, name=S("Dwarven Syrup Jellies"), image="dfcaverns_prepared_food06x16.png", sound = gummy},
{recipe = {"df_farming:dwarven_syrup_bucket", "group:food_flour", "group:sugar", "df_farming:quarry_bush_seed"}, replacements={{"df_farming:dwarven_syrup_bucket", bucket_empty}}, name=S("Dwarven Syrup Delight"), image="dfcaverns_prepared_food24x16.png", sound = mushy},
}

local complexity = {[2]={name="simple", value=4}, [3]={name="medium", value=6}, [4]={name="complex", value=8}}
local alias_items = {}

-- validate the recipes.
for index1 = 1, table.getn(recipes)-1 do
	for index2 = index1+1, table.getn(recipes) do
		local recipe1 = recipes[index1].recipe
		local recipe2 = recipes[index2].recipe
		local recipe1count = {}
		local recipe2count = {}
		for _, item in pairs(recipe1) do
			recipe1count[item] = (recipe1count[item] or 0) + 1
		end
		for _, item in pairs(recipe2) do
			recipe2count[item] = (recipe2count[item] or 0) + 1
		end
		local identical = true
		for key, val in pairs(recipe1count) do
			if recipe2count[key] ~= val then
				identical = false
				break
			end
		end
		for key, val in pairs(recipe2count) do
			if recipe1count[key] ~= val then
				identical = false
				break
			end
		end
		assert(not identical, "recipes " .. recipes[index1].name .. " and " .. recipes[index2].name .. " have identical ingredients!")
	end
end
local ingredient_count = {}
--for _, recipe_entry in pairs(recipes) do
--	for _, item in pairs(recipe_entry.recipe) do
--		ingredient_count[item] = (ingredient_count[item] or 0) + 1
--	end
--end
--minetest.debug(dump(ingredient_count))

for _, def in pairs(recipes) do
	local recipe_type = complexity[table.getn(def.recipe)]
	local _, item_name = string.match(def.recipe[1], "(.*):(.*)")
	local output = "df_farming:"..item_name.."_"..recipe_type.name.."_meal"
	alias_items[item_name] = true

	minetest.register_craftitem(output, {
		description = def.name,
		_doc_items_longdesc = df_farming.doc[recipe_type.name.."_meal_desc"],
		_doc_items_usagehelp = df_farming.doc[recipe_type.name.."_meal_usage"],
		inventory_image = def.image,
		sound = def.sound,
		on_use = minetest.item_eat(recipe_type.value),
		groups = {food = recipe_type.value, eatable=recipe_type.value},
		_hunger_ng = {satiates = recipe_type.value},
		_mcl_saturation = recipe_type.value, -- TODO: make this more interesting
	})

	minetest.register_craft({
		type = "shapeless",
		output = output,
		recipe = def.recipe,
		replacements = def.replacements
	})
end

for item, _ in pairs(alias_items) do
	minetest.register_alias("dfcaverns:"..item.."_biscuit", "df_farming:"..item.."_simple_meal")
	minetest.register_alias("dfcaverns:"..item.."_stew", "df_farming:"..item.."_medium_meal")
	minetest.register_alias("dfcaverns:"..item.."_roast", "df_farming:"..item.."_complex_meal")
	minetest.register_alias("df_farming:"..item.."_biscuit", "df_farming:"..item.."_simple_meal")
	minetest.register_alias("df_farming:"..item.."_stew", "df_farming:"..item.."_medium_meal")
	minetest.register_alias("df_farming:"..item.."_roast", "df_farming:"..item.."_complex_meal")
end


-- dfcaverns_prepared_food28 is currently unused
-- dfcaverns_prepared_food13 is used for dwarven bread