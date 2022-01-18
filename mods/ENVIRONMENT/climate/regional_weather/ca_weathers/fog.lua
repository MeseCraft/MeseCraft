local name = "regional_weather:fog"

local conditions = {
	min_height = regional_weather.settings.min_height,
	max_height = regional_weather.settings.max_height,
	min_humidity = 40,
	max_humidity = 50,
	max_windspeed = 2,
	min_heat = 40,
	max_heat = 50
}

local effects = {}

effects["climate_api:skybox"] = {
	sky_data = {
		clouds = true
	},
	cloud_data = {
		density = 1,
		color = "#ffffff80",
		thickness = 40,
		speed = {x=0,y=0,z=0}
	},
	priority = 50
}

local function generate_effects(params)
	local override = {}
	override["climate_api:skybox"] = {
		cloud_data = {
			height = params.player:get_pos().y - 20
		}
	}
	return climate_api.utility.merge_tables(effects, override)
end

climate_api.register_weather(name, conditions, generate_effects)
