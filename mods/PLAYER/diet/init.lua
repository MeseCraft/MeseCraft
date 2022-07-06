diet = {
	players = {}
}

function diet.__init()
	local file = io.open(minetest.get_worldpath().."/diet.txt", "r")
	if file then
		local table = minetest.deserialize(file:read("*all"))
		if type(table) == "table" then
			diet.players = table.players
			return
		end
	end
end

function diet.save()
	local file = io.open(minetest.get_worldpath().."/diet.txt", "w")
	if file then
		file:write(minetest.serialize({
			players = diet.players
		}))
		file:close()
	end
end

-- Poison player
local function poisenp(tick, time, time_left, player)
	time_left = time_left + tick
	if time_left < time then
		minetest.after(tick, poisenp, tick, time, time_left, player)
	else
		--reset hud image
	end
	if player:get_hp()-1 > 0 then
		player:set_hp(player:get_hp()-1)
	end

end

function diet.item_eat(max, replace_with_item, poisen, heal)
	return function(itemstack, user, pointed_thing)

		-- Process player data
		local name = user:get_player_name()
		local player = diet.__player(name)
		local item = itemstack:get_name()

		-- Get type
		local ftype = ""
		if (minetest.registered_items[item] and minetest.registered_items[item].groups) then
			local groups = minetest.registered_items[item].groups
			if groups.food_type_meal then
				ftype = "meal"
			elseif groups.food_type_snack then
				ftype = "snack"
			elseif groups.food_type_dessert then
				ftype = "dessert"
			elseif groups.food_type_drink then
				ftype = "drink"
			end
		end

		-- Calculate points
		local points = max
		if (#player.eaten>0) then
			local same_food = 0
			local same_type = 0
			for _,v in pairs(player.eaten) do
				if v[1] == item then
					same_food = same_food + 1
				end
				if v[2] == ftype then
					same_type = same_type + 1
				end
			end
			local mult = same_food/10
			points = points * 1-mult
	 
			if (mult > 0.9) then
				local desc = item
				if (minetest.registered_items[item] and minetest.registered_items[item].description) then
					desc = minetest.registered_items[item].description
				end
				minetest.chat_send_player(name,"Your stomach hates "..desc)
			elseif (mult > 0.4) then
				minetest.chat_send_player(name,"Your stomach could do with a change.")
			end
			if points > max then
				error("[DIET] This shouldn't happen! points > max")
				return
			end
		end

		-- Increase health
		if minetest.get_modpath("hbhunger") and hbhunger then
			minetest.sound_play({name = "hbhunger_eat_generic", gain = 1}, {pos=user:getpos(), max_hear_distance = 16})

			-- saturation
			local h = tonumber(hbhunger.hunger[name])
			h = h + points
			if h > 30 then h = 30 end
			hbhunger.hunger[name] = h
			hbhunger.set_hunger_raw(user)

			-- healing
			local hp = user:get_hp()
			if hp < 20 and heal then
				hp = hp + heal
				if hp > 20 then hp = 20 end
				user:set_hp(hp)
			end

			 -- Poison
			if poisen then
				--set hud-img
				poisenp(1.0, poisen, 0, user)
			end
	 
		elseif minetest.get_modpath("hunger") and hunger then
			local h = tonumber(hunger.players[name].lvl)
			h = h + points
			hunger.update_hunger(user, h)
			
		elseif minetest.get_modpath("hud") and hud and hud.hunger then
			local h = tonumber(hud.hunger[name])
			h = h + points
			if h > 30 then h = 30 end
			hud.hunger[name] = h
			hud.save_hunger(user)

		else
			local hp = user:get_hp()		
			if (hp+points > 20) then
				hp = 20
			else
				hp = hp + points
			end		
			user:set_hp(hp)
		end

		-- Register
		diet.__register_eat(player,item,ftype)

		diet.save()

		-- Remove item
		itemstack:add_item(replace_with_item)
		itemstack:take_item()
		return itemstack
	end
end	

function diet.__player(name)
	if name == "" then
		return nil
	end
	if diet.players[name] then
		return diet.players[name]
	end
	
	diet.players[name] = {
		name = name,
		eaten = {}
	}
	diet.save()
	return diet.players[name]
end

function diet.__register_eat(player,food,type)
	table.insert(player.eaten,{food,type})
	
	while (#player.eaten > 10) do
		table.remove(player.eaten,1)
	end
end

local function overwrite(name, hunger_change, replace_with_item, poisen, heal)
	local tab = minetest.registered_items[name]
	if not tab then
		return
	end
	tab.on_use = diet.item_eat(hunger_change, replace_with_item, poisen, heal)
end

diet.__init()

overwrite("default:apple", 2)
if minetest.get_modpath("farming") ~= nil then
	overwrite("farming:bread", 4)
end

if minetest.get_modpath("mobs") ~= nil then
	if mobs.mod ~= nil and mobs.mod == "redo" then
		overwrite("mobs:cheese", 4)
		overwrite("mobs:meat", 8)
		overwrite("mobs:meat_raw", 4)
		overwrite("mobs:rat_cooked", 4)
		overwrite("mobs:honey", 2)
		overwrite("mobs:pork_raw", 3, "", 3)
		overwrite("mobs:pork_cooked", 8)
		overwrite("mobs:chicken_cooked", 6)
		overwrite("mobs:chicken_raw", 2, "", 3)
		overwrite("mobs:chicken_egg_fried", 2)
		if minetest.get_modpath("mesecraft_bucket") then 
			overwrite("mobs:bucket_milk", 3, "mesecraft_bucket:bucket_empty")
		end
	else
		overwrite("mobs:meat", 6)
		overwrite("mobs:meat_raw", 3)
		overwrite("mobs:rat_cooked", 5)
	end
end

if minetest.get_modpath("moretrees") ~= nil then
	overwrite("moretrees:coconut_milk", 1)
	overwrite("moretrees:raw_coconut", 2)
	overwrite("moretrees:acorn_muffin", 3)
	overwrite("moretrees:spruce_nuts", 1)
	overwrite("moretrees:pine_nuts", 1)
	overwrite("moretrees:fir_nuts", 1)
end

if minetest.get_modpath("dwarves") ~= nil then
	overwrite("dwarves:beer", 2)
	overwrite("dwarves:apple_cider", 1)
	overwrite("dwarves:midus", 2)
	overwrite("dwarves:tequila", 2)
	overwrite("dwarves:tequila_with_lime", 2)
	overwrite("dwarves:sake", 2)
end

if minetest.get_modpath("animalmaterials") ~= nil then
	overwrite("animalmaterials:milk", 2)
	overwrite("animalmaterials:meat_raw", 3)
	overwrite("animalmaterials:meat_pork", 3)
	overwrite("animalmaterials:meat_beef", 3)
	overwrite("animalmaterials:meat_chicken", 3)
	overwrite("animalmaterials:meat_lamb", 3)
	overwrite("animalmaterials:meat_venison", 3)
	overwrite("animalmaterials:meat_undead", 3, "", 3)
	overwrite("animalmaterials:meat_toxic", 3, "", 5)
	overwrite("animalmaterials:meat_ostrich", 3)
	overwrite("animalmaterials:fish_bluewhite", 2)
	overwrite("animalmaterials:fish_clownfish", 2)
end

if minetest.get_modpath("fishing") ~= nil then
	overwrite("fishing:fish_raw", 2)
	overwrite("fishing:fish_cooked", 5)
	overwrite("fishing:sushi", 6)
	overwrite("fishing:shark", 4)
	overwrite("fishing:shark_cooked", 8)
	overwrite("fishing:pike", 4)
	overwrite("fishing:pike_cooked", 8)
end

if minetest.get_modpath("glooptest") ~= nil then
	overwrite("glooptest:kalite_lump", 1)
end

if minetest.get_modpath("bushes") ~= nil then
	overwrite("bushes:sugar", 1)
	overwrite("bushes:strawberry", 2)
	overwrite("bushes:berry_pie_raw", 3)
	overwrite("bushes:berry_pie_cooked", 4)
	overwrite("bushes:basket_pies", 15)
end

if minetest.get_modpath("bushes_classic") then
	-- bushes_classic mod, as found in the plantlife modpack
	local berries = {
		"strawberry",
		"blackberry",
		"blueberry",
		"raspberry",
		"gooseberry",
		"mixed_berry"}
	for _, berry in ipairs(berries) do
		if berry ~= "mixed_berry" then
			overwrite("bushes:"..berry, 1)
		end
		overwrite("bushes:"..berry.."_pie_raw", 2)
		overwrite("bushes:"..berry.."_pie_cooked", 5)
		overwrite("bushes:"..berry.."_pie_slice", 1)
		overwrite("bushes:basket_"..berry, 15)
	end
end

if minetest.get_modpath("mushroom") ~= nil then
	overwrite("mushroom:brown", 1)
	overwrite("mushroom:red", 1, "", 3)
	-- mushroom potions: red = strong poison, brown = light restorative
	if minetest.get_modpath("vessels") then
		overwrite("mushroom:brown_essence", 1, "vessels:glass_bottle", nil, 4)
		overwrite("mushroom:poison", 1, "vessels:glass_bottle", 10)
	end
end

if minetest.get_modpath("docfarming") ~= nil then
	overwrite("docfarming:carrot", 3)
	overwrite("docfarming:cucumber", 2)
	overwrite("docfarming:corn", 3)
	overwrite("docfarming:potato", 4)
	overwrite("docfarming:bakedpotato", 5)
	overwrite("docfarming:raspberry", 3)
end

if minetest.get_modpath("farming_plus") ~= nil then
	overwrite("farming_plus:carrot_item", 3)
	overwrite("farming_plus:banana", 2)
	overwrite("farming_plus:orange_item", 2)
	overwrite("farming:pumpkin_bread", 4)
	overwrite("farming_plus:strawberry_item", 2)
	overwrite("farming_plus:tomato_item", 2)
	overwrite("farming_plus:potato_item", 4)
	overwrite("farming_plus:rhubarb_item", 2)
end

if minetest.get_modpath("mtfoods") ~= nil then
	overwrite("mtfoods:dandelion_milk", 1)
	overwrite("mtfoods:sugar", 1)
	overwrite("mtfoods:short_bread", 4)
	overwrite("mtfoods:cream", 1)
	overwrite("mtfoods:chocolate", 2)
	overwrite("mtfoods:cupcake", 2)
	overwrite("mtfoods:strawberry_shortcake", 2)
	overwrite("mtfoods:cake", 3)
	overwrite("mtfoods:chocolate_cake", 3)
	overwrite("mtfoods:carrot_cake", 3)
	overwrite("mtfoods:pie_crust", 3)
	overwrite("mtfoods:apple_pie", 3)
	overwrite("mtfoods:rhubarb_pie", 2)
	overwrite("mtfoods:banana_pie", 3)
	overwrite("mtfoods:pumpkin_pie", 3)
	overwrite("mtfoods:cookies", 2)
	overwrite("mtfoods:mlt_burger", 5)
	overwrite("mtfoods:potato_slices", 2)
	overwrite("mtfoods:potato_chips", 3)
	--mtfoods:medicine
	overwrite("mtfoods:casserole", 3)
	overwrite("mtfoods:glass_flute", 2)
	overwrite("mtfoods:orange_juice", 2)
	overwrite("mtfoods:apple_juice", 2)
	overwrite("mtfoods:apple_cider", 2)
	overwrite("mtfoods:cider_rack", 2)
end

if minetest.get_modpath("fruit") ~= nil then
	overwrite("fruit:apple", 2)
	overwrite("fruit:pear", 2)
	overwrite("fruit:bananna", 3)
	overwrite("fruit:orange", 2)
end

if minetest.get_modpath("mush45") ~= nil then
	overwrite("mush45:meal", 4)
end

if minetest.get_modpath("seaplants") ~= nil then
	overwrite("seaplants:kelpgreen", 1)
	overwrite("seaplants:kelpbrown", 1)
	overwrite("seaplants:seagrassgreen", 1)
	overwrite("seaplants:seagrassred", 1)
	overwrite("seaplants:seasaladmix", 6)
	overwrite("seaplants:kelpgreensalad", 1)
	overwrite("seaplants:kelpbrownsalad", 1)
	overwrite("seaplants:seagrassgreensalad", 1)
	overwrite("seaplants:seagrassgreensalad", 1)
end

if minetest.get_modpath("mobfcooking") ~= nil then
	overwrite("mobfcooking:cooked_pork", 6)
	overwrite("mobfcooking:cooked_ostrich", 6)
	overwrite("mobfcooking:cooked_beef", 6)
	overwrite("mobfcooking:cooked_chicken", 6)
	overwrite("mobfcooking:cooked_lamb", 6)
	overwrite("mobfcooking:cooked_venison", 6)
	overwrite("mobfcooking:cooked_fish", 6)
end

if minetest.get_modpath("creatures") ~= nil then
	overwrite("creatures:meat", 6)
	overwrite("creatures:flesh", 3)
	overwrite("creatures:rotten_flesh", 3, "", 3)
end

if minetest.get_modpath("ethereal") then
	overwrite("ethereal:strawberry", 1)
	overwrite("ethereal:banana", 4)
	overwrite("ethereal:pine_nuts", 1)
	overwrite("ethereal:bamboo_sprout", 0, "", 3)
	overwrite("ethereal:fern_tubers", 1)
	overwrite("ethereal:banana_bread", 7)
	overwrite("ethereal:mushroom_plant", 2)
	overwrite("ethereal:coconut_slice", 2)
	overwrite("ethereal:golden_apple", 4, "", nil, 10)
	overwrite("ethereal:wild_onion_plant", 2)
	overwrite("ethereal:mushroom_soup", 4, "ethereal:bowl")
	overwrite("ethereal:mushroom_soup_cooked", 6, "ethereal:bowl")
	overwrite("ethereal:hearty_stew", 6, "ethereal:bowl", 3)
	overwrite("ethereal:hearty_stew_cooked", 10, "ethereal:bowl")
	if minetest.get_modpath("mesecraft_bucket") then
		overwrite("ethereal:bucket_cactus", 2, "mesecraft_bucket:bucket_empty")
	end
	overwrite("ethereal:fish_raw", 2)
	overwrite("ethereal:fish_cooked", 5)
	overwrite("ethereal:seaweed", 1)
	overwrite("ethereal:yellowleaves", 1, "", nil, 1)
	overwrite("ethereal:sashimi", 4)
end

if minetest.get_modpath("farming") and farming.mod == "redo" then
   overwrite("farming:bread", 6)
   overwrite("farming:potato", 1)
   overwrite("farming:baked_potato", 6)
   overwrite("farming:cucumber", 4)
   overwrite("farming:tomato", 4)
   overwrite("farming:carrot", 3)
   overwrite("farming:carrot_gold", 6, "", nil, 8)
   overwrite("farming:corn", 3)
   overwrite("farming:corn_cob", 5)
   overwrite("farming:melon_slice", 2)
   overwrite("farming:pumpkin_slice", 1)
   overwrite("farming:pumpkin_bread", 9)
   overwrite("farming:coffee_cup", 2, "farming:drinking_cup")
   overwrite("farming:coffee_cup_hot", 3, "farming:drinking_cup", nil, 2)
   overwrite("farming:cookie", 2)
   overwrite("farming:chocolate_dark", 3)
   overwrite("farming:donut", 4)
   overwrite("farming:donut_chocolate", 6)
   overwrite("farming:donut_apple", 6)
   overwrite("farming:raspberries", 1)
   overwrite("farming:blueberries", 1)
   overwrite("farming:muffin_blueberry", 4)
   if minetest.get_modpath("vessels") then
      overwrite("farming:smoothie_raspberry", 2, "vessels:drinking_glass")
      overwrite("farming:pineapple_juice", 4, "vessels:drinking_glass")
   end
   overwrite("farming:rhubarb", 1)
   overwrite("farming:rhubarb_pie", 6)
   overwrite("farming:garlic", 1)
   overwrite("farming:chili_bowl", 8, "farming:bowl")
   overwrite("farming:grapes", 2)
   overwrite("farming:peas", 1)
   overwrite("farming:pea_soup", 4, "farming:bowl")
   overwrite("farming:pepper", 2)
   overwrite("farming:chili_pepper", 2)
   overwrite("farming:pineapple_ring", 1)
   overwrite("farming:onion", 1)
   overwrite("farming:bread_slice", 1)
   overwrite("farming:toast", 1)
   overwrite("farming:toast_sandwich", 4)
   overwrite("farming:porridge", 6)
end

if minetest.get_modpath("kpgmobs") ~= nil then
	overwrite("kpgmobs:uley", 3)
	overwrite("kpgmobs:meat", 6)
	overwrite("kpgmobs:rat_cooked", 5)
	overwrite("kpgmobs:med_cooked", 4)
	if minetest.get_modpath("mesecraft_bucket") then
	   overwrite("kpgmobs:bucket_milk", 4, "mesecraft_bucket:bucket_empty")
	end
end

if minetest.get_modpath("jkfarming") ~= nil then
	overwrite("jkfarming:carrot", 3)
	overwrite("jkfarming:corn", 3)
	overwrite("jkfarming:melon_part", 2)
	overwrite("jkfarming:cake", 3)
end

if minetest.get_modpath("jkanimals") ~= nil then
	overwrite("jkanimals:meat", 6)
end

if minetest.get_modpath("jkwine") ~= nil then
	overwrite("jkwine:grapes", 2)
	overwrite("jkwine:winebottle", 1)
end

if minetest.get_modpath("cooking") ~= nil then
	overwrite("cooking:meat_beef_cooked", 4)
	overwrite("cooking:fish_bluewhite_cooked", 3)
	overwrite("cooking:fish_clownfish_cooked", 1)
	overwrite("cooking:meat_chicken_cooked", 2)
	overwrite("cooking:meat_cooked", 2)
	overwrite("cooking:meat_pork_cooked", 3)
	overwrite("cooking:meat_toxic_cooked", -3)
	overwrite("cooking:meat_venison_cooked", 3)
	overwrite("cooking:meat_undead_cooked", 1)
end

-- ferns mod of plantlife_modpack
if minetest.get_modpath("ferns") ~= nil then
	overwrite("ferns:fiddlehead", 1, "", 1)
	overwrite("ferns:fiddlehead_roasted", 3)
	overwrite("ferns:ferntuber_roasted", 3)
	overwrite("ferns:horsetail_01", 1)
end

-- crops
if minetest.get_modpath("crops") ~= nil then
	overwrite("crops:potato", 1)
	overwrite("crops:roasted_pumpkin", 2)
	overwrite("crops:melon_slice", 1)
	overwrite("crops:green_bean", 1)
	overwrite("crops:tomato", 1)
	overwrite("crops:corn_on_the_cob", 1)
	overwrite("crops:vegetable_stew", 8, "crops:clay_bowl")
	overwrite("crops:uncooked_vegetable_stew", 2, "crops:clay_bowl")
end

-- nsspf
if minetest.get_modpath("nsspf") ~= nil then
	overwrite("nsspf:boletus_edulis", 2)
	overwrite("nsspf:cooked_boletus_edulis", 16)
	overwrite("nsspf:cantharellus_cibarius", 1)
	overwrite("nsspf:cooked_cantharellus_cibarius", 8)
	overwrite("nsspf:suillus_grevillei", 1)
	overwrite("nsspf:cooked_suillus_grevillei", 10)
	overwrite("nsspf:morchella_conica", 2)
	overwrite("nsspf:cooked_morchella_conica", 8)
	overwrite("nsspf:russula_xerampelina", -8)
	overwrite("nsspf:cooked_russula_xerampelina", 6)
	overwrite("nsspf:boletus_pinophilus", 2)
	overwrite("nsspf:cooked_boletus_pinophilus", 16)
	overwrite("nsspf:boletus_satanas", -20)
	overwrite("nsspf:cooked_boletus_satanas", -16)
	overwrite("nsspf:amanita_phalloides", -20)
	overwrite("nsspf:cooked_amanita_phalloides", -20)
	overwrite("nsspf:amanita_muscaria", -20)
	overwrite("nsspf:cooked_amanita_muscaria", -18)
	overwrite("nsspf:fistulina_hepatica", 4)
	overwrite("nsspf:cooked_fistulina_hepatica", 14)
	overwrite("nsspf:armillaria_mellea", 2)
	overwrite("nsspf:fomes_fomentarius", -1)
	overwrite("nsspf:cooked_armillaria_mellea", 12)
	overwrite("nsspf:mycena_chlorophos", -2)
	overwrite("nsspf:cooked_mycena_chlorophos", -4)
	overwrite("nsspf:mycena_chlorophos_light", -2)
	overwrite("nsspf:panellus_pusillus", -2)
	overwrite("nsspf:cooked_panellus_pusillus", -4)
	overwrite("nsspf:panellus_pusillus_light", -2)
	overwrite("nsspf:macrolepiota_procera", 3)
	overwrite("nsspf:cooked_macrolepiota_procera", 16)
	overwrite("nsspf:psilocybe_cubensis", -7)
	overwrite("nsspf:cooked_psilocybe_cubensis", 2)
	overwrite("nsspf:lycoperdon_pyriforme", 8)
	overwrite("nsspf:cooked_lycoperdon_pyriforme", 12)
	overwrite("nsspf:gyromitra_esculenta", -20)
	overwrite("nsspf:cooked_gyromitra_esculenta", -16)
	overwrite("nsspf:coprinus_atramentarius", -13)
	overwrite("nsspf:cooked_coprinus_atramentarius", 6)
	overwrite("nsspf:lentinus_strigosus", 1)
	overwrite("nsspf:cooked_lentinus_strigosus", 16)
	overwrite("nsspf:ganoderma_lucidum", 14)
	overwrite("nsspf:cooked_ganoderma_lucidum", 4)
	overwrite("nsspf:marasmius_haematocephalus", -1)
	overwrite("nsspf:cooked_marasmius_haematocephalus", -19)
	overwrite("nsspf:clitocybula_azurea", -6)
	overwrite("nsspf:cooked_clitocybula_azurea", 10)
	overwrite("nsspf:clitocybe_glacialis", 1)
	overwrite("nsspf:cooked_clitocybe_glacialis", 10)
	overwrite("nsspf:hygrophorus_goetzii", -4)
	overwrite("nsspf:cooked_hygrophorus_goetzii", 8)
	overwrite("nsspf:plectania_nannfeldtii", -20)
	overwrite("nsspf:cooked_plectania_nannfeldtii", -20)
end

