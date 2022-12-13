-- internationalization boilerplate
local MP = minetest.get_modpath(minetest.get_current_modname())
local S, NS = dofile(MP.."/intllib.lua")

minetest.register_alias("castle:orb_day", "orbs_of_time:orb_day")
minetest.register_alias("castle:orb_night", "orbs_of_time:orb_night")

minetest.register_tool("orbs_of_time:orb_day", {
	description = S("Orb of Midday"),
	_doc_items_longdesc = S("This magical orb grants you the power to bring the Sun to the zenith of the sky."),
	_doc_items_usagehelp = S("When weilded, use this item and the Sun will jump to its highest point. The day will then progress normally from there. This orb can be used eight times - once for each diamond that was used to craft it."),
	tiles = {"orbs_orb_day.png"},
	inventory_image = "orbs_orb_day.png",
	wield_image = "orbs_orb_day_weild.png",
	stack_max=1,
	groups = { tool=1 },
	on_use = function(itemstack, user)
		minetest.sound_play("orbs_ding", {pos=user:getpos(), loop=false})
		minetest.set_timeofday(0.5)
		minetest.sound_play("orbs_birds", {pos=user:getpos(), loop=false})
		if not minetest.settings:get_bool("creative_mode") then
			itemstack:add_wear(65535/8)
		end
		return itemstack
	end,
})

minetest.register_tool("orbs_of_time:orb_night",{
	description = S("Orb of Midnight"),
	_doc_items_longdesc = S("This magical orb grants you the power to banish the Sun to the bottom of the world."),
	_doc_items_usagehelp = S("When weilded, use this item and the Moon will jump to its highest point. The night will then progress normally from there. This orb can be used eight times - once for each diamond that was used to craft it."),
	tiles = {"orbs_orb_night.png"},
	inventory_image = "orbs_orb_night.png",
	wield_image = "orbs_orb_night_weild.png",
	stack_max=1,
	groups = { tool=1 },
	on_use = function(itemstack, user)
		minetest.sound_play("orbs_ding", {pos=user:getpos(), loop=false})
		minetest.set_timeofday(0)
		minetest.sound_play("orbs_owl", {pos=user:getpos(), loop=false})
		if not minetest.settings:get_bool("creative_mode") then
			itemstack:add_wear(65535/8)
		end
		return itemstack
	end,
})


minetest.register_tool("orbs_of_time:orb_dawn", {
	description = S("Orb of Dawn"),
	_doc_items_longdesc = S("This magical orb grants you the power to bring the Sun to eastern horizon."),
	_doc_items_usagehelp = S("When weilded, use this item and day will break. The day will then progress normally from there. This orb can be used eight times - once for each diamond that was used to craft it."),
	tiles = {"orbs_orb_day.png"},
	inventory_image = "orbs_orb_day.png^[lowpart:50:orbs_orb_night.png",
	wield_image = "orbs_orb_day_weild.png^[lowpart:75:orbs_orb_night_weild.png",
	stack_max=1,
	on_use = function(itemstack, user)
		minetest.sound_play("orbs_ding", {pos=user:getpos(), loop=false})
		minetest.set_timeofday(0.2)
		minetest.sound_play("orbs_birds", {pos=user:getpos(), loop=false})
		if not minetest.settings:get_bool("creative_mode") then
			itemstack:add_wear(65535/8)
		end
		return itemstack
	end,
})

minetest.register_tool("orbs_of_time:orb_dusk",{
	description = S("Orb of Dusk"),
	_doc_items_longdesc = S("This magical orb grants you the power to send the Sun to western horizon."),
	_doc_items_usagehelp = S("When weilded, use this item and night will fall. The night will then progress normally from there. This orb can be used eight times - once for each diamond that was used to craft it."),
	tiles = {"orbs_orb_night.png"},
	inventory_image = "orbs_orb_night.png^[lowpart:50:orbs_orb_day.png",
	wield_image = "orbs_orb_night_weild.png^[lowpart:75:orbs_orb_day_weild.png",
	stack_max=1,
	on_use = function(itemstack, user)
		minetest.sound_play("orbs_ding", {pos=user:getpos(), loop=false})
		minetest.set_timeofday(0.8)
		minetest.sound_play("orbs_owl", {pos=user:getpos(), loop=false})
		if not minetest.settings:get_bool("creative_mode") then
			itemstack:add_wear(65535/8)
		end
		return itemstack
	end,
})

-----------
--Crafting
-----------

if minetest.get_modpath("mcl_core") then
	minetest.register_craft({
		output = "orbs_of_time:orb_day",
		recipe = {
			{"mcl_core:diamond", "mcl_core:diamond","mcl_core:diamond"},
			{"mcl_core:diamond", "mesecons:redstone","mcl_core:diamond"},
			{"mcl_core:diamond", "mcl_core:diamond","mcl_core:diamond"}
		 },
	})

	minetest.register_craft({
		output = "orbs_of_time:orb_night",
		recipe = {
			{"mcl_core:diamond", "mcl_core:diamond","mcl_core:diamond"},
			{"mcl_core:diamond", "dye:black","mcl_core:diamond"},
			{"mcl_core:diamond", "mcl_core:diamond","mcl_core:diamond"}
		},
	})
else
	minetest.register_craft({
		output = "orbs_of_time:orb_day",
		recipe = {
			{"magic_materials:light_rune", "magic_materials:light_rune","magic_materials:light_rune"},
			{"magic_materials:light_rune", "magic_materials:earth_rune","magic_materials:light_rune"},
			{"magic_materials:light_rune", "magic_materials:light_rune","magic_materials:light_rune"}
		},
	})

	minetest.register_craft({
		output = "orbs_of_time:orb_night",
		recipe = {
			{"magic_materials:void_rune", "magic_materials:void_rune","magic_materials:void_rune"},
			{"magic_materials:void_rune", "magic_materials:earth_rune","magic_materials:void_rune"},
			{"magic_materials:void_rune", "magic_materials:void_rune","magic_materials:void_rune"}
		},
	})
end

minetest.register_craft({
	output = "orbs_of_time:orb_dawn 2",
	recipe = {
		{"orbs_of_time:orb_day"},
		{"orbs_of_time:orb_night"},
	},
})

minetest.register_craft({
	output = "orbs_of_time:orb_dusk 2",
	recipe = {
		{"orbs_of_time:orb_night"},
		{"orbs_of_time:orb_day"},
	},
})

-----------
--Loot mod support
-----------

if minetest.get_modpath("loot") then
	loot.register_loot({
		weights = { generic = 10, valuable= 10 },
		payload = {
			stack = ItemStack("orbs_of_time:orb_day"),
			min_size = 1,
			max_size = 1,
		},
	})

	loot.register_loot({
		weights = { generic = 10, valuable= 10 },
		payload = {
			stack = ItemStack("orbs_of_time:orb_night"),
			min_size = 1,
			max_size = 1,
		},
	})

	loot.register_loot({
		weights = { generic = 10, valuable= 10 },
		payload = {
			stack = ItemStack("orbs_of_time:orb_dawn"),
			min_size = 1,
			max_size = 1,
		},
	})

	loot.register_loot({
		weights = { generic = 10, valuable= 10 },
		payload = {
			stack = ItemStack("orbs_of_time:orb_dusk"),
			min_size = 1,
			max_size = 1,
		},
	})

end
