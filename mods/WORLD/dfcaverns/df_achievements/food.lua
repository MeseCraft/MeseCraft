local S = minetest.get_translator(minetest.get_current_modname())

for itemname, def in pairs(minetest.registered_items) do
	--"df_farming:"..item_name.."_"..recipe_type.name.."_meal"
	if string.sub(itemname, 1, 11) == "df_farming:" and string.sub(itemname, -5, -1) == "_meal" then
		local meal_name = string.sub(itemname, 12, -1)
		local meal_desc = def.description
		local image = string.sub(def.inventory_image, 1, -7) .. "32.png"
	
		awards.register_achievement("dfcaverns_meal_"..meal_name, {
			title = S("Eat @1", meal_desc),
			description = S("One of the many delights that can be crafted only from fungal growths found deep underground."),
			icon = "dfcaverns_awards_backgroundx32.png^" .. image .. "^dfcaverns_awards_foregroundx32.png",
			trigger = {
				type = "eat",
				item = itemname,
				target = 1
			},
			difficulty = 2,
			_dfcaverns_achievements = {"dfcaverns_gourmand"},
		})
	end
end

local bread_def = minetest.registered_items["df_farming:cave_bread"]
awards.register_achievement("dfcaverns_meal_dwarven_bread", {
	title = S("Eat @1", bread_def.description),
	description = S("It's a basic staple of the underground, but at least it's not Plump Helmet."),
	icon = "dfcaverns_awards_backgroundx32.png^dfcaverns_prepared_food13x32.png^dfcaverns_awards_foregroundx32.png",
	trigger = {
		type = "eat",
		item = "df_farming:cave_bread",
		target = 1,
	},
	difficulty = 1,
	_dfcaverns_achievements = {"dfcaverns_gourmand"},
})

awards.register_achievement("dfcaverns_gourmand", {
	title = S("Dwarven Gourmand"),
	description = S("Eat one of each of the various meals that can be cooked or crafted from underground ingredients."),
	icon ="dfcaverns_awards_backgroundx32.png^dfcaverns_prepared_food28x32.png^dfcaverns_gourmand_achievement.png^dfcaverns_awards_foregroundx32.png",
	difficulty = 2 / df_achievements.get_child_achievement_count("dfcaverns_gourmand"),
	trigger = {
		type="dfcaverns_achievements",
		achievement_name="dfcaverns_gourmand",
		target=df_achievements.get_child_achievement_count("dfcaverns_gourmand"),
	},
})

if minetest.get_modpath("df_primordial_items") then
	awards.register_achievement("dfcaverns_primordial_fruit", {
		title = S("Eat a Primordial Fruit"),
		description = S("Eat one of the strange fruits found only deep underground in the Primordial caverns."),
		icon ="dfcaverns_awards_backgroundx32.png^dfcaverns_primordial_fruit.png^dfcaverns_awards_foregroundx32.png",
		difficulty = 3,
		trigger = {
			type = "eat",
			item = "df_primordial_items:primordial_fruit",
			target = 1
		},
		secret = true,
	})

	awards.register_achievement("dfcaverns_glowtato", {
		title = S("Eat a Glowtato"),
		description = S("Slightly less prestigious than the Primordial Fruit, but still rare and exotic compared to surface world fare."),
		icon ="dfcaverns_awards_backgroundx32.png^dfcaverns_glowtato.png^dfcaverns_awards_foregroundx32.png",
		difficulty = 3,
		trigger = {
			type = "eat",
			item = "df_primordial_items:glowtato",
			target = 1
		},
	})

-- too mundane compared to the other achievements
--	awards.register_achievement("dfcaverns_diced_mushroom", {
--		title = S("Eat Diced Mushroom"),
--		description = S(""),
--		icon =,
--		trigger = {
--			type = "eat",
--			item = "df_primordial_items:diced_mushroom",
--			target = 1
--		},
--	})
end