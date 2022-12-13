local name = "regional_weather:hail"

local conditions = {
	min_height			= regional_weather.settings.min_height,
	max_height			= regional_weather.settings.max_height,
	min_heat				= 30,
	max_heat				= 45,
	min_humidity		= 65,
	min_windspeed		= 2.5,
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

effects["climate_api:damage"] = {
	rarity = 15,
	value = 3,
	check = {
		type = "raycast",
		height = 7,
		velocity = 20
	}
}

effects["climate_api:sound"] = {
	name = "weather_hail",
	gain = 1
}

effects["regional_weather:lightning"] = 1 / 30

local textures = {}
for i = 1,5 do
	textures[i] = "weather_hail" .. i .. ".png"
end

effects["climate_api:particles"] = {
	boxsize = { x = 18, y = 0, z = 18 },
	v_offset = 7,
	velocity = 20,
	amount = 6,
	expirationtime = 0.7,
	texture = textures,
	glow = 5
}

climate_api.register_weather(name, conditions, effects)
