
local mg_name = minetest.get_mapgen_setting("mg_name")
if mg_name ~= "v6" and mg_name ~= "singlenode" then
	minetest.register_decoration({
		deco_type = "simple",
		place_on = { "default:dirt_with_grass" },
		sidelen = 16,
		noise_params = {
			offset = -0.02,
			scale = 0.02,
			spread = {x = 200, y = 200, z = 200},
			seed = 90459126,
			octaves = 3,
			persist = 0.6
		},
		biomes = {"grassland", "deciduous_forest", "coniferous_forest"},
		y_min = 1,
		y_max = 31000,
		decoration = "crops:melon_plant_4"
	})
	minetest.register_decoration({
		deco_type = "simple",
		place_on = { "default:dirt_with_grass" },
		sidelen = 16,
		noise_params = {
			offset = -0.02,
			scale = 0.02,
			spread = {x = 200, y = 200, z = 200},
			seed = 26294592,
			octaves = 3,
			persist = 0.6
		},
		biomes = {"deciduous_forest", "coniferous_forest", "tundra"},
		y_min = 1,
		y_max = 31000,
		decoration = "crops:pumpkin_plant_4"
	})
end

-- drop potatoes when digging in dirt
minetest.override_item("default:dirt_with_grass", {
	drop = {
		items = {
			{ items = {'default:dirt'}},
			{ items = {'crops:potato'}, rarity = 500 }
		}
	}
})
