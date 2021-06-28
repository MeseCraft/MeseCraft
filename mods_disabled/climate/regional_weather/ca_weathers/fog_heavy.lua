local name = "regional_weather:fog_heavy"

local conditions = {
	min_height = regional_weather.settings.min_height * 0.9,
	max_height = regional_weather.settings.max_height * 0.9,
	min_humidity = 43,
	max_humidity = 47,
	max_windspeed = 1.5,
	min_heat = 43,
	max_heat = 47
}

local effects = {}

effects["climate_api:hud_overlay"] = {
	file = "weather_hud_fog.png^[opacity:100",
	z_index = -200,
	color_correction = true
}

effects["climate_api:skybox"] = {
	sky_data = {
		type = "plain",
		base_color = "#c0c0c08f"
	},
	cloud_data = {
		color = "#ffffffc0",
	},
	priority = 51
}

climate_api.register_weather(name, conditions, effects)
