local name = "regional_weather:snow"

local conditions = {
	min_height = regional_weather.settings.min_height,
	max_height = regional_weather.settings.max_height,
	max_heat				= 35,
	min_humidity		= 50,
	max_humidity		= 65,
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

local textures = {}
for i = 1,12,1 do
	textures[i] = "weather_snowflake" .. i .. ".png"
end

effects["climate_api:particles"] = {
	boxsize = { x = 24, y = 6, z = 24 },
	v_offset = 2,
	amount = 4,
	expirationtime = 7,
	velocity = 0.85,
	acceleration = -0.06,
	texture = textures,
	glow = 6
}

climate_api.register_weather(name, conditions, effects)
