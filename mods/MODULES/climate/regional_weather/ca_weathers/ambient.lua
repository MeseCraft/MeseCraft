local name = "regional_weather:ambient"

local conditions = {}

-- see https://en.wikipedia.org/wiki/Cloud_base
local function calc_cloud_height(heat, humidity, dewpoint)
	local base = regional_weather.settings.cloud_height
	-- much lower scale like 20 instead of 1000 fitting for Minetest
	local scale = regional_weather.settings.cloud_scale
	local spread = heat - dewpoint
	local variation = spread / 4.4 * scale * 0.3
	return base + climate_api.utility.rangelim(variation, -scale, scale)
end

local function generate_effects(params)
	local override = {}

	local cloud_height = calc_cloud_height(params.heat, params.humidity, params.dewpoint)
	local wind = climate_api.environment.get_wind({ x = 0, y = cloud_height, z = 0 })

	local skybox = {priority = 10}
	skybox.cloud_data = {
		density = climate_api.utility.rangelim(params.humidity / 100, 0.15, 0.65),
		speed = wind,
		thickness = climate_api.utility.rangelim(params.base_humidity * 0.2, 1, 18),
		height = cloud_height,
		ambient = "#0f0f1050"
	}

	if params.height > -100 and params.humidity > 40 then
		skybox.cloud_data.color  = "#b2a4a4b0"
	end

	if params.height > -100 and params.humidity > 65 then
		skybox.sky_data = {
			type = "regular",
			clouds = true,
			sky_color = {
				day_sky = "#6a828e",
				day_horizon = "#5c7a8a",
				dawn_sky = "#b2b5d7",
				dawn_horizon = "#b7bce1",
				night_sky = "#2373e1",
				night_horizon = "#315d9b"
			}
		}
		skybox.cloud_data.color = "#828e97b5"
		skybox.cloud_data.ambient = "#20212250"
	end

	override["climate_api:skybox"] = skybox

	local movement = params.player:get_player_velocity()
	local movement_direction
	if (vector.length(movement) < 0.1) then
		movement_direction = vector.new(0, 0, 0)
	else
		movement_direction = vector.normalize(movement)
	end
	local vector_product = vector.dot(movement_direction, wind)
	local movement_penalty = climate_api.utility.sigmoid(vector_product, 1.5, 0.15, 0.9) + 0.2
	override["regional_weather:speed_buff"] = movement_penalty
	return override
end

climate_api.register_weather(name, conditions, generate_effects)
