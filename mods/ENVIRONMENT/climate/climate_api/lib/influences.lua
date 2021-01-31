climate_api.register_influence("heat",
	climate_api.environment.get_heat
)

climate_api.register_influence("base_heat",
	minetest.get_heat
)

climate_api.register_influence("humidity",
	climate_api.environment.get_humidity
)

climate_api.register_influence("base_humidity",
	minetest.get_humidity
)

-- see https://en.wikipedia.org/wiki/Dew_point#Simple_approximation
climate_api.register_influence("dewpoint", function(pos)
	local heat = climate_api.environment.get_heat(pos)
	local humidity = climate_api.environment.get_humidity(pos)
	return heat - (9/25 * (100 - humidity))
end)

climate_api.register_influence("base_dewpoint", function(pos)
	local heat = minetest.get_heat(pos)
	local humidity = minetest.get_humidity(pos)
	return heat - (9/25 * (100 - humidity))
end)

climate_api.register_influence("biome", function(pos)
	local data = minetest.get_biome_data(pos)
	local biome = minetest.get_biome_name(data.biome)
	return biome
end)

climate_api.register_influence("windspeed", function(pos)
	local wind = climate_api.environment.get_wind(pos)
	return vector.length(wind)
end)

climate_api.register_global_influence("wind_yaw", function()
	local wind = climate_api.environment.get_wind({x = 0, y = 0, z = 0})
	if vector.length(wind) == 0 then return 0 end
	return minetest.dir_to_yaw(wind)
end)

climate_api.register_influence("height", function(pos)
	return pos.y
end)

climate_api.register_influence("light", function(pos)
	pos = vector.add(pos, {x = 0, y = 1, z = 0})
	return minetest.get_node_light(pos) or 0
end)

climate_api.register_influence("daylight", function(pos)
	pos = vector.add(pos, {x = 0, y = 1, z = 0})
	return minetest.get_node_light(pos, 0.5) or 0
end)

climate_api.register_influence("indoors", function(pos)
	pos = vector.add(pos, {x = 0, y = 1, z = 0})
	local daylight = minetest.get_node_light(pos, 0.5) or 0
	if daylight < 15 then return true end

	for i = 1, climate_mod.settings.ceiling_checks do
		local lpos = vector.add(pos, {x = 0, y = i, z = 0})
		local node = minetest.get_node_or_nil(lpos)
		if node ~= nil and node.name ~= "air" and node.name ~= "ignore" then
			return true
		end
	end
	return false
end)

climate_api.register_global_influence("time",
	minetest.get_timeofday
)