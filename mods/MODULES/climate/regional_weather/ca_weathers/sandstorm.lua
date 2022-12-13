local name = "regional_weather:sandstorm"

local conditions = {
	min_height = regional_weather.settings.min_height,
	max_height = regional_weather.settings.max_height,
	min_heat				= 50,
	max_humidity		= 25,
	min_windspeed		= 4.5,
	has_biome				= {
		"cold_desert",
		"cold_desert_ocean",
		"desert",
		"desert_ocean",
		"sandstone_desert",
		"sandstone_desert_ocean"
	}
}

local effects = {}

effects["climate_api:hud_overlay"] = {
	file = "weather_hud_sand.png",
	z_index = -100,
	color_correction = true
}

effects["climate_api:damage"] = {
	rarity = 3,
	value = 1,
	check = {
		type = "raycast",
		height = 0,
		velocity = 0.3
	}
}

effects["climate_api:particles"] = {
	boxsize = { x = 8, y = 4.5, z = 8 },
	velocity = 0.6,
	acceleration = -0.2,
	amount = 12,
	expirationtime = 0.7,
	size = 25,
	texture = {
		"weather_sandstorm.png",
		"weather_sandstorm.png^[transformFY",
		"weather_sandstorm.png^[transformR180",
		"weather_sandstorm.png^[transformFYR180"
	}
}

effects["climate_api:skybox"] = {
	sky_data = {
		type = "plain",
		clouds = true,
	},
	cloud_data = {
		density = 1,
		color = "#f7e4bfc0",
		thickness = 40,
		speed = {x=0,y=0,z=0}
	},
	priority = 60
}

local function generate_effects(params)
	local override = {}
	local light = math.max(params.light / 15, 0.2)
	local color = {r = 247 * light, g = 228 * light, b = 191 * light, a = 256}
	override["climate_api:skybox"] = {
		sky_data = {
			base_color = color
		},
		cloud_data = {
			height = params.player:get_pos().y - 20
		}
	}
	override = climate_api.utility.merge_tables(effects, override)
	if params.daylight < 15 then
		local result = {}
		result["climate_api:skybox"] = override["climate_api:skybox"]
		return result
	end
	return override
end

climate_api.register_weather(name, conditions, generate_effects)
