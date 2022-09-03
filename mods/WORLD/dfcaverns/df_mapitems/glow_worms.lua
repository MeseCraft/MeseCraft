local S = minetest.get_translator(minetest.get_current_modname())

local growth_multiplier = 1
if minetest.get_modpath("df_farming") then
	growth_multiplier = df_farming.config.plant_growth_time
end

minetest.register_node("df_mapitems:glow_worm", {
	description = S("Glow Worms"),
	_doc_items_longdesc = df_mapitems.doc.glow_worms_desc,
	_doc_items_usagehelp = df_mapitems.doc.glow_worms_usage,
	tiles = {
		{
			name = "dfcaverns_glow_worm_animated.png",
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 4.0,
			},
		},
	},
	inventory_image = "dfcaverns_glow_worm.png",
	wield_image = "dfcaverns_glow_worm.png",
	is_ground_content = false,
	groups = {oddly_breakable_by_hand=3, light_sensitive_fungus = 12, shearsy=1, swordy=1, destroy_by_lava_flow=1},
	_dfcaverns_dead_node = "air",
	light_source = 9,
	paramtype = "light",
	drawtype = "plantlike",
	walkable = false,
	buildable_to = true,
	floodable = true,
	visual_scale = 1.0,
	_mcl_blast_resistance = 0.2,
	_mcl_hardness = 0.2,
	after_place_node = function(pos, placer) 
		if df_mapitems.config.glow_worm_delay_multiplier > 0 then
			minetest.get_node_timer(pos):start(math.random(
				df_mapitems.config.glow_worm_delay_multiplier * growth_multiplier * 0.75,
				df_mapitems.config.glow_worm_delay_multiplier * growth_multiplier * 1.25))
		end
	end,
	on_timer = function(pos, elapsed)
		local below = {x=pos.x, y=pos.y-1, z=pos.z}
		if minetest.get_node(below).name == "air" then
			minetest.set_node(below, {name="df_mapitems:glow_worm"})
			if math.random() > 0.5 then
				minetest.get_node_timer(below):start(math.random(
				df_mapitems.config.glow_worm_delay_multiplier * growth_multiplier * 0.75,
				df_mapitems.config.glow_worm_delay_multiplier * growth_multiplier * 1.25))			
			end
		end
	end,
})

local c_air = minetest.get_content_id("air")
local c_worm = minetest.get_content_id("df_mapitems:glow_worm")

df_mapitems.glow_worm_ceiling = function(area, data, vi)
	local ystride = area.ystride
	local bi = vi - ystride
	if data[vi] == c_air and data[bi] == c_air then
		data[vi] = c_worm
		data[bi] = c_worm
		if math.random(2) == 1 then
			bi = bi - ystride
			if data[bi] == c_air then
				data[bi] = c_worm
				if math.random(2) == 1 then
					bi = bi - ystride
					if data[bi] == c_air then
						data[bi] = c_worm
					end
				end
			end
		end
	end
end


