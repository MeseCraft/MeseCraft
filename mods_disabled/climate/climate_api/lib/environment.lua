local environment = {}

function environment.get_heat(pos)
	if climate_mod.forced_enviroment.heat ~= nil then
		return climate_mod.forced_enviroment.heat
	end
	local base = climate_mod.settings.heat
	local biome = minetest.get_heat(pos)
	local height = climate_api.utility.rangelim((-pos.y + 10) / 15, -10, 10)
	local time = climate_api.utility.normalized_cycle(minetest.get_timeofday()) * 0.6 + 0.7
	local random = climate_mod.state:get_float("heat_random");
	return (base + biome + height) * time * random
end

function environment.get_humidity(pos)
	if climate_mod.forced_enviroment.humidity ~= nil then
		return climate_mod.forced_enviroment.humidity
	end
	local base = climate_mod.settings.humidity
	local biome = minetest.get_humidity(pos)
	local random = climate_mod.state:get_float("humidity_random");
	local random_base = climate_mod.state:get_float("humidity_base");
	return (base + biome * 0.7 + random_base * 0.3) * random
end

function environment.get_wind(pos)
	if climate_mod.forced_enviroment.wind ~= nil then
		return climate_mod.forced_enviroment.wind
	end
	local wind_x = climate_mod.state:get_float("wind_x")
	local wind_z = climate_mod.state:get_float("wind_z")
	local base_wind = vector.new({ x = wind_x, y = 0, z = wind_z })
	local height_modifier = climate_api.utility.sigmoid(pos.y, 2, 0.02, 1)
	return vector.multiply(base_wind, height_modifier)
end

function environment.get_weather_presets(player)
	local pname = player:get_player_name()
	local weathers = climate_mod.current_weather[pname]
	if type(weathers) == "nil" then weathers = {} end
	return weathers
end

function environment.get_effects(player)
	local pname = player:get_player_name()
	local effects = {}
	for effect, players in pairs(climate_mod.current_effects) do
		if type(players[pname]) ~= "nil" then
			table.insert(effects, effect)
		end
	end
	return effects
end

return environment