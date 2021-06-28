local name = "regional_weather:snow_heavy"

local conditions = {
	min_height = regional_weather.settings.min_height,
	max_height = regional_weather.settings.max_height,
	max_heat				= 30,
	min_humidity		= 65,
	indoors					= false,
	not_biome				= {
		"cold_desert",
		"cold_desert_ocean",
		"desert",
		"desert_ocean",
		"sandstone_desert",
		"sandstone_desert_ocean"
	}
}

local effects = {}

effects["climate_api:skybox"] = {
	cloud_data = {
		color = "#5e676eb5"
	},
	priority = 11
}

effects["climate_api:hud_overlay"] = {
	file = "weather_hud_frost.png",
	z_index = -100,
	color_correction = true
}

effects["climate_api:particles"] = {
	boxsize = { x = 14, y = 3, z = 14 },
	v_offset = 3,
	expirationtime = 7.5,
	size = 15,
	amount = 6,
	velocity = 0.75,
	texture = "weather_snow.png",
	glow = 6
}

climate_api.register_weather(name, conditions, effects)
