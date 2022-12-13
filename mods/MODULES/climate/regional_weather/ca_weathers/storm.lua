local name = "regional_weather:storm"

local conditions = {
	min_height 		= regional_weather.settings.min_height,
	max_height 		= regional_weather.settings.max_height,
	min_windspeed	= 3,
	indoors				= false,
}

local effects = {}

effects["climate_api:sound"] = {
	name = "weather_wind"
}

local function generate_effects(params)
	local avg_windspeed = 5
	local intensity = params.windspeed / avg_windspeed
	local override = {}

	override["climate_api:sound"]  = {
		gain = math.min(intensity, 1.2)
	}

	return climate_api.utility.merge_tables(effects, override)
end

climate_api.register_weather(name, conditions, generate_effects)
