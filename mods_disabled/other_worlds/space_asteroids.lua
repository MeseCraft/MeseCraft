if otherworlds.settings.space_asteroids.enable then

	-- Approximate realm limits
	local YMIN = otherworlds.settings.space_asteroids.YMIN or 5000
	local YMAX = otherworlds.settings.space_asteroids.YMAX or 6000

	-- Register on_generated function for this layer

	minetest.register_on_generated(otherworlds.asteroids.create_on_generated(YMIN, YMAX, {
		c_air = minetest.get_content_id("vacuum:vacuum"),
		c_obsidian = minetest.get_content_id("default:obsidian"),
		c_stone = minetest.get_content_id("asteroid:stone"),
		c_cobble = minetest.get_content_id("asteroid:cobble"),
		c_gravel = minetest.get_content_id("asteroid:gravel"),
		c_dust = minetest.get_content_id("asteroid:dust"),
		c_ironore = minetest.get_content_id("default:stone_with_iron"),
		c_copperore = minetest.get_content_id("default:stone_with_copper"),
		c_goldore = minetest.get_content_id("default:stone_with_gold"),
		c_diamondore = minetest.get_content_id("default:stone_with_diamond"),
		c_meseore = minetest.get_content_id("default:stone_with_mese"),
		c_waterice = minetest.get_content_id("default:ice"),
		c_snowblock = minetest.get_content_id("default:snowblock"),
	}))
	
end
