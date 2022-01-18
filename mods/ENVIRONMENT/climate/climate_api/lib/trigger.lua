local trigger = {}

function trigger.get_global_environment()
	local env = {}
	for influence, func in pairs(climate_mod.global_influences) do
		env[influence] = func()
	end
	return env
end

function trigger.get_position_environment(pos)
	local env = table.copy(climate_mod.global_environment)
	for influence, func in pairs(climate_mod.influences) do
		env[influence] = func(pos)
	end
	return env
end

function trigger.get_player_environment(player)
	local ppos = player:get_pos()
	if ppos == nil then return end
	local env = trigger.get_position_environment(ppos)
	env.player = player
	return env
end

function trigger.test_condition(condition, env, goal)
	local value = env[condition:sub(5)]
	if condition:sub(1, 4) == "min_" then
		return value ~= nil and goal <= value
	elseif condition:sub(1, 4) == "max_" then
		return value ~= nil and goal > value
	elseif condition:sub(1, 4) == "has_" then
		if value == nil then return false end
		for _, g in ipairs(goal) do
			if value == g then return true end
		end
		return false
	elseif condition:sub(1, 4) == "not_" then
		if value == nil then return true end
		if type(goal) ~= "table" then
			return value ~= goal
		end
		for _, g in ipairs(goal) do
			if value == g then return false end
		end
		return true
	else
		value = env[condition]
		return type(value) == "nil" or goal == value
	end
end

local function is_weather_active(player, weather, env)
	if climate_mod.forced_weather[weather] ~= nil then
		return climate_mod.forced_weather[weather]
	end
	local config = climate_mod.weathers[weather]
	if type(config.conditions) == "function" then
		return config.conditions(env)
	end
	for condition, goal in pairs(config.conditions) do
		if not trigger.test_condition(condition, env, goal) then
			return false
		end
	end
	return true
end

local function get_weather_effects(player, weather_config, env)
	local config = {}
	local effects = {}
	if type(weather_config.effects) == "function" then
		config = weather_config.effects(env)
	else
		config = weather_config.effects
	end
	for effect, value in pairs(config) do
		if climate_mod.effects[effect] ~= nil then
			effects[effect] = value
		end
	end
	return effects
end

function trigger.get_active_effects()
	local environments = {}
	for _, player in ipairs(minetest.get_connected_players()) do
		local playername = player:get_player_name()
		local hp = player:get_hp()
		-- skip weather presets for dead players
		if hp ~= nil and hp > 0 then
			environments[playername] = trigger.get_player_environment(player)
		end
	end

	local effects = {}
	climate_mod.current_weather = {}
	for wname, wconfig in pairs(climate_mod.weathers) do
		for _, player in ipairs(minetest.get_connected_players()) do
			local pname = player:get_player_name()
			local env = environments[pname]
			if env ~= nil then
				if is_weather_active(player, wname, env) then
					if climate_mod.current_weather[pname] == nil then
						climate_mod.current_weather[pname] = {}
					end
					table.insert(climate_mod.current_weather[pname], wname)
					local player_effects = get_weather_effects(player, wconfig, env)
					for effect, value in pairs(player_effects) do
						if type(effects[effect]) == "nil" then
							effects[effect] = {}
						end
						if type(effects[effect][pname]) == "nil" then
							effects[effect][pname] = {}
						end
						effects[effect][pname][wname] = value
					end
				end
			end
		end
	end
	return effects
end

function trigger.call_handlers(name, effect, prev_effect)
	if effect == nil then effect = {} end
	if prev_effect == nil then prev_effect = {} end

	local starts = {}
	local has_starts = false
	local ticks = {current = {}, prev = {}}
	local has_ticks = false
	local stops = {}
	local has_stops = false

	for player, sources in pairs(effect) do
		if type(prev_effect[player]) ~= "nil" then
			has_ticks = true
			ticks.current[player] = sources
			ticks.prev[player] = prev_effect[player]
		else
			has_starts = true
			starts[player] = sources
		end
	end

	for player, sources in pairs(prev_effect) do
		if type(effect[player]) == "nil" then
			stops[player] = sources
			has_stops = true
		end
	end

	if has_starts then
		for _, handler in ipairs(climate_mod.effects[name]["start"]) do
			handler(starts)
		end
	end

	if has_ticks then
		for _, handler in ipairs(climate_mod.effects[name]["tick"]) do
			handler(ticks.current, ticks.prev)
		end
	end

	-- remaining table lists ending effects
	if has_stops then
		for _, handler in ipairs(climate_mod.effects[name]["stop"]) do
			handler(stops)
		end
	end
end

return trigger