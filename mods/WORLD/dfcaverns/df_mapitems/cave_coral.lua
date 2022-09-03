local S = minetest.get_translator(minetest.get_current_modname())

local water_source = df_dependencies.node_name_water_source
local coral_skeleton = df_dependencies.node_name_coral_skeleton

minetest.register_node("df_mapitems:cave_coral_3", {
	description = S("Cave Coral"),
	_doc_items_longdesc = df_mapitems.doc.cave_coral_desc,
	_doc_items_usagehelp = df_mapitems.doc.cave_coral_usage,
	tiles = {"dfcaverns_cave_coral_end.png", "dfcaverns_cave_coral_end.png", "dfcaverns_cave_coral.png"},
	drop = coral_skeleton,
	light_source = 3,
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {cracky = 3, dfcaverns_cave_coral = 1, pickaxey = 1, building_block = 1, coral=1, coral_block=1},
	sounds = df_dependencies.sound_stone(),
	on_timer = function(pos)
		if minetest.find_node_near(pos, 1, {water_source}) == nil then
			minetest.set_node(pos, {name=coral_skeleton})
		end
	end,
	_mcl_hardness = 1.5,
	_mcl_blast_resistance = 6,
})

minetest.register_node("df_mapitems:cave_coral_2", {
	description = S("Cave Coral"),
	_doc_items_longdesc = df_mapitems.doc.cave_coral_desc,
	_doc_items_usagehelp = df_mapitems.doc.cave_coral_usage,
	tiles = {"dfcaverns_cave_coral_end.png", "dfcaverns_cave_coral_end.png", "dfcaverns_cave_coral.png"},
	drop = coral_skeleton,
	light_source = 2,
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {cracky = 3, dfcaverns_cave_coral = 1, pickaxey = 1, building_block = 1, coral=1, coral_block=1},
	sounds = df_dependencies.sound_stone(),
	on_timer = function(pos)
		if minetest.find_node_near(pos, 1, {water_source}) == nil then
			minetest.set_node(pos, {name=coral_skeleton})
		end
	end,
	_mcl_hardness = 1.5,
	_mcl_blast_resistance = 6,
})

minetest.register_node("df_mapitems:cave_coral_1", {
	description = S("Cave Coral"),
	_doc_items_longdesc = df_mapitems.doc.cave_coral_desc,
	_doc_items_usagehelp = df_mapitems.doc.cave_coral_usage,
	tiles = {"dfcaverns_cave_coral_end.png", "dfcaverns_cave_coral_end.png", "dfcaverns_cave_coral.png"},
	drop = coral_skeleton,
	light_source = 1,
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {cracky = 3, dfcaverns_cave_coral = 1, pickaxey = 1, building_block = 1, coral=1, coral_block=1},
	sounds = df_dependencies.sound_stone(),
	on_timer = function(pos)
		if minetest.find_node_near(pos, 1, {water_source}) == nil then
			minetest.set_node(pos, {name=coral_skeleton})
		end
	end,
	_mcl_hardness = 1.5,
	_mcl_blast_resistance = 6,
})

local coral_names = {"df_mapitems:cave_coral_1", "df_mapitems:cave_coral_2", "df_mapitems:cave_coral_3"}
local water_node = df_dependencies.node_name_water_source
minetest.register_abm{
	label = "df_mapitems:shifting_coral",
	nodenames = {"group:dfcaverns_cave_coral"},
	neighbors = {water_node},
	interval = 2,
	chance = 10,
	action = function(pos)
		local node = minetest.get_node(pos)
		minetest.swap_node(pos, {name=coral_names[math.random(1,3)], param2=node.param2})
	end,
}
