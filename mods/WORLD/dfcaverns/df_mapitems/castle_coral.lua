local S = minetest.get_translator(minetest.get_current_modname())

minetest.register_node("df_mapitems:castle_coral", {
	description = S("Castle Coral"),
	tiles = {
		"dfcaverns_castle_coral_gradient.png",
		"dfcaverns_castle_coral.png",
		"dfcaverns_castle_coral.png",
		"dfcaverns_castle_coral.png^[multiply:#888888",
	},
	_doc_items_longdesc = df_mapitems.doc.castle_coral_desc,
	_doc_items_usagehelp = df_mapitems.doc.castle_coral_usage,
	drawtype = "mesh",
	is_ground_content = false,
	light_source = 2,
	mesh = "octagonal_coral.obj",
	drop = "df_mapitems:castle_coral_skeleton",
	paramtype = "light",
	groups = {cracky=2, pickaxey = 1, building_block = 1, coral=1, coral_block=1},
	sounds = df_dependencies.sound_stone(),
	_mcl_hardness = 1.5,
	_mcl_blast_resistance = 6,
})

minetest.register_node("df_mapitems:castle_coral_skeleton", {
	description = S("Castle Coral Skeleton"),
	_doc_items_longdesc = df_mapitems.doc.castle_coral_desc,
	_doc_items_usagehelp = df_mapitems.doc.castle_coral_usage,
	tiles = {
		df_dependencies.texture_coral_skeleton
	},
	drawtype = "mesh",
	mesh = "octagonal_coral.obj",
	paramtype = "light",
	is_ground_content = false,
	groups = {cracky = 3,pickaxey = 1, building_block = 1, coral=2, coral_block=1},
	sounds = df_dependencies.sound_stone(),
	_mcl_hardness = 1.5,
	_mcl_blast_resistance = 6,
})

local c_coral = minetest.get_content_id("df_mapitems:castle_coral")
local c_coral_skeleton = minetest.get_content_id("df_mapitems:castle_coral_skeleton")
 
local c_stone = minetest.get_content_id(df_dependencies.node_name_stone)
local c_water = minetest.get_content_id(df_dependencies.node_name_water_source)

df_mapitems.spawn_castle_coral = function(area, data, vi, iterations)
	local run = math.random(2,4)
	local index = vi
	local zstride = area.zstride
	local ystride = area.ystride
	while run > 0 do
		-- TODO should this be checking for not-water instead of stone?
		if math.random() > 0.95 or data[index] == c_stone or not area:containsi(index) then return end
		data[index] = c_coral
		if iterations > 2 then
			data[index + 1] = c_coral
			data[index - 1] = c_coral
			data[index + zstride] = c_coral
			data[index - zstride] = c_coral
		end
		if iterations > 3 then
			data[index + 2] = c_coral
			data[index - 2] = c_coral
			data[index + zstride * 2] = c_coral
			data[index - zstride * 2] = c_coral
			data[index + 1 + zstride] = c_coral
			data[index - 1 + zstride] = c_coral
			data[index + 1 - zstride] = c_coral
			data[index - 1 - zstride] = c_coral
		end
		index = index + ystride
		run = run - 1
	end

	local newiterations = iterations - 1
	if newiterations == 0 then return end
	
	if math.random() > 0.5 then
		df_mapitems.spawn_castle_coral(area, data, index + 1 - ystride, newiterations)
		df_mapitems.spawn_castle_coral(area, data, index - 1 - ystride, newiterations)
	else
		df_mapitems.spawn_castle_coral(area, data, index + zstride - ystride, newiterations)
		df_mapitems.spawn_castle_coral(area, data, index - zstride - ystride, newiterations)
	end
end

df_mapitems.spawn_coral_pile = function(area, data, vi, radius)
	local pos = area:position(vi)
	for li in area:iterp(vector.add(pos, -radius), vector.add(pos, radius)) do
		local adjacent = li + area.ystride
		local node_type = data[li]
		if math.random() < 0.2  and not mapgen_helper.buildable_to(node_type) and data[adjacent] == c_water then
			data[adjacent] = c_coral_skeleton
		end
	end
end