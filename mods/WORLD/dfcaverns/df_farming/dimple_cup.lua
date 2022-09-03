local S = minetest.get_translator(minetest.get_current_modname())

local dimple_grow_time = df_farming.config.plant_growth_time * df_farming.config.dimple_cup_delay_multiplier / 4

local dimple_cup_groups = {snappy = 3, flammable = 2, plant = 1, not_in_creative_inventory = 1, attached_node = 1, light_sensitive_fungus = 11, flower = 1, fire_encouragement=60,fire_flammability=100, compostability=70, handy=1,shearsy=1,hoey=1}

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
		groups = dimple_cup_groups,
		sounds = df_dependencies.sound_leaves(),
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
					items = {'df_farming:dimple_cup_seed 2', 'df_farming:dimple_cup_harvested'},
					rarity = 7-number,
				},
				{
					items = {'df_farming:dimple_cup_seed 1', 'df_farming:dimple_cup_harvested'},
					rarity = 5-number,
				},
			},
		},
		_mcl_blast_resistance = 0.2,
		_mcl_hardness = 0.2,
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

local dimple_cup_groups_harvested = {}
for group, val in pairs(dimple_cup_groups) do
	dimple_cup_groups_harvested[group] = val
end
dimple_cup_groups_harvested.color_blue = 1
dimple_cup_groups_harvested.basecolor_blue = 1
dimple_cup_groups_harvested.excolor_blue = 1

local name = "df_farming:dimple_cup_harvested"
local def = {
	description = S("Dimple Cup"),
	_doc_items_longdesc = df_farming.doc.dimple_cup_desc,
	_doc_items_usagehelp = df_farming.doc.dimple_cup_usage,
	drawtype = "plantlike",
	tiles = {"dfcaverns_dimple_cup_4.png"},
	inventory_image = "dfcaverns_dimple_cup_4.png",
	paramtype = "light",
	walkable = false,
	floodable = true,
	is_ground_content = false,
	buildable_to = true,
	groups = dimple_cup_groups_harvested,
	sounds = df_dependencies.sound_leaves(),
    selection_box = {
        type = "fixed",
        fixed = {
            {-8/16, -8/16, -8/16, 8/16, -8/16 + 4*4/16, 8/16},
        },
    },
	_mcl_blast_resistance = 0.2,
	_mcl_hardness = 0.2,
}
minetest.register_node(name, def)

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
