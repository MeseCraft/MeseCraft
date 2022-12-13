if otherworlds.settings.redsky_asteroids.enable then

	-- Approximate realm limits
	local YMIN = otherworlds.settings.redsky_asteroids.YMIN or 6000
	local YMAX = otherworlds.settings.redsky_asteroids.YMAX or 7000

	-- Register on_generated function for this layer

	minetest.register_on_generated(otherworlds.asteroids.create_on_generated(YMIN, YMAX, {
		c_air = minetest.get_content_id("vacuum:vacuum"),
		c_obsidian = minetest.get_content_id("default:obsidian"),
		c_stone = minetest.get_content_id("asteroid:redstone"),
		c_cobble = minetest.get_content_id("vacuum:vacuum"),
		c_gravel = minetest.get_content_id("asteroid:redgravel"),
		c_dust = minetest.get_content_id("asteroid:reddust"),
		c_ironore = minetest.get_content_id("asteroid:ironore"),
		c_copperore = minetest.get_content_id("asteroid:copperore"),
		c_goldore = minetest.get_content_id("asteroid:goldore"),
		c_diamondore = minetest.get_content_id("asteroid:diamondore"),
		c_meseore = minetest.get_content_id("asteroid:meseore"),
		c_waterice = minetest.get_content_id("default:ice"),
		c_snowblock = minetest.get_content_id("default:snowblock"),
	}))


	-- Deco code for grass and crystal

	local TOPDECO = 500 -- how often surface decoration appears on top of asteroid cobble

	local grass = {
		"mars:grass_1", "mars:grass_2", "mars:grass_3",
		"mars:grass_4", "mars:grass_5"
	}
	local flower = {
		"mars:moss", "mars:redweed", "mars:redgrass"
	}
	local crystal = {
		"crystals:ghost_crystal_1", "crystals:ghost_crystal_2", 
		"crystals:red_crystal_1", "crystals:red_crystal_2", 
		"crystals:rose_quartz_1", "crystals:rose_quartz_2", 
	}

	-- Add surface decoration
	minetest.register_on_generated(function(minp, maxp)

		if minp.y < YMIN or maxp.y > YMAX then
			return
		end

		local bpos, ran
		local coal = minetest.find_nodes_in_area_under_air(minp, maxp,
			{"asteroid:redgravel"})

		for n = 1, #coal do

			bpos = {x = coal[n].x, y = coal[n].y + 1, z = coal[n].z }

			ran = math.random(TOPDECO)

			if ran < 100 then -- grass

				minetest.swap_node(bpos, {name = grass[ math.random(1, #grass) ] })

			elseif ran >= 180 and ran <= 200 then -- other plants

				minetest.swap_node(bpos, {name = flower[ math.random(1, #flower) ] })

			elseif ran == TOPDECO then -- crystals

				minetest.swap_node(bpos, {name = crystal[ math.random(1, #crystal) ] })
			end
		end
	end)

end
