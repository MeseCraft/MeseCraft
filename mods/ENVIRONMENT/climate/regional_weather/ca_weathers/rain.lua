local name = "regional_weather:rain"

local conditions = {
	min_height		= regional_weather.settings.min_height,
	max_height		= regional_weather.settings.max_height,
	min_heat			= 35,
	min_humidity	= 50,
	max_humidity	= 65,
	indoors				= false
}

local effects = {}

effects["climate_api:sound"] = {
	name = "weather_rain",
	gain = 1.5
}

effects["climate_api:particles"] = {
	boxsize = { x = 18, y = 2, z = 18 },
	v_offset = 6,
	expirationtime = 1.6,
	size = 2,
	amount = 15,
	velocity = 6,
	acceleration = 0.05,
	texture = "weather_raindrop.png",
	glow = 5
}

climate_api.register_weather(name, conditions, effects)
