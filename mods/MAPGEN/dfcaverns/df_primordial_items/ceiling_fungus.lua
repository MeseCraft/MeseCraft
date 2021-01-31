local S = df_primordial_items.S

---------------------------------------------------------------------------------------
-- Glownode and stalk

minetest.register_node("df_primordial_items:glownode", {
	description = S("Primordial Fungal Lantern"),
	_doc_items_longdesc = df_primordial_items.doc.glownode_desc,
	_doc_items_usagehelp = df_primordial_items.doc.glownode_usage,
	drawtype = "glasslike",
	tiles = {"dfcaverns_mush_glownode.png"},
	paramtype = "light",
	sunlight_propagates = true,
	is_ground_content = false,
	groups = {cracky = 3, oddly_breakable_by_hand = 3},
	sounds = df_primordial_items.sounds.glass,
	light_source = minetest.LIGHT_MAX,
})

minetest.register_node("df_primordial_items:glownode_stalk", {
	description = S("Primordial Fungal Lantern Stalk"),
	_doc_items_longdesc = df_primordial_items.doc.glownode_stalk_desc,
	_doc_items_usagehelp = df_primordial_items.doc.glownode_stalk_usage,
	tiles = {"dfcaverns_mush_stalk_top.png", "dfcaverns_mush_stalk_top.png", "dfcaverns_mush_stalk_side.png"},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
	sounds = df_primordial_items.sounds.wood,
	on_place = minetest.rotate_node
})

minetest.register_node("df_primordial_items:glow_orb_hanging", {
	description = S("Primordial Fungal Orb"),
	_doc_items_longdesc = df_primordial_items.doc.glow_orb_desc,
	_doc_items_usagehelp = df_primordial_items.doc.glow_orb_usage,
	tiles = {"dfcaverns_mush_orb_vert.png"},
	inventory_image = "dfcaverns_mush_orb_vert.png",
	wield_image = "dfcaverns_mush_orb_vert.png",
	groups = {snappy = 3, flora = 1, flammable = 1},
	paramtype = "light",
	paramtype2 = "degrotate",
	drawtype = "plantlike",
	buildable_to = true,
	is_ground_content = false,
	walkable = false,
	light_source = 6,
	sounds = df_primordial_items.sounds.leaves,
	use_texture_alpha = true,
	sunlight_propagates = true,
})

local c_stalk = minetest.get_content_id("df_primordial_items:glownode_stalk")
local c_node = minetest.get_content_id("df_primordial_items:glownode")
local c_air = minetest.get_content_id("air")

df_primordial_items.spawn_ceiling_spire_vm = function(vi, area, data)
	local spire_height = math.random(1,10)

	local ystride = area.ystride
	local zstride = area.zstride
	
	for i = 0, spire_height do
		if data[vi-i*ystride] == c_air then
			data[vi-i*ystride] = c_stalk
		end
	end
	local bottom = vi - (spire_height +1) * ystride
	if data[bottom] == c_air then
		data[bottom] = c_node
	end
	
	if spire_height > 4 then -- thicken it all up
		for i = 0, math.floor(spire_height/2) do
			local current_vi = vi-i*ystride
			if data[current_vi+1] == c_air then
				data[current_vi+1] = c_stalk
			end
			if data[current_vi-1] == c_air then
				data[current_vi-1] = c_stalk
			end
			if data[current_vi+zstride] == c_air then
				data[current_vi+zstride] = c_stalk
			end
			if data[current_vi-zstride] == c_air then
				data[current_vi-zstride] = c_stalk
			end
		end
		
		if spire_height > 7 then
			bottom = bottom-ystride
			if data[bottom] == c_air then
				data[bottom] = c_node
			end
			if data[bottom-ystride] == c_air then
				data[bottom-ystride] = c_node
			end
			if data[bottom+1] == c_air then
				data[bottom+1] = c_node
			end
			if data[bottom-1] == c_air then
				data[bottom-1] = c_node
			end
			if data[bottom+zstride] == c_air then
				data[bottom+zstride] = c_node
			end
			if data[bottom-zstride] == c_air then
				data[bottom-zstride] = c_node
			end
		end
	end	
end