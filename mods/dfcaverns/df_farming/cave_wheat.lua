-- internationalization boilerplate
local MP = minetest.get_modpath(minetest.get_current_modname())
local S, NS = dofile(MP.."/intllib.lua")

local wheat_grow_time = df_farming.config.plant_growth_time * df_farming.config.cave_wheat_delay_multiplier / 8

local register_cave_wheat = function(number)
	local name = "df_farming:cave_wheat_"..tostring(number)
	local def = {
		description = S("Cave Wheat"),
		_doc_items_longdesc = df_farming.doc.cave_wheat_desc,
		_doc_items_usagehelp = df_farming.doc.cave_wheat_usage,
		drawtype = "plantlike",
		paramtype2 = "meshoptions",
		place_param2 = 3,
		tiles = {"dfcaverns_cave_wheat_"..tostring(number)..".png"},
		inventory_image = "dfcaverns_cave_wheat_"..tostring(number)..".png",
		paramtype = "light",
		walkable = false,
		is_ground_content = false,
		buildable_to = true,
		floodable = true,
		groups = {snappy = 3, flammable = 2, plant = 1, not_in_creative_inventory = 1, attached_node = 1, light_sensitive_fungus = 11},
		sounds = default.node_sound_leaves_defaults(),
        selection_box = {
            type = "fixed",
            fixed = {
                {-8/16, -8/16, -8/16, 8/16, -8/16 + 2*number/16, 8/16},
            },
        },

		on_timer = function(pos, elapsed)
			df_farming.grow_underground_plant(pos, name, elapsed)
		end,
		
		drop = {
			max_items = 1,
			items = {
				{
					items = {'df_farming:cave_wheat_seed 2', 'df_farming:cave_wheat'},
					rarity = 9-number,
				},
				{
					items = {'df_farming:cave_wheat_seed 1', 'df_farming:cave_wheat'},
					rarity = 9-number,
				},
				{
					items = {'df_farming:cave_wheat_seed'},
					rarity = 9-number,
				},
			},
		},
	}
	
	if number < 8 then
		def._dfcaverns_next_stage_time = wheat_grow_time
		def._dfcaverns_next_stage = "df_farming:cave_wheat_"..tostring(number+1)
	end

	minetest.register_node(name, def)
end

for i = 1,8 do
	register_cave_wheat(i)
end

local place_list = {
	minetest.get_content_id("df_farming:cave_wheat_1"),
	minetest.get_content_id("df_farming:cave_wheat_2"),
	minetest.get_content_id("df_farming:cave_wheat_3"),
	minetest.get_content_id("df_farming:cave_wheat_4"),
	minetest.get_content_id("df_farming:cave_wheat_5"),
	minetest.get_content_id("df_farming:cave_wheat_6"),
	minetest.get_content_id("df_farming:cave_wheat_7"),
	minetest.get_content_id("df_farming:cave_wheat_8"),
}
-- doesn't set the timer running, so plants placed by this method won't grow
df_farming.spawn_cave_wheat_vm = function(vi, area, data, param2_data)
	data[vi] = place_list[math.random(1,8)]
	param2_data[vi] = 3
end


df_farming.register_seed(
	"cave_wheat_seed",
	S("Cave Wheat Seed"),
	"dfcaverns_cave_wheat_seed.png",
	"df_farming:cave_wheat_1",
	wheat_grow_time,
	df_farming.doc.cave_wheat_desc,
	df_farming.doc.cave_wheat_usage)

minetest.register_craftitem("df_farming:cave_wheat", {
	description = S("Cave Wheat"),
	_doc_items_longdesc = df_farming.doc.cave_wheat_desc,
	_doc_items_usagehelp = df_farming.doc.cave_wheat_usage,
	inventory_image = "dfcaverns_cave_wheat.png",
	stack_max = 99,
})
minetest.register_craft({
	type = "fuel",
	recipe = "df_farming:cave_wheat",
	burntime = 2
})

-------------
--- Flour and bread

minetest.register_craftitem("df_farming:cave_flour", {
	description = S("Cave Wheat Flour"),
	_doc_items_longdesc = df_farming.doc.cave_flour_desc,
	_doc_items_usagehelp = df_farming.doc.cave_flour_usage,
	inventory_image = "dfcaverns_flour.png",
	groups = {flammable = 1, dfcaverns_cookable = 1, food_flour = 1},
})

minetest.register_craftitem("df_farming:cave_bread", {
	description = S("Dwarven Bread"),
	_doc_items_longdesc = df_farming.doc.cave_bread_desc,
	_doc_items_usagehelp = df_farming.doc.cave_bread_usage,
	inventory_image = "dfcaverns_prepared_food13x16.png",
	sound = {eat = {name = "df_farming_chomp_crunch", gain = 1.0}},
	on_use = minetest.item_eat(5),
	groups = {flammable = 2, food = 5},
})

local recipe_registered = false
if minetest.get_modpath("cottages") then
	cottages.handmill_product["df_farming:cave_wheat"] = "df_farming:cave_flour";
	recipe_registered = true
end

if minetest.registered_items["farming:mortar_pestle"] ~= nil then
	minetest.register_craft({
		type = "shapeless",
		output = "df_farming:cave_flour",
		recipe = {
			"df_farming:cave_wheat", "df_farming:cave_wheat", "df_farming:cave_wheat",
			"df_farming:cave_wheat", "farming:mortar_pestle"
		},
		replacements = {{"group:food_mortar_pestle", "farming:mortar_pestle"}},
	})
	recipe_registered = true
end

if not recipe_registered then
	minetest.register_craft({
		type = "shapeless",
		output = "df_farming:cave_flour",
		recipe = {"df_farming:cave_wheat", "df_farming:cave_wheat", "df_farming:cave_wheat", "df_farming:cave_wheat"}
	})
end

minetest.register_craft({
	type = "cooking",
	cooktime = 15,
	output = "df_farming:cave_bread",
	recipe = "df_farming:cave_flour"
})

--------
-- Straw

minetest.register_node("df_farming:cave_straw", {
	description = S("Cave Straw"),
	tiles = {"dfcaverns_cave_straw.png"},
	is_ground_content = false,
	groups = {snappy=3, flammable=4, fall_damage_add_percent=-30, straw=1},
	sounds = default.node_sound_leaves_defaults(),
})

minetest.register_craft({
	output = "df_farming:cave_straw 3",
	recipe = {
		{"df_farming:cave_wheat", "df_farming:cave_wheat", "df_farming:cave_wheat"},
		{"df_farming:cave_wheat", "df_farming:cave_wheat", "df_farming:cave_wheat"},
		{"df_farming:cave_wheat", "df_farming:cave_wheat", "df_farming:cave_wheat"},
	}
})

minetest.register_craft({
	output = "df_farming:cave_wheat 3",
	recipe = {
		{"df_farming:cave_straw"},
	}
})


---------
-- Trample support

if minetest.get_modpath("trail") and trail and trail.register_trample_node then	
	minetest.register_node("df_farming:wheat_trampled", {
		description = S("Flattened Cave Wheat"),
		tiles = {"dfcaverns_cave_wheat_flattened.png"},
		inventory_image = "dfcaverns_cave_wheat_flattened.png",
		drawtype = "nodebox",
		paramtype = "light",
		paramtype2 = "facedir",
		buildable_to = true,
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, -3 / 8, 0.5}
			},
		},
		groups = {snappy = 3, flammable = 2, attached_node = 1},
		drop = "",
		sounds = default.node_sound_leaves_defaults(),
	})
	
	trail.register_trample_node("df_farming:cave_wheat_5", {
		trampled_node_name = "df_farming:wheat_trampled",
		randomize_trampled_param2 = true,
	})
	trail.register_trample_node("df_farming:cave_wheat_6", {
		trampled_node_name = "df_farming:wheat_trampled",
		randomize_trampled_param2 = true,
	})
	trail.register_trample_node("df_farming:cave_wheat_7", {
		trampled_node_name = "df_farming:wheat_trampled",
		randomize_trampled_param2 = true,
	})
	trail.register_trample_node("df_farming:cave_wheat_8", {
		trampled_node_name = "df_farming:wheat_trampled",
		randomize_trampled_param2 = true,
	})
end