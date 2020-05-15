-- internationalization boilerplate
local MP = minetest.get_modpath(minetest.get_current_modname())
local S, NS = dofile(MP.."/intllib.lua")

local dimple_grow_time = df_farming.config.plant_growth_time * df_farming.config.dimple_cup_delay_multiplier / 4

local register_dimple_cup = function(number)
	local name = "df_farming:dimple_cup_"..tostring(number)
	local def = {
		description = S("Dimple Cup"),
		_doc_items_longdesc = df_farming.doc.dimple_cup_desc,
		_doc_items_usagehelp = df_farming.doc.dimple_cup_usage,
		drawtype = "plantlike",
		tiles = {"dfcaverns_dimple_cup_"..tostring(number)..".png"},
		inventory_image = "dfcaverns_dimple_cup_"..tostring(number)..".png",
		paramtype = "light",
		walkable = false,
		floodable = true,
		is_ground_content = false,
		buildable_to = true,
		groups = {snappy = 3, flammable = 2, plant = 1, not_in_creative_inventory = 1, attached_node = 1, color_blue = 1, light_sensitive_fungus = 11, flower = 1},
		sounds = default.node_sound_leaves_defaults(),
        selection_box = {
            type = "fixed",
            fixed = {
                {-8/16, -8/16, -8/16, 8/16, -8/16 + 4*number/16, 8/16},
            },
        },
		
		on_timer = function(pos, elapsed)
			df_farming.grow_underground_plant(pos, name, elapsed)
		end,
		
		drop = {
			max_items = 1,
			items = {
				{
					items = {'df_farming:dimple_cup_seed 2', 'df_farming:dimple_cup_4'},
					rarity = 7-number,
				},
				{
					items = {'df_farming:dimple_cup_seed 1', 'df_farming:dimple_cup_4'},
					rarity = 5-number,
				},
			},
		},
	}
	
	if number < 4 then
		def._dfcaverns_next_stage_time = dimple_grow_time
		def._dfcaverns_next_stage = "df_farming:dimple_cup_"..tostring(number+1)
	end
	
	minetest.register_node(name, def)
end

for i = 1,4 do
	register_dimple_cup(i)
end

local place_list = {
	minetest.get_content_id("df_farming:dimple_cup_1"),
	minetest.get_content_id("df_farming:dimple_cup_2"),
	minetest.get_content_id("df_farming:dimple_cup_3"),
	minetest.get_content_id("df_farming:dimple_cup_4"),
}
-- doesn't set the timer running, so plants placed by this method won't grow
df_farming.spawn_dimple_cup_vm = function(vi, area, data, param2_data)
	data[vi] = place_list[math.random(1,4)]
	param2_data[vi] = 0
end

df_farming.register_seed(
	"dimple_cup_seed",
	S("Dimple Cup Spores"),
	"dfcaverns_dimple_cup_seed.png",
	"df_farming:dimple_cup_1",
	dimple_grow_time,
	df_farming.doc.dimple_cup_desc,
	df_farming.doc.dimple_cup_usage)
