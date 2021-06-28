local name = "regional_weather:pollen"

local conditions = {
	min_height			= regional_weather.settings.min_height,
	max_height			= regional_weather.settings.max_height,
	min_heat				= 40,
	min_humidity		= 30,
	max_humidity		= 40,
	max_windspeed		= 2,
	indoors					= false,
	has_biome				= {
		"default",
		"deciduous_forest",
		"deciduous_forest_ocean",
		"deciduous_forest_shore",
		"grassland",
		"grassland_dunes",
		"grassland_ocean",
		"snowy_grassland",
		"snowy_grassland_ocean",
		"grassy",
		"grassy_ocean",
		"grassytwo",
		"grassytwo_ocean",
		"mushroom",
		"mushroom_ocean",
		"plains",
		"plains_ocean",
		"sakura",
		"sakura_ocean"
	}
}

local effects = {}

effects["climate_api:particles"] = {
	boxsize = { x = 24, y = 0, z = 24 },
	vbox = 5,
	v_offset = -1,
	velocity = -0.1,
	acceleration = -0.03,
	expirationtime = 5,
	size = 0.8,
	texture = "weather_pollen.png",
	glow = 2
}

climate_api.register_weather(name, conditions, effects)
