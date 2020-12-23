-- This file contains code that is used by multiple different cavern layers.

local c_air = df_caverns.node_id.air
local c_cobble = df_caverns.node_id.cobble
local c_cobble_fungus = df_caverns.node_id.cobble_fungus
local c_cobble_fungus_fine = df_caverns.node_id.cobble_fungus_fine
local c_dead_fungus = df_caverns.node_id.dead_fungus
local c_dirt = df_caverns.node_id.dirt
local c_dirt_moss = df_caverns.node_id.dirt_moss
local c_dry_flowstone = df_caverns.node_id.dry_flowstone
local c_fireflies = df_caverns.node_id.fireflies
local c_glowstone = df_caverns.node_id.glowstone
local c_ice = df_caverns.node_id.ice
local c_mossycobble = df_caverns.node_id.mossycobble
local c_oil = df_caverns.node_id.oil
local c_sand_scum = df_caverns.node_id.sand_scum
local c_spongestone = df_caverns.node_id.spongestone
local c_rock_rot = df_caverns.node_id.rock_rot
local c_water = df_caverns.node_id.water
local c_wet_flowstone = df_caverns.node_id.wet_flowstone

df_caverns.data_param2 = {}

--------------------------------------------------

df_caverns.stalagmites = function(abs_cracks, vert_rand, vi, area, data, data_param2, wet, reverse_sign)
	local flowstone
	local stalagmite_ids
	if wet then
		flowstone = c_wet_flowstone
		stalagmite_ids = df_mapitems.wet_stalagmite_ids
	else
		flowstone = c_dry_flowstone
		stalagmite_ids = df_mapitems.dry_stalagmite_ids	
	end
	
	local height_mult = 1
	local ystride = area.ystride
	if reverse_sign then
		ystride = - ystride
		height_mult = -1
	end		

	if vert_rand < 0.004 then
		if reverse_sign then
			subterrane.big_stalactite(vi+ystride, area, data, 6, 15, flowstone, flowstone, flowstone)
		else
			subterrane.big_stalagmite(vi+ystride, area, data, 6, 15, flowstone, flowstone, flowstone)
		end
	else
		local param2 = abs_cracks*1000000 - math.floor(abs_cracks*1000000/4)*4
		local height = math.floor(abs_cracks * 50)
		subterrane.stalagmite(vi+ystride, area, data, data_param2, param2, height*height_mult, stalagmite_ids)
	end
	data[vi] = flowstone
end

df_caverns.stalactites = function(abs_cracks, vert_rand, vi, area, data, data_param2, wet)
	df_caverns.stalagmites(abs_cracks, vert_rand, vi, area, data, data_param2, wet, true)
end

--------------------------------------------------


df_caverns.flooded_cavern_floor = function(abs_cracks, vert_rand, vi, area, data)
	local ystride = area.ystride
	if abs_cracks < 0.25 then
		data[vi] = c_mossycobble
	elseif data[vi-ystride] ~= c_water then
		data[vi] = c_sand_scum
	end
	
	-- put in only the large stalagmites that won't get in the way of the water
	if abs_cracks < 0.1 then
		if vert_rand < 0.004 then
			subterrane.big_stalagmite(vi+ystride, area, data, 6, 15, c_wet_flowstone, c_wet_flowstone, c_wet_flowstone)
		end
	end
end

df_caverns.dry_cavern_floor = function(abs_cracks, vert_rand, vi, area, data, data_param2)
	if abs_cracks < 0.075 then
		df_caverns.stalagmites(abs_cracks, vert_rand, vi, area, data, data_param2, false)
	elseif abs_cracks < 0.4 then
		data[vi] = c_cobble
	elseif abs_cracks < 0.6 then
		data[vi] = c_cobble_fungus_fine
	else
		data[vi] = c_cobble_fungus
		if c_dead_fungus and math.random() < 0.05 then
			data[vi+area.ystride] = c_dead_fungus
		end
	end
end

df_caverns.wet_cavern_floor = function(abs_cracks, vert_rand, vi, area, data, data_param2)
	if abs_cracks < 0.1 then
		df_caverns.stalagmites(abs_cracks, vert_rand, vi, area, data, data_param2, true)
	elseif abs_cracks < 0.6 then
		data[vi] = c_cobble
	elseif abs_cracks < 0.8 then
		data[vi] = c_rock_rot
	else
		data[vi] = c_spongestone
		if c_dead_fungus and math.random() < 0.05 then
			data[vi+area.ystride] = c_dead_fungus
		end
	end
end

--------------------------------------

df_caverns.glow_worm_cavern_ceiling = function(abs_cracks, vert_rand, vi, area, data, data_param2)
	if abs_cracks < 0.1 then
		df_caverns.stalactites(abs_cracks, vert_rand, vi, area, data, data_param2, true)
	elseif abs_cracks < 0.5 and abs_cracks > 0.3 and math.random() < 0.3 then
		df_mapitems.glow_worm_ceiling(area, data, vi-area.ystride)
	end
end

local content_in_list=function(content, list)
	for i, v in ipairs(list) do
		if content == v then return true end
	end
	return false
end

df_caverns.tunnel_floor = function(minp, maxp, area, vi, nvals_cracks, data, data_param2, wet, dirt_node)
	if maxp.y > -30 then
		wet = false
	end
	local ystride = area.ystride
	local index2d = mapgen_helper.index2di(minp, maxp, area, vi)
	local cracks = nvals_cracks[index2d]
	local abs_cracks = math.abs(cracks)

	if wet then
		if abs_cracks < 0.05 and data[vi+ystride] == c_air and not content_in_list(data[vi], df_mapitems.wet_stalagmite_ids) then -- make sure data[vi] is not already flowstone. Stalagmites from lower levels are acting as base for further stalagmites
			local param2 = abs_cracks*1000000 - math.floor(abs_cracks*1000000/4)*4
			local height = math.floor(abs_cracks * 100)
			subterrane.stalagmite(vi+ystride, area, data, data_param2, param2, height, df_mapitems.wet_stalagmite_ids)
			data[vi] = c_wet_flowstone
		elseif dirt_node and abs_cracks > 0.5 and data[vi-ystride] ~= c_air then
			data[vi] = dirt_node		
		end
	else
		if abs_cracks < 0.025 and data[vi+ystride] == c_air and not content_in_list(data[vi], df_mapitems.dry_stalagmite_ids) then -- make sure data[vi] is not already flowstone. Stalagmites from lower levels are acting as base for further stalagmites
			local param2 = abs_cracks*1000000 - math.floor(abs_cracks*1000000/4)*4
			local height = math.floor(abs_cracks * 100)
			subterrane.stalagmite(vi+ystride, area, data, data_param2, param2, height, df_mapitems.dry_stalagmite_ids)
		elseif dirt_node and cracks > 0.5 and data[vi-ystride] ~= c_air then
			data[vi] = dirt_node
		end
	end
end

df_caverns.tunnel_ceiling = function(minp, maxp, area, vi, nvals_cracks, data, data_param2, wet)
	if maxp.y > -30 then
		wet = false
	end

	local ystride = area.ystride
	local index2d = mapgen_helper.index2di(minp, maxp, area, vi)
	local cracks = nvals_cracks[index2d]
	local abs_cracks = math.abs(cracks)
	 
	if wet then
		if abs_cracks < 0.05 and data[vi-ystride] == c_air and not content_in_list(data[vi], df_mapitems.wet_stalagmite_ids) then -- make sure data[vi] is not already flowstone. Stalagmites from lower levels are acting as base for further stalagmites
			local param2 = abs_cracks*1000000 - math.floor(abs_cracks*1000000/4)*4
			local height = math.floor(abs_cracks * 100)
			subterrane.stalactite(vi-ystride, area, data, data_param2, param2, height, df_mapitems.wet_stalagmite_ids)
			data[vi] = c_wet_flowstone
		end
	else
		if abs_cracks < 0.025 and data[vi-ystride] == c_air and not content_in_list(data[vi], df_mapitems.dry_stalagmite_ids) then -- make sure data[vi] is not already flowstone. Stalagmites from lower levels are acting as base for further stalagmites
			local param2 = abs_cracks*1000000 - math.floor(abs_cracks*1000000/4)*4
			local height = math.floor(abs_cracks * 100)
			subterrane.stalactite(vi-ystride, area, data, data_param2, param2, height, df_mapitems.dry_stalagmite_ids)
		end
	end
end

df_caverns.perlin_cave = {
	offset = 0,
	scale = 1,
	spread = {x=df_caverns.config.horizontal_cavern_scale, y=df_caverns.config.vertical_cavern_scale, z=df_caverns.config.horizontal_cavern_scale},
	seed = -400000000089,
	octaves = 3,
	persist = 0.67
}

df_caverns.perlin_wave = {
	offset = 0,
	scale = 1,
	spread = {x=df_caverns.config.horizontal_cavern_scale * 2, y=df_caverns.config.vertical_cavern_scale, z=df_caverns.config.horizontal_cavern_scale * 2}, -- squashed 2:1
	seed = 59033,
	octaves = 6,
	persist = 0.63
}

-- Used for making lines of dripstone, and in various other places where small-scale patterns are needed
df_caverns.np_cracks = {
	offset = 0,
	scale = 1,
	spread = {x = 20, y = 20, z = 20},
	seed = 5717,
	octaves = 3,
	persist = 0.63,
	lacunarity = 2.0,
}

---------------------------------------------------------------------------------

df_caverns.place_shrub = function(vi, area, data, param2_data, shrub_list)
	if shrub_list == nil then
		return
	end
	
	local shrub = shrub_list[math.random(#shrub_list)]
	shrub(vi, area, data, param2_data)
end

---------------------------------------------------------------------------------
-- This method allows subterrane to overgenerate caves without destroying any of the decorations
local dfcaverns_nodes = nil
local dfcaverns_mods = {
	"df_farming:",
	"df_mapitems:",
	"df_primordial_items:",
	"df_trees:",
	"df_underworld_items:",
	"ice_sprites:",
	"mine_gas:",
}

df_caverns.is_ground_content = function(c_node)
	if dfcaverns_nodes then
		return not dfcaverns_nodes[c_node]
	end
	dfcaverns_nodes = {}
	for k, v in pairs(minetest.registered_nodes) do
		for _, prefix in ipairs(dfcaverns_mods) do
			if k:sub(1, #prefix) == prefix then
				dfcaverns_nodes[minetest.get_content_id(k)] = true
			end
		end
	end
	dfcaverns_nodes[c_ice] = true -- needed for nethercap cavern water covering
	dfcaverns_nodes[c_oil] = true -- needed for blackcap oil slicks
	if c_fireflies then
		dfcaverns_nodes[c_fireflies] = true -- used in the primordial caverns
	end
	dfcaverns_nodes[c_glowstone] = nil
	dfcaverns_mods = nil
	return not dfcaverns_nodes[c_node]
end