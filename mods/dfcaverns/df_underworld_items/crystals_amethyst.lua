local S = df_underworld_items.S

minetest.register_node("df_underworld_items:glow_amethyst", {
	description = S("Glowing Amethyst Block"),
	_doc_items_longdesc = df_underworld_items.doc.glow_amethyst_desc,
	_doc_items_usagehelp = df_underworld_items.doc.glow_amethyst_usage,
	tiles = {"dfcaverns_glow_amethyst.png"},
	is_ground_content = false,
	groups = {cracky=3, pit_plasma_resistant=1},
	sounds = default.node_sound_glass_defaults(),
	light_source = 6,
	paramtype = "light",
	use_texture_alpha = true,
	drawtype = "glasslike",
	sunlight_propagates = true,
})

if minetest.get_modpath("radiant_damage") and radiant_damage.override_radiant_damage and radiant_damage.config.enable_mese_damage then
	radiant_damage.override_radiant_damage("mese", {emitted_by={["df_underworld_items:glow_amethyst"] = radiant_damage.config.mese_damage*0.25}})
end

local c_amethyst = minetest.get_content_id("df_underworld_items:glow_amethyst")

local safe_write = function(data, area, vi, c_node)
	if area:containsi(vi) then data[vi] = c_node end
end

-- x_slant and z_slant can be 1, 0 or -1
-- rotated is true or false
-- length is 1 or more
df_underworld_items.underworld_shard = function(data, area, vi, x_slant, z_slant, rotated, length)
	if x_slant == nil then x_slant = math.random(-1,1) end
	if z_slant == nil then z_slant = math.random(-1,1) end
	if rotated == nil then rotated = math.random() > 0.5 end
	if length == nil then length = math.random(4, 12) end
	
	length = math.ceil(length/2) * 2 -- make it an even multiple of 2

	local xstride, ystride, zstride
	ystride = area.ystride
	if rotated then
		xstride = area.zstride
		zstride = 1
	else
		xstride = 1
		zstride = area.zstride
	end
	
	-- bottom end
	safe_write(data, area, vi, c_amethyst)
	safe_write(data, area, vi+xstride, c_amethyst)
	
	for i = 1, length do
		vi = vi + ystride
		
		safe_write(data, area, vi-xstride, c_amethyst)
		
		safe_write(data, area, vi+zstride, c_amethyst)
		safe_write(data, area, vi, c_amethyst)
		safe_write(data, area, vi-zstride, c_amethyst)

		safe_write(data, area, vi+zstride+xstride, c_amethyst)
		safe_write(data, area, vi+xstride, c_amethyst)
		safe_write(data, area, vi-zstride+xstride, c_amethyst)

		safe_write(data, area, vi+2*xstride, c_amethyst)

		if i % 2 == 0 and i ~= length then
			vi = vi + xstride * x_slant + zstride * z_slant
		end
	end

	vi = vi + ystride
	
	safe_write(data, area, vi, c_amethyst)
	safe_write(data, area, vi+xstride, c_amethyst)
end