local S = df_mapitems.S

minetest.register_node("df_mapitems:snareweed", {
	description = S("Snareweed"),
	_doc_items_longdesc = df_mapitems.doc.snareweed_desc,
	_doc_items_usagehelp = df_mapitems.doc.snareweed_usage,
	tiles = {df_mapitems.texture.dirt .. "^dfcaverns_snareweed_roots.png", df_mapitems.texture.dirt},
	drawtype="plantlike_rooted",
	paramtype2 = "leveled",
	special_tiles = {{name = "dfcaverns_snareweed.png", tileable_vertical = true}},
	is_ground_content = false,
	drop = df_mapitems.node_name.dirt,
	light_source = 6,
	groups = {crumbly = 3, soil = 1},
	sounds = df_mapitems.sounds.dirt,
})

if df_mapitems.config.snareweed_damage then
	local timer = 0
	
	minetest.register_globalstep(function(dtime)
		timer = timer + dtime
		if timer >= 1 then
			timer = timer - 1
			for _, player in pairs(minetest.get_connected_players()) do
				local player_pos = player:get_pos() -- node player's feet are in this location.
				local rounded_pos = vector.round(player_pos)
				local nearby_nodes = minetest.find_nodes_in_area(vector.add(rounded_pos, {x=0, y= -8, z=0}), rounded_pos, {"df_mapitems:snareweed"})
				for _, node_pos in ipairs(nearby_nodes) do
					local node = minetest.get_node(node_pos)
					local distance = player_pos.y - node_pos.y
					if distance <= node.param2/16 then
						minetest.log("action", player:get_player_name() .. " takes 2 damage from snareweed at " .. minetest.pos_to_string(node_pos))
						player:set_hp(player:get_hp() - 2)
						break
					end
				end
			end
		end
	end)	
end


local c_water = df_mapitems.node_id.water
local c_dirt = df_mapitems.node_id.dirt
local c_stone = df_mapitems.node_id.stone
local c_snareweed = minetest.get_content_id("df_mapitems:snareweed")

df_mapitems.place_snareweed = function(area, data, bi, param2_data)
	local max_height = 0
	local index = bi + area.ystride
	while area:containsi(index) and data[index] == c_water and max_height <= 8*16 do
		index = index + area.ystride
		max_height = max_height + 16
	end
	if max_height > 0 then
		data[bi] = c_snareweed
		param2_data[bi] = math.min(math.random(3*16, 8*16), max_height)
	else
		data[bi] = c_dirt
	end
end

df_mapitems.place_snareweed_patch = function(area, data, bi, param2_data, radius)
	local pos = area:position(bi)	
	for li in area:iterp(vector.add(pos, -radius), vector.add(pos, radius)) do
		local adjacent = li + area.ystride
		local node_type = data[li]
		if math.random() < 0.1  and (node_type == c_stone or node_type == c_dirt) and data[adjacent] == c_water then
			df_mapitems.place_snareweed(area, data, li, param2_data)
		end
	end
end